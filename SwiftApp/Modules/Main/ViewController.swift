//
//  ViewController.swift
//  SwiftApp
//
//  Created by KUN on 2023/11/26.
//

import RxCocoa
import RxDataSources
import RxSwift
import UIKit

class ViewController: TableViewController {
    override func makeUI() {
        super.makeUI()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.reuseIdentifier)
        navigationItem.title = "RxSwift + MVVM"
    }

    override func bindViewModel() {
        super.bindViewModel()
        guard let viewModel = viewModel as? MainViewModel else { return }
        let ready = viewDidLoadSubject.asObservable()
        let selection = tableView.rx.modelSelected(Item.self).asDriver()
        let input = MainViewModel.Input(ready: ready,
                                        selection: selection)
        let output = viewModel.transform(input: input)

        output.itemSelected.drive(onNext: { [weak self] item in
            guard let self = self else { return }
            Navigator.default.show(scene: item.scene, sender: self)
        }).disposed(by: disposeBag)

        output.sections.drive(tableView.rx.items(dataSource: ViewController.dataSource())).disposed(by: disposeBag)
    }
}

extension ViewController {
    static func dataSource() -> RxTableViewSectionedReloadDataSource<MySection> {
        return RxTableViewSectionedReloadDataSource<MySection>(
            configureCell: { _, tableView, indexPath, item in
                let cell: UITableViewCell = tableView.dequeueReusableCell(for: indexPath)
                cell.textLabel?.text = "\(item.title)"
                return cell
            },
            titleForHeaderInSection: { dataSource, sectionIndex in
                let section = dataSource[sectionIndex]
                return section.header
            }
        )
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
