//
//  ViewController.swift
//  SwiftApp
//
//  Created by KUN on 2023/11/26.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Differentiator

struct MySection {
    var header: String
    var items: [Item]
}

extension MySection: AnimatableSectionModelType {
    //    typealias Item = Int
    typealias Item = String
    
    var identity: String {
        return header
    }
    
    init(original: MySection, items: [Item]) {
        self = original
        self.items = items
    }
}

class ViewController: UIViewController {
    
    var tableView: UITableView?
    
    let disposeBag = DisposeBag()
    
    let dataSource = RxTableViewSectionedAnimatedDataSource<MySection>(
        configureCell: { _, tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style: .default, reuseIdentifier: "Cell")
            cell.textLabel?.text = "\(item)"
            return cell
        },
        titleForHeaderInSection: { dataSource, sectionIndex in
            return dataSource.sectionModels[sectionIndex].header
        }
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView(frame: view.frame, style: .plain)
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        view.addSubview(tableView!)
        
        let dataSource = self.dataSource
        
        let items = Observable.just([
            MySection(header: "MVVM", items: [
                "SimpleValidation",
                "MVVM 设计模式"
            ]),
            MySection(header: "RxFeedback", items: [
                "反馈循环架构"
            ]),
            MySection(header: "ReactorKit ", items: [
                "结合了 Flux 和响应式编程的架构"
            ])
        ])
        
        items.bind(to: tableView!.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
        tableView!.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        tableView!.rx.itemSelected
            .map { indexPath in
                return (indexPath, dataSource[indexPath])
            }
            .subscribe(onNext: { indexPath, item in
                let message = "Tapped `\(item)` @ \(indexPath)"
                let alertView = UIAlertController(title: "SwiftApp", message: message, preferredStyle: .alert)
                alertView.addAction(UIAlertAction(title: "OK", style: .cancel) { _ in
                })
                rootViewController().present(alertView, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = dataSource[indexPath]
        let section = dataSource[indexPath.section]
        print("item = \(item)")
        print("section = \(section)")
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}

private func rootViewController() -> UIViewController {
    return UIApplication.shared.keyWindow!.rootViewController!
}

