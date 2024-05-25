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
        let ready: Observable<Void>
        let selection: Driver<Item>
    }
    
    struct Output {
        let sections: Driver<[MySection]>
        let itemSelected: Driver<Item>
    }
    
    func transform(input: Input) -> Output {
        let sectionsRelay = BehaviorRelay<[MySection]>(value: [])
        let selectedItemsRelay = PublishSubject<Item>()
        
        let sectionsData = [
            MySection(header: "设计模式", items: [
                Item(title: "mvc", scene: .mvc),
                Item(title: "mvp", scene: .mvp)
            ]),
            MySection(header: "MVVM", items: [
                Item(title: "mvvm-closures", scene: .mvvm_closures),
                Item(title: "mvvm-functions-subjects-observables", scene: .mvvm_functions_subjects),
                Item(title: "mvvm-rxswift-subjects-observables", scene: .mvvm_rxswift_subjects),
                Item(title: "mvvm-rxswift-pure", scene: .mvvm_rxswift_pure)
            ]),
            MySection(header: "RxSwift", items: [
                Item(title: "GitHub", scene: .rxswift_github)
            ]),
            MySection(header: "Combine", items: [
                Item(title: "GitHub", scene: .combine_github)
            ])
        ]
        
        input.ready.flatMapLatest({ () -> Observable<[MySection]> in
            return Observable.just(sectionsData)
        }).subscribe(onNext: { (sections) in
            sectionsRelay.accept(sections)
        }, onError: { error in
            print("Error occurred: \(error)")
        }).disposed(by: disposeBag)
        
        input.selection.asObservable().bind(to: selectedItemsRelay).disposed(by: disposeBag)
        
        let itemSelectedDriver = selectedItemsRelay.asDriver(onErrorRecover: { error in
            return Driver.just(Item(title: "", scene: .home))
        })
        return Output(sections: sectionsRelay.asDriver(), itemSelected: itemSelectedDriver)
    }
}
