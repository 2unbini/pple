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
    func alert(isPresented: Binding<Bool>, title: String, message: String, buttonLabel: String) -> some View {
        self
            .alert(isPresented: isPresented) {
                Alert(
                    title: Text(title),
                    message: Text(message),
                    dismissButton: .default(Text(buttonLabel))
                )
            }
    }
    
    func cardify(size: CGSize) -> some View {
        self.modifier(Cardify(size: size))
    }
    
    func popup<Content: View>(
        item: Binding<Int?>,
        @ViewBuilder content: @escaping (Int) -> Content
    ) -> some View {
        self.modifier(
            Popup(item: item.wrappedValue, popupContent: content)
        )
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct CustomViewModifier: ViewModifier {
    var width: CGFloat
    var height: CGFloat
    var offset: CGFloat
    var corners: UIRectCorner
    func body(content: Content) -> some View {
        content
            .font(UIDevice.current.userInterfaceIdiom == .pad ? .title2 : .caption)
            .frame(width: width , height: height)
            .background(Color.orange)
            .cornerRadius(3, corners: corners)
            .offset(x: offset * 0.025)
            .clipped()
    }
}

extension View {
    func calendarStackModifier(width: CGFloat, height: CGFloat, offset: CGFloat, corners: UIRectCorner) -> some View {
        modifier(CustomViewModifier(width: width, height: height, offset: offset, corners: corners))
    }
}
