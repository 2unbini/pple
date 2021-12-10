//
//  Task.swift
//  i-scheduler
//
//  Created by sun on 2021/12/08.
//

import CoreData

extension Task:Comparable {
    public static func < (lhs: Task, rhs: Task) -> Bool {
        lhs.name! < rhs.name!
    }
    
    static func withId(_ id: UUID, context: NSManagedObjectContext) -> Task {
        let request = fetchRequest(NSPredicate(format: "id = %@", id as CVarArg))
        let task = (try? context.fetch(request)) ?? []
        if let task = task.first {
            return task
        } else {
            // check here for later..
            let newTask = Task(context: context)
            newTask.id = id
            return newTask
        }
    }
    
    static func fetchRequest(_ predicate: NSPredicate) -> NSFetchRequest<Task> {
        let request = NSFetchRequest<Task>(entityName: "Task")
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        request.predicate = predicate
        return request
    }
    
    var startToEnd : String {
        let formatter = DateIntervalFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        
        return formatter.string(from: startDate ?? Date(), to: endDate ?? Date())
    }
}
