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
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        let midnightString = formatter.string(from: self)
        return formatter.date(from: midnightString) ?? self
    }
    
    var tomorrowMidnight: Date {
        var components = DateComponents()
        components.day = 1
        return Calendar.current.date(byAdding: components, to: midnight) ?? midnight
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

extension View {
    func cardify(size: CGSize) -> some View {
        self.modifier(Cardify(size: size))
    }
}
