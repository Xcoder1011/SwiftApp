//
//  MySection.swift
//  SwiftApp
//
//  Created by KUN on 2023/12/6.
//

import Differentiator
import Foundation

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
        lhs.title == rhs.title && lhs.scene == rhs.scene
    }

    // IdentifiableType 实现
    var identity: String {
        title
    }
}

extension MySection: AnimatableSectionModelType, IdentifiableType {
    // IdentifiableType 实现
    var identity: String {
        header
    }

    init(original: MySection, items: [Item]) {
        header = original.header
        self.items = items
    }
}
