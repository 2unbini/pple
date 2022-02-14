//
//  Persistence.swift
//  i-scheduler
//
//  Created by 권은빈 on 2021/12/06.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "pple")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print("Unable to Load Persistent Store")
                print("\(error), \(error.localizedDescription)")
            }
        })
    }
    
    func save(errorDescription: String = "") -> Bool {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("core data saving error")
                print(errorDescription + ": \(error.localizedDescription)")
                return false
            }
        }
        return true
    }
}
