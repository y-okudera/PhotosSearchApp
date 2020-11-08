# PhotosSearchApp
RxSwiftを使用したサンプルアプリ

## Architecture

Clean ArchitectureでPresentationレイヤーには、MVVMを採用

### Libraries

Using Swift Package Manager.

|   Name    | Version |
| :-------: | :-----: |
| Alamofire |  5.3.0  |
|   Nuke    |  9.1.2  |
| XCGLogger |  7.0.1  |
|  RxSwift  |  5.1.1  |
|   Unio    | 0.10.0  |
|  Action   |  4.2.0  |

## Environment


|       Name        |      Version      |
| :---------------: | :---------------: |
|       Xcode       |      12.0.1       |
| Deployment Target | iOS 13.0 or later |

## Build

Flickr APIのAPIキーは、cocoapods-keysを利用して管理していますが、.envファイルはGit管理されていません。

動作確認する際には、APIキーを発行して、.envファイルに `FlickrAPIKey="<発行したAPIキー>"`の形式で保存してください。

Podfileと同階層に.envファイルを格納し、 `pod install`を実行すると、動作確認ができるようになります。
