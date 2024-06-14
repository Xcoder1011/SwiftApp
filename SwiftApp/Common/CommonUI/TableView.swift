//
//  TableView.swift
//  SwiftApp
//
//  Created by KUN on 2023/12/6.
//

import Foundation
import SwiftUI
import UIKit

class TableView: UITableView {
    init() {
        super.init(frame: CGRect(), style: .grouped)
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        makeUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        makeUI()
    }
    
    func makeUI() {
        rowHeight = UITableView.automaticDimension
        estimatedRowHeight = 50
        sectionHeaderHeight = 40
        backgroundColor = .clear
        cellLayoutMarginsFollowReadableWidth = false
        keyboardDismissMode = .onDrag
        separatorColor = .clear
        separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableHeaderView = UIView()
        tableFooterView = UIView()
        separatorStyle = UITableViewCell.SeparatorStyle.none
        keyboardDismissMode = UIScrollView.KeyboardDismissMode.onDrag
        if #available(iOS 11, *) {
            contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        }
        if #available(iOS 15.0, *) {
            sectionHeaderTopPadding = 0
        }
    }
}
