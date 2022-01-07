//
//  CalendarBody.swift
//  i-scheduler
//
//  Created by 권은빈 on 2022/01/07.
//

import SwiftUI

struct CalendarBody<DateView: View>: View {
    @Environment(\.calendar) private var calendar
    let interval: DateInterval
    let content: (Date, Date) -> DateView
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(spacing: 0), count: 7), spacing: 0) {
            ForEach(months) { month in
                Section {
                    ForEach(days(of: month)) { date in
                        // content
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
