# XKCD Comic Viewer

An iOS app for browsing XKCD comics, built as an MVP for the Shortcut coding challenge.

## Features

- **Browse Comics** — Navigate through comics (first, previous, next, latest, random)
- **Comic Details** — View comic image with title and alt text description
- **Comic Explanation** — Access explain xkcd for each comic
- **Share** — Share comic links with others
- **Unit Tests** — ViewModel tests with dependency injection

## Architecture

**MVVM + Repository Pattern**

The app uses MVVM with a Repository layer for data access. While Clean Architecture was considered, it would be over-engineering for an MVP of this size. The current structure keeps concerns separated while remaining pragmatic.

```
XKCDComicViewerApp/
├── App/                  # App entry point
├── Data/
│   ├── DTOs/             # API response models
│   ├── Network/          # API client, endpoints, error handling
│   └── Repositories/     # Data access layer
├── Domain/
│   └── Models/           # Business models
├── Features/
│   ├── ComicList/        # Main comic browsing (View + ViewModel)
│   └── ComicExplanation/ # Explanation WebView
├── Shared/
│   ├── Components/       # Reusable UI components
│   └── Constants/        # Icons, strings, view state
└── Resources/            # Assets
```

## Tech Stack

- **Swift 6** with strict concurrency
- **SwiftUI** for UI
- **Swift Testing** for unit tests
- **Async/Await** for networking
- **SwiftLint** for code style
- **iOS 26+**

## Design Decisions

- **@Observable** over ObservableObject for modern state management
- **Protocol-based Repository** for testability and dependency injection
- **ViewState enum** for explicit UI state handling (idle, loading, loaded, error)
- **No third-party dependencies** except SwiftLint

## Future Improvements

- Search by comic number and text
- Favorites with offline support
- Push notifications for new comics
- iPad/multiple form factor support

## How to Run

1. Open `XKCDComicViewerApp.xcodeproj` in Xcode
2. Select a simulator or device (iOS 26+)
3. Build and run (⌘R)

## Testing

Run tests with ⌘U or `xcodebuild test`
