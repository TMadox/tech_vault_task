# Currency Converter App

A production-ready Flutter currency converter application built with Clean Architecture, BLoC pattern for state management, and Drift for local database persistence.

## Features

- **Currency List**: Browse all supported currencies with country flags, cached locally after first API fetch
- **Currency Converter**: Convert between any two currencies with real-time exchange rates
- **Historical Data**: View 7-day historical exchange rate chart for USD/KWD

## Screenshots

The app features three main screens accessible via bottom navigation:

1. **Converter** - Select currencies, enter amount, and get instant conversion results
2. **Currencies** - Scrollable list of all currencies with flags from flagcdn.com
3. **Historical** - Line chart showing USD to KWD rates for the past 7 days

## Build Instructions

### Prerequisites

- Flutter SDK 3.10.4 or higher
- Dart SDK 3.10.4 or higher

### Setup

1. Clone the repository:

```bash
git clone https://github.com/YOUR_USERNAME/task_currency.git
cd task_currency
```

2. Get dependencies:

```bash
flutter pub get
```

3. Generate code (Drift database and Injectable DI):

```bash
dart run build_runner build --delete-conflicting-outputs
```

4. **Add your API key**: Open `lib/core/constants/api_constants.dart` and replace `YOUR_API_KEY_HERE` with your free API key from [free.currencyconverterapi.com](https://free.currencyconverterapi.com/)

5. Run the app:

```bash
flutter run
```

### Running Tests

```bash
flutter test
```

## Architecture

### Design Pattern: Clean Architecture + BLoC

**Justification:**

Clean Architecture was chosen for several key reasons:

1. **Separation of Concerns**: The app is divided into three layers:

   - **Presentation Layer** (UI, BLoC): Handles user interaction and state management
   - **Domain Layer** (Entities, Use Cases, Repository interfaces): Contains business logic, independent of any framework
   - **Data Layer** (Data sources, Models, Repository implementations): Handles data fetching and caching

2. **Testability**: Each layer can be tested in isolation. Use cases can be tested without UI, and BLoCs can be tested without actual API calls.

3. **Maintainability**: Changes to one layer don't affect others. Switching from Drift to another database would only require changes in the data layer.

4. **Scalability**: New features can be added as independent modules following the same structure.

**BLoC Pattern** was chosen for state management because:

- Clear separation of UI and business logic
- Predictable state changes through events and states
- Built-in support for testing with `bloc_test`
- Excellent Flutter community support and documentation

### Project Structure

```
lib/
├── core/                          # Shared infrastructure
│   ├── constants/                 # API and app constants
│   ├── database/                  # Drift database setup
│   ├── di/                        # Dependency injection (GetIt + Injectable)
│   ├── error/                     # Exception and failure classes
│   ├── network/                   # Dio HTTP client
│   ├── theme/                     # Material Design theme
│   └── usecases/                  # Base use case class
├── features/                      # Feature modules
│   ├── currencies/                # Currencies list feature
│   │   ├── data/                  # Data sources, models, repository impl
│   │   ├── domain/                # Entities, repository interface, use cases
│   │   └── presentation/          # BLoC, pages, widgets
│   ├── converter/                 # Currency converter feature
│   └── historical/                # Historical rates feature
└── main.dart                      # App entry point
```

## Image Loader Library

### Library: cached_network_image

**Justification:**

1. **Automatic Caching**: Images are cached on disk, reducing network requests and improving performance
2. **Placeholder Support**: Shows loading indicator while fetching flags
3. **Error Handling**: Displays fallback widget when flag is unavailable
4. **Memory Efficient**: Uses LRU cache to manage memory usage
5. **Production Ready**: Widely used package with excellent community support

## Database

### Library: Drift (formerly Moor)

**Justification:**

1. **Type Safety**: Full Dart type safety with compile-time SQL validation
2. **Code Generation**: Reduces boilerplate with generated database code
3. **Query Builder**: Fluent API for building complex queries
4. **Migrations**: Built-in schema migration support
5. **Performance**: Native SQLite with optimized query execution
6. **Offline First**: Enables cache-first strategy for currencies and historical data

### Data Strategy

- **Currencies**: Fetched from API on first launch, cached in local database, loaded from cache on subsequent launches
- **Historical Rates**: Cached per currency pair and date range, refreshed when data is stale or missing

## Dependency Injection

### Libraries: get_it + injectable

**Justification:**

1. **Compile-time Safety**: Injectable generates code at build time, catching errors early
2. **Clean Syntax**: Simple annotations (`@injectable`, `@lazySingleton`) for registration
3. **Testability**: Easy to mock dependencies in tests
4. **Performance**: GetIt is one of the fastest DI containers for Dart

## API

This app uses the [Free Currency Converter API](https://free.currencyconverterapi.com/):

- **Currencies List**: `/api/v7/currencies`
- **Conversion**: `/api/v7/convert?q=USD_KWD&compact=ultra`
- **Historical**: `/api/v7/convert?q=USD_KWD&date=YYYY-MM-DD&endDate=YYYY-MM-DD`

## Testing

Unit tests are provided for:

- **API Integration**: Remote data source tests with mocked Dio client
- **Use Cases**: Business logic tests with mocked repositories
- **BLoCs**: State management tests using `bloc_test`

Run all tests:

```bash
flutter test
```

Run specific test file:

```bash
flutter test test/features/currencies/presentation/bloc/currencies_bloc_test.dart
```

## Dependencies

| Package               | Purpose                              |
| --------------------- | ------------------------------------ |
| flutter_bloc          | State management                     |
| get_it + injectable   | Dependency injection                 |
| drift + drift_flutter | Local database                       |
| dio                   | HTTP client                          |
| cached_network_image  | Flag images with caching             |
| fl_chart              | Historical data visualization        |
| dartz                 | Functional programming (Either type) |
| mocktail              | Mocking for tests                    |
| bloc_test             | BLoC testing utilities               |

## License

This project is created for assessment purposes.
