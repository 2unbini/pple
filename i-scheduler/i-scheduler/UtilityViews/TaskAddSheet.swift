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
    @State private var tempTask: TempData = TempData()
    
    private var prefix: String = "할 일"
    private var project: Project
    
    init(relatedTo project: Project) {
        self.project = project
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
        .onAppear {
            self.tempTask.setSpecificDate(with: project.startDate, project.endDate)
        }
    }
}
