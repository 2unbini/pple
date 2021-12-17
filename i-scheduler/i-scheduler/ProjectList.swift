//
//  ProjectList.swift
//  i-scheduler
//
//  Created by 권은빈 on 2021/12/08.
//

import SwiftUI
import CoreData


// MARK: - EditButton 사용하지 않고 Custom Button 만들어서 toolBar에서 사용하는 경우, 화면의 왼편과 오른편이 나뉘는 현상 발생...

struct ProjectList: View {
    
    @Environment(\.editMode) private var editMode: Binding<EditMode>?
    @Environment(\.managedObjectContext) var viewContext: NSManagedObjectContext
    
    @FetchRequest(
        entity: Project.entity(),
        sortDescriptors: [NSSortDescriptor(key: "name_", ascending: true)]
    ) var projects: FetchedResults<Project>
    
    @State private var isEditing: Bool = false
    @State private var isTapped: Bool = false
    @State private var showAddSheet: Bool = false
    
    // TODO: Project 자체를 넘길 수 있는 방법 다시 생각
    @StateObject private var selectedProject: TempData = TempData()
    
    var body: some View {
        NavigationView {
            VStack {
                List(projects, id: \.self) { project in
                    NavigationLink(destination: ProjectCalendarView(project: project),
                                   label: {
                        Text(project.name)
                            .font(.title3)
                            .padding(8.0)
                    })
                        .onTapGesture {
                            if self.editMode?.wrappedValue == .active {
                                setSelectedData(with: project)
                                isTapped.toggle()
                            }
                        }
                }
                .listStyle(.plain)
                .navigationTitle(isEditing ? "프로젝트 선택" : "내 프로젝트")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading, content: {
                        Button(isEditing ? "완료" : "수정") {
                            self.editMode?.wrappedValue.toggle()
                            self.isEditing.toggle()
                        }
                    })
                    ToolbarItem(placement: .navigationBarTrailing, content: {
                        if !isEditing {
                            Button("추가") {
                                showAddSheet.toggle()
                            }
                            .sheet(isPresented: $showAddSheet, content: {
                                AddSheet(.project)
                            })
                        }
                    })
                }
                .sheet(isPresented: $isTapped, content: {
                    EditSheet(editWith: selectedProject, .project)
                        .environment(\.managedObjectContext, viewContext)
                })
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private func setSelectedData(with project: Project) {
        selectedProject.id = project.projectId
        selectedProject.name = project.name
        selectedProject.summary = project.summary
        selectedProject.startDate = project.startDate
        selectedProject.endDate = project.endDate
        selectedProject.isFinished = project.isFinished
    }
}

extension EditMode {
    mutating func toggle() {
        self = self == .active ? .inactive : .active
    }
}

//struct ProjectList_Previews: PreviewProvider {
//    static var previews: some View {
//        ProjectList()
//    }
//}
