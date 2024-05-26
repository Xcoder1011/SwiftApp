//
//  RxSwiftGitHubSearchViewModel.swift
//  SwiftApp
//
//  Created by KUN on 2024/5/17.
//

import RxSwift
import RxCocoa
import Moya

class RxSwiftGitHubSearchViewModel: ViewModel, ViewModelType {
    
    struct Input {
        let headerRefresh: Observable<Void>
        let footerRefresh: Observable<Void>
    }
    
    struct Output {
        let repos: Driver<[RepoElement]>
    }
    
    var dataArray = BehaviorRelay<[RepoElement]>(value: [])
    var page: Int = 1
    
    func transform(input: Input) -> Output {
        // 下拉刷新
        input.headerRefresh.flatMapLatest { [weak self] in
            self?.page = 1
            return GitHubAPI.searchRepositories(language: "swift", since: "monthly").rx_request().asObservable().take(1)
        }
        .map { [weak self] (response) -> Result<[RepoElement], Error> in
            self?.refreshingStateObservable.accept(.headerEndRefreshing)
            do {
                let elements = try response.map([RepoElement].self)
                if let string = String(data: response.data, encoding: .utf8) {
                    print("返回结果 string = \(string)")
                }
                return .success(elements)
            } catch {
                return .failure(error)
            }
        }
        .subscribe(onNext: { [weak self] result in
            switch result {
            case .success(let elements):
                self?.dataArray.accept(elements)
            case .failure(let error):
                print("Error: \(error)")
            }
        }).disposed(by: disposeBag)
        
        // 上拉加载
        input.footerRefresh.flatMapLatest { [weak self] in
            self?.page += 1
            return GitHubAPI.searchRepositories(language: "swift", since: "monthly").rx_request().asObservable().take(1)
        }
        .map { [weak self] (response) -> Result<[RepoElement], Error> in
            do {
                let elements = try response.map([RepoElement].self)
                if elements.isEmpty {
                    self?.refreshingStateObservable.accept(.endRefreshingWithNoMoreData)
                } else {
                    self?.refreshingStateObservable.accept(.footerEndRefreshing)
                }
                return .success(elements)
            } catch {
                return .failure(error)
            }
        }
        .subscribe(onNext: { [weak self] result in
            switch result {
            case .success(let elements):
                let totalElements = (self?.dataArray.value ?? []) + elements
                self?.dataArray.accept(totalElements)
            case .failure(let error):
                print("Error: \(error)")
            }
        }).disposed(by: disposeBag)
        
        let repos = self.dataArray.asDriver(onErrorJustReturn: [])
        return Output(repos: repos)
    }
}

extension RxSwiftGitHubSearchViewModel: ViewModelHeaderFooterConfigure {
    
    var enterRefreshImmediately: Bool {
        return true
    }
}
