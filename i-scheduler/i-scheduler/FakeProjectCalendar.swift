//
//  FakeProjectCalendar.swift
//  i-scheduler
//
//  Created by sun on 2021/12/07.
//

import SwiftUI
import CoreData

struct FakeProjectCalendar: View {
    @Environment(\.managedObjectContext) var context
    @FetchRequest var project: FetchedResults<Project> {
        didSet {
            print("fetched : \(project.first)")
        }
    }
    var projectId : UUID
    
    init(projectId: UUID) {
        self.projectId = projectId
        let request = Project.fetchRequest(NSPredicate(format: "id = %@", projectId as CVarArg))
        _project = FetchRequest(fetchRequest: request)
        print("fetch successful")
        print("fetched : \(!project.isEmpty)")
        print("fetched : \(project.first)")
    }
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                ZStack {
                    if !project.isEmpty {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 50))]) {
                            ForEach(1..<10 , id: \.self) { day in
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .frame(width: 50, height: 75)
                                        .foregroundColor(.green)
                                    VStack {
                                        Text(Array(project.first?.allTasksConverted.sorted() ?? []).last?.name ?? "none")
                                    }
                                }
                                .onTapGesture {
                                    withAnimation {
                                        showTaskList = true
                                    }
                                }
                            }
                        }
                    } else {
                        Text("Add new project")
                    }
                }
                .padding()
                .navigationBarTitle(project.first?.name ?? "None")
                .toolbar {
                    Button {
                        isPresented = true
                        
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                .sheet(isPresented: $isPresented) {
                    FakeProjectEditor()
                }
                .popup(isPresented: $showTaskList, projectId: projectId, size: geometry.size, date: Date())
                .environment(\.managedObjectContext, context)
            }
        }
    }
    
    @State private var isPresented = false
    @State private var showTaskList = false
    private func getTodaysTasks() -> [Task] {
        return [Task]()
    }
}

//struct FakeProjectCalendar_Previews: PreviewProvider {
//    static var previews: some View {
//        FakeProjectCalendar()
//    }
//}
