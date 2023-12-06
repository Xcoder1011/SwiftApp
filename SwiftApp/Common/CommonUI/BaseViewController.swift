//
//  BaseViewController.swift
//  SwiftApp
//
//  Created by KUN on 2023/12/6.
//

import UIKit
import RxSwift
import RxCocoa
import DZNEmptyDataSet

class BaseViewController: UIViewController {
    
    var viewModel: ViewModel?
    var navigator: Navigator!
    let isLoading = BehaviorRelay(value: false)
    
    let disposeBag = DisposeBag()

    init(viewModel: ViewModel?, navigator: Navigator) {
        self.viewModel = viewModel
        self.navigator = navigator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        makeUI()
        bindViewModel()
    }
    
    func makeUI() {
        view.backgroundColor = .white
    }
    
    func bindViewModel() {
        viewModel?.loading.asObservable().bind(to: isLoading).disposed(by: disposeBag)
        
        isLoading.subscribe(onNext: { isLoading in
            UIApplication.shared.isNetworkActivityIndicatorVisible = isLoading
        }).disposed(by: disposeBag)
    }
}
