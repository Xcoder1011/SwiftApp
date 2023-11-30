# SwiftApp

## Technologies
- [x] Clean architecture ([RxSwift](https://github.com/ReactiveX/RxSwift) and MVVM)
- [x] REST API v3 (for unauthenticated or basic authentication) ([Moya](https://github.com/Moya/Moya), [ObjectMapper](https://github.com/tristanhimmelman/ObjectMapper))
- [x] Custom transition animations ([Hero](https://github.com/HeroTransitions/Hero))
- [x] Programmatically UI ([SnapKit](https://github.com/SnapKit/SnapKit))
- [x] Crash reporting ([Crashlytics](https://fabric.io/kits/ios/crashlytics))
- [x] Logging ([CocoaLumberjack](https://github.com/CocoaLumberjack/CocoaLumberjack))


## Tools
- [x] [Brew](https://github.com/Homebrew/brew) - The missing package manager for macOS
- [x] [Bundler](https://github.com/bundler/bundler) - Manage your Ruby application's gem dependencies
- [x] [Fastlane](https://github.com/fastlane/fastlane) - The easiest way to automate building and releasing your iOS and Android apps
- [x] [SwiftLint](https://github.com/realm/SwiftLint) - A tool to enforce Swift style and conventions
- [x] [R.swift](https://github.com/mac-cain13/R.swift) - Get strong typed, autocompleted resources like images, fonts and segues in Swift projects


## Building and Running

Install Xcode's command line tools
```sh
xcode-select --install
```

Install [`Bundler`](https://bundler.io) for managing Ruby gem dependencies
```sh
[sudo] gem install bundler
```


The following commands will set up SwiftApp
```sh
bundle install
bundle exec fastlane setup
```
