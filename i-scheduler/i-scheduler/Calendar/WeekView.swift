//
//  WeekView.swift
//  i-scheduler
//
//  Created by sun on 2022/01/18.
//

import SwiftUI
import CoreData

struct WeekView: View {
    
    @FetchRequest var projects: FetchedResults<Project>
    @EnvironmentObject private var calendarConfig: CalendarConfig
    @Environment(\.calendar) private var calendar
    private var month: Date
    private var week: Date

    
    init(month: Date, week: Date) {
        self.month = month
        self.week = week
        
        let start = max(month, week)
        let end = Calendar.current.dateInterval(of: .weekOfMonth, for: week)!.end

        let request = Project.fetchRequest(predicate: NSPredicate(
            format: "startDate_ < %@ and endDate_ >= %@",
            argumentArray: [end, start]
        ))
        _projects = FetchRequest(fetchRequest: request)
    }
    
    var body: some View {
        ForEach(daysOfWeek) { date in
            if calendar.isDate(date, equalTo: month, toGranularity: .month) {
                DateView(month: month, date: date, projectPositions: projectPositions)
            } else {
                DateView(month: month, date: date, projectPositions: projectPositions)
                    .hidden()
            }
        }
    }
    
    private var daysOfWeek: [Date] {
        guard let weekInterval = calendar.dateInterval(of: .weekOfMonth, for: week)
        else { return [] }

        return calendar.generateDates(interval: weekInterval, dateComponents: DateComponents(hour: 0, minute: 0, second: 0))
    }
    
    private var projectPositions: [Project:Int] {
        var projectPositions = [Project:Int]()
        var endDatePerIndex = [Date]()
        var isUpdated = false
        
        let projects = projects.sorted { lhs, rhs in
            if lhs.startDate.midnight == rhs.startDate.midnight {
                return lhs.endDate < rhs.endDate
            } else {
                return lhs.startDate < rhs.startDate
            }
        }
        
        for project in projects {
            isUpdated = false
            for endDateIndex in endDatePerIndex.indices {
                if endDatePerIndex[endDateIndex] < project.startDate.midnight {
                    endDatePerIndex[endDateIndex] = project.endDate.midnight
                    projectPositions[project] = endDateIndex
                    isUpdated.toggle()
                    break
                }
            }
            if isUpdated == false {
                projectPositions[project] = endDatePerIndex.count
                endDatePerIndex.append(project.endDate.midnight)
            }
        }
        return projectPositions
    }
}




