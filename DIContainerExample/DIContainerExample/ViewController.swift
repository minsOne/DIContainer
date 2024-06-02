//
//  ViewController.swift
//  DIContainerExample
//
//  Created by minsOne on 6/2/24.
//

import DIContainer
import UIKit

class ViewController: UIViewController {
    @Inject(FooServiceKey.self) var fooService
    @Inject(BarServiceKey.self) var barService
    @Inject(BazServiceKey.self) var bazService

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        fooService.doSomething()
        barService.doSomething()
        bazService.doSomething()
    }
}
