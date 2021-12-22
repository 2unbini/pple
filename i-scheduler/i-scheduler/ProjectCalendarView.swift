//
//  ProjectCalendarView.swift
//  i-scheduler
//
//  Created by Kim TaeSoo on 2021/12/07.
//

import SwiftUI

struct NavigationTrailingEditButton: View {
    @State var showModifyTab: Bool = false
    
    var body: some View {
        Button {
            self.showModifyTab = !self.showModifyTab
        } label: {
            Text("수정")
        }
        .sheet(isPresented: $showModifyTab) {
            EditSheet(editWith: TempData(), .project)
        }
    }
}

struct DayButtonView: View {
    let day: String
    let width: CGFloat = UIScreen.main.bounds.size.width
    let height: CGFloat = UIScreen.main.bounds.size.height
    var body: some View {
        ZStack {
            Image(systemName: "square.fill")
                .resizable()
                .frame(width: UIDevice.current.userInterfaceIdiom != .pad ? width / 7 : width / 10,
                       height: UIDevice.current.userInterfaceIdiom != .pad ? height / 12 : height / 11)
                .foregroundColor(.white)
                .shadow(color: .black, radius: 2)
            Text(day)
                .multilineTextAlignment(.center)
                .frame(width: 80, height: 80, alignment: .center)
                .foregroundColor(.black)
                .font(UIDevice.current.userInterfaceIdiom != .pad ? .none : .title3)
        }
        .padding(5)
    }
}

struct ProjectCalendarView: View {
    let startDate: Date
    let endDate: Date
    let dayData: [String]
    
    @ObservedObject var project: Project
    @State var showModifyView: Bool = false
    @State var dayOf: Int = 0
    
    init(project: Project) {
        
        _project = ObservedObject(initialValue: project)
        self.startDate = project.startDate
        self.endDate = project.endDate
        self.dayData = Array(1...daysBetween(startDate: startDate, endDate: endDate) + 1).map { "Day\n\($0)" }
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
                            self.dayOf = Int(atoi(day.components(separatedBy: "Day\n")[1]))
                        } label: {
                            DayButtonView(day: day)
                            
                        }
                    }
                }
            }
            .popup(isPresented: $showModifyView, content: {
                
                // TODO: 1) dayOf 인자로 넘겨지는 것 해야 함!
                // TODO: 2) cardify의 인자로 들어가는 size GeometryReader로 넘겨주기
                TaskList(
                    isPresented: $showModifyView, project: project,
                    date: plusDays(startDate: startDate, dayOf: dayOf)
                )
                    .cardify(size: CGSize(width: geometry.size.width, height: geometry.size.height))
            })
            .padding()
            .navigationBarTitle(project.name)
            .navigationBarItems(trailing: NavigationTrailingEditButton())
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
