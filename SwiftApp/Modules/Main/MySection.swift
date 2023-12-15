//
//  MySection.swift
//  SwiftApp
//
//  Created by KUN on 2023/12/6.
//

import Foundation
import Differentiator

struct MySection {
    var header: String
    var items: [Item]
}

typealias Item = String

extension MySection: AnimatableSectionModelType {
    
    var identity: String {
        return header
    }
    
    init(original: MySection, items: [Item]) {
        self = original
        self.items = items
    }
}
