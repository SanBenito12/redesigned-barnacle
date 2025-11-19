# Repository Guidelines

## Project Structure & Module Organization
`lib/main.dart` bootstraps the Flutter app and wires dependencies via `lib/injection.dart`. Feature code follows MVVM layers in `lib/src`: `data/` for API/datasource/repository glue, `domain/` for models and use-cases, and `presentation/` for pages, widgets, and helpers registered in `blocProviders.dart`. UI assets sit in `assets/img`, and widget/unit tests mirror the `lib/` paths inside `test/`. Keep generated files like `injection.config.dart` under version control so GetIt stays in sync.

## Build, Test, and Development Commands
- `flutter pub get` installs packages from `pubspec.yaml`.
- `flutter pub run build_runner build --delete-conflicting-outputs` regenerates injectable bindings.
- `flutter analyze` enforces the lint rules in `analysis_options.yaml`.
- `flutter run -d chrome` (or another device id) starts a hot-reload session.
- `flutter test` executes the full suite; use `--coverage` when required.
- `flutter build apk --release` or `flutter build ios` produce distributable binaries.

## Coding Style & Naming Conventions
Use 2-space Dart indentation and keep files formatted with `dart format .` before committing. Prefer PascalCase for classes (`ProductRepository`), camelCase for members (`fetchProducts`), and snake_case for file names (`product_card.dart`). Follow Flutter lints plus the local override disabling `prefer_const_constructors`; document intentional deviations with `// ignore`. Co-locate constants and API hosts in `ApiConfig` or dedicated `*_constants.dart` files to avoid magic strings in widgets.

## Testing Guidelines
Store tests under `test/` with names ending in `_test.dart` that mirror the structure of the code under test (e.g., `test/presentation/pages/cart_page_test.dart`). Focus on widget behaviors and repository/use-case contracts; mock GetIt entries in `setUp` with temporary singletons. Run `flutter test` before every push and prefer `flutter test --coverage` for PRs touching business logic, keeping network calls stubbed so the suite remains deterministic.

## Commit & Pull Request Guidelines
History is empty; adopt a compact Conventional Commit style such as `feat: add product grid view` plus optional body detail. Reference issue IDs when available. Pull requests should state scope, list affected modules, attach screenshots for UI updates, and paste the latest `flutter analyze`/`flutter test` output. Keep diffs narrow in focus and ensure `build_runner` artifacts are current before requesting review.

## Security & Configuration Tips
Backends default to the LAN host defined in `lib/src/data/api/ApiConfig.dart`; update it per environment and avoid hardcoding secrets anywhere else. When using environment-specific flags, pass them via `--dart-define` instead of committing values. Review new dependencies for licensing and pin versions in `pubspec.yaml` to avoid unexpected supply-chain regressions.
