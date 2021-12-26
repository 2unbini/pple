//
//  TaskEditSheet.swift
//  i-scheduler
//
//  Created by 권은빈 on 2021/12/23.
//

import SwiftUI
import CoreData

struct TaskEditSheet: View {
    @Environment(\.managedObjectContext) private var viewContext: NSManagedObjectContext
    @State private var tempTask: TempData = TempData()
    
    private var prefix: String = "할 일"
    private var task: Task
    
    init(editWith selectedTask: Task) {
        self.task = selectedTask
    }
    
    var body: some View {
        VStack {
            TaskToolBar(.edit, task: task, with: tempTask, to: nil)
            Form {
                Section(content: {
                    VStack {
                        TextField("", text: $tempTask.name)
                    }
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
                
                Section(content: {
                    Toggle("\(prefix) 완료", isOn: $tempTask.isFinished)
                        .toggleStyle(.switch)
                }, header: {
                    Text("\(prefix) 완료")
                })
            }
        }
        .onAppear {
            self.tempTask.setSpecificTask(with: task)
        }
    }
}