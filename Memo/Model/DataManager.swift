//
//  DataManager.swift
//  Memo
//
//  Created by 전율 on 10/28/24.
//

import Foundation
import CoreData

// Singleton
class DataManager {
    static let shared = DataManager()
    
    private init() { }
    
    var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    var list = [MemoEntity]()
    
    func fetch() {
        let request = MemoEntity.fetchRequest()
        // sorted
        let sortByDateDesc = NSSortDescriptor(key: "insertDate", ascending: false)
        request.sortDescriptors = [sortByDateDesc]
        do {
            list = try mainContext.fetch(request)
        } catch {
            print(error)
        }
    }
    
    /// 개발 환경에서만
    func insertDummyData() {
#if DEBUG
        let countRequest = MemoEntity.fetchRequest()
        
        do {
            let count = try mainContext.count(for: countRequest)
            if count > 0 { return }
        } catch {
            print(error)
        }
        
        guard let path = Bundle.main.path(forResource: "lipsum", ofType: "txt") else { return }
        do {
            let source = try String(contentsOfFile: path) // file의 내용을 문자열로 반환
            let sentences = source.components(separatedBy: .newlines).filter { $0.trimmingCharacters(in: .whitespacesAndNewlines).count > 0 }
            
            var dataList = [[String: Any]]()
            
            for sentence in sentences {
                dataList.append(["content": sentence, "insertDate": Date(timeIntervalSinceNow: Double.random(in: 0...3600 * 24 * 30) * -1)
                                ])
            }
            let insertRequest = NSBatchInsertRequest(entityName: "Memo", objects: dataList)
            if let result = try mainContext.execute(insertRequest) as? NSBatchInsertResult, let succeeded = result.result as? Bool {
                if succeeded {
                    print("batch insert success")
                }
            }
        } catch {
            print(error)
        }
#endif
    }
    
    func insertMemo(memo: String) {
        let newMemo = MemoEntity(context: mainContext)
        newMemo.content = memo
        newMemo.insertDate = .now
        saveContext()
        list.insert(newMemo, at: 0)
        
    }
    
    func update(entity: MemoEntity, with content: String) {
        entity.content = content
        saveContext()
    }
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Memo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    
}
