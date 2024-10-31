//
//  MemoEntity+CoreDataClass.swift
//  Memo
//
//  Created by 전율 on 10/28/24.
//
//

import Foundation
import CoreData

fileprivate let formatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .none
    formatter.doesRelativeDateFormatting = true // 가까운 날짜 표시를 어제 오늘로 표기
    return formatter
}()

@objc(MemoEntity)
public class MemoEntity: NSManagedObject {    
    var dateString: String? {
        return formatter.string(for: insertDate)
    }

}
