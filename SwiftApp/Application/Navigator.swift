//
//  Navigator.swift
//  SwiftApp
//
//  Created by KUN on 2023/12/6.
//

import Foundation
import UIKit

protocol NavigatorProtocol {
    var navigator: Navigator! { get set }
}

class Navigator {
    static var `default` = Navigator()
    
    enum Scene {
        case simpleValidation(viewMode: SimpleValidationViewModel)
    }
    
    func getController(scene: Scene) -> UIViewController? {
        switch scene {
            case .simpleValidation(_): return SimpleValidationViewController()
        }
    }
    
}
