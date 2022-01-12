//
//  CalendarBody.swift
//  i-scheduler
//
//  Created by 권은빈 on 2022/01/07.
//

import SwiftUI

struct ScrollableCalendarVGrid<DateView: View>: View {
    @Environment(\.calendar) private var calendar
    let interval: DateInterval
    let content: (Date, Date, CGFloat) -> DateView
    
    var body: some View {
        GeometryReader { geometry in
            ScrollViewReader { scrollView in
                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(spacing: 0), count: 7), spacing: 0) {
                        ForEach(months) { month in
                            monthSection(month: month, width: geometry.size.width / 7)
                        }
                    }
                }
                .onAppear {
                    scrollView.scrollTo(calendar.dateInterval(of: .month, for: Date()), anchor: .top)
                }
            }
        }
    }
    private func monthSection(month: Date, width: CGFloat) -> some View {
        Section {
            // Month Label
            ForEach(days(of: month)) { date in
                if calendar.isDate(date, equalTo: month, toGranularity: .month) {
                    content(month, date, width)
                } else {
                    content(month, date, width).hidden()
                }
            }
        }
        .id(month)
    }
    private var months: [Date] {
        calendar.generateDates(interval: DateInterval(start: interval.start, end: interval.end.addingTimeInterval(1)), dateComponents: DateComponents(day: 1))
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

struct CalendarBody<DateView: View>: View {
    @Environment(\.calendar) private var calendar
    let interval: DateInterval
    let content: (Date, Date) -> DateView
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(spacing: 0), count: 7), spacing: 0) {
            ForEach(months) { month in
                Section {
                    ForEach(days(of: month)) { date in
                        if calendar.isDate(date, equalTo: month, toGranularity: .month) {
                            content(month, date)
                        } else {
                            content(month, date).hidden()
                        }
                    }
                }
                .id(month)
            }
        }
    }
    private var months: [Date] {
        calendar.generateDates(interval: DateInterval(start: interval.start, end: interval.end.addingTimeInterval(1)), dateComponents: DateComponents(day: 1))
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
