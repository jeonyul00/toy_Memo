//
//  DetailViewController.swift
//  Memo
//
//  Created by 전율 on 10/31/24.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    var memo: MemoEntity?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let memo {
            textView.text = memo.content
        }
        
    }
    
}