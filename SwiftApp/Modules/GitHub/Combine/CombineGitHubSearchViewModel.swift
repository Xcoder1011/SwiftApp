//
//  CombineGitHubSearchViewModel.swift
//  SwiftApp
//
//  Created by KUN on 2024/5/17.
//

import Combine
import Foundation
import Moya
import RxCocoa
import RxSwift

class CombineGitHubSearchViewModel: ViewModel {
    struct Input {
        let headerRefresh: PassthroughSubject<Void, Never>
        let footerRefresh: PassthroughSubject<Void, Never>
        let selectTrendingPeriod: PassthroughSubject<Int, Never>
    }
    
    struct Output {
        let repos: AnyPublisher<[RepoElement], Never>
    }
    
    var page: Int = 1
    @Published private(set) var repos: [RepoElement] = []
    @Published private(set) var trendingPeriod: TrendingPeriodSegments = .daily
    
    func transform(input: Input) -> Output {
        input.headerRefresh
            .eraseToAnyPublisher()
            .sink { _ in
                self.refreshData()
            }.store(in: &cancellables)
        
        input.footerRefresh
            .eraseToAnyPublisher()
            .sink { _ in
                self.page += 1
                self.requestData(page: self.page)
            }.store(in: &cancellables)
        
        input.selectTrendingPeriod
            .receive(on: RunLoop.main)
            .map { TrendingPeriodSegments(rawValue: $0) ?? .daily }
            .sink(receiveValue: { period in
                self.trendingPeriod = period
                self.refreshData()
            })
            .store(in: &cancellables)
        
        return Output(repos: $repos.eraseToAnyPublisher())
    }
}

// MARK: - Private Methods

private extension CombineGitHubSearchViewModel {
        
    func refreshData() {
        self.page = 1
        self.requestData(page: self.page)
    }
    
    func requestData(page: Int) {
        let since = trendingPeriod.paramValue
        GitHubAPI.searchRepositories(language: "swift", since: since).request { [weak self] result in
            guard let self else { return }
            self.refreshingStateSubject.send(.idle)
            self.loading.accept(false)
            switch result {
            case let .success(response):
                do {
                    let elements = try response.map([RepoElement].self)
                    if let string = String(data: response.data, encoding: .utf8) {
                        print("response data = \(string)")
                    }
                    if page == 1 {
                        self.repos.removeAll()
                        self.repos.append(contentsOf: elements)
                    } else {
                        self.repos.append(contentsOf: elements)
                    }
                } catch {
                    print("error = \(error)")
                }
            case let .failure(err):
                print("failure = \(err)")
            }
        }
    }
}

// MARK: - CombineTableViewDataSource

class CombineTableViewDataSource: NSObject, UITableViewDataSource {
    var repos: [RepoElement]?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        repos?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let repos else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(for: indexPath)
        let repo = repos[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = "\(repo.name)\n\(repo.author)"
        return cell
    }
}

// MARK: - ViewModelHeaderFooterConfigure

extension CombineGitHubSearchViewModel: ViewModelHeaderFooterConfigure {
    /// 是否立即进入刷新状态
    var enterRefreshImmediately: Bool {
        true
    }
}
