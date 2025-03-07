# DLProgressHUD

[![CI Status](https://img.shields.io/travis/DeluxeAlonso/DLProgressHUD.svg?style=flat)](https://travis-ci.org/DeluxeAlonso/DLProgressHUD)
[![Version](https://img.shields.io/cocoapods/v/DLProgressHUD.svg?style=flat)](https://cocoapods.org/pods/DLProgressHUD)
[![License](https://img.shields.io/cocoapods/l/DLProgressHUD.svg?style=flat)](https://cocoapods.org/pods/DLProgressHUD)
[![Platform](https://img.shields.io/cocoapods/p/DLProgressHUD.svg?style=flat)](https://cocoapods.org/pods/DLProgressHUD)

Lightweight Progress HUD implementation for iOS.

## Demo

| Loading   |      Loading with text      | Text only     |      Image     |      Image with text      |
|:----------:|:-------------:|:-------------:|:-------------:|:-------------:|
| ![](Screenshots/Loading.gif) | ![](Screenshots/LoadingWithText.gif) |  <img src="Screenshots/TextOnly.png" width=200 height=100> | <img src="Screenshots/Image.png" width=130 height=130> | <img src="Screenshots/ImageWithText.png" width=130 height=130> |

## Example project

To run the example project, clone the repo, and run `pod install` from the Example directory beforehand.

## Requirements

DLProgressHUD requires iOS 13.0 and Swift 5.0 or above. For iOS 12 support you can use 0.1.12 pod version.

## Installation

DLProgressHUD is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'DLProgressHUD'
```

## Usage

There are five modes that can be used to show the progress HUD: loading, loadingWithText, textOnly, image and imageWithText.

You just need to call the show method and pass the HUD mode as a parameter:

```swift
DLProgressHUD.show(.loading)
```

## Available HUD modes

| Mode   |      Description      |
|:----------:|:-------------:|
| loading |  HUD with an activity indicator only |
| loadingWithText(_ text: String) |  HUD with an activity indicator and a text label below it |
| textOnly(_ text: String) |  HUD with a text label only |
| image(_ image: UIImage) |  HUD with an image view only |
| imageWithText(image: UIImage, text: String) |  HUD with an image view and a text label below it |

## Appearance and presentation configuration

There are two ways to configure the appearance and presentation of `DLProgressHUD`:

1) You can do it globally using the `DefaultHudConfiguration` class before instantiation.

```swift
DLProgressHUD.defaultConfiguration.backgroundInteractionEnabled = true
DLProgressHUD.show(.loading)
```

2) You can create your own configuration instance that conforms to `HudConfigurationProtocol` protocol and pass it on `DLProgressHUD`'s methods.

```swift
struct HudCustomConfiguration: HudConfigurationProtocol {
    var hudContentPreferredHeight: CGFloat = 64
    var hudContentPreferredWidth: CGFloat = 180
    var textFont: UIFont = .systemFont(ofSize: 18.0)
}
```

```swift
let configuration = HudCustomConfiguration()
DLProgressHUD.show(.textOnly("Loading..."), configuration: configuration)
```

## Author

DeluxeAlonso, alonso.alvarez.dev@gmail.com

## License

DLProgressHUD is available under the MIT license. See the LICENSE file for more info.
