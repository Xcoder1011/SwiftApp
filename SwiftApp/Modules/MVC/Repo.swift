//
//  File.swift
//  SwiftApp
//
//  Created by KUN on 2023/12/15.
//

import Foundation

struct Repo: Decodable {
    let id: Int
    let name: String
}

struct SearchReponse: Decodable {
    let items: [Repo]
}

