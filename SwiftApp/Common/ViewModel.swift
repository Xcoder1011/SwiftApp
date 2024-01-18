//
//  ViewModel.swift
//  SwiftApp
//
//  Created by KUN on 2023/12/6.
//

import Foundation
import RxSwift
import RxCocoa

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}

class ViewModel: NSObject {
    var page = 1
    let disposeBag = DisposeBag()
    let service: NetworkingService
    let loading = ActivityIndicator()
    let headerLoading = ActivityIndicator()
    let footerLoading = ActivityIndicator()
        
    init(service: NetworkingService) {
        self.service = service
        super.init()
    }
        
    deinit {
        logDebug("\(type(of: self)): Deinited")
    }
}
