//
//  MainCalendar.swift
//  i-scheduler
//
//  Created by sun on 2022/01/07.
//

import SwiftUI

struct MainCalendar: View {
    @Environment(\.calendar) var calendar
    @StateObject var calendarConfig: CalendarConfig = CalendarConfig()
    //    let contents: (Date) -> DateView
    let interval: DateInterval = DateInterval(start: Date(), end: Date().addingTimeInterval(60 * 60 * 24 * 365))
    let sevendaysInterval: DateInterval = DateInterval(
        start: Date(timeIntervalSince1970: 60 * 60 * 24 * 3),
        end: Date(timeIntervalSince1970: 60 * 60 * 24 * 9)
    )
    //    init(interval: DateInterval, @ViewBuilder contents: @escaping (Date) -> DateView) {
    //        self.interval = interval
    //        self.contents = contents
    //    }
    //    @State var year: Int = 0
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollViewReader { value in
                //                year
                daysOfTheWeek
                Divider()
                ScrollView(.vertical) {
                    CalendarBody(interval: interval) { month, date in
                        DateView(month: month, date: date)
                            .onAppear {
                                //
                            }
                    }
                }
                .onAppear(perform: {
                    value.scrollTo(calendar.dateInterval(of: .month, for: Date()), anchor: .top)
                })
                .background(Color.white)
            }
        }
        .background(Color.init(white: 0.95).ignoresSafeArea(.all, edges: .top))
    }
    func header(month: Date) -> some View {
        let formatter = DateFormatter.yearAndMonth
        return Text(formatter.string(from: month))
            .font(.title)
            .padding()
    }
        private var year: some View {
            // TODO: @State로 만들기
            Text("2021")
        }
    private var daysOfTheWeek: some View {
        HStack(spacing: 0) {
            let daysOfTheWeek = ["일", "월", "화", "수", "목", "금", "토"]
            ForEach(daysOfTheWeek, id: \.self) { dayOfTheWeek in
                Text(dayOfTheWeek)
                    .font(.caption)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(.vertical, 5)
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

//struct MainCalendar_Previews: PreviewProvider {
//    static var previews: some View {
//        MainCalendar()
//    }
//}
