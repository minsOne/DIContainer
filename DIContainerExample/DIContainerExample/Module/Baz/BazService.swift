//
//  BazService.swift
//  DIContainerExample
//
//  Created by minsOne on 6/2/24.
//

import DIContainer
import Foundation

final class BazServiceKey: InjectionKey {
    typealias Value = BazService
}

protocol BazService {
    func doSomething()
}
