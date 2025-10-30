# Pagination ReqRes API

A simple Flutter app demonstrating **pagination** using the [ReqRes API](https://reqres.in/).

## Features

* Fetches paginated user data from ReqRes API
* Load more on scroll
* Clean architecture (data, domain, presentation)
* State management using Cubit/BLoC
* Handles loading and error states

## Tech Stack

* Flutter
* Dio / Retrofit for network calls
* BLoC / Cubit for state management
* Clean Architecture

## Setup

```bash
git clone https://github.com/prathamesh-mali/pagination_regres_api.git
cd pagination_regres_api
flutter pub get
flutter run
```

## Folder Structure

```
lib/
 ├── data/
 ├── domain/
 └── presentation/
```

## API Used

[https://reqres.in/api/users](https://reqres.in/api/users)

## Author

Prathamesh Mali
