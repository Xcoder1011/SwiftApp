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
    
    private override init() {
        navigator = Navigator.default
        super.init()
    }
        
    var window: UIWindow?
    let navigator: Navigator

    func initialScreenWindow(in window: UIWindow?) {
        guard let window = window else { return }
        self.window = window
        self.navigator.show(scene: .navHome, sender: nil, transition: .root(in: window))
    }
}


extension Notification.Name {
    public static let SKLanguageChangeNotification =
        Notification.Name("com.kun.SwiftApp.SKLanguageChangeNotification")
}
