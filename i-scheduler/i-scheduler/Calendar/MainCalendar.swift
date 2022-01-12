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

    var body: some View {
        VStack(spacing: 0) {
            year
            daysOfTheWeek
            Divider()
            ScrollableCalendarVGrid()
        }
        .environmentObject(calendarConfig)
        .background(Color.init(white: 0.95).ignoresSafeArea(.all, edges: .top))
    }

    private var year: some View {
        // TODO: @State로 만들기
        Text(calendarConfig.yearLabel)
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
}
