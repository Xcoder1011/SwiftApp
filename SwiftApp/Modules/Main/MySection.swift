//
//  MySection.swift
//  SwiftApp
//
//  Created by KUN on 2023/12/6.
//

import Foundation
import Differentiator

struct Item {
    var title: String
    var scene: Navigator.Scene
}

struct MySection {
    var header: String
    var items: [Item]
}

extension Item: Equatable, IdentifiableType {
    static func == (lhs: Item, rhs: Item) -> Bool {
        return lhs.title == rhs.title
    }
    var identity: String {
        return title
    }
    typealias Identity = String
}

extension MySection: AnimatableSectionModelType, IdentifiableType {
    var identity: String {
        return header
    }
    typealias Identity = String
    init(original: MySection, items: [Item]) {
        self = original
        self.items = items
    }
}
