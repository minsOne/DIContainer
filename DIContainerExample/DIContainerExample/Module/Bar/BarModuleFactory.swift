//
//  BarModuleFactory.swift
//  DIContainerExample
//
//  Created by minsOne on 6/2/24.
//

import DIContainer
import Foundation

struct BarModuleFactory {
    func makeModule() -> Module {
        Module(BarServiceImpl.self)
    }
}
