//
//  MemoEntity+CoreDataProperties.swift
//  Memo
//
//  Created by 전율 on 10/28/24.
//
//

import Foundation
import CoreData

extension MemoEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<MemoEntity> {
        return NSFetchRequest<MemoEntity>(entityName: "Memo")
    }
    @NSManaged public var content: String?
    @NSManaged public var insertDate: Date?
}

extension MemoEntity : Identifiable {

}
