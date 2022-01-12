//
//  CalendarConfig.swift
//  i-scheduler
//
//  Created by Kim TaeSoo on 2022/01/12.
//

import SwiftUI

class CalendarConfig: ObservableObject {
    @Published var initialDateId: Date
    var today: Today
    let interval: DateInterval
    let calendar = Calendar(identifier: .gregorian)
    init() {
        let startDate = DateComponents(year: start)
        let endDate = DateComponents(year: end)
        self.interval = DateInterval(start: calendar.date(from: startDate)!, end: calendar.date(from: endDate)!)
        self.today = Today()
        initialDateId = calendar.date(from: DateComponents(year: today.year, month: today.month)) ?? Date()
    }
    
    struct Today {
        var date = Date()
        var year: Int
        var month: Int
        let calendar = Calendar(identifier: .gregorian)
        init() {
            self.year = calendar.component(.year, from: date)
            self.month = calendar.component(.month, from: date)
        }
    }
}
