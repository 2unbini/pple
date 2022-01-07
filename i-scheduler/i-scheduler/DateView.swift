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
//    let width: CGFloat
    
    var body: some View {
        VStack(spacing: 0) {
            // monthly label
            Divider()
            VStack(spacing: 0) {
                Text("30")
                    .hidden()
                    .padding(7)
//                    .background(Color) if today, color pink else white
                    .clipShape(Circle())
                Circle()
                Spacer(minLength: 0)
            }
        }
    }
}
