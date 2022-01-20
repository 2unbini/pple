//
//  DateView.swift
//  i-scheduler
//
//  Created by 권은빈 on 2022/01/07.
//

import SwiftUI
import CoreData

struct DateView: View {
    @Environment(\.calendar) private var calendar
    @FetchRequest private var dailyProjects: FetchedResults<Project>
    @EnvironmentObject private var calendarConfig: CalendarConfig
    
    let month: Date
    let date: Date
    let projectPositions: [Project:Int]
    
    init(month: Date, date: Date, projectPositions: [Project:Int]) {
        self.month = month
        self.date = date
        self.projectPositions = projectPositions
        
        let request = Project.fetchRequest(
            predicate: NSPredicate(
                format: "startDate_ < %@ and endDate_ >= %@",
                argumentArray: [date.tomorrowMidnight, date.midnight]
            ),
            sortDescriptor: [NSSortDescriptor(key: "startDate_", ascending: true)]
        )
        self._dailyProjects = FetchRequest(fetchRequest: request)
    }
    
    var body: some View {
        VStack(spacing: 5) {
            Divider()
            dayCell
        }
    }
    
    private var dayCell: some View {
        VStack(spacing: 0) {
            dayText
            projectIndicatorStack
            Spacer(minLength: 0)
        }
        .frame(width: calendarConfig.cellSize.width, height: calendarConfig.cellSize.height)
    }
    
    private var dayText: some View {
        Text("30")
            .hidden()
            .padding(7)
            .background(date.isToday ? Color.pink : nil)
            .clipShape(Circle())
            .overlay(
                Text(String(date.day))
            )
            .foregroundColor(date.isToday ? Color.white : date.isWeekend ? Color.gray : Color.primary)
        // TODO: bold if today
    }
    
    private var projectIndicatorStack: some View {
        var positions = [Int:Project?]()
        var lastIndex = 0
        
        dailyProjects.forEach { project in
            if let projectPosition = projectPositions[project] {
                positions[projectPosition] = project
                lastIndex = max(lastIndex, projectPosition)
            }
        }
        
        return VStack(spacing: 0) {
//            Spacer(minLength: 0)
            let end = lastIndex >= 3 ? 1 : lastIndex
            ForEach(0...end) { index in
                if positions[index] != nil {
                    ZStack {
                        Color.orange
                        if date.midnight == positions[index]!!.startDate.midnight {
                            Text(positions[index]!!.name)
                        }
                    }
                    .frame(width: calendarConfig.cellSize.width, height: calendarConfig.cellSize.width * 0.23)
                    .clipped()
                    .padding(.top, 2)
                } else {
                    Color.orange
                        .frame(width: calendarConfig.cellSize.width, height: calendarConfig.cellSize.width * 0.23)
                        .hidden()
                        .clipped()
                        .padding(.top, 2)
                }
            }
            if lastIndex >= 3 {
                // TODO: replace w/ image...?
                Text("...")
//                    .frame(width: width, height: width * 0.1)
                    .font(.caption)
                    .clipped()
            }
        }
        .clipped()
        .padding(.bottom, 0.5)
    }
}
