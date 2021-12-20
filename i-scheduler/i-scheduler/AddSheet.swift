//
//  AddSheet.swift
//  i-scheduler
//
//  Created by 권은빈 on 2021/12/08.
//

import SwiftUI
import CoreData

struct ProjectAddSheet: View {
    @Environment(\.managedObjectContext) private var viewContext: NSManagedObjectContext
    @ObservedObject private var tempProject: TempData = TempData()
    
    private var prefix: String = "프로젝트"

    var body: some View {
        VStack {
            ProjectToolBar(.add, project: nil, with: tempProject)
            Form {
                Section(content: {
                    TextField("", text: $tempProject.name)
                }, header: {
                    Text("\(prefix) 이름")
                })
                
                Section(content: {
                    TextEditor(text: $tempProject.summary)
                        .modifier(TextEditorModifier())
                }, header: {
                    Text("\(prefix) 설명")
                })
                
                Section(content: {
                    DatePicker("시작 날짜", selection: $tempProject.startDate, displayedComponents: .date)
                    DatePicker("종료 날짜", selection: $tempProject.endDate,
                               in: PartialRangeFrom(tempProject.startDate), displayedComponents: .date)
                }, header: {
                    Text("\(prefix) 기간")
                })
            }
        }
    }
}

struct TaskAddSheet: View {
    @Environment(\.managedObjectContext) private var viewContext: NSManagedObjectContext
    @ObservedObject private var tempTask: TempData
    
    private var prefix: String = "할 일"
    private var project: Project
    
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
