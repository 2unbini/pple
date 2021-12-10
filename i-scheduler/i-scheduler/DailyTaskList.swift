//
//  DailyTaskList.swift
//  i-scheduler
//
//  Created by sun on 2021/12/07.
//

import SwiftUI

struct DailyTaskList: View {
    @Environment(\.managedObjectContext) var context
    @FetchRequest var tasks: FetchedResults<Task>
    @Binding var isPresented: Bool
    var projectId: UUID
    
    init(isPresented: Binding<Bool>, projectId: UUID, date: Date) {
        self._isPresented = isPresented
        self.projectId = projectId
        // func in Task extension
        let request = Task.fetchRequest(NSPredicate(format: "project.id = %@ and startDate <= %@ and endDate >= %@", projectId as CVarArg, date as CVarArg, date as CVarArg))
        _tasks = FetchRequest(fetchRequest: request)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                if !tasks.isEmpty {
                    List {
                        ForEach(tasks) { task in
                            DailyTaskRowView(task: task)
                        }
                        .onDelete(perform: deleteTask(at:))
                    }
                } else {
                    Text("No Tasks Today")
                }
            }
            .navigationBarTitle("오늘의 할 일")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { cancel }
                ToolbarItem(placement: .navigationBarTrailing) { add }
            }
            .sheet(isPresented: $taskEditorIsPresented) {
                // replace with 은빈's Editor
                FakeTaskEditor(projectId: projectId)
                    .environment(\.managedObjectContext, context)
            }
        }
    }
    
    private func deleteTask(at indexSet: IndexSet) {
        for index in indexSet {
            // func in Task extension
            let task = Task.withId(tasks[index].id!, context: context)
            context.delete(task)
        }
        try? context.save()
    }
    
    private var cancel: some View {
        Button("취소") {
            withAnimation {
                isPresented = false
            }
        }
    }
    
    @State private var taskEditorIsPresented = false
    private var add: some View {
        Button {
            taskEditorIsPresented = true
        } label: {
            Image(systemName: "plus")
        }
    }
    
}

//struct DailyTaskList_Previews: PreviewProvider {
//    static var previews: some View {
//        DailyTaskList()
//    }
//}
