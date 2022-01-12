//
//  CalendarConfig.swift
//  i-scheduler
//
//  Created by Kim TaeSoo on 2022/01/12.
//

import SwiftUI

class CalendarConfig: ObservableObject {
    @Published var yearLabel: String
    let initialDateId: Date
    var today: Today
    let interval: DateInterval
    let calendar = Calendar(identifier: .gregorian)
    init() {
        let startDate = DateComponents(year: start)
        let endDate = DateComponents(year: end)
        self.interval = DateInterval(start: calendar.date(from: startDate)!, end: calendar.date(from: endDate)!)
        self.today = Today()
        initialDateId = calendar.date(from: DateComponents(year: today.year, month: today.month)) ?? Date()
        self.yearLabel = today.stringify(content: today.year)
    }
    
    struct Today {
        var date = Date()
        var year: Int
        var month: Int
        init() {
            self.year = date.year
            self.month = date.month
        }
        func stringify(content: Int) -> String {
            return String(content)
        }
    }
}
