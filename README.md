# Dependency Injection Container

[English](README.md) | [한국어](README-ko.md)

## Overview

The Swift Dependency Injection Container is a lightweight and flexible library designed to facilitate dependency management in Swift applications. It provides a structured and type-safe approach to resolve dependencies throughout your codebase, promoting code reusability, testability, and maintainability.

## Features
- Type-safe dependency resolution.
- Lazy instantiation of dependencies.
- Property wrappers for convenient dependency injection.
- Dynamic module registration and management.
- Result builder syntax for declarative module registration.
- Debug utilities for module and injection key scanning.

## Requirements

- Swift 5.9+

## Installation

DIContainer is available [Swift Package Manager](https://swift.org/package-manager/).

### Swift Package Manager

in `Package.swift` add the following:

```swift
dependencies: [
    .package(url: "https://github.com/minsOne/DIContainer.git", from: "1.0.0")
]
```

## Usage

### Basic Usage

First, register a key and module pair to a `Container`, where the module has concreate type. `Key` has `protocol type`, and `concreate type` is inheriting `protocol type`

```swift
Container {
    Module(AnimalKey.self) { Cat() }
}
.build()
```

Then get an instance from the container.

```swift
@Inject(AnimalKey.self)
var cat: Meow
cat.doSomething() // prints "Meow.."
// or
Container[AnimalKey.self].doSomething() // prints "Meow.."
```

Where definitions of the protocols and struct are

```swift
class AnimalKey: InjectionKey {
    var type: Meow?
}

protocol Meow {
    func doSomething()
}

struct Cat: Meow {
    func doSomething() {
        print("Meow..")
    }
}
```

### Test

```shell
$ (cd MockData/Sources/MockData && for i in {1..20}; do cp MockClass.swift MockClass$i.swift; done)
$ swift test
$ swift test -Xswiftc -O
```

## Contributing
Contributions to the Swift Dependency Injection Container are welcome. Here are ways you can contribute:
- Reporting issues
- Suggesting enhancements
- Submitting pull requests with bug fixes or new features

Please ensure to follow the coding standards and write tests for new functionality.

## License
This project is licensed under the [MIT License](LICENSE).

## Post

*  [[Swift 5.7+] Dependency Injection (1) - PropertyWrapper를 이용한 Service Locator 구현하기](https://minsone.github.io/ios-dicontainer-1-property-wrapper)
* [[Swift 5.7+] Dependency Injection (2) - 컨테이너 무결성 보장해 보기](https://minsone.github.io/ios-dicontainer-2-property-wrapper)
* [[Swift 5.7+][Objective-C] Dependency Injection (3) - objc_getClassList를 사용하여 모든 클래스 목록 얻기](https://minsone.github.io/ios-dicontainer-3-property-wrapper)

## Credits

The DIContainer are inspired by:

* [Dependency Injection in Swift using latest Swift features](https://www.avanderlee.com/swift/dependency-injection/)
* [iOS Dependency Injection Using Swinject](https://ali-akhtar.medium.com/ios-dependency-injection-using-swinject-9c4ceff99e41)
* [Dependency Injection via Property Wrappers](https://www.kiloloco.com/articles/004-dependency-injection-via-property-wrappers/)
* [DI 라이브러리 “Koin” 은 DI가 맞을까?](https://dev-kimji1.medium.com/di-%EB%9D%BC%EC%9D%B4%EB%B8%8C%EB%9F%AC%EB%A6%AC-koin-%EC%9D%80-di%EA%B0%80-%EB%A7%9E%EC%9D%84%EA%B9%8C-66f974fead4f)
* [SwiftLee 방식의 DI를 하는 것으로 TCA의 Environment 버킷 릴레이를 그만두고 싶은 이야기](https://zenn.dev/yimajo/articles/e9f72549270873)
* [Swift Dependency Injection via Property Wrapper](https://zamzam.io/swift-dependency-injection-via-property-wrapper/)
* [뱅크샐러드 안드로이드 앱에서 Koin 걷어내고 Hilt로 마이그레이션하기](https://blog.banksalad.com/tech/migrate-from-koin-to-hilt/)
* [마틴 파울러 - Inversion of Control Containers and the Dependency Injection pattern](https://martinfowler.com/articles/injection.html)
  * [번역글](https://edykim.com/ko/post/the-service-locator-is-an-antipattern/)
* [Nest.js는 실제로 어떻게 의존성을 주입해줄까?](https://velog.io/@coalery/nest-injection-how)
* [mikeash.com - Friday Q&A 2014-08-08: Swift Name Mangling](https://mikeash.com/pyblog/friday-qa-2014-08-15-swift-name-mangling.html)
* [Wikipedia - Name mangling](https://en.wikipedia.org/wiki/Name_mangling#Swift)
* [Github - DerekSelander/dsdump](https://github.com/DerekSelander/dsdump)
* [Github - Apple/swift-service-context](https://github.com/apple/swift-service-context)
* [Building a class-dump in 2020](https://derekselander.github.io/dsdump/)
