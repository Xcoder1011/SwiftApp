//
//  AppDelegate.swift
//  SwiftApp
//
//  Created by KUN on 2023/11/26.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        LibsManager.shared.setupLibs()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()
        Application.shared.initialScreenWindow(in: window)
        return true
    }
}

