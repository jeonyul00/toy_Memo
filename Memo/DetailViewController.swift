//
//  DetailViewController.swift
//  Memo
//
//  Created by 전율 on 10/31/24.
//

import UIKit

extension Notification.Name {
    static let memoDidDelete = Notification.Name("memoDidDelete")
}

class DetailViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    var memo: MemoEntity?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let memo {
            textView.text = memo.content
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination.children.first as? ComposeViewController {
            vc.editTarget = memo
            
            NotificationCenter.default.addObserver(forName: .memoDidUpdate, object: nil, queue: .main) { _ in
                self.textView.text = self.memo?.content
            }
        }
    }
    
    @IBAction func deleteMemo(_ sender: Any) {
        // 알림
        let alert = UIAlertController(title: "삭제 확인", message: "메모를 삭제할까요?", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "삭제", style: .destructive) { [weak self] _ in
            guard let memo = self?.memo else { return }
            if let index = DataManager.shared.delete(entity: memo) {
                NotificationCenter.default.post(name: .memoDidDelete, object: nil,userInfo: ["index":index])
            }
            self?.navigationController?.popViewController(animated: true)
        }
        alert.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(cancelAction)
        present(alert,animated: true)
    }
}
