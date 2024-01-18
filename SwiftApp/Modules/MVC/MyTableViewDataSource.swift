//
//  MyTableViewDataSource.swift
//  SwiftApp
//
//  Created by KUN on 2023/12/16.
//

import Foundation
import UIKit

class MyTableViewDataSource: NSObject, UITableViewDataSource {
    
    var repos: [Repo]?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repos?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let repos = repos else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(for: indexPath)
        let repo = repos[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = "\(repo.name)\n\(repo.description)"
        return cell
    }
}
