//
//  BazModuleFactory.swift
//  DIContainerExample
//
//  Created by minsOne on 6/2/24.
//

import DIContainer
import Foundation

struct BazModuleFactory {
    func makeModule() -> Module {
        Module(BazServiceImpl.self)
    }
}
