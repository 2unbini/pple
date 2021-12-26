//
//  ProjectCalendarView.swift
//  i-scheduler
//
//  Created by Kim TaeSoo on 2021/12/07.
//

import SwiftUI

struct NavigationTrailingEditButton: View {
    @State var showModifyTab: Bool = false
    @State var project: Project
    
    var body: some View {
        Button {
            self.showModifyTab = !self.showModifyTab
        } label: {
            Text("수정")
        }
        .sheet(isPresented: $showModifyTab) {
            ProjectEditSheet(editWith: project)
        }
    }
}

struct DayButtonView: View {
    let day: Int
    let date: Date
    static let dateformat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "M.d"
        return formatter
    }()
    
    // MARK: colorOpacity - TaskList에서 할일의 개수를 받아와서 사용 예정
    let colorOpacity: Double = 20

    let width: CGFloat = UIScreen.main.bounds.size.width
    let height: CGFloat = UIScreen.main.bounds.size.height
    var body: some View {
        ZStack {
            Image(systemName: "square.fill")
                .resizable()
                .frame(width: UIDevice.current.userInterfaceIdiom != .pad ? width / 7 : width / 10,
                       height: UIDevice.current.userInterfaceIdiom != .pad ? height / 12 : height / 11)
                .foregroundColor(colorOpacity == 20 ? .white : Color(red: 117/255, green: 249/255, blue: 217/255))
                .opacity(colorOpacity == 20 ? 1 : colorOpacity / 100)
                .shadow(color: .black, radius: 2)
            VStack {
                Text(String(day))
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .frame(alignment: .center)
                    .foregroundColor(date.midnight == Date().midnight ? .accentColor : .black)
                    .font(UIDevice.current.userInterfaceIdiom != .pad ? .title3 : .title2)
                    .padding(2.0)
                Text("\(date, formatter: DayButtonView.dateformat)")
                    .lineLimit(1)
                    .font(UIDevice.current.userInterfaceIdiom != .pad ? .footnote : .title3)
                    .foregroundColor(date.midnight == Date().midnight ? .accentColor : .black)
            }
        }
        .padding(5)
    }
}

struct ProjectCalendarView: View {
    let startDate: Date
    let endDate: Date
    let dayData: [Int]
    
    @ObservedObject var project: Project
    @State var showModifyView: Bool = false
    @State var dayOf: Int = 0
    
    init(project: Project) {
        
        _project = ObservedObject(initialValue: project)
        self.startDate = project.startDate
        self.endDate = project.endDate
        self.dayData = Array(0...daysBetween(startDate: startDate, endDate: endDate))

    }
    var body: some View {

        GeometryReader { geometry in
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: UIDevice.current.userInterfaceIdiom != .pad ? 60 : 130))]) {
                    ForEach(dayData, id: \.self) { day in
                        Button {
                            withAnimation{
                                self.showModifyView = !self.showModifyView
                            }
                            self.dayOf = day
                        } label: {
                            DayButtonView(day: day + 1, date: plusDays(startDate: startDate, dayOf: day))
\
                        }
                    }
                }
            }
            .popup(isPresented: $showModifyView, content: {
                TaskList(
                    isPresented: $showModifyView, project: project,
                    date: plusDays(startDate: startDate, dayOf: dayOf)
                )
                    .cardify(size: CGSize(width: geometry.size.width, height: geometry.size.height))
            })
            .padding()
            .navigationBarTitle(project.name)
            .navigationBarItems(trailing: NavigationTrailingEditButton(project: self.project))
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

func plusDays(startDate: Date, dayOf: Int) -> Date {
    var dateComponent = DateComponents()
    dateComponent.day = dayOf
    return Calendar.current.date(byAdding: dateComponent, to: startDate)!
}


//struct ProjectCalendarView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProjectCalendarView()
//    }
//}
