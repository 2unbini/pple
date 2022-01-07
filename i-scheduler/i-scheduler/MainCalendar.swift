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
        ScrollView(.vertical) {
            LazyVStack{
                ForEach(years, id: \.self) { year in
                    YearView(of: year, content: contents)
                }
            }
        }
        /*LazyVGrid(columns: Array(repeating: GridItem(), count: 7)) {
            ForEach(createMonths, id: \.self) { months in
                
            }
        }*/
    }
    var years: [Date] {
        return calendar.generateDates(interval: interval, dateComponents: DateComponents(month: 1, day: 1, hour: 0, minute: 0, second: 0))
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

struct YearView<DateView>: View where DateView: View {
    @Environment(\.calendar) var calendar
    let year: Date
    let content: (Date) -> DateView
    init(of year: Date, @ViewBuilder content: @escaping (Date) -> DateView){
        self.year = year
        self.content = content
    }
    var body: some View {
        LazyVStack{
            ForEach(months, id: \.self) { month in
                MonthView(of: month, content: content)
            }
        }
    }
    var months: [Date] {
        guard let yearInterval = calendar.dateInterval(of: .year, for: year)
        else { return [] }
        return calendar.generateDates(interval: yearInterval, dateComponents: DateComponents(day: 1))
    }
}

struct MonthView<DateView>: View where DateView: View {
    @Environment(\.calendar) var calendar
    let month: Date
    let content: (Date) -> DateView
    init(of month: Date, @ViewBuilder content: @escaping (Date) -> DateView){
        self.month = month
        self.content = content
    }
    var body: some View {
        LazyVStack{
            ForEach(0..<weeks.count, id: \.self) { nth in
                if nth == 0 {
                    MonthLabel
                }
                WeekView
            }
        }
    }
    var weeks: [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: month)
        else { return[] }
        return calendar.generateDates(interval: monthInterval, dateComponents: DateComponents(hour: 0, minute: 0, second: 0, weekday: calendar.firstWeekday))
    }
}
struct WeekView<DateView>: View where DateView: View {
    @Environment(\.calendar) var calendar
    let week: Date
    let content: (Date) -> DateView
    init(of week: Date, @ViewBuilder content: @escaping (Date) -> DateView){
        self.week = week
        self.content = content
    }
    var days: [Date] {
        guard let weekInterval = calendar.dateInterval(of: .weekOfMonth, for: week)
        else { return[] }
        return calendar.generateDates(interval: weekInterval, dateComponents: DateComponents(hour: 0, minute: 0, second: 0))
    }
}
//struct MainCalendar_Previews: PreviewProvider {
//    static var previews: some View {
//        MainCalendar()
//    }
//}
