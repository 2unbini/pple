//
//  TaskDetailView.swift
//  i-scheduler
//
//  Created by sun on 2021/12/08.
//

import SwiftUI

struct TaskDetailView: View {
    @ObservedObject var task: Task
    @State var isPresented = false
    
    var body: some View {
        HStack {
            taskDetails
            Spacer()
        }
        .padding(.horizontal)
        // TODO: discuss button function and UI
        .toolbar {
            // TODO: implement functioning
            Button("Edit") {
                isPresented = true
            }
            .sheet(isPresented: $isPresented) {
                EditSheet(editWith: TempData(), .task)
            }
        }
    }
    
    private var taskDetails: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                CheckBox(task: task)
                Text(task.isFinished ? "완료!" : "진행 중!")
                    .bold()
            }
            .foregroundColor(task.isFinished ? .gray : .green)
            Text(task.name)
                .font(.title)
            Text(task.startDateToEndDateInPrettyFormat)
            Text(task.summary)
            Spacer()
        }
        .foregroundColor(task.isFinished ? .gray : .black)
        .padding(.leading)
    }
}









//struct TaskDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        TaskDetailView()
//    }
//}
