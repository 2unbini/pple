//
//  DateView.swift
//  i-scheduler
//
//  Created by 권은빈 on 2022/01/07.
//

import SwiftUI

struct DateView: View {
    @Environment(\.calendar) private var calendar
    
    let month: Date
    let date: Date
    let width: CGFloat
    
    var body: some View {
        VStack(spacing: 5) {
            Divider()
            dayCell
        }
    }
    
    private var dayCell: some View {
        VStack(spacing: 0) {
            dayText
            // TODO: Project Indicatior
            Spacer(minLength: 0)
        }
        .frame(width: width, height: width * 1.5)
    }
    
    private var dayText: some View {
        Text("30")
            .hidden()
            .padding(7)
            .background(date.isToday ? Color.pink : nil)
            .clipShape(Circle())
            .overlay(
                Text(String(date.day))
            )
            .foregroundColor(date.isToday ? Color.white : date.isWeekend ? Color.gray : Color.primary)
            // TODO: bold if today
    }
}

// MARK: Tae's Refactor

struct MonthLabel: View {
    let date: Date
    var body: some View {
        VStack {
            if date.day == 1 {
                if (date.year, date.month) == (Date().year, Date().month) {
                    Text(DateFormatter.month.string(from: date))
                        .bold()
                        .foregroundColor(.yellow)
                } else {
                    Text(DateFormatter.month.string(from: date))
                        .bold()
                }
            }
            else {
                Text(DateFormatter.month.string(from: date))
                    .hidden()
            }
        }
        .onAppear {
            // upadate year label
        }
        Divider()
        VStack(spacing: 0) {
            // monthly label
            VStack(spacing: 0) {
                if (date.day, date.year, date.month) == (Date().day, Date().year, Date().month) {
                    ZStack {
                        Image(systemName: "circle.fill")
                            .foregroundColor(.yellow)
                        Text(String(date.day))
                    }
                }
                else {
                    Text(String(date.day))
                }
            }
        }
        .padding()
    }
}
