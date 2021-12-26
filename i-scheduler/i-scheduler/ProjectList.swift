//
//  ProjectList.swift
//  i-scheduler
//
//  Created by 권은빈 on 2021/12/08.
//

import SwiftUI
import CoreData


struct ProjectList: View {
    
    @Environment(\.managedObjectContext) private var viewContext: NSManagedObjectContext
    @FetchRequest(
        entity: Project.entity(),
        sortDescriptors: [NSSortDescriptor(key: "name_", ascending: true)]
    ) var projects: FetchedResults<Project>
    
    @State private var isEditing: Bool = false
    @State private var showAddSheet: Bool = false
    @State private var project: Project?
    @State private var editMode: EditMode = .inactive
    
    var body: some View {
        NavigationView {
            List {
                ForEach(projects, id: \.self) { project in
                    if isEditing {
                        ProjectLabel(project: project)
                            .onTapGesture {
                                self.project = project
                            }
                    }
                    else {
                        NavigationLink(destination: ProjectCalendarView(project: project)) {
                            ProjectLabel(project: project)
                        }
                    }
                }
                .onDelete(perform: removeSelectedProject)
            }
            .listStyle(.plain)
            .navigationTitle(isEditing ? "프로젝트 선택" : "내 프로젝트")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(isEditing ? "완료" : "편집") {
                        editMode.toggle()
                        isEditing.toggle()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    if !isEditing {
                        Button("추가") {
                            showAddSheet.toggle()
                        }
                        .sheet(isPresented: $showAddSheet, content: {
                            ProjectAddSheet()
                        })
                    }
                }
            }
            .sheet(item: $project) { project in
                ProjectEditSheet(editWith: project)
            }
            .environment(\.editMode, $editMode)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private func removeSelectedProject(at indexSet: IndexSet) {
        guard let index = indexSet.first else { fatalError("Cannot Convert IndexSet to Int") }
        
        viewContext.delete(projects[index])
        do {
            try viewContext.save()
        } catch {
            fatalError("Cannot save context")
        }
    }
}

struct ProjectLabel: View {
    var project: Project
    
    var body: some View {
        Text(project.name)
        // TODO: need to find the way to update isFinished when endDate expires
        // stikethrough and foregroundColor change when isFinished
            .strikethrough(project.isFinished, color: .gray)
            .foregroundColor(project.isFinished ? .gray : .black)
            .font(.title3)
            .padding(8.0)
    }
}

extension EditMode {
    mutating func toggle() {
        self = self == .active ? .inactive : .active
    }
}
