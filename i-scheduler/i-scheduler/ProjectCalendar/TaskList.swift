//
//  TaskList.swift
//  i-scheduler
//
//  Created by sun on 2021/12/07.
//

import SwiftUI

struct TaskList: View {
    @Environment(\.managedObjectContext) private var context
    @FetchRequest private var tasks: FetchedResults<Task>
    @Binding var item: Int?
    private var project: Project
    private var date: Date
    
    init(item: Binding<Int?>, project: Project, date: Date) {
        self._item = item
        self.project = project
        self.date = date
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
                    Text("할 일을 추가하세요")
                }
            }
            .navigationBarTitle("\(date.month)월 \(date.day)일의 할 일")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { cancelButton }
                ToolbarItem(placement: .navigationBarTrailing) { addButton }
            }
            .sheet(isPresented: $isPresented) {
                TaskAddSheet(relatedTo: self.project)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
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
        indexSet.forEach { context.delete(tasks[$0]) }
        PersistenceController.shared.save(
            errorDescription: "TaskList.deleteTask"
        )
    }
    
    private var cancelButton: some View {
        Button("닫기") {
            withAnimation {
                item = nil
            }
        }
    }
    
    @State private var isPresented = false

    private var addButton: some View {
        Button {
            isPresented.toggle()
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
