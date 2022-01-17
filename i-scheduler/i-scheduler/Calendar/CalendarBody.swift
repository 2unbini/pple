//
//  CalendarBody.swift
//  i-scheduler
//
//  Created by 권은빈 on 2022/01/07.
//

import SwiftUI

struct ScrollableCalendarVGrid: View {
    @Environment(\.calendar) private var calendar
    @EnvironmentObject var calendarConfig: CalendarConfig
    
    var body: some View {
        GeometryReader { geometry in
            ScrollViewReader { scrollView in
                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(spacing: 0), count: 7), spacing: 0) {
                        ForEach(months) { month in
                            MonthSection(month: month, width: geometry.size.width / 7)
                        }
                    }
                }
                .background(Color.white)
                .onAppear {
                    calendarConfig.cellSize.width = geometry.size.width / 7
                    calendarConfig.cellSize.height = calendarConfig.cellSize.width * 1.5
                    scrollView.scrollTo(calendarConfig.initialDateId, anchor: .top)
                }
            }
        }
    }
    
    private var months: [Date] {
        calendar.generateDates(interval: DateInterval(start: calendarConfig.interval.start, end: calendarConfig.interval.end.addingTimeInterval(1)), dateComponents: DateComponents(day: 1))
    }
}

struct MonthSection: View {
    @Environment(\.calendar) var calendar: Calendar
    @EnvironmentObject var calendarConfig: CalendarConfig
    
    let month: Date
    let width: CGFloat
    
    init (month: Date, width: CGFloat) {
        self.month = month
        self.width = width
    }
    
    var body: some View {
        Section {
            monthLabel(month: month)
                .onAppear {
                    if month.month == 12 && calendarConfig.yearLabel != String(month.year) {
                        calendarConfig.yearLabel = String(month.year)
                    }
                }
            ForEach(days(of: month)) { date in
                if calendar.isDate(date, equalTo: month, toGranularity: .month) {
                    DateView(month: month, date: date, width: width)
                } else {
                    DateView(month: month, date: date, width: width).hidden()
                }
            }
        }
        .id(month)
    }
    
    private var weeks: [Date] {
        guard let monthInterval: DateInterval = calendar.dateInterval(of: .month, for: month)
        else { return [] }
        return calendar.generateDates(interval: monthInterval, dateComponents: DateComponents(hour: 0, minute: 0, second: 0, weekday: calendar.firstWeekday))
    }
    
    private var weeklyProjectList: [[Project]] {
        for week in weeks {
            var days: [Date]
            guard let weekInterval: DateInterval = calendar.dateInterval(of: .weekOfMonth, for: week)
            else { return [[]] }
            days = calendar.generateDates(interval: weekInterval, dateComponents: DateComponents(hour: 0, minute: 0, second: 0))
            for project in calendarConfig.projects
        }
        
    }
    
    
    @ViewBuilder
    private func monthLabel(month: Date) -> some View {
        if let monthFirstWeekInterval = calendar.dateInterval(of: .weekOfMonth, for: month) {
            let daysOfMonthFirstWeek = calendar.generateDates(interval: monthFirstWeekInterval, dateComponents: DateComponents(hour: 0, minute: 0, second: 0))
            
            ForEach(daysOfMonthFirstWeek) { date in
                if date.day == 1 {
                    Text(String(month.month) + "월")
                        .bold()
                        .font(.title3)
                        .foregroundColor(calendar.isDate(date, equalTo: Date(), toGranularity: .month) ? .pink : .primary)
                        .padding(.top, 10)
                        .padding(.bottom, 5)
                }
                else {
                    Text(String(month.month))
                        .font(.title3)
                        .bold()
                        .hidden()
                }
            }
        }
    }
    
    private func days(of month: Date) -> [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: month),
              let firstWeekInterval = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.start),
              let lastDayOfMonth = calendar.date(byAdding: .day, value: -1, to: monthInterval.end),
              let lastWeekInterval = calendar.dateInterval(of: .weekOfMonth, for: lastDayOfMonth)
        else { return [] }
        
        return calendar.generateDates(interval: DateInterval(start: firstWeekInterval.start, end: lastWeekInterval.end), dateComponents: DateComponents(hour:0, minute: 0, second: 0))
    }
}
