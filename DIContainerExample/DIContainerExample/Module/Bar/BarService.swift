//
//  BarService.swift
//  DIContainerExample
//
//  Created by minsOne on 6/2/24.
//

import DIContainer
import Foundation

final class BarServiceKey: InjectionKey {
    typealias Value = BarService
}

protocol BarService {
    func doSomething()
}
