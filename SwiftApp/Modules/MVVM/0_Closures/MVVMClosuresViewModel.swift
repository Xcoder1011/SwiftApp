//
//  MVVMClosuresViewModel.swift
//  SwiftApp
//
//  Created by KUN on 2024/1/15.
//

import Foundation

class MVVMClosuresViewModel: ViewModel {
    
    // Outputs
    var didReceiveRepos: (([Repo]) -> Void)?
    var didSelectId: ((Int) -> Void)?
    var requestLoading: ((Bool) -> Void)?

    var repos: [Repo]?
    private let validator = ThrottledTextFieldValidator()
    private let fetcher = CancellableReposFetcher()
    
    func didChangeQuery(_ query: String) {
        validator.validate(query: query) { [weak self] query in
            guard let self = self,
                  let query = query else { return }
            self.startFetching(forQuery: query)
        }
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        guard let repos = repos else { return }
        let id = repos[indexPath.item].id
        didSelectId?(id)
    }
    
    private func startFetching(forQuery query: String) {
        requestLoading?(true)
        fetcher.fetchRepos(withQuery: query, completion: { [weak self] repos in
            guard let self = self else { return }
            self.requestLoading?(false)
            self.repos = repos
            self.didReceiveRepos?(repos)
        })
    }
}
