//
//  Task.swift
//  i-scheduler
//
//  Created by sun on 2021/12/08.
//

import CoreData

extension Task: Comparable {
    public static func < (lhs: Task, rhs: Task) -> Bool {
        lhs.name < rhs.name
    }
    
    // MARK: - Fetching From CoreDate
    
    static func withId(_ id: UUID, context: NSManagedObjectContext) -> Task {
        let request = fetchRequest(NSPredicate(format: "taskId_ = %@", id as CVarArg))
        let task = (try? context.fetch(request)) ?? []
        if let task = task.first {
            return task
        } else {
            // TODO: - protect against nil before shipping
            let newTask = Task(context: context)
            newTask.taskId = id
            newTask.project = Project.withId(UUID(), context: context)
            return newTask
        }
    }
    
    static func fetchRequest(_ predicate: NSPredicate) -> NSFetchRequest<Task> {
        let request = NSFetchRequest<Task>(entityName: "Task")
        request.sortDescriptors = [NSSortDescriptor(key: "name_", ascending: true)]
        request.predicate = predicate
        return request
    }
    
    // MARK: - Nil-coalesced Properties
    
    var taskId: UUID {
        // TODO: maybe throw error when nil?
        get { taskId_ ?? UUID() }
        set { taskId_ = newValue }
    }
    var name: String {
        get { name_ ?? "Unknown" }
        set { name_ = newValue }
    }
    var summary: String {
        get { summary_ ?? "Unknown" }
        set { summary_ = newValue }
    }
    var startDate: Date {
        get { startDate_ ?? Date() }
        set { startDate_ = newValue }
    }
    var endDate: Date {
        get { endDate_ ?? Date(timeInterval: 60 * 60 * 24, since: startDate) }
        set { endDate_ = newValue }
    }
    var project: Project {
        get { project_! }  // TODO: - protect against nil before app ships
        set { project_ = newValue }
    }
    var startDateToEndDateInPrettyFormat : String {
        let formatter = DateIntervalFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter.string(from: startDate, to: endDate)
    }
}
