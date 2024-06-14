//
//  GitHubAPI.swift
//  SwiftApp
//
//  Created by KUN on 2024/5/22.
//

import Foundation
import Moya

enum GitHubAPI {
    case searchRepositories(language: String, since: String)
}

extension GitHubAPI: NetworkingAPI {
    var baseURL: URL {
        return URL(string: Configs.Network.gitHubApiBaseUrl)!
    }

    var path: String {
        switch self {
        case .searchRepositories:
            return "/repositories"
        }
    }

    var method: Moya.Method {
        switch self {
        default:
            return .get
        }
    }

    var task: Moya.Task {
        switch self {
        case .searchRepositories(let language, let since):
            return .requestParameters(parameters: ["language": language, "since": since], encoding: URLEncoding.default)
        }
    }

    var headers: [String: String]? {
        return nil
    }
}
