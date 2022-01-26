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
    @State private var taskDataHolder: DataHolder = DataHolder()
    
    private var prefix: String = "할 일"
    private var project: Project
    
    init(relatedTo project: Project) {
        self.project = project
    }
    
    var body: some View {
        VStack {
            TaskToolBar(.add, task: nil, with: taskDataHolder, to: project)
            Form {
                Section(content: {
                    TextField("", text: $taskDataHolder.name)
                }, header: {
                    Text("\(prefix) 이름")
                })
                
                Section(content: {
                    TextEditor(text: $taskDataHolder.summary)
                        .modifier(TextEditorModifier())
                }, header: {
                    Text("\(prefix) 설명")
                })
                
                Section(content: {
                    DatePicker("시작 날짜", selection: $taskDataHolder.startDate, displayedComponents: .date)
                    DatePicker("종료 날짜", selection: $taskDataHolder.endDate,
                               in: PartialRangeFrom(taskDataHolder.startDate), displayedComponents: .date)
                }, header: {
                    Text("\(prefix) 기간")
                })
            }
        }
        .onAppear {
            self.taskDataHolder.setSpecificDate(with: project.startDate, project.endDate)
        }
    }
}
