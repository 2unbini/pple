//
//  CalendarConfig.swift
//  i-scheduler
//
//  Created by Kim TaeSoo on 2022/01/12.
//

import SwiftUI
import CoreData
class CalendarConfig: ObservableObject {
    @Published var yearLabel: String
    
    var projects: [Project]
    var cellSize: CGSize
    var today: Today
    let initialDateId: Date
    let interval: DateInterval
    let calendar = Calendar.current
    
    init() {
        let startDate = DateComponents(year: Interval.start)
        let endDate = DateComponents(year: Interval.end)
        
        self.today = Today()
        self.initialDateId = calendar.date(from: DateComponents(year: today.year, month: today.month)) ?? Date()
        self.interval = DateInterval(start: calendar.date(from: startDate)!, end: calendar.date(from: endDate)!)
        self.yearLabel = today.year.stringify()
        self.cellSize = CGSize()
        let request: NSFetchRequest<Project> = Project.fetchRequest()
        do {
            let context = PersistenceController.shared.container.viewContext
            let entries = try context.fetch(request)
            self.projects = entries.map{ $0 }
        }catch{
            projects = []
            fatalError()
        }
    }
    
    struct Today {
        var date = Date()
        var year: Int
        var month: Int
        
        init() {
            self.year = date.year
            self.month = date.month
        }
    }
}
