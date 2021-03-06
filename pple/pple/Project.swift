//
//  Project.swift
//  i-scheduler
//
//  Created by sun on 2021/12/08.
//

import CoreData
import SwiftUI

extension Project: Comparable {
    public static func < (lhs: Project, rhs: Project) -> Bool {
        lhs.name < rhs.name
    }
    
    // MARK: - Fetching From CoreData
    
    static func fetchRequest(predicate: NSPredicate, sortDescriptor: [NSSortDescriptor] = [NSSortDescriptor(key: "name_", ascending: true)]) -> NSFetchRequest<Project> {
        let request = NSFetchRequest<Project>(entityName: "Project")
        request.sortDescriptors = sortDescriptor
        request.predicate = predicate
        return request
    }
    
    // MARK: - Nil-coalesced Properties
    
    var projectId : UUID {
        // TODO: maybe throw error when nil?
        get { projectId_ ?? UUID() }
        set { projectId_ = newValue }
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
    var tasks: Set<Task> {
        get { (tasks_ as? Set<Task>) ?? [] }
        set { tasks_ = newValue as NSSet }
    }
}

