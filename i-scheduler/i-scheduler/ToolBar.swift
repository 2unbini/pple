//
//  ToolBar.swift
//  i-scheduler
//
//  Created by 권은빈 on 2021/12/08.
//

import SwiftUI
import CoreData

struct AddToolBar: View {
    
    private var subject: Subject
    private var barText: String
    private var saveData: TempData
    
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @Environment(\.managedObjectContext) private var viewContext: NSManagedObjectContext
    
    @State private var showAlert: Bool = false
    
    init(_ subject: Subject, addData: TempData) {
        switch subject {
        case .project:
            self.barText = "프로젝트 추가"
        case .task:
            self.barText = "할 일 추가"
        }
        self.subject = subject
        self.saveData = addData
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
                if saveData.name == "" {
                    showAlert.toggle()
                }
                else {
                    addNewData()
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("제목을 추가해주세요!"), dismissButton: .cancel(Text("확인"), action: {
                    showAlert.toggle()
                }))
            }
            .padding()
        }
    }
    
    private func addNewData() {
        
        if subject == .project {
            let newProject = Project(context: viewContext)
            
            // id는 자동생성되게하는 것 어떤지
            newProject.projectId = saveData.id
            newProject.name = saveData.name
            newProject.summary = saveData.summary
            newProject.startDate = saveData.startDate
            newProject.endDate = saveData.endDate
        }
        else if subject == .task {
            let newTask = Task(context: viewContext)
            
            newTask.taskId = saveData.id
            newTask.name = saveData.name
            newTask.summary = saveData.summary
            newTask.startDate = saveData.startDate
            newTask.endDate = saveData.endDate
        }
        
        do {
            try viewContext.save()
        }
        catch {
            fatalError("error in addNewData: \(error)")
        }
    }
}


struct EditToolBar: View {
    
    private var subject: Subject
    private var barText: String
    private var saveData: TempData
    
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @Environment(\.managedObjectContext) private var viewContext: NSManagedObjectContext
    
    @State private var showAlert: Bool = false
    
    init(subject: Subject, editedData: TempData) {
        switch subject {
        case .project:
            self.barText = "프로젝트 수정"
        case .task:
            self.barText = "할 일 수정"
        }
        
        self.subject = subject
        self.saveData = editedData
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
                saveEditedData()
                presentationMode.wrappedValue.dismiss()
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("제목을 추가해주세요!"), dismissButton: .cancel(Text("확인"), action: {
                    showAlert.toggle()
                }))
            }
            .padding()
        }
    }
    
    private func saveContext() {
        do {
            try viewContext.save()
        }
        catch {
            fatalError("error in saveContext: \(error)")
        }
    }
    
    private func saveEditedData() {
        
        if saveData.name == "" {
            showAlert.toggle()
            return
        }

        if subject == .project {

            // View에서 사용하는 공용 Data로 넘겨받고, 저장시에 대입
            // init 시점에서 context 사용하는 방법, Project 불러올 때 nil 오류들 해결 못함 -> TempData로 뷰에서 운용, 실제 저장시에 대입

            // id 찾지 못했을 때 현재로선 새로운 프로젝트가 만들어짐
            // 이 부분 보완 필요

            guard let editedProject = Project.withId(saveData.id, context: viewContext) else { fatalError("Cannot Find Project with \(saveData.id.uuidString)") }

            editedProject.name = saveData.name
            editedProject.summary = saveData.summary
            editedProject.startDate = saveData.startDate
            editedProject.endDate = saveData.endDate
            editedProject.isFinished = saveData.isFinished
        }
        else {
            guard let editedTask = Task.withId(saveData.id, context: viewContext) else { fatalError("Cannot Find Task with \(saveData.id.uuidString)") }

            editedTask.name = saveData.name
            editedTask.summary = saveData.summary
            editedTask.startDate = saveData.startDate
            editedTask.endDate = saveData.endDate
            editedTask.isFinished = saveData.isFinished
        }

        do {
            try viewContext.save()
        }
        catch {
            print(error.localizedDescription)
        }
    }
}

//
//struct TopBar_Previews: PreviewProvider {
//    static var previews: some View {
//        TopBar(bar: Bar.editSheet, subject: Subject.project)
//    }
//}
