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
            guard let self,
                  let query else { return }
            startFetching(forQuery: query)
        }
    }

    func didSelectRow(at indexPath: IndexPath) {
        guard let repos else { return }
        let id = repos[indexPath.item].id
        didSelectId?(id)
    }

    private func startFetching(forQuery query: String) {
        requestLoading?(true)
        fetcher.fetchRepos(withQuery: query, completion: { [weak self] repos in
            guard let self else { return }
            requestLoading?(false)
            self.repos = repos
            didReceiveRepos?(repos)
        })
    }
}
