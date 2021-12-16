//
//  EditSheet.swift
//  i-scheduler
//
//  Created by 권은빈 on 2021/12/08.
//

import SwiftUI
import CoreData


struct EditSheet: View {
    @Environment(\.managedObjectContext) var viewContext
    @ObservedObject private var editData: TempData
    
    private var subject: Subject
    private var prefix: String
    
    init(editWith selectedData: TempData, _ subject: Subject) {
        switch subject {
        case .project:
            self.prefix = "프로젝트"
        case .task:
            self.prefix = "할 일"
        }
        
        self.subject = subject
        self.editData = selectedData
    }
    
    var body: some View {
        VStack {
            EditToolBar(subject: subject, editedData: editData)
            Form {
                Section(content: {
                    TextField("", text: $editData.name)
                }, header: {
                    Text("\(prefix) 이름")
                })
                
                Section(content: {
                    TextEditor(text: $editData.summary)
                        .modifier(TextEditorModifier())
                }, header: {
                    Text("\(prefix) 설명")
                })
                
                Section(content: {
                    DatePicker("시작 날짜", selection: $editData.startDate, displayedComponents: .date)
                    DatePicker("종료 날짜", selection: $editData.endDate,
                               in: PartialRangeFrom(editData.startDate), displayedComponents: .date)
                }, header: {
                    Text("\(prefix) 기간")
                })
                
                Section(content: {
                    Toggle("\(prefix) 완료", isOn: $editData.isFinished)
                        .toggleStyle(.switch)
                }, header: {
                    Text("\(prefix) 완료")
                })
            }
//            .onAppear {
//                UITableView.appearance().backgroundColor = .clear
//            }
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
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 100, maxHeight: 100, alignment: .center)
    }
}

//struct EditSheet_Previews: PreviewProvider {
//    static var previews: some View {
//        EditSheet(subject: .task)
//    }
//}
