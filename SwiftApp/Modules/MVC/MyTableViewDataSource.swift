//
//  MyTableViewDataSource.swift
//  SwiftApp
//
//  Created by KUN on 2023/12/16.
//

import Foundation
import UIKit

let reuseIdentifier = "MyRepoCell"

class MyTableViewDataSource: NSObject, UITableViewDataSource {
    var repos: [Repo]?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repos?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let repos = repos else { return UITableViewCell() }

        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) ?? UITableViewCell(style: .default, reuseIdentifier: reuseIdentifier)
        cell.textLabel?.text = "\(repos[indexPath.row].name)"
        return cell
    }
}
