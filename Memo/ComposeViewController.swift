//
//  ComposeViewController.swift
//  Memo
//
//  Created by 전율 on 10/29/24.
//

import UIKit

extension Notification.Name {
    static let memoDidInsert = Notification.Name("memoDidInsert")
}

class ComposeViewController: UIViewController {
    
    @IBOutlet weak var contentTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "new memo"
        contentTextView.becomeFirstResponder() // 키보드 올리기
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if contentTextView.isFirstResponder { // 키보드가 올라가 있는가
            contentTextView.resignFirstResponder() // 키보드 내리기
        }
    }
    @IBAction func colseVC(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func save(_ sender: Any) {
        // TODO: 경고창 추가
        guard let text = contentTextView.text, text.count > 0 else { return }
        DataManager.shared.insertMemo(memo: text)
        NotificationCenter.default.post(name: .memoDidInsert, object: nil)
        self.dismiss(animated: true)
    }
    
}
