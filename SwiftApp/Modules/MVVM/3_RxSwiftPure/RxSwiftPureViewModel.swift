//
//  RxSwiftPureViewModel.swift
//  SwiftApp
//
//  Created by KUN on 2024/1/15.
//

import Foundation
import RxSwift
import RxCocoa

class RxSwiftPureViewModel: ViewModel, ViewModelType {
    
    struct Input {
        let ready: Driver<Void>
        let selectedIndex: Driver<IndexPath>
        let searchText: Driver<String>
    }
    
    struct Output {
        let requestIsLoadding: Driver<Bool>
        let didSelectId: Driver<Int>
        let repos: Driver<[Repo]>
    }
    
    func transform(input: Input) -> Output {
        let loading = ActivityIndicator()
        let initialRepos = input.ready
            .flatMap { _ in
                self.service.rx_searchRepos(query: "RxSwift")
                    .trackActivity(loading)
                    .asDriver(onErrorJustReturn: [])
            }
        let searchRepos = input.searchText
            .filter { $0.count > 2 }
            .throttle(RxTimeInterval.milliseconds(300))
            .distinctUntilChanged()
            .flatMapLatest { query in
                self.service.rx_searchRepos(query: query)
                    .trackActivity(loading)
                    .asDriver(onErrorJustReturn: [])
            }
        let repos = Driver.merge(initialRepos, searchRepos)
        
        let selectRepoId = input.selectedIndex
            .withLatestFrom(repos) { (indexPath, repos) in
                return repos[indexPath.item]
            }
            .map { $0.id }
        return Output(requestIsLoadding: loading.asDriver(),
                      didSelectId: selectRepoId,
                      repos: repos)
    }
}
