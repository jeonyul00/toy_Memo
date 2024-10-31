//
//  ComposeViewController.swift
//  Memo
//
//  Created by 전율 on 10/29/24.
//

import UIKit

extension Notification.Name {
    static let memoDidInsert = Notification.Name("memoDidInsert")
    static let memoDidUpdate = Notification.Name("memoDidUpdate")
}

class ComposeViewController: UIViewController {
    
    @IBOutlet weak var contentTextView: UITextView!
    var editTarget: MemoEntity?
    var originContent = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let editTarget {
            navigationItem.title = "edit memo"
            contentTextView.text = editTarget.content
            originContent = editTarget.content ?? ""
        } else {
            navigationItem.title = "new memo"
            contentTextView.text = ""
        }
        contentTextView.becomeFirstResponder() // 키보드 올리기
        
        contentTextView.delegate = self
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
        if let editTarget {
            DataManager.shared.update(entity: editTarget, with: text)
            NotificationCenter.default.post(name: .memoDidUpdate, object: nil, userInfo: ["memo": editTarget])

        } else {
            DataManager.shared.insertMemo(memo: text)
            NotificationCenter.default.post(name: .memoDidInsert, object: nil)
        }
        self.dismiss(animated: true)
    }
    
}

extension ComposeViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if let _ = editTarget {
            // 뷰 컨트롤로의 동작을 결정 => 드래그로 모달 닫을 수 있냐 없냐
            isModalInPresentation = originContent != textView.text
        } else {
            // 뷰 컨트롤로의 동작을 결정 => 드래그로 모달 닫을 수 있냐 없냐
            isModalInPresentation = !textView.text.isEmpty
        }
        
    }
}
