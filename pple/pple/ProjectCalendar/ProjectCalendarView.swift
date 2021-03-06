//
//  ProjectCalendarView.swift
//  i-scheduler
//
//  Created by Kim TaeSoo on 2021/12/07.
//

import SwiftUI

struct ProjectCalendarView: View {
    let startDate: Date
    let endDate: Date
    let dayData: [Int]
    
    @ObservedObject var project: Project
    @State private var currentIndex: Int?
    @State private var lastIndex = 0
    
    init(project: Project) {
        _project = ObservedObject(initialValue: project)
        self.startDate = project.startDate
        self.endDate = project.endDate
        self.dayData = Array(0...daysBetween(startDate: startDate, endDate: endDate))
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollViewReader { scrollView in
                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(.adaptive(minimum: UIDevice.current.userInterfaceIdiom != .pad ? 60 : 130)), count: UIDevice.current.userInterfaceIdiom != .pad ? 5 : 7)) {
                        ForEach(dayData, id: \.self) { day in
                            Button {
                                withAnimation {
                                    currentIndex = day
                                }
                            } label: {
                                DayButtonView(nTHDay: day + 1, displayedDate: plusDays(startDate: startDate, dayOf: day))
                            }
                        }
                    }
                }
                .navigationBarTitle(project.name)
                .navigationBarItems(trailing: ProjectCalendarNavigationTrailingEditButton(project: self.project)
                                        .disabled(currentIndex != nil)
                )
                .popup(item: $currentIndex) { index in
                    TaskList(
                        item: $currentIndex,
                        project: project,
                        date: plusDays(startDate: startDate, dayOf: index)
                    )
                        .cardify(size: geometry.size)
                }
                .padding()
            }
        }
    }
}

func daysBetween(startDate: Date, endDate: Date) -> Int {
    if endDate < startDate {
        return 1
    }
    return Calendar.current.dateComponents([.day], from: removeUnderHour(fromDate: startDate), to: removeUnderHour(fromDate: endDate)).day!
}

func removeUnderHour(fromDate: Date) -> Date {
    guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: fromDate)) else {
        fatalError("Failed to strip time from Date object")
    }
    return date
}

fileprivate func plusDays(startDate: Date, dayOf: Int) -> Date {
    var dateComponent = DateComponents()
    dateComponent.day = dayOf
    return Calendar.current.date(byAdding: dateComponent, to: startDate)!
}


//struct ProjectCalendarView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProjectCalendarView()
//    }
//}
