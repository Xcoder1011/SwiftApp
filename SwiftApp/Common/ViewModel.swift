//
//  ViewModel.swift
//  SwiftApp
//
//  Created by KUN on 2023/12/6.
//

import Foundation
import RxCocoa
import RxSwift
import Combine

protocol ViewModelType {
    associatedtype Input
    associatedtype Output

    func transform(input: Input) -> Output
}

class ViewModel: NSObject, ObservableObject {
    /// RxSwift
    let disposeBag = DisposeBag()
    var service: NetworkingService
    let loading = BehaviorRelay(value: false)
    
    /// Combine
    var cancellables = Set<AnyCancellable>()

    init(service: NetworkingService) {
        self.service = service
        super.init()
    }

    override convenience init() {
        self.init(service: NetworkingServiceIMP())
    }

    deinit {
        logDebug("\(type(of: self)): Deinited")
    }
}
