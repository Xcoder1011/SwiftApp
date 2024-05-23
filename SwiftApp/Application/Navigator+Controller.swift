//
//  Navigator+Controller.swift
//  SwiftApp
//
//  Created by KUN on 2024/1/18.
//

import Foundation
import UIKit

extension Navigator {
    
    enum Scene {
        case home
        case navHome
        case mvc
        case mvp
        case mvvm_closures
        case mvvm_functions_subjects
        case mvvm_rxswift_subjects
        case mvvm_rxswift_pure
        case rxswift_github
        case combine_github
    }
    
    func getController(scene: Scene) -> UIViewController? {
        switch scene {
        case .home: return ViewController(viewModel: nil, navigator: self)
        case .navHome: return NavigationController(rootViewController: ViewController(viewModel: MainViewModel(service: NetworkingServiceIMP()), navigator: self))
        case .mvc: return MVCViewController(viewModel: nil, navigator: self)
        case .mvp: return MVPViewController(viewModel: MVPViewModel(service: NetworkingServiceIMP()), navigator: self)
        case .mvvm_closures:
            return MVVMClosuresViewController(viewModel: MVVMClosuresViewModel(service: NetworkingServiceIMP()), navigator: self)
        case .mvvm_functions_subjects:
            return FunctionsSubjectsController(viewModel: FunctionsSubjectsViewModel(service: NetworkingServiceIMP()), navigator: self)
        case .mvvm_rxswift_subjects:
            return RxSwiftSubjectsController(viewModel: RxSwiftSubjectsViewModel(service: NetworkingServiceIMP()), navigator: self)
        case .mvvm_rxswift_pure:
            return RxSwiftPureViewController(viewModel: RxSwiftPureViewModel(service: NetworkingServiceIMP()), navigator: self)
        case .rxswift_github:
            return RxSwiftGitHubSearchController(viewModel: RxSwiftGitHubSearchViewModel(service: NetworkingServiceIMP()), navigator: self)
        case .combine_github:
            return CombineGitHubSearchController(viewModel: CombineGitHubSearchViewModel(service: NetworkingServiceIMP()), navigator: self)
        }
    }
}
