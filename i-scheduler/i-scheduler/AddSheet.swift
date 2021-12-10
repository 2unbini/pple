//
//  AddSheet.swift
//  i-scheduler
//
//  Created by 권은빈 on 2021/12/08.
//

import SwiftUI

struct AddSheet: View {
    
    private var subject: Subject
    private var prefix: String
    
    @State var addData: TestProject
    
    init(subject: Subject) {
        self.subject = subject
        
        if subject == .project {
            self.prefix = "프로젝트"
        } else {
            self.prefix = "할 일"
        }
        
        _addData = State(initialValue: TestProject(name: "", summary: ""))
    }
    
    var body: some View {
        VStack {
            TopBar(bar: .addSheet, subject: subject, data: addData)
            VStack {
                Text("\(prefix) 이름")
                TextField("", text: $addData.name)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal, 30.0)
            }
            .padding()
            VStack {
                Text("\(prefix) 설명")
                TextEditor(text: $addData.summary)
                    .modifier(TextEditorModifier())
            }
            .padding()
            VStack {
                DatePicker("시작 날짜", selection: $addData.startDate, displayedComponents: .date)
                DatePicker("종료 날짜", selection: $addData.endDate, in: PartialRangeFrom(addData.startDate), displayedComponents: .date)
            }
            .padding(.horizontal, 50.0)
            .padding(.top, 20.0)
            
            Spacer()
        }
    }
}

//struct AddSheet_Previews: PreviewProvider {
//    static var previews: some View {
//        AddSheet(subject: .project)
//    }
//}
