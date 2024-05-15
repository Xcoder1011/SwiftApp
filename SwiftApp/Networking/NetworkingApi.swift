//
//  CommonAPI.swift
//  SwiftApp
//
//  Created by KUN on 2023/12/6.
//

import Foundation
import RxSwift
import RxCocoa

protocol NetworkingHomeService {
    // 闭包形式
    @discardableResult
    func searchRepos(withQuery query: String, completion: @escaping ([Repo]) -> Void) -> URLSessionDataTask
    // Rx 响应式
    func rx_searchRepos(withQuery query: String) -> Observable<[Repo]>
    func fetchPopularRepos() -> Observable<[Repo]?>
}

protocol NetworkingAuthService {
    func localSections() -> Single<[MySection]>
    func login(username: String, password: String) -> Single<String>
}

protocol NetworkingService: NetworkingHomeService, NetworkingAuthService { }

final class NetworkingApi: NetworkingService {
    
    private let session = URLSession.shared
    
    // 闭包形式
    @discardableResult
    func searchRepos(withQuery query: String, completion: @escaping ([Repo]) -> Void) -> URLSessionDataTask {
        let request = URLRequest(url: URL(string: "https://api.github.com/search/repositories?q=\(query)")!)
        let task = session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    // 网络请求出错
                    completion([])
                    print("Error occurred during search: \(error.localizedDescription)")
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200,
                      let data = data else {
                    // 服务器返回非200状态码或数据为空，返回空数组
                    completion([])
                    print("Invalid response or no data received")
                    return
                }
            
                do {
                    // 解析数据
                    let searchResponse = try JSONDecoder().decode(SearchResponse.self, from: data)
                    completion(searchResponse.items)
                } catch {
                    // 解析数据出错
                    completion([])
                    print("Error decoding search response: \(error.localizedDescription)")
                }
            }
        }
        // 启动任务
        task.resume()
        return task
    }
    
    // Rx 响应式
    func rx_searchRepos(withQuery query: String) -> RxSwift.Observable<[Repo]> {
        let request = URLRequest(url: URL(string: "https://api.github.com/search/repositories?q=\(query)")!)
        return session.rx.data(request: request)
            .map { data -> [Repo] in
                guard let response = try? JSONDecoder().decode(SearchResponse.self, from: data) else {
                    return []
                }
                return response.items
            }
    }
    
    func fetchPopularRepos() -> RxSwift.Observable<[Repo]?> {
        let request = URLRequest(url: URL(string: "https://api.github.com/search/repositories?q=hot")!)
        return session.rx.data(request: request)
            .map { data -> [Repo]? in
                guard let response = try? JSONDecoder().decode(SearchResponse.self, from: data) else {
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
