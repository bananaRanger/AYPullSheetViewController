# AYPullSheetViewController

[![CI Status](https://img.shields.io/travis/antonyereshchenko@gmail.com/AYPullSheetViewController.svg?style=flat)](https://travis-ci.org/antonyereshchenko@gmail.com/AYPullSheetViewController)
[![Version](https://img.shields.io/cocoapods/v/AYPullSheetViewController.svg?style=flat)](https://cocoapods.org/pods/AYPullSheetViewController)
[![License](https://img.shields.io/cocoapods/l/AYPullSheetViewController.svg?style=flat)](https://cocoapods.org/pods/AYPullSheetViewController)
[![Platform](https://img.shields.io/cocoapods/p/AYPullSheetViewController.svg?style=flat)](https://cocoapods.org/pods/AYPullSheetViewController)

<p align="center">
  <img width="32%" height="32%" src="https://github.com/bananaRanger/AYPullSheetViewController/blob/master/Resources/logo.png?raw=true">
</p>

## About

AYPullSheetViewController - is the pull view controller. That you can use to display any additional information or provide a list of actions to the user for choosing.

## Installation

AYPullSheetViewController is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
inhibit_all_warnings!

target 'YOUR_TARGET_NAME' do
  use_frameworks!
	pod 'AYPullSheetViewController'
end
```

## Usage

```swift
// 'clickHandler' - closure of 'AYActionViewClickHandler' type.

let pullSheet = AYPullSheetViewController.create(
  initialAppearancePercent: 32,
  finalAppearancePercent: 92,
  horizontalSpacing: 16,
  animationType: .scaled)
  
pullSheet.containerView?.pullView?.topCornerRadius = 16
pullSheet.containerView?.pullView?.arrow?.strokeColor = .action

pullSheet.addRow(actionView: AYPullItemActionView.make(with: "Home", image: nil, clickHandler: clickHandler))
pullSheet.addRow(actionView: AYPullItemActionView.make(with: "About", image: nil, clickHandler: clickHandler))
pullSheet.addRow(actionView: AYPullItemActionView.make(with: "Settings", image: nil, clickHandler: clickHandler))

present(pullSheet, animated: true, completion: nil)
```

### Demo

<p align="center">
  <img width="64%" height="64%" src="https://github.com/bananaRanger/AYPullSheetViewController/blob/master/Resources/demo.png?raw=true">
</p>


## Author

Anton Yereshchenko

## License

AYPullSheetViewController is available under the MIT license. See the LICENSE file for more info.

## Used in project

Icons:

Icons8 - https://icons8.com
