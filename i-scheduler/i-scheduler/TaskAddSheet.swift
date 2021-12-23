//
//  TaskAddSheet.swift
//  i-scheduler
//
//  Created by 권은빈 on 2021/12/23.
//

import SwiftUI
import CoreData

struct TaskAddSheet: View {
    @Environment(\.managedObjectContext) private var viewContext: NSManagedObjectContext
    @ObservedObject private var tempTask: TempData
    
    private var prefix: String = "할 일"
    private var project: Project
    
    // TODO: 실제 기기에서 textField, textEditor, DatePicker 선택시 초기화되는 오류 발생
    // ObservedObject -> 계속 init됨
    init(relatedTo project: Project) {
        self.project = project
        self.tempTask = TempData()
        self.tempTask.startDate = project.startDate
        self.tempTask.endDate = project.endDate
    }
    
    var body: some View {
        VStack {
            TaskToolBar(.add, task: nil, with: tempTask, to: project)
            Form {
                Section(content: {
                    TextField("", text: $tempTask.name)
                }, header: {
                    Text("\(prefix) 이름")
                })
                
                Section(content: {
                    TextEditor(text: $tempTask.summary)
                        .modifier(TextEditorModifier())
                }, header: {
                    Text("\(prefix) 설명")
                })
                
                Section(content: {
                    DatePicker("시작 날짜", selection: $tempTask.startDate, displayedComponents: .date)
                    DatePicker("종료 날짜", selection: $tempTask.endDate,
                               in: PartialRangeFrom(tempTask.startDate), displayedComponents: .date)
                }, header: {
                    Text("\(prefix) 기간")
                })
            }
        }
    }
}
