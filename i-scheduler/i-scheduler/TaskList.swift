//
//  TaskList.swift
//  i-scheduler
//
//  Created by sun on 2021/12/07.
//

import SwiftUI

struct TaskList: View {
    @Environment(\.managedObjectContext) var context
    @FetchRequest var tasks: FetchedResults<Task>
    @Binding var isPresented: Bool
    var projectId: UUID
    
    init(isPresented: Binding<Bool>, projectId: UUID, date: Date) {
        self._isPresented = isPresented
        self.projectId = projectId
        let datePredicates = date.modifiedForPredicates()
        let request = Task.fetchRequest(
            NSPredicate(
                format: "project_.projectId_ = %@ and startDate_ < %@ and endDate_ >= %@",
                argumentArray: [projectId, datePredicates.start, datePredicates.end]
        ))
        _tasks = FetchRequest(fetchRequest: request)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                if !tasks.isEmpty {
                    taskList
                } else {
                    Text("오늘은 자유!")
                }
            }
            .navigationBarTitle("오늘의 할 일")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { cancel }
                ToolbarItem(placement: .navigationBarTrailing) { add }
            }
            .sheet(isPresented: $editorIsPresented) {
                AddSheet(.task, projectId: projectId)
            }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
    
    private var taskList: some View {
        List {
            ForEach(tasks) { task in
                TaskRowView(task: task)
            }
            .onDelete(perform: deleteTask(at:))
        }
    }
    
    private func deleteTask(at indexSet: IndexSet) {
        for index in indexSet {
            if let task = Task.withId(tasks[index].taskId, context: context) {
                context.delete(task)
            }
        }
        // replace with PersistenceController.shared.save()
        do {
            try context.save()
        } catch(let error) {
            print("태스크 삭제에 실패했습니다: \(error.localizedDescription)")
        }
    }
    
    private var cancel: some View {
        Button("취소") {
            withAnimation {
                isPresented = false
            }
        }
    }
    
    @State private var editorIsPresented = false

    private var add: some View {
        Button {
            editorIsPresented = true
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


//struct DailyTaskList_Previews: PreviewProvider {
//    static var previews: some View {
//        TaskList()
//    }
//}
