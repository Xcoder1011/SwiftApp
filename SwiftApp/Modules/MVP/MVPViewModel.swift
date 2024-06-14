//
//  MVPViewModel.swift
//  SwiftApp
//
//  Created by KUN on 2023/12/16.
//

import Foundation

protocol MVPViewModelDelegate: AnyObject {
    func mvpReposViewModel(_ reposViewModel: MVPViewModel, didReceiveRepos repos: [Repo])
    func mvpReposViewModel(_ reposViewModel: MVPViewModel, didSelectRepoWithId id: Int)
    func mvpReposViewModel(_ reposViewModel: MVPViewModel, isRequestLoading: Bool)
}

class MVPViewModel: ViewModel {
    weak var delegate: MVPViewModelDelegate?
    var repos: [Repo]?
    private let validator = ThrottledTextFieldValidator()
    private let fetcher = CancellableReposFetcher()

    func didChangeQuery(_ query: String) {
        validator.validate(query: query) { [weak self] query in
            guard let self,
                  let query else { return }
            startFetching(forQuery: query)
        }
    }

    func didSelectRow(at indexPath: IndexPath) {
        guard let repos, indexPath.item < repos.count else { return }
        let id = repos[indexPath.item].id
        delegate?.mvpReposViewModel(self, didSelectRepoWithId: id)
    }

    /// 开始获取仓库列表
    /// - Parameters:
    ///   - query: 查询关键字
    private func startFetching(forQuery query: String) {
        delegate?.mvpReposViewModel(self, isRequestLoading: true)
        fetcher.fetchRepos(withQuery: query, completion: { [weak self] repos in
            guard let self else { return }
            delegate?.mvpReposViewModel(self, isRequestLoading: false)
            updateRepos(with: repos)
        })
    }

    private func updateRepos(with repos: [Repo]) {
        self.repos = repos
        delegate?.mvpReposViewModel(self, didReceiveRepos: repos)
    }
}
