//
//  MVPViewModel.swift
//  SwiftApp
//
//  Created by KUN on 2023/12/16.
//

import Foundation

protocol MVPViewModelDelegate: AnyObject {
    func mvpReposViewModel(_ reposViewModel: MVPViewModel, didReceiveRepos repos: [Repo])
    func mvpReposViewModel(_ reposViewModel: MVPViewModel, didSelectId id: Int)
    func mvpReposViewModel(_ reposViewModel: MVPViewModel, requestIsLoadding: Bool)
}

class MVPViewModel: ViewModel {
    weak var delegate: MVPViewModelDelegate?
    var repos: [Repo]?
    private let validator = ThrottledTextFieldValidator()
    private let fetcher = CancellableReposFetcher()
    
    func didChangeQuery(_ query: String) {
        validator.validate(query: query) { [weak self] query in
            guard let strongSelf = self,
                  let query = query else { return }
            strongSelf.startFetching(forQuery: query)
        }
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        guard let repos = repos else { return }
        let id = repos[indexPath.item].id
        delegate?.mvpReposViewModel(self, didSelectId: id)
    }
    
    private func startFetching(forQuery query: String) {
        delegate?.mvpReposViewModel(self, requestIsLoadding: true)
        fetcher.fetchRepos(withQuery: query, completion: { [weak self] repos in
            guard let strongSelf = self else { return }
            strongSelf.delegate?.mvpReposViewModel(strongSelf, requestIsLoadding: false)
            strongSelf.repos = repos
            strongSelf.delegate?.mvpReposViewModel(strongSelf, didReceiveRepos: repos)
        })
    }
}
