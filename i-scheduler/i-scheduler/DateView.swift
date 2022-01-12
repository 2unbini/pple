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
        VStack(spacing: 0) {
            Divider()
            dayCell
        }
    }
    
    private var dayCell: some View {
        VStack(spacing: 0) {
            dayText
            // Project Indicatior
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
            
    }
//        VStack {
//            if String(calendar.component(.day, from: date)) == "1" {
//                if (calendar.component(.year, from: date), calendar.component(.month, from: date)) == (calendar.component(.year, from: date), calendar.component(.month, from: date)) {
//                    Text(DateFormatter.month.string(from: date))
//                        .bold()
//                        .foregroundColor(.yellow)
//                } else {
//                    Text(DateFormatter.month.string(from: date))
//                        .bold()
//                }
//            }
//            else {
//                Text(DateFormatter.month.string(from: date))
//                    .hidden()
//            }
//            VStack(spacing: 0) {
//                // monthly label
//                Divider()
//                VStack(spacing: 0) {
//                    if (calendar.component(.year, from: date), calendar.component(.month, from: date), calendar.component(.day, from: date)) == (calendar.component(.year, from: Date()), calendar.component(.month, from: Date()), calendar.component(.day, from: Date())) {
//                        ZStack {
//                            Image(systemName: "circle.fill")
//                                .foregroundColor(.yellow)
//                            Text(String(calendar.component(.day, from: date)))
//                        }
//                        //                    Text("30")
//                        //                        .hidden()
//                        //                        .padding(7)
//                        //                    //                    .background(Color) if today, color pink else white
//                        //                        .clipShape(Circle())
//                        //                    Circle()
//                        //                    Spacer(minLength: 0)
//                    }
//                    else if calendar.component(.weekday, from: date) == 1 || calendar.component(.weekday, from: date) == 7 {
//                        Text(String(calendar.component(.day, from: date)))
//                            .foregroundColor(.gray)
//                    } else {
//                        Text(String(calendar.component(.day, from: date)))
//                    }
//                }
//            }
//        }
//    }
}
