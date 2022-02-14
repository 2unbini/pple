//
//  TaskToolBar.swift
//  i-scheduler
//
//  Created by 권은빈 on 2021/12/23.
//

import SwiftUI
import CoreData

struct TaskToolBar: View {
    
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @Environment(\.managedObjectContext) private var viewContext: NSManagedObjectContext
    
    @State private var alertInfo: AlertType = .invalidData
    @State private var showAlert: Bool = false
    @State private var showCoreDataAlert: Bool = false

    private var action: ToolBarAction
    private var barText: String
    private var task: Task?
    private var project: Project?
    private var taskDataHolder: DataHolder

    init(_ action: ToolBarAction, task: Task?, with tempTask: DataHolder, to project: Project?) {
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
        self.taskDataHolder = tempTask
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
                    alertInfo = .invalidData
                    showAlert.toggle()
                }
            }
            .alert(isPresented: $showAlert) {
                switch alertInfo {
                case .saveError:
                    return Alert(
                        title: Text("저장오류"),
                        message: Text("저장에 실패했습니다"),
                        dismissButton: .default(Text("확인"))
                    )
                case .invalidData:
                    return Alert(
                        title: Text("제목이 없습니다"),
                        message: Text("제목을 입력해주세요"),
                        dismissButton: .default(Text("확인"))
                    )
                }
            }
            .padding()
        }
    }
    
    private func isValidData() -> Bool {
        
        if taskDataHolder.name.isEmpty || taskDataHolder.name == "" { return false }
        if taskDataHolder.startDate > taskDataHolder.endDate { return false }
        
        return true
    }
    
    private func setNewTask() {
        if project == nil {
            self.alertInfo = .saveError
            self.showAlert.toggle()
        }
        else {
            let newTask = Task(context: viewContext)
            
            newTask.taskId = UUID()
            newTask.name = taskDataHolder.name
            newTask.summary = taskDataHolder.summary
            newTask.startDate = taskDataHolder.startDate
            newTask.endDate = taskDataHolder.endDate
            newTask.isFinished = taskDataHolder.isFinished
            newTask.project = project!
        }
    }
    
    private func editTask() {
        if task == nil {
            self.alertInfo = .saveError
            self.showAlert.toggle()
        }
        else {
            task!.name = taskDataHolder.name
            task!.summary = taskDataHolder.summary
            task!.startDate = taskDataHolder.startDate
            task!.endDate = taskDataHolder.endDate
            task!.isFinished = taskDataHolder.isFinished
        }
    }
    
    private func saveContext() {
        let saved = PersistenceController.shared.save(
            errorDescription: "Error in saveContext()"
        )
        if saved == false {
            self.alertInfo = .saveError
            self.showAlert.toggle()
        }
    }
}
