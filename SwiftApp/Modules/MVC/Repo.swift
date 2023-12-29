//
//  File.swift
//  SwiftApp
//
//  Created by KUN on 2023/12/15.
//

import Foundation

struct RepoOwner: Decodable {
    let id: Int
    let login: String
    let avatar_url: String
    
    let html_url: String

    
}

struct Repo: Decodable {
    let id: Int
    let name: String
    let full_name: String
    let owner: RepoOwner
    let html_url: String
    let description: String
    let url: String    
}

struct SearchReponse: Decodable {
    let items: [Repo]
}

