//
//  RegisterContainer.swift
//  DIContainerExample
//
//  Created by minsOne on 6/2/24.
//

import DIContainer
import Foundation

struct RegisterContainer {
    func setup() {
        Container {
            FooModuleFactory().makeModule()
            BarModuleFactory().makeModule()
            BazModuleFactory().makeModule()
        }.build()
    }
}
