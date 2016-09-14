# SwiftCompressor

[![Version](https://img.shields.io/cocoapods/v/SwiftCompressor.svg?style=flat)](http://cocoapods.org/pods/SwiftCompressor)
[![License](https://img.shields.io/cocoapods/l/SwiftCompressor.svg?style=flat)](http://cocoapods.org/pods/SwiftCompressor)
[![Platform](https://img.shields.io/cocoapods/p/SwiftCompressor.svg?style=flat)](http://cocoapods.org/pods/SwiftCompressor)

## Requirements

iOS 9.0+, macOS 10.11+, watchOS 2.0+, tvOS 9.0+

Swift 3

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

SwiftCompressor is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "SwiftCompressor"
```

## Usage

SwiftCompression is a `Data` extension. It lets you easily compress/decompress `Data` objects this way:

```swift
// Create NSData from file
let path = URL(fileURLWithPath: Bundle.main.path(forResource: "lorem", ofType: "txt")!)
let loremData = try? Data(contentsOf: path)

// Compress and then decompress it!
let compressedData = try? loremData?.compress()
let decompressedData = try? compressedData??.decompress()

// You can also choose one of four algorithms and set a buffer size if you want.
// Available algorithms are LZFSE, LZMA, ZLIB and LZ4.
// Compression without parameters uses LZFSE algorithm. Default buffer size is 4096 bytes.
let compressWithLZ4 = try? loremData?.compress(algorithm: .lz4)
let compressWithLZMAReallyBigBuffer = try? loremData?.compress(algorithm: .lzma, bufferSize: 65_536)
```

## Author

Piotr Sochalewski, piotr.sochalewski@droidsonroids.com

## License

SwiftCompressor is available under the MIT license. See the LICENSE file for more info.
