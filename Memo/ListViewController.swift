//
//  ViewController.swift
//  Memo
//
//  Created by 전율 on 10/28/24.
//

import UIKit

class ListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        DataManager.shared.fetch()
    }
    
    
}

extension ListViewController:UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataManager.shared.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let target = DataManager.shared.list[indexPath.row]
        cell.textLabel?.text = target.content
        cell.detailTextLabel?.text = target.insertDate?.description
        return cell
    }
}
