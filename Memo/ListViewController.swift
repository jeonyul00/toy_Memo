//
//  ViewController.swift
//  Memo
//
//  Created by 전율 on 10/28/24.
//

import UIKit

class ListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var reloadTargetIndexPath: IndexPath?
    var deleteTargetIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        DataManager.shared.fetch()
        
        NotificationCenter.default.addObserver(forName: .memoDidInsert, object: nil, queue: .main) { [weak self] _ in
            // self.tableView.reloadData() // 이건 전부 리셋
            // 0번 인덱스에 데이터 추가
            let indexPath = IndexPath(row: 0, section: 0)
            self?.tableView.insertRows(at: [indexPath], with: .automatic)
        }
        
        NotificationCenter.default.addObserver(forName: .memoDidUpdate, object: nil, queue: .main) { [weak self] noti in
            if let memo = noti.userInfo?["momo"] as? MemoEntity, let index = DataManager.shared.list.firstIndex(of: memo) {
                let indexPath = IndexPath(row: index, section: 0)
                // self.tableView.reloadRows(at: [indexPath], with: .automatic)
                self?.reloadTargetIndexPath = indexPath
            }
        }
        
        NotificationCenter.default.addObserver(forName: .memoDidDelete, object: nil, queue: .main) { [weak self] noti in
            guard let self else { return }
            if let index = noti.userInfo?["index"] as? Int {
                let indexPath = IndexPath(row: index, section: 0)
                self.deleteTargetIndexPath = indexPath
            }
        }
    }
    
    // rootview가 계층에 추가되고 화면에 표시되기 전
    override func viewIsAppearing(_ animated: Bool) {
        if let reloadTargetIndexPath {
            tableView.reloadRows(at: [reloadTargetIndexPath], with: .automatic)
            self.reloadTargetIndexPath = nil
        }
        
        if let deleteTargetIndexPath {
            tableView.deleteRows(at: [deleteTargetIndexPath], with: .automatic)
            self.deleteTargetIndexPath = nil
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.setupSearchBar()
    }
    
    // 데이터 전달
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
            if let vc = segue.destination as? DetailViewController {
                vc.memo = DataManager.shared.list[indexPath.row]
            }
        }
    }
    
    func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "메모 내용으로 검색해 보세요."
        searchController.searchResultsUpdater = self // 검색어 입력할 때마다 updateSearchResults 호출
        navigationItem.searchController = searchController
        
    }
}


// MARK: - Search Bar
extension ListViewController:UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        defer {
            tableView.reloadData()
        }
        
        guard let keyword = searchController.searchBar.text, keyword.count > 0 else {
            DataManager.shared.fetch()
            return
        }
        DataManager.shared.fetch(keyword: keyword)
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
        cell.detailTextLabel?.text = target.dateString
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // tableView에서 스와이프 활성화
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            DataManager.shared.delete(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}


