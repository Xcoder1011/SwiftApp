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

extension MySection: AnimatableSectionModelType {
    typealias Item = String
    
    var identity: String {
        return header
    }
    
    init(original: MySection, items: [Item]) {
        self = original
        self.items = items
    }
}
