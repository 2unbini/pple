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
    
    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        calendar.component(component, from: self)
    }
    
    var day: Int { self.get(.day) }
    var month: Int { self.get(.month) }
    var year: Int { self.get(.year) }
    
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
}

extension Int: Identifiable {
    public var id: Int { self }
}

extension View {
    func cardify(size: CGSize) -> some View {
        self.modifier(Cardify(size: size))
    }
}
