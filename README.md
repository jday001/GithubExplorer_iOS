### GithubExplorer for iOS

This is a version of the GithubExplorer project written natively for iOS in Swift.

![alt text](https://github.com/jdayCBRE/GithubExplorer_iOS/blob/master/GithubExplorer_iOS/media/GithubExplorer_iOS.gif)

#### Pros
- Swift (type safety, concise, great readability)
- XCode, Simulator, Instruments
- Minimal 3rd party dependencies
- Visual tools for UI layout, quick prototypes without writing code
- Great debugging & performance profiling tools
- Great community support & StackOverflow

#### Cons
- Code signing and submission process could be easier, but this is also required for a ReactNative app 🤷🏻‍♂️

#### Development
|   |  |
| ------------- | ------------- |
| __Time to build__ | ~ 4 hours  |
| __Experience Level__ | Several years of professional iOS development |
| __External Dependencies__ | None* |
| __Learning Curve__ | Pretty low since the adoption of Swift  |

*The project does include a homemade networking library, [RemoteDataRequestor](https://github.com/jdayCBRE/GithubExplorer_iOS/blob/master/GithubExplorer_iOS/util/RemoteDataRequestor.swift), and a commonly used utility for managing Keychain access, [KeychainSwift](https://github.com/jdayCBRE/GithubExplorer_iOS/blob/master/GithubExplorer_iOS/util/KeychainSwift.swift), which would rarely change or need to be updated. These are pretty common one time setups for an iOS app.
