//
//  ProjectToolBar.swift
//  i-scheduler
//
//  Created by 권은빈 on 2021/12/08.
//

import SwiftUI
import CoreData

struct ProjectToolBar: View {
    
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @Environment(\.managedObjectContext) private var viewContext: NSManagedObjectContext
    
    @State private var alertInfo: AlertType = .invalidData
    @State private var showAlert: Bool = false
    @State private var showCoreDataAlert: Bool = false
    
    private var action: ToolBarAction
    private var barText: String
    private var project: Project?
    private var projectDataHolder: DataHolder
    
    init(_ action: ToolBarAction, project: Project?, with tempProject: DataHolder) {
        self.action = action
        self.barText = "프로젝트"
        
        switch action {
        case .add:
            self.barText += " 추가"
        case .edit:
            self.barText += " 수정"
        }
        
        self.project = project
        self.projectDataHolder = tempProject
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
        
        if projectDataHolder.name.isEmpty || projectDataHolder.name == "" { return false }
        if projectDataHolder.startDate > projectDataHolder.endDate { return false }
        
        return true
    }
    
    private func setNewProject() {
        let newProject = Project(context: viewContext)
        
        newProject.projectId = UUID()
        newProject.name = projectDataHolder.name
        newProject.summary = projectDataHolder.summary
        newProject.startDate = projectDataHolder.startDate
        newProject.endDate = projectDataHolder.endDate
        newProject.isFinished = projectDataHolder.isFinished
    }
    
    private func editProject() {
        if project == nil {
            self.alertInfo = .saveError
            self.showAlert.toggle()
        }
        else {
            project!.name = projectDataHolder.name
            project!.summary = projectDataHolder.summary
            project!.startDate = projectDataHolder.startDate
            project!.endDate = projectDataHolder.endDate
            project!.isFinished = projectDataHolder.isFinished
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
