//
//  Application.swift
//  SwiftApp
//
//  Created by KUN on 2023/11/30.
//

import Foundation
import UIKit

class Application: NSObject {
    static let shared = Application()

    override private init() {
        self.navigator = Navigator.default
        super.init()
    }

    var window: UIWindow?
    let navigator: Navigator

    func initialScreenWindow(in window: UIWindow?) {
        guard let window else { return }
        self.window = window
        self.navigator.show(scene: .navHome, sender: nil, transition: .root(in: window))
    }
}

public extension Notification.Name {
    static let SKLanguageChangeNotification =
        Notification.Name("com.kun.SwiftApp.SKLanguageChangeNotification")
}
