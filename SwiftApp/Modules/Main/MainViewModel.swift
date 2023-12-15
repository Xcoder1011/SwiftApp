//
//  MainViewModel.swift
//  SwiftApp
//
//  Created by KUN on 2023/12/14.
//

import Foundation
import RxCocoa
import RxSwift

class MainViewModel: ViewModel, ViewModelType {
    
    struct Input {
        let headerRefresh: Observable<Void>
        let selection: Driver<Item>
    }
    
    struct Output {
        let sections: Driver<[MySection]>
        let itemSelected: Driver<Item>
    }
    
    func transform(input: Input) -> Output {
        let elements = BehaviorRelay<[MySection]>(value: [])
        let itemSelected = PublishSubject<Item>()
        
        input.headerRefresh.flatMapLatest({ [weak self] () -> Observable<[MySection]> in
            guard self != nil else { return Observable.just([]) }
            let items = Observable.just([
                MySection(header: "设计模式", items: [
                    "mvc",
                    "mvp"
                ]),
                MySection(header: "MVVM", items: [
                    "mvvm-closures",
                    "mvvm-functions-subjects-observables",
                    "mvvm-rxswift-pure",
                    "mvvm-rxswift-subjects-observables"
                ]),
                MySection(header: "反馈循环架构", items: [
                    "RxFeedback"
                ]),
                MySection(header: "结合了 Flux 和响应式编程的架构", items: [
                    "ReactorKit"
                ])
            ])
            return items
        }).subscribe(onNext: { (items) in
            elements.accept(items)
        }).disposed(by: disposeBag)
        
        input.selection.asObservable().bind(to: itemSelected).disposed(by: disposeBag)
        
        return Output(sections: elements.asDriver(), itemSelected: itemSelected.asDriver(onErrorJustReturn: ""))
    }
}
