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
        let selectTrendingPeriod: Observable<TrendingPeriodSegments>
    }
    
    struct Output {
        let repos: Driver<[RepoElement]>
    }
    
    var dataArray = BehaviorRelay<[RepoElement]>(value: [])
    var page: Int = 1
    let trendingPeriod = BehaviorRelay<TrendingPeriodSegments>(value: .daily)
    
    func transform(input: Input) -> Output {
        input.selectTrendingPeriod.bind(to: trendingPeriod).disposed(by: disposeBag)
        
        let headerRefreshObservable = Observable.of(input.headerRefresh, input.selectTrendingPeriod.map { _ in }.skip(1)).merge()
        /// 下拉刷新
        headerRefreshObservable.flatMapLatest { [weak self] in
            guard let self = self else { return Observable<Result<[RepoElement], Error>>.empty() }
            self.page = 1
            let since = self.trendingPeriod.value.paramValue
            return self.fetchRepositories(page: self.page, since: since)
        }
        .subscribe(onNext: { [weak self] result in
            guard let self = self else { return }
            self.loading.accept(false)
            self.refreshingStateObservable.accept(.headerEndRefreshing)
            switch result {
            case .success(let elements):
                self.dataArray.accept(elements)
            case .failure(let error):
                print("Error: \(error)")
            }
        }).disposed(by: disposeBag)
        
        /// 上拉加载
        input.footerRefresh.flatMapLatest { [weak self] in
            guard let self = self else { return Observable<Result<[RepoElement], Error>>.empty() }
            self.page += 1
            let since = self.trendingPeriod.value.paramValue
            return self.fetchRepositories(page: self.page, since: since)
        }
        .subscribe(onNext: { [weak self] result in
            guard let self = self else { return }
            self.loading.accept(false)
            self.refreshingStateObservable.accept(.footerEndRefreshing)
            switch result {
            case .success(let elements):
                self.dataArray.accept(self.dataArray.value + elements)
            case .failure(let error):
                print("Error: \(error)")
            }
        }).disposed(by: disposeBag)
        
        let repos = self.dataArray.asDriver(onErrorJustReturn: [])
        return Output(repos: repos)
    }
}

// MARK: - Private Methods

private extension RxSwiftGitHubSearchViewModel {
    /// 获取仓库列表
    ///
    /// - Parameters:
    ///   - page: 页码
    ///   - since: 时间参数
    func fetchRepositories(page: Int, since: String) -> Observable<Result<[RepoElement], Error>> {
        return GitHubAPI.searchRepositories(language: "swift", since: since).rx_request().asObservable().take(1).map { response -> Result<[RepoElement], Error> in
            do {
                let elements = try response.map([RepoElement].self)
                if let string = String(data: response.data, encoding: .utf8) {
                    print("response data = \(string)")
                }
                return .success(elements)
            } catch {
                return .failure(error)
            }
        }
    }
}

// MARK: - ViewModelHeaderFooterConfigure

extension RxSwiftGitHubSearchViewModel: ViewModelHeaderFooterConfigure {
    /// 是否立即进入刷新状态
    var enterRefreshImmediately: Bool {
        return true
    }
}
