//
//  CommonAPI.swift
//  SwiftApp
//
//  Created by KUN on 2023/12/6.
//

import Foundation
import RxSwift
import RxCocoa

protocol NetworkingService {
    func localSections() -> Single<[MySection]>
    func login(username: String, password: String) -> Single<String>
    // 闭包形式
    @discardableResult func searchRepos(withQuery query: String, completion: @escaping ([Repo]) -> Void) -> URLSessionDataTask
    // Rx 响应式
    func rx_searchRepos(withQuery query: String) -> Observable<[Repo]>
}

class NetworkingApi: NetworkingService {
        
    private let session = URLSession.shared
    
    // 闭包形式
    @discardableResult
    func searchRepos(withQuery query: String, completion: @escaping ([Repo]) -> Void) -> URLSessionDataTask {
        let request = URLRequest(url: URL(string: "https://api.github.com/search/repositories?q=\(query)")!)
        let task = session.dataTask(with: request) { data, _, error in
            DispatchQueue.main.async {
                guard let data = data,
                      let response = try? JSONDecoder().decode(SearchReponse.self, from: data) else {
                    completion([])
                    return
                }
                completion(response.items)
            }
        }
        task.resume()
        return task
    }
    
    // Rx 响应式
    func rx_searchRepos(withQuery query: String) -> RxSwift.Observable<[Repo]> {
        let request = URLRequest(url: URL(string: "https://api.github.com/search/repositories?q=\(query)")!)
        return session.rx.data(request: request)
            .map { data -> [Repo] in
                guard let response = try? JSONDecoder().decode(SearchReponse.self, from: data) else {
                    return []
                }
                return response.items
            }
    }
    
}

extension NetworkingApi {
    func localSections() -> Single<[MySection]> {
        let items = Observable.just([
            MySection(header: "设计模式", items: [
                Item(title: "mvc", scene: .mvc),
                Item(title: "mvp", scene: .mvp)
            ]),
            MySection(header: "MVVM", items: [
                Item(title: "mvvm-closures", scene: .mvvm_closures),
                Item(title: "mvvm-functions-subjects-observables", scene: .mvp),
                Item(title: "mvvm-rxswift-subjects-observables", scene: .mvc),
                Item(title: "mvvm-rxswift-pure", scene: .mvc)
            ]),
            MySection(header: "反馈循环架构", items: [
                Item(title: "RxFeedback", scene: .mvc)
            ]),
            MySection(header: "结合了 Flux 和响应式编程的架构", items: [
                Item(title: "ReactorKit", scene: .mvc)
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
