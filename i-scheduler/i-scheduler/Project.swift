//
//  Project.swift
//  i-scheduler
//
//  Created by sun on 2021/12/08.
//

import CoreData
import SwiftUI

extension Project {
    
    static func withId(_ id: UUID, context: NSManagedObjectContext) -> Project {
        let request = fetchRequest(NSPredicate(format: "id = %@", id as CVarArg))
        let project = (try? context.fetch(request)) ?? []
        if let project = project.first {
            return project
        } else {
            // check here for later..
            let newProject = Project(context: context)
            newProject.id = id
            newProject.name = "foo"
            newProject.summary = "foo"
            newProject.isFinished = false
            newProject.startDate = Date()
            newProject.endDate = Date()
            newProject.allTasks = []
            return newProject
        }
    }
    
    static func fetchRequest(_ predicate: NSPredicate) -> NSFetchRequest<Project> {
        let request = NSFetchRequest<Project>(entityName: "Project")
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        request.predicate = predicate
        return request
    }
    
    var allTasksConverted: Set<Task> {
        get { (allTasks as? Set<Task>) ?? [] }
        set { allTasks = newValue as NSSet }
    }
    
//    var period 
}

