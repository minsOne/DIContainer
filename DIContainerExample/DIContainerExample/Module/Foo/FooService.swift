//
//  FooService.swift
//  DIContainerExample
//
//  Created by minsOne on 6/2/24.
//

import DIContainer
import Foundation

final class FooServiceKey: InjectionKey {
    typealias Value = FooService
}

protocol FooService {
    func doSomething()
}
