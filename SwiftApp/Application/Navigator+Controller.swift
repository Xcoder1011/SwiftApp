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
        case .home: ViewController(viewModel: nil, navigator: self)
        case .navHome: NavigationController(rootViewController: ViewController(viewModel: MainViewModel(service: NetworkingServiceIMP()), navigator: self))
        case .mvc: MVCViewController(viewModel: nil, navigator: self)
        case .mvp: MVPViewController(viewModel: MVPViewModel(service: NetworkingServiceIMP()), navigator: self)
        case .mvvm_closures:
            MVVMClosuresViewController(viewModel: MVVMClosuresViewModel(service: NetworkingServiceIMP()), navigator: self)
        case .mvvm_functions_subjects:
            FunctionsSubjectsController(viewModel: FunctionsSubjectsViewModel(service: NetworkingServiceIMP()), navigator: self)
        case .mvvm_rxswift_subjects:
            RxSwiftSubjectsController(viewModel: RxSwiftSubjectsViewModel(service: NetworkingServiceIMP()), navigator: self)
        case .mvvm_rxswift_pure:
            RxSwiftPureViewController(viewModel: RxSwiftPureViewModel(service: NetworkingServiceIMP()), navigator: self)
        case .rxswift_github:
            RxSwiftGitHubSearchController(viewModel: RxSwiftGitHubSearchViewModel(), navigator: self)
        case .combine_github:
            CombineGitHubSearchController(viewModel: CombineGitHubSearchViewModel(), navigator: self)
        }
    }
}
