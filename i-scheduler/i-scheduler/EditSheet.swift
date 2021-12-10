//
//  EditSheet.swift
//  i-scheduler
//
//  Created by 권은빈 on 2021/12/08.
//

import SwiftUI

struct EditSheet: View {
    
    private var subject: Subject
    private var prefix: String
    
    @State private var editedProject: TestProject
    
    init(subject: Subject, editData: TestProject) {
        self.subject = subject
        
        if subject == .project {
            self.prefix = "프로젝트"
        } else {
            self.prefix = "할 일"
        }
        
        _editedProject = State(initialValue: editData)
    }
    
    var body: some View {
        VStack {
            TopBar(bar: .editSheet, subject: subject, data: editedProject)
            VStack {
                Text("\(prefix) 이름")
                TextField("", text: $editedProject.name)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal, 30.0)
            }
            .padding()
            VStack {
                Text("\(prefix) 설명")
                TextEditor(text: $editedProject.summary)
                    .modifier(TextEditorModifier())
            }
            .padding()
            VStack {
                DatePicker("시작 날짜", selection: $editedProject.startDate, displayedComponents: .date)
                DatePicker("종료 날짜", selection: $editedProject.endDate, in: PartialRangeFrom(editedProject.startDate), displayedComponents: .date)
            }
            .padding(.horizontal, 50.0)
            .padding(.top, 20.0)
            
            Toggle("\(prefix) 완료", isOn: $editedProject.isFinished)
                .toggleStyle(.switch)
                .padding(.horizontal, 50.0)
                .padding(.top, 20.0)
            
            Spacer()
        }
    }
}

struct TextEditorModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color.clear)
            .foregroundColor(Color.black)
            .font(.body)
            .lineSpacing(5)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 100, alignment: .center)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
            .padding(.horizontal, 30.0)
    }
}

//struct EditSheet_Previews: PreviewProvider {
//    static var previews: some View {
//        EditSheet(subject: .task)
//    }
//}
