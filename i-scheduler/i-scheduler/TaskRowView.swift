//
//  TaskRowView.swift
//  i-scheduler
//
//  Created by sun on 2021/12/07.
//

import SwiftUI

//
//  TaskRowView.swift
//  i-scheduler
//
//  Created by sun on 2021/12/07.
//

import SwiftUI

struct TaskRowView: View {
    @ObservedObject var task: Task
    
    var body: some View {
        HStack {
            CheckBox(task: task)
            description(of: task)
        }
        .foregroundColor(task.isFinished ? .gray : .black)
    }
    
    private func description(of task: Task) -> some View{
        VStack(alignment: .leading) {
            Text(task.name)
                .font(.headline)
                .strikethrough(task.isFinished)
            Text(task.startDateToEndDateInPrettyFormat)
                .strikethrough(task.isFinished)
            Text(task.summary)
                .strikethrough(task.isFinished)
                .lineLimit(2)
        }
        .padding(.leading)
    }
}

