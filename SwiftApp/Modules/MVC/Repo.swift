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

struct SearchResponse: Decodable {
    let items: [Repo]
}

// MARK: - RepoElement

struct RepoElement: Codable {
    var author: String
    var avatar: String
    var forks, currentPeriodStars: Int
    var builtBy: [TrendingUser]
    var url: String
    var language: String?
    var stars: Int
    var description: String?
    var name: String
    var languageColor: String?
}

struct TrendingUser: Codable {
    var avatar: String
    var username: String
    var href: String
}

enum TrendingPeriodSegments: Int, CaseIterable {
    case daily, weekly, monthly

    var title: String {
        switch self {
        case .daily: R.string.localizable.gitHubDailySegmentTitle.key.localized()
        case .weekly: R.string.localizable.gitHubWeeklySegmentTitle.key.localized()
        case .monthly: R.string.localizable.gitHubMonthlySegmentTitle.key.localized()
        }
    }

    var paramValue: String {
        switch self {
        case .daily: "daily"
        case .weekly: "weekly"
        case .monthly: "monthly"
        }
    }
}
