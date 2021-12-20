//
//  ProjectList.swift
//  i-scheduler
//
//  Created by 권은빈 on 2021/12/08.
//

import SwiftUI
import CoreData


struct ProjectList: View {
    
    @Environment(\.editMode) private var editMode: Binding<EditMode>?
    @FetchRequest(
        entity: Project.entity(),
        sortDescriptors: [NSSortDescriptor(key: "name_", ascending: true)]
    ) var projects: FetchedResults<Project>
    
    @State private var isEditing: Bool = false
    @State private var isTapped: Bool = false
    @State private var showAddSheet: Bool = false
    @State private var project: Project?
    
    
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
                                self.project = project
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
                                ProjectAddSheet()
                            })
                        }
                    })
                }
                .sheet(item: $project) { project in
                    ProjectEditSheet(editWith: project)
                }
                .environment(\.editMode, editMode)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

extension EditMode {
    mutating func toggle() {
        self = self == .active ? .inactive : .active
    }
}
