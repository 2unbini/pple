//
//  MainCalendar.swift
//  i-scheduler
//
//  Created by sun on 2022/01/07.
//

import SwiftUI

struct MainCalendar<DateView>: View where DateView: View {
    @Environment(\.calendar) var calendar
    let contents: (Date) -> DateView
    let interval: DateInterval
    let sevendaysInterval: DateInterval = DateInterval(start: Date(timeIntervalSince1970: 60 * 60 * 24 * 3), end: Date(timeIntervalSince1970: 60 * 60 * 24 * 9))
    init(interval: DateInterval, @ViewBuilder contents: @escaping (Date) -> DateView) {
        self.interval = interval
        self.contents = contents
    }
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(), count: 7)) {
            ForEach(createMonths, id: \.self) { months in
                
            }
        }
    }
    
    func createDaysThroughMonth(month: Date) -> [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: month),
              let firstWeekInterval = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.start),
              let lastWeekInterval = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.end)
        else { return [] }
        return calendar.generateDates(interval: DateInterval(start: firstWeekInterval.start, end: lastWeekInterval.end), dateComponents: DateComponents(hour:0))
    }
    
    var createAnArrayToDisplayWeekDay: [Date] {
        calendar.generateDates(interval: sevendaysInterval, dateComponents: DateComponents(hour: 0))
    }
    
    func showWeekDay(date: Date) -> some View {
        let formatter = DateFormatter.weekday
        return Text(formatter.string(from: date))
    }
    
    var createMonths: [Date] {
        calendar.generateDates(interval: interval, dateComponents: DateComponents(day: 1))
    }
}



//struct MainCalendar_Previews: PreviewProvider {
//    static var previews: some View {
//        MainCalendar()
//    }
//}
