//
//  CommonAPI.swift
//  SwiftApp
//
//  Created by KUN on 2023/12/6.
//

import Foundation
import RxSwift
import RxCocoa

protocol CommonAPI {
    func localSections() -> Single<[MySection]>
    func login(username: String, password: String) -> Single<String>
}

class ApiTool: CommonAPI {
   
}

extension ApiTool {
    func localSections() -> Single<[MySection]> {
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
        ]).asSingle()
        return items
    }
    
    func login(username: String, password: String) -> Single<String> {
        return Single.create { single in
            DispatchQueue.global().async {
                single(.success(""))
            }
            return Disposables.create { }
            }
        .observe(on: MainScheduler.instance)
    }
}
