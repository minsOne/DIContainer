//
//  AppDelegate.swift
//  DIContainerExample
//
//  Created by minsOne on 6/2/24.
//

import DIContainer
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        // Override point for customization after application launch.

//        RegisterContainer().setup()

        // If DemoApp is running, use Module Scanner
         Container.autoRegisterModules()

        return true
    }
}
