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
        case .navHome: return NavigationController(rootViewController: ViewController(viewModel: MainViewModel(service: NetworkingApi()), navigator: self))
        case .mvc: return MVCViewController(viewModel: nil, navigator: self)
        case .mvp: return MVPViewController(viewModel: MVPViewModel(service: NetworkingApi()), navigator: self)
        case .mvvm_closures:
            return MVVMClosuresViewController(viewModel: MVVMClosuresViewModel(service: NetworkingApi()), navigator: self)
        case .mvvm_functions_subjects:
            return FunctionsSubjectsController(viewModel: FunctionsSubjectsViewModel(service: NetworkingApi()), navigator: self)
        case .mvvm_rxswift_subjects:
            return RxSwiftSubjectsController(viewModel: RxSwiftSubjectsViewModel(service: NetworkingApi()), navigator: self)
        case .mvvm_rxswift_pure:
            return RxSwiftPureViewController(viewModel: RxSwiftPureViewModel(service: NetworkingApi()), navigator: self)
        case .rxswift_github:
            return RxSwiftGitHubSearchController(viewModel: RxSwiftGitHubSearchViewModel(service: NetworkingApi()), navigator: self)
        case .combine_github:
            return CombineGitHubSearchController(viewModel: CombineGitHubSearchViewModel(service: NetworkingApi()), navigator: self)
        }
    }
}
