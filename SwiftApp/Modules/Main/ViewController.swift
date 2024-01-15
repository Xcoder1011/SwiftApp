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
    
    private let reuseIdentifier = "ViewControllerCell"
    
    override func makeUI() {
        super.makeUI()
        tableView.headRefreshControl = nil
        tableView.footRefreshControl = nil
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        guard let viewModel = viewModel as? MainViewModel else { return }
        
        let dataSource = RxTableViewSectionedReloadDataSource<MySection>(
            configureCell: { _, tableView, indexPath, item in
                let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseIdentifier) ?? UITableViewCell(style: .default, reuseIdentifier: self.reuseIdentifier)
                cell.textLabel?.text = "\(item.title)"
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
            Navigator.default.show(scene: item.scene, sender: self)
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
