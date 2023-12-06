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
            MySection(header: "MVVM", items: [
                "SimpleValidation",
                "MVVM 设计模式"
            ]),
            MySection(header: "RxFeedback", items: [
                "反馈循环架构"
            ]),
            MySection(header: "ReactorKit ", items: [
                "结合了 Flux 和响应式编程的架构"
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
