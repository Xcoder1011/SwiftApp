//
//  RxSwiftGitHubSearchViewModel.swift
//  SwiftApp
//
//  Created by KUN on 2024/5/17.
//

import Foundation
import RxSwift
import RxCocoa
import Moya

class RxSwiftGitHubSearchViewModel: ViewModel, ViewModelType {
    
    struct Input {
        let headerRefresh: Observable<Void>
    }
    
    struct Output {
        let repos: Driver<[RepoElement]>
    }
    
    func transform(input: Input) -> Output {
        let loading = ActivityIndicator()
        let initialRepos = input.headerRefresh.flatMapLatest {[weak self] () -> Observable<[RepoElement]> in
            guard let _ = self else { return Observable.just([]) }
            return GitHubAPI.searchRepositories(language: "swift", since: "monthly").rx_request().trackActivity(loading).take(1).map { response in
                let elements = try response.map([RepoElement].self)
                return elements
            }
        }
        let repos = initialRepos.asDriver(onErrorJustReturn: [])
        return Output(repos: repos)
    }
}
