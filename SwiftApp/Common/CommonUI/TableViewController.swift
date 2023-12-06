//
//  TableViewController.swift
//  SwiftApp
//
//  Created by KUN on 2023/12/6.
//

import UIKit
import RxSwift
import RxCocoa
import KafkaRefresh

class TableViewController: BaseViewController, UIScrollViewDelegate {
    
    lazy var tableView: TableView = {
        let view = TableView(frame: CGRect(), style: .plain)
        view.rx.setDelegate(self).disposed(by: disposeBag)
        return view
    }()
    
}
