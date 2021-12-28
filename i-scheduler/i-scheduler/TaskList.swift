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
    @Binding var isPresented: Bool
    private var project: Project
    private var date: Date
    
    init(isPresented: Binding<Bool>, project: Project, date: Date) {
        self._isPresented = isPresented
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
                    Text("오늘은 자유!")
                }
            }
            .navigationBarTitle("\(date.month)월 \(date.day)일의 할 일")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { cancelButton }
                ToolbarItem(placement: .navigationBarTrailing) { addButton }
            }
            .sheet(isPresented: $addSheetIsPresented) {
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
                isPresented.toggle()
            }
        }
    }
    
    @State private var addSheetIsPresented = false

    private var addButton: some View {
        Button {
            addSheetIsPresented.toggle()
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
