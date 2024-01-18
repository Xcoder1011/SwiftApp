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
  
    enum Transition {
        case root(in: UIWindow)
        case resetToot(in: UIWindow)
        case navigation
        case modal
        case present
        case detail
    }
    
    func show(scene: Scene, sender: UIViewController?, transition: Transition = .navigation) {
        if let target = getController(scene: scene) {
            _show(target: target, sender: sender, transition: transition)
        }
    }
    
    private func _show(target: UIViewController, sender: UIViewController?, transition: Transition) {
        switch transition {
        case .root(in: let window):
            window.rootViewController = target
            return
        case .resetToot(in: let window):
            UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromLeft, animations: {
                window.rootViewController = target
            }, completion: nil)
            return
        default: break
        }
        
        guard let sender = sender else {
            fatalError("Navigator need to pass a sender")
        }
        
        if let nav = sender as? UINavigationController {
            nav.pushViewController(target, animated: false)
            return
        }
        
        switch transition {
        case .navigation:
            if let nav = sender.navigationController {
                nav.pushViewController(target, animated: true)
            }
        case .modal:
            DispatchQueue.main.async {
                let nav = NavigationController(rootViewController: target)
                sender.present(nav, animated: true, completion: nil)
            }
        case .detail:
            DispatchQueue.main.async {
                let nav = NavigationController(rootViewController: target)
                sender.showDetailViewController(nav, sender: nil)
            }
        case .present:
            DispatchQueue.main.async {
                sender.present(target, animated: true, completion: nil)
            }
        default: break
        }
    }
    
}
