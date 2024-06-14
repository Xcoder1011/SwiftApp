//
//  Foundations+Extension.swift
//  SwiftApp
//
//  Created by KUN on 2024/6/7.
//

import Foundation
import Localize_Swift

extension StaticString {
    func localized() -> String {
        description.localized()
    }
}
