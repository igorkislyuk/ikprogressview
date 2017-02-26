# IKProgressView

<!-- [![CI Status](http://img.shields.io/travis/igorkislyuk/IKProgressView.svg?style=flat)](https://travis-ci.org/igorkislyuk/IKProgressView) -->

[![Version](https://img.shields.io/cocoapods/v/IKProgressView.svg?style=flat)](http://cocoapods.org/pods/IKProgressView)
[![License](https://img.shields.io/cocoapods/l/IKProgressView.svg?style=flat)](http://cocoapods.org/pods/IKProgressView)
[![Platform](https://img.shields.io/cocoapods/p/IKProgressView.svg?style=flat)](http://cocoapods.org/pods/IKProgressView)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/igorkislyuk/ikprogressview)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

iOS 8.0 and higher

## Installation

IKProgressView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "IKProgressView"
```

## Example
<img src="https://raw.githubusercontent.com/igorkislyuk/ikprogressview/master/gifs/example-1.gif" width="267px"/>

## Features

- Cool radial animated progress view.

- Use `setProgress(XXX, animated: YYY, ZZZ)` - method for setting progress animated or not. Completion is required due to animation performs with redraw whole progress view. If you know how to implement this stuff using CoreAnimation, feel free to contact me.
- `filledView` - mean that progress view will use whole view, measure it sizes itself
- `interiorR` & `exteriorR` - radiuses for progress view, only usable within turn off-ed `filledView`
- `animated` - static view, or active redrawing with gradient animation.

There are some inner setting, you can play with.

## Author

Igor Kislyuk, igorkislyuk@icloud.com

## License

IKProgressView is available under the MIT license. See the LICENSE file for more info.
