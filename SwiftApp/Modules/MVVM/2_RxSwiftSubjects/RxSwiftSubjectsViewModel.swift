//
//  RxSwiftSubjectsViewModel.swift
//  SwiftApp
//
//  Created by KUN on 2024/1/15.
//

import Foundation
import RxSwift
import RxCocoa

class RxSwiftSubjectsViewModel: ViewModel {
    
    // Inputs
    let viewWillAppearSubject = PublishSubject<Void>()
    let didSelectRowSubject = PublishSubject<IndexPath>()
    let didSearchSubject = BehaviorSubject(value: "")
    
    // Outputs
    var didReceiveRepos: Driver<[Repo]>
    var didSelectId: Driver<Int>
    var requestLoading: Driver<Bool>
    
    override init(service: NetworkingService) {
        let loading = ActivityIndicator()
        self.requestLoading = loading.asDriver()
        
        let initialRepos = self.viewWillAppearSubject
            .asObservable()
            .flatMap { _ in
                service.rx_searchRepos(query: "RxSwift").trackActivity(loading)
            }
            .asDriver(onErrorJustReturn: [])
        
        let searchRepos = self.didSearchSubject
            .asObservable()
            .filter { $0.count > 2 }
            .throttle(RxTimeInterval.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest { query in
                service.rx_searchRepos(query: query).trackActivity(loading)
            }
            .asDriver(onErrorJustReturn: [])
        
        let repos = Driver.merge(initialRepos, searchRepos)
        self.didReceiveRepos = repos.asDriver()
        
        self.didSelectId = self.didSelectRowSubject
            .asObservable()
            .withLatestFrom(repos, resultSelector: { indexPath, repos in
                return repos[indexPath.item]
            })
            .map { $0.id }
            .asDriver(onErrorJustReturn: -1)
        
        super.init(service: service)
    }
}


