# Dependency Injection Container

[English](README.md) | [한국어](README-ko.md)

## 개요
Swift 의존성 주입 컨테이너는 Swift 애플리케이션에서 의존성 관리를 용이하게 하기 위해 설계된 경량화되고 유연한 라이브러리입니다. 이 라이브러리는 코드베이스 전반에 걸쳐 의존성을 해결하는 구조화되고 타입 안전한 접근 방식을 제공하여 코드 재사용성, 테스트 용이성 및 유지 관리성을 향상시킵니다.

## 기능
- 타입 안전 의존성 해결.
- 의존성의 지연 인스턴스화.
- 편리한 의존성 주입을 위한 프로퍼티 래퍼.
- 동적 모듈 등록 및 관리.
- 선언적 모듈 등록을 위한 결과 빌더 구문.
- 주입 키와 자동 모듈을 발견하는 디버그 전용 스캐너.
- `AutoModule`과 `Container.autoRegisterModules()`를 통한 디버그 빌드 자동 모듈 등록.

## 요구사항

- Swift 5.9+

## 설치

DIContainer는 [Swift Package Manager](https://swift.org/package-manager/)를 사용할 수 있습니다.

### Swift Package Manager

`Package.swift` 파일에 이 라이브러리를 의존성으로 추가할 수 있습니다.

```swift
dependencies: [
    .package(url: "https://github.com/minsOne/DIContainer.git", from: "1.0.0")
]
```

## 사용법

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

### Scanner와 자동 모듈 등록

DIContainer는 로드된 앱에서 주입 키와 자동 모듈을 발견하는 디버그 전용 스캐너를 제공합니다.

- `ModuleScanner`는 Objective-C 런타임으로 클래스를 스캔합니다.
- `MachOLoader`는 로드된 Mach-O 이미지의 Swift 메타데이터를 스캔합니다.
- `Container.autoRegisterModules()`는 스캔된 `AutoModule` 구현체 타입을 `Module`로 변환해 컨테이너를 구성합니다.

키와 구현체의 역할은 서로 다릅니다.

- `InjectionKey`는 의존성 계약을 정의합니다. `Value`는 보통 호출자가 의존하는 프로토콜이나 추상 타입입니다.
- `AutoModule` 구현체는 실제 생성될 구체 타입입니다. `ModuleKeyType`은 이 구현체를 어떤 키로 등록할지 스캐너에게 알려줍니다.
- `keyList`는 진단에 유용하지만, 자동 등록은 스캔된 `AutoModule` 구현체와 그 구현체의 `ModuleKeyType`을 기준으로 동작합니다.

아래 예제에서 `FooServiceKey`는 `FooService`를 resolve 가능한 타입으로 노출하고, `FooServiceImpl`은 스캐너가 발견하는 실제 구현체입니다.

```swift
final class FooServiceKey: InjectionKey {
    typealias Value = FooService
}

protocol FooService {
    func doSomething()
}

final class FooServiceImpl: AutoModule, FooService {
    typealias ModuleKeyType = FooServiceKey

    func doSomething() {
        print("Foo")
    }
}
```

스캔 이후 DIContainer는 이 구현체를 다음과 같은 명시 등록과 같은 의미로 다룹니다.

```swift
Module(FooServiceKey.self) {
    FooServiceImpl()
}
// or
Module(FooServiceImpl.self)
```

그다음 디버그 composition root에서 스캔된 모듈을 자동 등록할 수 있습니다.

```swift
#if DEBUG
Container.autoRegisterModules()
#endif
```

스캔 결과를 직접 확인할 수도 있습니다.

```swift
let keys = ModuleScanner().keyList
let modules = ModuleScanner().scanModuleList
Container(modules: modules).build()
```

Scanner API는 `#if DEBUG`에서만 컴파일됩니다. 진단, 데모, 테스트 등록에는 유용하지만, 프로덕션 composition은 명시적으로 구성하고 테스트로 보호하는 것을 권장합니다.

### Test

```shell
$ (cd MockData/Sources/MockData && for i in {1..20}; do cp MockClass.swift MockClass$i.swift; done)
$ swift test
$ swift test -Xswiftc -O
```

## 기여
Swift 의존성 주입 컨테이너에 대한 기여는 언제나 환영합니다. 다음과 같은 방식으로 기여할 수 있습니다.
- 이슈 보고
- 기능 개선 제안
- 버그 수정 또는 새로운 기능을 위한 풀 요청 제출

새로운 기능을 추가할 때는 코딩 표준을 따르고 테스트를 작성해 주시기 바랍니다.

## 라이센스
이 프로젝트는 [MIT 라이선스](LICENSE)를 따릅니다.

## Post

*  [[Swift 5.7+] Dependency Injection (1) - PropertyWrapper를 이용한 Service Locator 구현하기](https://minsone.github.io/ios-dicontainer-1-property-wrapper)
* [[Swift 5.7+] Dependency Injection (2) - 컨테이너 무결성 보장해 보기](https://minsone.github.io/ios-dicontainer-2-property-wrapper)
* [[Swift 5.7+][Objective-C] Dependency Injection (3) - objc_getClassList를 사용하여 모든 클래스 목록 얻기](https://minsone.github.io/ios-dicontainer-3-property-wrapper)

## Credits

DIContainer는 다음 자료에서 영감을 받았습니다:

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
* [Github - Apple/swift-service-context](https://github.com/apple/swift-service-context)
* [Github - baidu/CarbonGraph](https://github.com/baidu/CarbonGraph)
* [Github - DerekSelander/dsdump](https://github.com/DerekSelander/dsdump)
* [Github - p-x9/MachOKit](https://github.com/p-x9/MachOKit)
* [Github - SpectralDragon/DITranquillity](https://github.com/SpectralDragon/DITranquillity)
* [Github - ukhsa-collaboration/covid-19-app-ios-ag-public](https://github.com/ukhsa-collaboration/covid-19-app-ios-ag-public)
* [Building a class-dump in 2020](https://derekselander.github.io/dsdump/)
