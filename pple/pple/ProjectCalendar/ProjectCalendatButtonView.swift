//
//  ProjectCalendatButtonView.swift
//  i-scheduler
//
//  Created by Kim TaeSoo on 2021/12/29.
//

import SwiftUI

struct ProjectCalendarNavigationTrailingEditButton: View {
    @State var isShowModifyTab: Bool = false
    @State var project: Project
    
    var body: some View {
        Button {
            self.isShowModifyTab = !self.isShowModifyTab
        } label: {
            Text("수정")
        }
        .sheet(isPresented: $isShowModifyTab) {
            ProjectEditSheet(editWith: project)
        }
    }
}

struct DayButtonImageForiPad: View {
    let buttonViewColorOpacity: Double
    let screenWidth: CGFloat
    let screenHeight: CGFloat
    var body: some View {
        Image(systemName: "square.fill")
            .resizable()
            .frame(width: UIDevice.current.userInterfaceIdiom != .pad ? screenWidth / 7 : screenWidth / 10,
                   height: UIDevice.current.userInterfaceIdiom != .pad ? screenHeight / 12 : screenHeight / 11)
            .foregroundColor(buttonViewColorOpacity == 20 ? .white : Color(red: 117/255, green: 249/255, blue: 217/255))
            .opacity(buttonViewColorOpacity == 20 ? 1 : buttonViewColorOpacity / 100)
            .shadow(color: .black, radius: 2)
    }
}

struct DayButtonImageForiPhone: View {
    let buttonViewColorOpacity: Double
    var body: some View {
        GeometryReader { geometry in
            Image(systemName: "square.fill")
                .resizable()
                .frame(width: geometry.size.width ,
                       height: geometry.size.height * 1.2)
                .foregroundColor(buttonViewColorOpacity == 20 ? .white : Color(red: 117/255, green: 249/255, blue: 217/255))
                .opacity(buttonViewColorOpacity == 20 ? 1 : buttonViewColorOpacity / 100)
                .shadow(color: .black, radius: 2)
        }
    }
}

struct nTHDayText: View {
    let nTHDay: Int
    let displayedDate: Date
    var body: some View {
        Text(String(nTHDay))
            .fontWeight(.bold)
            .multilineTextAlignment(.center)
            .frame(alignment: .center)
            .foregroundColor(displayedDate.midnight == Date().midnight ? .accentColor : .black)
            .font(UIDevice.current.userInterfaceIdiom != .pad ? .title3 : .title2)
            .padding(2.0)
    }
    
}

struct DisplayDateText: View {
    static let dateformat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "M.d"
        return formatter
    }()
    
    let displayedDate: Date
    
    var body: some View {
        Text("\(displayedDate, formatter: DisplayDateText.dateformat)")
            .lineLimit(1)
            .font(UIDevice.current.userInterfaceIdiom != .pad ? .footnote : .title3)
            .foregroundColor(displayedDate.midnight == Date().midnight ? .accentColor : .black)
    }
}

struct DayButtonView: View {
    let nTHDay: Int
    let displayedDate: Date

    // MARK: colorOpacity - TaskList에서 할일의 개수를 받아와서 사용 예정
    let buttonViewColorOpacity: Double = 20

    let screenWidth: CGFloat = UIScreen.main.bounds.size.width
    let screenHeight: CGFloat = UIScreen.main.bounds.size.height
    var body: some View {
        ZStack {
            if UIDevice.current.userInterfaceIdiom == .pad {
                DayButtonImageForiPad(buttonViewColorOpacity: buttonViewColorOpacity, screenWidth: screenWidth, screenHeight: screenHeight)
            }
            else if UIDevice.current.userInterfaceIdiom != .pad {
                DayButtonImageForiPhone(buttonViewColorOpacity: buttonViewColorOpacity)
            }
            VStack {
                nTHDayText(nTHDay: nTHDay, displayedDate: displayedDate)
                    .multilineTextAlignment(.center)
                DisplayDateText(displayedDate: displayedDate)
                    .multilineTextAlignment(.center)
                    
            }
        }
        .padding(8)
    }
}
