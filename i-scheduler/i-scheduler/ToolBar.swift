//
//  ToolBar.swift
//  i-scheduler
//
//  Created by 권은빈 on 2021/12/08.
//

import SwiftUI
import CoreData


struct ProjectToolBar: View {
    
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @Environment(\.managedObjectContext) private var viewContext: NSManagedObjectContext
    
    @State private var showAlert: Bool = false
    
    private var action: ToolBarAction
    private var barText: String
    private var project: Project?
    private var tempProject: TempData

    init(_ action: ToolBarAction, project: Project?, with tempProject: TempData) {
        self.action = action
        self.barText = "프로젝트"
        
        switch action {
        case .add:
            self.barText += " 추가"
        case .edit:
            self.barText += " 수정"
        }
        
        self.project = project
        self.tempProject = tempProject
    }
    
    var body: some View {
        HStack {
            
            Button("닫기") {
                presentationMode.wrappedValue.dismiss()
            }
            .padding()

            Spacer()
            Text(barText)
                .font(.system(size: 20))
            Spacer()
            
            Button("저장") {
                if isValidData() {
                    switch action {
                    case .add:
                        setNewProject()
                    case .edit:
                        editProject()
                    }
                    saveContext()
                    presentationMode.wrappedValue.dismiss()
                }
                else {
                    showAlert.toggle()
                }
            }
            .alert(isPresented: $showAlert) {
                
                // TODO: Alert 강종되는 오류 수정
                    Alert(title: Text("제목을 추가해주세요!"), dismissButton: .cancel(Text("확인"), action: {
                        showAlert.toggle()
                    }))
            }
            .padding()
        }
    }
    
    private func isValidData() -> Bool {
        
        if tempProject.name.isEmpty || tempProject.name == "" { return false }
        if tempProject.startDate > tempProject.endDate { return false }
        
        return true
    }
    
    private func setNewProject() {
        let newProject = Project(context: viewContext)
        
        newProject.projectId = UUID()
        newProject.name = tempProject.name
        newProject.summary = tempProject.summary
        newProject.startDate = tempProject.startDate
        newProject.endDate = tempProject.endDate
        newProject.isFinished = tempProject.isFinished
    }
    
    private func editProject() {
        if project == nil {
            fatalError("Error in editProject... Project to edit is nil")
        }
        else {
            project!.name = tempProject.name
            project!.summary = tempProject.summary
            project!.startDate = tempProject.startDate
            project!.endDate = tempProject.endDate
            project!.isFinished = tempProject.isFinished
        }
    }
    
    private func saveContext() {
        do {
            try viewContext.save()
        }
        catch {
            fatalError("Error in saveContext(): \(error.localizedDescription)")
        }
    }
}

struct TaskToolBar: View {
    
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @Environment(\.managedObjectContext) private var viewContext: NSManagedObjectContext
    
    @State private var showAlert: Bool = false
    
    private var action: ToolBarAction
    private var barText: String
    private var task: Task?
    private var project: Project?
    private var tempTask: TempData

    init(_ action: ToolBarAction, task: Task?, with tempTask: TempData, to project: Project?) {
        self.action = action
        self.barText = "할 일"
        
        switch action {
        case .add:
            self.barText += " 추가"
        case .edit:
            self.barText += " 수정"
        }
        
        self.task = task
        self.project = project
        self.tempTask = tempTask
    }
    
    var body: some View {
        HStack {
            
            Button("닫기") {
                presentationMode.wrappedValue.dismiss()
            }
            .padding()

            Spacer()
            Text(barText)
                .font(.system(size: 20))
            Spacer()
            
            Button("저장") {
                if isValidData() {
                    switch action {
                    case .add:
                        setNewTask()
                    case .edit:
                        editTask()
                    }
                    saveContext()
                    presentationMode.wrappedValue.dismiss()
                }
                else {
                    showAlert.toggle()
                }
            }
            .alert(isPresented: $showAlert) {
                
                // TODO: Alert 강종되는 오류 수정
                    Alert(title: Text("제목을 추가해주세요!"), dismissButton: .cancel(Text("확인"), action: {
                        showAlert.toggle()
                    }))
            }
            .padding()
        }
    }
    
    private func isValidData() -> Bool {
        
        if tempTask.name.isEmpty || tempTask.name == "" { return false }
        if tempTask.startDate > tempTask.endDate { return false }
        
        return true
    }
    
    private func setNewTask() {
        if project == nil {
            fatalError("Error in setNewTask... Project to add new task is nil")
        }
        else {
            let newTask = Task(context: viewContext)
            
            newTask.taskId = UUID()
            newTask.name = tempTask.name
            newTask.summary = tempTask.summary
            newTask.startDate = tempTask.startDate
            newTask.endDate = tempTask.endDate
            newTask.isFinished = tempTask.isFinished
            newTask.project = project!
        }
    }
    
    private func editTask() {
        if task == nil {
            fatalError("Error in editTask... Task to edit is nil")
        }
        else {
            task!.name = tempTask.name
            task!.summary = tempTask.summary
            task!.startDate = tempTask.startDate
            task!.endDate = tempTask.endDate
            task!.isFinished = tempTask.isFinished
        }
    }
    
    private func saveContext() {
        do {
            try viewContext.save()
        }
        catch {
            fatalError("Error in saveContext(): \(error.localizedDescription)")
        }
    }
}
