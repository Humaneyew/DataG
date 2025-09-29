# DataG

Localized timeline trivia prototype for the DataG experience.

## Structure
- `assets/data/` — curated JSON datasets per category plus an index file.
- `lib/content/` — data models and repository for loading questions.
- `lib/l10n/` — application strings in ARB format for intl-based localization.
- `lib/ui/` — Flutter UI, including locale switching and gameplay flows.
- `tool/content_import.dart` — CSV import/validation utility for datasets.

## Content pipeline
1. Place source spreadsheets as CSV files inside `assets/data_raw/`.
2. Run `dart run tool/content_import.dart` to validate and convert them into
   JSON under `assets/data/`. The tool reports skipped rows and totals in
   `tool/out/report.txt`.
3. Commit both the generated JSON and the updated report for traceability.

Each question row must provide localized prompts (`_en`, `_ru`), a
unique id, valid year bounds (`min < year < max`), category metadata, and any
optional hint fields. The import script enforces these requirements and skips
invalid rows.

## Localization workflow
- Run `flutter gen-l10n` whenever ARB files change to regenerate
  `AppLocalizations`.
- Supported locales: English (`en`) and Russian (`ru`). The
  UI falls back to English strings when a translation is unavailable.

## Running the app
Standard Flutter commands apply:

```sh
flutter pub get
flutter run
```

Use the in-app locale menu to switch languages at runtime.
