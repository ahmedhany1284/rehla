# Thaheen LMS

Rehla is the name of this app in the project configuration and the `app_name` string. It is a small offline course app. Courses, lessons, and videos are included with the app, and lesson progress is saved on the device.

Screens, data, and rules are kept apart on purpose. Two courses and a small progress map do not need a bigger setup.

## Features

- Course list with thumbnail, instructor, lesson count, and progress
- Continue watching for the first unfinished lesson, in the order of the course file
- Course sections and lessons, with duration and status
- Sequential unlock: a lesson stays locked until the previous one is completed
- Video playback from a local file: play/pause, seek, speed (1x, 1.25x, 1.5x, 2x), fullscreen
- Resume from the saved position, including a lesson that is already completed
- A lesson is marked completed when the playback position reaches 90% of its duration, and seeking backward does not clear that.
- Progress is still there after the app restarts
- Arabic-first UI, with an English switch, and light/dark theme
- Loading, empty, and error states, including a missing video file



## Getting Started



### Requirements

Flutter stable with Dart 3.12 or newer.

### Run

```bash
flutter pub get
flutter run
```



### Tests

```bash
flutter test
```



## Architecture

Courses live under `lib/features/home`.

- `data` reads `assets/data/courses.json` and the saved progress map.
- `domain` holds the course types, repository contract, four use cases, and progress rules.
- `presentation` holds the screens, their widgets, and the cubits. Screens sit in `view`, feature widgets in `view/widgets`, cubits in `view-model`.

Settings is only a screen. It calls the existing app cubit. Code used across the app lives in `lib/core`: routing, theme, storage, and shared widgets. Shared app-level files use an `app_` prefix, as in `app_router` and `app_theme`, so they are easy to find. Course and settings code stays inside its own feature. Navigation is `go_router`.

UI strings are not written in the widgets. The translations live in `assets/translations`, and `AppStrings` is the one place screens read them. The path is `assets/translations` → `AppStrings` → the feature UI. Course titles are separate: they come from the course JSON, not from `AppStrings`.

`AppTheme` keeps the light and dark themes in one place, and `MaterialApp` uses those two. Feature screens do not each define a theme. They use `AppTheme`, which is built from `AppColors`.

Repositories return `Either`, either a result or a failure. Cubits turn that into a screen status, such as loaded or error. Widgets do not show the failure text.

There are four use cases: `GetCoursesUseCase`, `GetCourseDetailsUseCase`, `GetLessonPlaybackUseCase`, and `SaveLessonProgressUseCase`. Those are the main jobs: load the list, load one course, load one lesson for playback, and save progress. Play, pause, seek, and playback speed stay on `PlayerCubit` and the `VideoPlayerController`. They are video player actions, so they are not separate use cases.

## State Management

Cubit, via `flutter_bloc`. There is no Bloc event class.

Each feature cubit keeps one state object with `copyWith` and a status (`loading`, `loaded`, `empty`, `error`, and the player statuses). That is enough for these screens. The changes are small: load a list, load one course, or run one player.

`AppCubit` is separate. It only switches theme, language, and font, and tells the app to rebuild.

`HomeCubit`, `CourseDetailsCubit`, and `PlayerCubit` are created on the route that needs them. They share one `CourseRepository` so the parsed course list stays in memory.

## Local Persistence

`shared_preferences`.

Lesson progress is one JSON string under `lesson_progress`. Each lesson id stores `positionSec` and `completed`. The course list, continue watching, and the player all read that same key.

Theme (`isDark`) is a bool in the same store. Language is saved by `easy_localization`.

SharedPreferences is enough because the app only saves a small progress map, and each lesson needs those two fields. A database such as SQLite, Drift, or Isar would add setup, queries, migrations, and maintenance that this small app does not currently need. A database would make sense if the data grew, or if the app needed real queries instead of one map keyed by lesson id.

## Key Decisions



### Offline data

There is no API. Course titles, instructors, sections, lesson durations, and video paths come from `assets/data/courses.json`. Two short MP4s live in `assets/videos/` and are reused across lessons.

Titles and descriptions are `{ar, en}` in that JSON. UI strings are in `assets/translations` and read through `AppStrings`.

### Progress

Position is saved on seek, on pause, about every 5 seconds while playing, and when the player cubit closes. Opening a lesson seeks to that second, whether or not the lesson is already completed. Completion is not cleared if the student seeks backward.

Course progress on the list is completed lessons divided by the lesson count, as a percent. It is not watched time. That percent is calculated in the repository. `courseProgress()` in `progress_rules.dart` is the same ratio from 0 to 1, and the unit tests call that function.

### Completion

`isCompleted` is true when watched time is at least 90% of the duration. A zero duration never completes.

### Unlocking

`isUnlocked` opens the first lesson always. Every later lesson opens only when the previous lesson id is in the completed set. The order is the full lesson list, not restarted in each section.

### Video

Playback uses `video_player` on the file path from the lesson. The player handles seek, speed, fullscreen, and a missing file. A missing file shows a message with retry and back. Speed stays for that viewing session, including fullscreen, and is not saved.

The watch screen is Arabic-first. The seek bar follows the language, so in Arabic the start of the bar is on the right. Double-tap skip follows that same side.

## Trade-offs

The structure matches the size of the app. It is simple on purpose, not unfinished.

- Course JSON included with the app, instead of a backend.
- One SharedPreferences string instead of a database. See Local Persistence for why.
- The course list is kept in memory on the repository. Later reads skip parsing the JSON again. There is no extra copy on disk, because the file is already included with the app.
- Four use cases cover loading and saving. Player controls stay on the cubit and the video controller.



## Known Issues

Continue watching goes through courses and lessons in file order and stops at the first lesson with `positionSec > 0` that is not completed. It is not the most recently watched lesson. A later in-progress lesson is skipped if an earlier one is also unfinished.

`chewie` is still listed in `pubspec.yaml` but is not used. The player currently uses `video_player` directly.

The empty state is in the course list and course details. The course file included with the app always has lessons, so that screen is not reached with this data.

The last lesson, The synapse, points at `assets/videos/missing.mp4`. That file is not included with the app, so opening it shows the player error. The other lessons use the two real clips.

## What I Would Do With More Time

1. Widget tests for the course list, the lock message, and resume.
2. One video file per lesson, instead of reusing two clips.
3. A version field on the progress JSON, so a later change to the saved fields does not break old data.
4. Accessibility pass on the player controls and the locked-lesson message.



## Testing

`flutter test` currently passes 9 tests.

`test/progress_rules_test.dart` covers the 90% completion boundary: 89% remains incomplete, while exactly 90% completes the lesson. It also covers zero duration, first-lesson unlock, second-lesson lock and unlock, half progress, and an empty course.

`test/widget_test.dart` checks that lesson count adds every section. It does not pump a widget.

`test/README.md` lists each test in plain language.

## Time Spent

Approximately 4 hours.