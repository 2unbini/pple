//
//  ProjectCalendarView.swift
//  i-scheduler
//
//  Created by Kim TaeSoo on 2021/12/07.
//

import SwiftUI

struct ModifyView: View {
    @Environment(\.presentationMode) var presentationMode
    var getDays: Int
    var startDate: Date
    var body: some View {
        VStack(spacing: 50) {
            Text("modal")
                .font(.largeTitle)
            Button(action: {
                presentationMode.wrappedValue.dismiss()
                // test passed data
                print("func test = \(plusDays(startDate: startDate, dayOf: getDays))")
                print("day = \(getDays)")
            }, label: {
                Image(systemName: "xmark.circle")
                
            })
        }
    }
}

struct NavigationTrailingEditButton: View {
    @State var showModifyTab: Bool = false
    var body: some View {
        Button {
            self.showModifyTab = !self.showModifyTab
        }
    label: {
        Text("수정")
    }
        //    .sheet(isPresented: self.$showModifyTab) {
        //        ModifyView(bindingTest: 30)
        //    }
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
    
    @State var showModifyView: Bool = false
    
    // MARK : datData, startDate, endDate의 날짜를 받아서 수정할 예정
    init(startDate: Date = Date(), endDate: Date = Date(timeIntervalSinceNow: 2 * 24 * 60 * 60)) {
        self.startDate = startDate
        self.endDate = endDate
        self.dayData = Array(1...daysBetween(startDate: startDate, endDate: endDate)).map { "Day\n\($0)" }
    }
    
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: UIDevice.current.userInterfaceIdiom != .pad ? 60 : 130))]) {
                    ForEach(dayData, id: \.self) { day in
                        Button {
                            self.showModifyView = !self.showModifyView
                        } label: {
                            DayButtonView(day: day)
                        }.sheet(isPresented: self.$showModifyView) {
                            //몇번째 Day인지 넘겨줌 다음 뷰로
                            ModifyView(getDays: Int(atoi(day.components(separatedBy: "Day\n")[1])))
                        }
                    }
                }
            }
            .padding()
            .navigationBarTitle("프로젝트")
            .navigationBarItems(trailing: NavigationTrailingEditButton())
        }
        .navigationViewStyle(StackNavigationViewStyle())
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
