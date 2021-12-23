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
