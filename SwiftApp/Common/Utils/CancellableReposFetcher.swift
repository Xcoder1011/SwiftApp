//
//  CancellableReposFetcher.swift
//  SwiftApp
//
//  Created by KUN on 2023/12/15.
//

import Foundation

final class CancellableReposFetcher {
    private var currentSearchNetworkTask: URLSessionDataTask?
    private let networkingService: NetworkingService
    
    init(networkingService: NetworkingService = NetworkingApi()) {
        self.networkingService = networkingService
    }
    
    func fetchRepos(withQuery query: String, completion: @escaping (([Repo]) -> ())) {
        currentSearchNetworkTask?.cancel()
        
        _ = currentSearchNetworkTask = networkingService.searchRepos(withQuery: query) { repos in
            completion(repos)
        }
    }
}
