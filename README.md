# Swim — Test Task

A small Flutter app covering both tasks in a single project, organised behind a
bottom navigation bar with two tabs:

1. **Pace Selector** — set your fastest 100m freestyle time, see your swimmer
   level update live, and submit the pace to the backend.
2. **Users** — fetch users from a REST API, search/refresh them, and open a
   detail screen.

| Pace tab | Users tab |
| --- | --- |
| MIN:SEC stepper + slider, live swimmer level, level-coloured Continue button | Searchable list with pull-to-refresh, collapsing-header detail screen |

---

## Getting started

```bash
flutter pub get
flutter run
```

Built with **Flutter 3.41 / Dart 3.11**. No platform-specific setup required —
the API is the public `https://jsonplaceholder.typicode.com`.

---

## State management — and why

I deliberately used **two** approaches from the BLoC family, picking the right
tool per feature instead of applying one dogmatically:

- **Pace → `Bloc`.** The pace screen has a real requirement to **debounce** the
  network call on slider changes. That is the textbook use case for a Bloc
  **`EventTransformer`**: `debounce(500ms).switchMap(...)` collapses the burst
  of events while scrubbing into a single request and cancels any in-flight one.
  With a Cubit I'd be hand-rolling a `Timer` and managing cancellation myself.
  The event/transformer model earns its keep here.

- **Users → `Cubit`.** Loading and refreshing a list is a simple
  `loading → success/failure` flow with no event stream to shape. A Cubit
  expresses that with far less ceremony; Bloc events would be boilerplate.

Knowing *when each fits* is the point — `flutter_bloc` gives you both.

State classes use **`Equatable`** so the framework skips rebuilds on
equal states. Async status is modelled with an explicit `status` enum
(`idle/loading/success/failure`) plus an `error` field, read only while
`status == failure`.

---

## Project structure

Feature-first, with a light **domain / data / presentation** split inside each
feature and a `core/` for cross-cutting concerns.

```
lib/
├── main.dart                 # bootstrap: init DI, runApp
├── app.dart                  # MaterialApp + theme
├── core/
│   ├── di/service_locator.dart   # get_it registrations
│   ├── network/dio_client.dart   # configured Dio instance
│   ├── theme/app_theme.dart      # dark theme + accent palette
│   └── home/home_shell.dart      # bottom-nav shell
└── features/
    ├── pace/
    │   ├── domain/           # PaceRange, SwimmerLevel, PaceRepository (interface)
    │   ├── data/             # PaceRepositoryImpl (Dio)
    │   └── presentation/
    │       ├── bloc/         # PaceBloc + events + state
    │       ├── view/         # PaceScreen
    │       └── widgets/      # stepper, slider, level badge, …
    └── users/
        ├── domain/           # UsersRepository (interface)
        ├── data/             # models (User/Address/Company/Geo) + impl
        └── presentation/
            ├── cubit/        # UsersCubit + state
            ├── view/         # list + detail screens
            └── widgets/      # user tile
```

### Dependency injection & repositories

- **`get_it`** is the service locator. It registers stateless, app-wide
  services (the `Dio` client and the repositories) as lazy singletons.
- Each repository is an **abstract interface** in `domain/` bound to a Dio-backed
  **`...Impl`** in `data/` — classic **dependency inversion**. Blocs/Cubits
  depend on the interface and know nothing about `Dio`, so the transport can be
  swapped or mocked in tests by changing one line in the locator.
- **Blocs/Cubits are *not* in `get_it`** — they live in the widget tree via
  `BlocProvider`, so their lifecycle (`close()`) is handled by the framework.

---

## Task 1 — Pace Selector details

### Swimmer level ranges

Levels are derived from the total time for the 100m freestyle. Boundaries are
aligned with the slider's tick marks (1:10 / 1:30 / 2:00):

| Level | Time (100m) | Total seconds |
| --- | --- | --- |
| **Elite** | under 1:10 | `< 70` |
| **Advanced** | 1:10 – 1:29 | `70 – 89` |
| **Intermediate** | 1:30 – 1:59 | `90 – 119` |
| **Beginner** | 2:00 and slower | `>= 120` |

Slider range: **0:30 → 4:00** (default **1:30**), one division per second so the
value is always an integer.

### Behaviour

- Up/down arrows and the slider both funnel through a single clamping setter in
  the bloc, so range/validation logic lives in one place.
- Tap a number to edit it directly (digits-only input, seconds validated to
  0–59). Editing happens in a small dialog with its own controller so the text
  field never fights the bloc state.
- **Submission:** every value change enqueues a `PaceSubmitted` event, debounced
  500ms → one `POST /posts {"pace_seconds": <n>}`. The Continue button submits
  the same way and shows a spinner while a request is in flight; failures surface
  via a `SnackBar`.
- The Continue button is tinted by level (blue → teal → emerald → gold) and the
  colour animates as the pace changes. The level→colour mapping is a
  presentation-layer extension so the `SwimmerLevel` domain enum stays UI-free.

---

## Task 2 — Users details

- `GET /users` parsed into **typed models** (`User`, `Address`, `Company`,
  `Geo`) via `fromJson` factories — no `Map<String, dynamic>` reaches the UI.
  Nested objects parse recursively (`User` → `Address` → `Geo`).
- **Search** is local: the query lives in the state and a `visibleUsers` getter
  filters by name — no extra request.
- **Pull-to-refresh** re-runs the same `loadUsers()` used on first load.
- Loading, empty and error states are all handled (error shows a Retry button).
- The **detail screen** uses a `CustomScrollView` + `SliverAppBar` that collapses
  on scroll: a large centered avatar cross-fades into a small circle next to the
  name in the toolbar, driven by a `LayoutBuilder` reading the collapse fraction.

---

## What I'd do differently with more time

- **Tests.** Unit tests for `PaceBloc` (debounce, clamping, validation) and
  `UsersCubit` (load/refresh/search) with a fake repository, plus a couple of
  widget tests. The repository abstraction is already in place for this.
- **Codegen for models.** `json_serializable` / `freezed` to remove hand-written
  `fromJson` and get `copyWith`/equality for free on the user models.
- **Routing.** Swap `Navigator.push` for `go_router` for typed, declarative
  navigation as the app grows.
- **Separate autosave from explicit submit.** Right now any in-flight request
  (including the debounced autosave) drives the Continue spinner. I'd split a
  quiet "saving…" indicator from the explicit Continue action.
- **Richer error handling.** Map `DioException` types to user-facing messages
  and add retry/backoff instead of a single generic message.
- **Polish.** Skeleton loaders, caching the user list for offline, and
  localisation.
