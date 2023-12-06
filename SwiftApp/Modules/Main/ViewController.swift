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

class ViewController: TableViewController {
    
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
        navigationItem.title = "RxSwift + Moya + MVVM"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
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
        
        items.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
        tableView.rx.itemSelected
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

