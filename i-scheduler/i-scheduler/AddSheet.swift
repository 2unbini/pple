//
//  AddSheet.swift
//  i-scheduler
//
//  Created by 권은빈 on 2021/12/08.
//

import SwiftUI
import CoreData

struct AddSheet: View {
    @Environment(\.presentationMode) private var presentationMode
    @StateObject var addData: TempData = TempData()
    
    private var subject: Subject
    private var prefix: String
    
    init(_ subject: Subject) {
        switch subject {
        case .project:
            self.prefix = "프로젝트"
        case .task:
            self.prefix = "할 일"
        }
        
        self.subject = subject
    }
    
    var body: some View {
        VStack {
            AddToolBar(subject, addData: addData)
            Form {
                Section(content: {
                    TextField("", text: $addData.name)
                }, header: {
                    Text("\(prefix) 이름")
                })
                
                Section(content: {
                    TextEditor(text: $addData.summary)
                        .modifier(TextEditorModifier())
                }, header: {
                    Text("\(prefix) 설명")
                })
                
                Section(content: {
                    DatePicker("시작 날짜", selection: $addData.startDate, displayedComponents: .date)
                    DatePicker("종료 날짜", selection: $addData.endDate, in: PartialRangeFrom(addData.startDate), displayedComponents: .date)
                }, header: {
                    Text("\(prefix) 기간")
                })
                
                Section(content: {
                    Toggle("\(prefix) 완료", isOn: $addData.isFinished)
                        .toggleStyle(.switch)
                }, header: {
                    Text("\(prefix) 완료")
                })
            }
        }
    }
}

//struct AddSheet_Previews: PreviewProvider {
//    static var previews: some View {
//        AddSheet(subject: .project)
//    }
//}
