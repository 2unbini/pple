//
//  UtilityExtensions.swift
//  i-scheduler
//
//  Created by sun on 2021/12/13.
//

import SwiftUI

extension Calendar {
    func generateDates(interval: DateInterval, dateComponents: DateComponents) -> [Date] {
        var dates: [Date] = [interval.start]
        enumerateDates(startingAfter: interval.start, matching: dateComponents, matchingPolicy: .nextTime) { result, _, stop in
            if let result = result {
                if result < interval.end {
                    dates.append(result)
                } else {
                    stop = true
                }
            }
        }
        return dates
    }
}

extension Date: Identifiable {
    public var id: String {
        description
    }
    
    private var calendar: Calendar {
        Calendar.current
    }
    
    func getComponent(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        calendar.component(component, from: self)
    }
    
    var day: Int { self.getComponent(.day) }
    var month: Int { self.getComponent(.month) }
    var year: Int { self.getComponent(.year) }
    var isToday: Bool { calendar.isDateInToday(self)}
    var isWeekend: Bool { calendar.isDateInWeekend(self)}
    
    var midnight: Date {
        calendar.date(bySettingHour: 0, minute: 0, second: 0, of: self) ?? self
    }
    
    var tomorrowMidnight: Date {
        calendar.date(byAdding: .day, value: 1, to: midnight) ?? midnight
    }
}

extension DateFormatter {
    static var weekday: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        return formatter
    }
    
    static var yearAndMonth: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MMMM"
        return formatter
    }
    
    static var month: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        return formatter
    }
}

extension Int: Identifiable {
    public var id: Int { self }
}

extension Int {
    func stringify() -> String {
        String(self)
    }
}

extension View {
    func cardify(size: CGSize) -> some View {
        self.modifier(Cardify(size: size))
    }
    
    @ViewBuilder
    func popup<Content: View>(
        item: Binding<Int?>,
        @ViewBuilder content: @escaping (Int) -> Content
    ) -> some View {
        if item.wrappedValue != nil {
            let index = item.wrappedValue!
            let backgroundShadow = Color.primary
                .opacity(0.15)
                .frame(
                    width: UIScreen.main.bounds.width,
                    height: UIScreen.main.bounds.height * 1.5
                )
            self
                .overlay(
                    ZStack {
                        backgroundShadow
                        content(index)
                            .offset(x: 0, y: -50)
                    }
                )
        } else {
            self
        }
    }
}
