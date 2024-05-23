//
//  NetworkingService.swift
//  SwiftApp
//
//  Created by KUN on 2023/12/6.
//

import Foundation
import RxSwift
import RxCocoa

protocol NetworkingHomeAPI {
    @discardableResult
    func searchRepos(withQuery query: String, completion: @escaping ([Repo]) -> Void) -> URLSessionDataTask
    func rx_searchRepos(query: String) -> Observable<[Repo]>
    func fetchPopularRepos() -> Observable<[Repo]?>
}

protocol NetworkingAuthAPI {
    func localSections() -> Single<[MySection]>
    func login(username: String, password: String) -> Single<String>
}

protocol NetworkingService: NetworkingHomeAPI, NetworkingAuthAPI { }

final class NetworkingServiceIMP: NetworkingService {
    private let session = URLSession.shared
    @discardableResult
    func searchRepos(withQuery query: String, completion: @escaping ([Repo]) -> Void) -> URLSessionDataTask {
        let request = URLRequest(url: URL(string: "https://api.github.com/search/repositories?q=\(query)")!)
        let task = session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion([])
                    print("Error occurred during search: \(error.localizedDescription)")
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200,
                      let data = data else {
                    completion([])
                    print("Invalid response or no data received")
                    return
                }
            
                do {
                    let searchResponse = try JSONDecoder().decode(SearchResponse.self, from: data)
                    completion(searchResponse.items)
                } catch {
                    completion([])
                    print("Error decoding search response: \(error.localizedDescription)")
                }
            }
        }
        task.resume()
        return task
    }
    
    func rx_searchRepos(query: String) -> RxSwift.Observable<[Repo]> {
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

extension NetworkingServiceIMP {
    func localSections() -> Single<[MySection]> {
        let items = Observable.just([
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
