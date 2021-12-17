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
                       height: UIDevice.current.userInterfaceIdiom != .pad ? height / 12 : height / 15)
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
    
    init(project: Project) {
        
        _project = ObservedObject(initialValue: project)
        self.startDate = project.startDate
        self.endDate = project.endDate
        self.dayData = Array(1...daysBetween(startDate: startDate, endDate: endDate)).map { "Day\n\($0)" }
    }
    
    
    var body: some View {
        
        // TODO: GeometryReader로 LazyVGrid 사이즈 수정 해 주기
        
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: UIDevice.current.userInterfaceIdiom != .pad ? 60 : 130))]) {
                ForEach(dayData, id: \.self) { day in
                    Button {
                        withAnimation{
                            self.showModifyView = !self.showModifyView
                        }
                    } label: {
                        DayButtonView(day: day)
                    }
                }
            }
        }
        .popup(isPresented: $showModifyView, content: {
            
            // TODO: 1) dayOf 인자로 넘겨지는 것 해야 함!
            // TODO: 2) cardify의 인자로 들어가는 size GeometryReader로 넘겨주기
            
            TaskList(isPresented: $showModifyView, projectId: project.projectId, date: plusDays(startDate: startDate, dayOf: /*1*/ 3))
                .cardify(size: /*2*/ CGSize(width: 450, height: 700))
        })
        .padding()
        .navigationBarTitle("프로젝트")
        .navigationBarItems(trailing: NavigationTrailingEditButton())
    }
}

func daysBetween(startDate: Date, endDate: Date) -> Int {
    return Calendar.current.dateComponents([.day], from: startDate, to: endDate).day!
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
