import 'dart:convert';
import 'dart:io';

const _rawDir = 'assets/data_raw';
const _outputDir = 'assets/data';
const _reportFile = 'tool/out/report.txt';

const _requiredHeaders = <String>{
  'id',
  'prompt_en',
  'prompt_uk',
  'prompt_ru',
  'year',
  'min',
  'max',
  'era',
  'category',
  'region',
};

void main(List<String> args) async {
  final rawDirectory = Directory(_rawDir);
  if (!await rawDirectory.exists()) {
    stderr.writeln('No $_rawDir directory found.');
    exitCode = 1;
    return;
  }

  final reportBuffer = StringBuffer();
  final jsonEncoder = const JsonEncoder.withIndent('  ');

  final csvFiles = await rawDirectory
      .list()
      .where((entity) => entity is File && entity.path.endsWith('.csv'))
      .cast<File>()
      .toList();

  if (csvFiles.isEmpty) {
    stdout.writeln('No CSV files found in $_rawDir.');
    await _writeReport(reportBuffer.toString());
    return;
  }

  final allIds = <String>{};

  for (final csvFile in csvFiles) {
    final name = csvFile.uri.pathSegments.last;
    final content = await csvFile.readAsString();
    final rows = _parseCsv(content);
    if (rows.isEmpty) {
      reportBuffer.writeln('$name: empty file');
      continue;
    }

    final headerRow = rows.first.map((value) => value.toString().trim()).toList();
    final headerSet = headerRow.map((e) => e.toLowerCase()).toSet();
    final missingHeaders = _requiredHeaders.difference(headerSet);
    if (missingHeaders.isNotEmpty) {
      reportBuffer.writeln(
          '$name: missing required columns: ${missingHeaders.join(', ')}');
      continue;
    }

    final indices = {
      for (var i = 0; i < headerRow.length; i++)
        headerRow[i].toLowerCase(): i,
    };

    final records = <Map<String, dynamic>>[];
    final errors = <String>[];
    final seenIds = <String>{};

    for (var i = 1; i < rows.length; i++) {
      final row = rows[i];
      if (row.isEmpty || (row.length == 1 && row.first.trim().isEmpty)) {
        continue;
      }
      final location = 'row ${i + 1}';
      final id = _readString(row, indices['id']!, '');
      if (id.isEmpty) {
        errors.add('$location: empty id');
        continue;
      }
      if (seenIds.contains(id) || allIds.contains(id)) {
        errors.add('$location: duplicate id $id');
        continue;
      }

      final prompts = <String, String>{
        'en': _readString(row, indices['prompt_en']!, ''),
        'uk': _readString(row, indices['prompt_uk']!, ''),
        'ru': _readString(row, indices['prompt_ru']!, ''),
      };
      if (prompts.values.any((value) => value.trim().isEmpty)) {
        errors.add('$location: missing prompt translation for $id');
        continue;
      }

      final eraRaw = _readString(row, indices['era']!, '').toUpperCase();
      if (eraRaw != 'CE' && eraRaw != 'BCE') {
        errors.add('$location: invalid era "$eraRaw" for $id');
        continue;
      }

      int? parseInt(int index) {
        final value = _readString(row, index, '');
        if (value.isEmpty) return null;
        return int.tryParse(value);
      }

      final year = parseInt(indices['year']!);
      final minYear = parseInt(indices['min']!);
      final maxYear = parseInt(indices['max']!);
      if (year == null || minYear == null || maxYear == null) {
        errors.add('$location: invalid year range for $id');
        continue;
      }
      if (!(minYear < year && year < maxYear)) {
        errors.add(
            '$location: year $year must be between $minYear and $maxYear for $id');
        continue;
      }

      final category = _readString(row, indices['category']!, '');
      final region = _readString(row, indices['region']!, '');
      if (category.isEmpty || region.isEmpty) {
        errors.add('$location: missing category or region for $id');
        continue;
      }

      final tags = indices.containsKey('tags')
          ? _readString(row, indices['tags']!, '')
              .split(';')
              .map((tag) => tag.trim())
              .where((tag) => tag.isNotEmpty)
              .toList()
          : <String>[];

      final difficulty = indices.containsKey('difficulty')
          ? parseInt(indices['difficulty']!) ?? 1
          : 1;
      final acceptableDelta = indices.containsKey('acceptable_delta')
          ? parseInt(indices['acceptable_delta']!) ?? 0
          : 0;

      final hints = <String, dynamic>{};
      if (indices.containsKey('hint_last_digits')) {
        final lastDigits =
            _readString(row, indices['hint_last_digits']!, '').trim();
        if (lastDigits.isNotEmpty) {
          hints['last_digits'] = lastDigits;
        }
      }
      if (indices.containsKey('hint_ab')) {
        final abRaw = _readString(row, indices['hint_ab']!, '');
        final abChoices = abRaw
            .split(';')
            .map((value) => value.trim())
            .where((value) => value.isNotEmpty)
            .toList();
        if (abChoices.isNotEmpty) {
          hints['ab'] = abChoices;
        }
      }
      if (indices.containsKey('hint_narrow')) {
        final narrow = _readString(row, indices['hint_narrow']!, '').trim();
        if (narrow.isNotEmpty) {
          hints['narrow'] = narrow;
        }
      }

      final record = {
        'id': id,
        'prompts': prompts,
        'year': year,
        'min': minYear,
        'max': maxYear,
        'era': eraRaw,
        'category': category,
        'region': region,
        'tags': tags,
        'difficulty': difficulty,
        'acceptable_delta': acceptableDelta,
        'hints': hints,
        'source': indices.containsKey('source')
            ? _readString(row, indices['source']!, '')
            : '',
        'license': indices.containsKey('license')
            ? _readString(row, indices['license']!, '')
            : 'unknown',
      };

      records.add(record);
      seenIds.add(id);
      allIds.add(id);
    }

    final outputName =
        csvFile.uri.pathSegments.last.replaceAll('.csv', '.json');
    final outputFile = File('$_outputDir/$outputName');
    await outputFile.writeAsString(jsonEncoder.convert(records));

    reportBuffer.writeln(
        '$name: ${records.length} imported, ${errors.length} skipped');
    if (errors.isNotEmpty) {
      for (final error in errors) {
        reportBuffer.writeln('  - $error');
      }
    }
  }

  await _writeReport(reportBuffer.toString());
  stdout.writeln('Import complete. See $_reportFile for details.');
}

List<List<String>> _parseCsv(String input) {
  final rows = <List<String>>[];
  var row = <String>[];
  final cell = StringBuffer();
  var insideQuotes = false;

  for (var i = 0; i < input.length; i++) {
    final char = input[i];
    if (insideQuotes) {
      if (char == '"') {
        final isEscapedQuote = i + 1 < input.length && input[i + 1] == '"';
        if (isEscapedQuote) {
          cell.write('"');
          i++;
        } else {
          insideQuotes = false;
        }
      } else {
        cell.write(char);
      }
    } else {
      switch (char) {
        case '"':
          insideQuotes = true;
          break;
        case ',':
          row.add(cell.toString());
          cell.clear();
          break;
        case '\r':
          if (i + 1 < input.length && input[i + 1] == '\n') {
            i++;
          }
          row.add(cell.toString());
          cell.clear();
          rows.add(row);
          row = <String>[];
          break;
        case '\n':
          row.add(cell.toString());
          cell.clear();
          rows.add(row);
          row = <String>[];
          break;
        default:
          cell.write(char);
      }
    }
  }

  if (insideQuotes) {
    throw const FormatException('Unterminated quoted field in CSV input.');
  }

  if (cell.isNotEmpty || row.isNotEmpty) {
    row.add(cell.toString());
    rows.add(row);
  }

  return rows;
}

String _readString(List<String> row, int index, String defaultValue) {
  if (index < 0 || index >= row.length) return defaultValue;
  final value = row[index];
  if (value.isEmpty) return defaultValue;
  return value.trim();
}

Future<void> _writeReport(String report) async {
  final file = File(_reportFile);
  await file.writeAsString(report.isEmpty ? 'No files processed.\n' : report);
}
