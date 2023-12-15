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

private let reuseIdentifier = "ViewControllerCell"

class ViewController: TableViewController {
    
    override func makeUI() {
        super.makeUI()
        tableView.headRefreshControl = nil
        tableView.footRefreshControl = nil
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        guard let viewModel = viewModel as? MainViewModel else { return }
        
        let dataSource = RxTableViewSectionedAnimatedDataSource<MySection>(
            configureCell: { _, tableView, indexPath, item in
                let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) ?? UITableViewCell(style: .default, reuseIdentifier: reuseIdentifier)
                cell.textLabel?.text = "\(item)"
                return cell
            },
            titleForHeaderInSection: { dataSource, sectionIndex in
                return dataSource.sectionModels[sectionIndex].header
            }
        )
        
        let refresh = Observable.of(Observable.just(()), headerRefreshTrigger).merge()
        let input = MainViewModel.Input(headerRefresh: refresh, selection: tableView.rx.modelSelected(Item.self).asDriver())
        let output = viewModel.transform(input: input)
        
        output.itemSelected.drive(onNext: { (item) in
            print("item = \(item)")
        }).disposed(by: disposeBag)
        
        output.sections.drive(tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "RxSwift + MVVM"
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}

private func rootViewController() -> UIViewController {
    return UIApplication.shared.keyWindow!.rootViewController!
}

