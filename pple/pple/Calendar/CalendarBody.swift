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
                            MonthSection(month: month)
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
    
    var body: some View {
        Section {
            monthLabel(month: month)
                .onAppear {
                    if [1, 2, 12].contains(month.month) {
                        calendarConfig.yearLabel = month.year.stringify()
                    }
                }
            ForEach(weeks) { week in
                WeekView(month: month, week: week)
            }
        }
        .id(month)
    }
    
    private var weeks: [Date] {
        guard let monthInterval: DateInterval = calendar.dateInterval(of: .month, for: month)
        else { return [] }
        return  calendar.generateDates(interval: monthInterval, dateComponents: DateComponents(hour: 0, minute: 0, second: 0, weekday: calendar.firstWeekday))
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
}
