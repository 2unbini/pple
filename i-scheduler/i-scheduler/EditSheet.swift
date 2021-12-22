//
//  EditSheet.swift
//  i-scheduler
//
//  Created by 권은빈 on 2021/12/08.
//

import SwiftUI
import CoreData

struct ProjectEditSheet: View {
    @Environment(\.managedObjectContext) private var viewContext: NSManagedObjectContext
    @ObservedObject private var tempProject: TempData
    
    private var prefix: String = "프로젝트"
    private var project: Project
    
    init(editWith selectedProject: Project) {
        self.project = selectedProject
        self.tempProject = TempData()
        
        self.tempProject.name = selectedProject.name
        self.tempProject.summary = selectedProject.summary
        self.tempProject.startDate = selectedProject.startDate
        self.tempProject.endDate = selectedProject.endDate
        self.tempProject.isFinished = selectedProject.isFinished
    }
    
    var body: some View {
        VStack {
            ProjectToolBar(.edit, project: project, with: tempProject)
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
                
                Section(content: {
                    Toggle("\(prefix) 완료", isOn: $tempProject.isFinished)
                        .toggleStyle(.switch)
                }, header: {
                    Text("\(prefix) 완료")
                })
            }
        }
    }
}

struct TaskEditSheet: View {
    @Environment(\.managedObjectContext) private var viewContext: NSManagedObjectContext
    @ObservedObject private var tempTask: TempData
    
    private var prefix: String = "할 일"
    private var task: Task
    
    init(editWith selectedTask: Task) {
        self.task = selectedTask
        self.tempTask = TempData()
        
        self.tempTask.name = selectedTask.name
        self.tempTask.summary = selectedTask.summary
        self.tempTask.startDate = selectedTask.startDate
        self.tempTask.endDate = selectedTask.endDate
        self.tempTask.isFinished = selectedTask.isFinished
    }
    
    var body: some View {
        VStack {
            TaskToolBar(.edit, task: task, with: tempTask, to: nil)
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
                
                Section(content: {
                    Toggle("\(prefix) 완료", isOn: $tempTask.isFinished)
                        .toggleStyle(.switch)
                }, header: {
                    Text("\(prefix) 완료")
                })
            }
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
