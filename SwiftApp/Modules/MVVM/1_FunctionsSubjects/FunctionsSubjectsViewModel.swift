//
//  FunctionsSubjectsViewModel.swift
//  SwiftApp
//
//  Created by KUN on 2024/1/15.
//

import Foundation
import RxSwift
import RxCocoa

protocol FuncSubViewModelInputs {
    func viewWillAppear()
    func didSearch(_ query: String)
    func didSelectRowAt(_ indexPath: IndexPath)
}

protocol FuncSubViewModelOutputs {
    var didReceiveRepos: Driver<[Repo]> { get }
    var didSelectId: Driver<Int> { get }
    var requestIsLoadding: Driver<Bool> { get }
}

protocol FuncSubViewModelType {
    var input: FuncSubViewModelInputs { get }
    var output: FuncSubViewModelOutputs { get }
}

class FunctionsSubjectsViewModel: ViewModel, FuncSubViewModelType, FuncSubViewModelInputs, FuncSubViewModelOutputs {
    
    // Inputs
    
    private let didSelectRowSubject = PublishSubject<IndexPath>()
    func didSelectRowAt(_ indexPath: IndexPath) {
        didSelectRowSubject.onNext(indexPath)
    }
    
    private let viewWillAppearSubject = PublishSubject<Void>()
    func viewWillAppear() {
        viewWillAppearSubject.onNext(())
    }
    
    private let didSearchSubject = PublishSubject<String>()
    func didSearch(_ query: String) {
        didSearchSubject.onNext(query)
    }
    
    // Outputs
    
    var didReceiveRepos: RxCocoa.Driver<[Repo]>
    var didSelectId: RxCocoa.Driver<Int>
    var requestIsLoadding: RxCocoa.Driver<Bool>
    
    var input: FuncSubViewModelInputs { return self }
    var output: FuncSubViewModelOutputs { return self }
    
    override init(service: NetworkingService) {
        let loading = ActivityIndicator()
        self.requestIsLoadding = loading.asDriver()
        
        let initialRepos = self.viewWillAppearSubject
            .asObservable()
            .flatMap { _ in
                AppEnvironment.instance.service.rx_searchRepos(withQuery: "RxSwift").trackActivity(loading)
            }
            .asDriver(onErrorJustReturn: [])
        
        let searchRepos = self.didSearchSubject
            .asObservable()
            .filter { $0.count > 2 }
            .throttle(RxTimeInterval.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest { query in
                AppEnvironment.instance.service.rx_searchRepos(withQuery: query).trackActivity(loading)
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
            .asDriver(onErrorJustReturn: 0)
        
        super.init(service: service)
    }
}
