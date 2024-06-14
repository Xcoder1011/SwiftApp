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
        case resetRoot(in: UIWindow)
        case navigation
        case modal
        case present
        case detail
    }
    
    /// 显示场景
    ///
    /// - Parameters:
    ///   - scene: 要显示的场景
    ///   - sender: 发送者视图控制器
    ///   - transition: 跳转类型，默认为导航跳转
    func show(scene: Scene, sender: UIViewController?, transition: Transition = .navigation) {
        if let target = getController(scene: scene) {
            _show(target: target, sender: sender, transition: transition)
        }
    }
}

private extension Navigator {
    func _show(target: UIViewController, sender: UIViewController?, transition: Transition) {
        switch transition {
        case .root(in: let window):
            window.rootViewController = target
            return
        case .resetRoot(in: let window):
            UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromLeft, animations: {
                window.rootViewController = target
            }, completion: nil)
            return
        default: break
        }
        
        guard let sender else {
            print("Navigator need to pass a sender")
            return
        }
        
        func presentViewController(viewController: UIViewController, animated: Bool, completion: (() -> Void)? = nil) {
            DispatchQueue.main.async {
                sender.present(viewController, animated: animated, completion: completion)
            }
        }
        
        switch transition {
        case .navigation:
            if let nav = sender.navigationController {
                nav.pushViewController(target, animated: true)
            }
        case .modal:
            let nav = NavigationController(rootViewController: target)
            presentViewController(viewController: nav, animated: true)
        case .detail:
            DispatchQueue.main.async {
                let nav = NavigationController(rootViewController: target)
                sender.showDetailViewController(nav, sender: nil)
            }
        case .present:
            presentViewController(viewController: target, animated: true)
        default: break
        }
    }
}
