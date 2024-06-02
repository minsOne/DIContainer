//
//  FooModuleFactory.swift
//  DIContainerExample
//
//  Created by minsOne on 6/2/24.
//

import DIContainer
import Foundation

struct FooModuleFactory {
    func makeModule() -> Module {
        Module(FooServiceImpl.self)
    }
}
