//
//  DailyTaskRowView.swift
//  i-scheduler
//
//  Created by sun on 2021/12/07.
//

import SwiftUI

struct DailyTaskRowView: View {
    @FetchRequest var tasks: FetchedResults<Task>
    @Environment(\.managedObjectContext) var context
    private var task: Task? { tasks.first }
    
    // func in Task extension
    init(task: Task) {
        let request = Task.fetchRequest(NSPredicate(format: "id = %@", (task.id ?? UUID()) as CVarArg))
        _tasks = FetchRequest(fetchRequest: request)
    }
    
    var body: some View {
        if let task = task {
            NavigationLink(destination: TaskDetailView(task: task)) {
                HStack {
                    checkbox(for: task)
                    description(of: task)
                }
                .foregroundColor(task.isFinished ? .gray : .black)
            }
        }
    }
    
    private func checkbox(for task: Task) -> some View {
        Button {
            save()
        } label: {
            Image(systemName: task.isFinished ? "checkmark.square" : "square")
                .scaleEffect(1.3)
        }
        .buttonStyle(.plain)
    }
    
    private func description(of task: Task) -> some View{
        VStack(alignment: .leading) {
            Text(task.name ?? "")
                .font(.headline)
                .strikethrough(task.isFinished)
            // var in Project extension
            Text(task.startToEnd)
                .strikethrough(task.isFinished)
            Text(task.summary ?? "")
                .strikethrough(task.isFinished)
                .lineLimit(2)
        }
        .padding(.leading)
    }
    
    private func save() {
        if let task = tasks.first {
            task.isFinished.toggle()
            try? context.save()
        }
    }
}

