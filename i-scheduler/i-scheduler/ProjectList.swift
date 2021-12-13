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
    @Environment(\.managedObjectContext) private var viewContet: NSManagedObjectContext
    
    @FetchRequest(
        entity: Project.entity(),
        sortDescriptors: [NSSortDescriptor(key: "name_", ascending: true)]
    ) var projects: FetchedResults<Project>
    
    @State private var isEditing: Bool = false
    @State private var isTapped: Bool = false
    @State private var showAddSheet: Bool = false
    @State private var editData: Project = Project()
    
    var body: some View {
        NavigationView {
            VStack {
                List(projects, id: \.self) { project in
                    NavigationLink(destination: ProjectGrid(row: project.name),
                                   label: {
                        Text(project.name)
                            .font(.title3)
                            .padding(8.0)
                    })
                    .onTapGesture {
                        if self.editMode?.wrappedValue == .active {
                            editData = project
                            isTapped.toggle()
                        }
                    }
                }
                .listStyle(.plain)
                .navigationTitle(isEditing ? "프로젝트 선택" : "내 프로젝트")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading, content: {
                        Button(isEditing ? "완료" : "수정") {
                            editMode?.wrappedValue.toggle()
                            isEditing.toggle()
                        }
                    })
                    ToolbarItem(placement: .navigationBarTrailing, content: {
                        if !isEditing {
                            Button("추가") {
                                showAddSheet.toggle()
                            }
                            .sheet(isPresented: $showAddSheet, content: {
                                AddSheet(subject: .project)
                            })
                        }
                    })
                }
                .sheet(isPresented: $isTapped, content: {
                    EditSheet(subject: .project, editData: editData)
                })
            }
        }
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
