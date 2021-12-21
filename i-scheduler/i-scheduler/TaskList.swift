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
    private var project: Project
    
    init(isPresented: Binding<Bool>, project: Project, date: Date) {
        self._isPresented = isPresented
        self.project = project
        let request = Task.fetchRequest(
            NSPredicate(
                format: "project_ = %@ and startDate_ < %@ and endDate_ >= %@",
                argumentArray: [project, date.tomorrowMidnight, date.midnight]
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
                ToolbarItem(placement: .cancellationAction) { cancelButton }
                ToolbarItem(placement: .navigationBarTrailing) { addButton }
            }
            .sheet(isPresented: $addSheetIsPresented) {
                // TODO: replace with refactored AddSheet
                AddSheet(.task, projectId: project.projectId)
            }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
    
    private var taskList: some View {
        List {
            ForEach(tasks) { task in
                NavigationLink(destination: TaskDetailView(task: task)) {
                    TaskRowView(task: task)
                }
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
    
    private var cancelButton: some View {
        Button("취소") {
            withAnimation {
                isPresented = false
            }
        }
    }
    
    @State private var addSheetIsPresented = false

    private var addButton: some View {
        Button {
            addSheetIsPresented = true
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
