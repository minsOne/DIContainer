//
//  BarServiceImpl.swift
//  DIContainerExample
//
//  Created by minsOne on 6/2/24.
//

import DIContainer
import Foundation

final class BarServiceImpl: AutoModule, BarService {
    typealias ModuleKeyType = BarServiceKey

    var count = 0

    func doSomething() {
        count += 1
        print("\(Self.self) doing something... count : \(count)")
    }
}
