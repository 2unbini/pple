//
//  TaskDetailView.swift
//  i-scheduler
//
//  Created by sun on 2021/12/08.
//

import SwiftUI

struct TaskDetailView: View {
    var task: Task
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(task.isFinished ? "진행 상태 : 완료!" : "진행 상태 : 진행 중!")
                    .foregroundColor(.green)
                    .bold()
                Text(task.name!)
                    .font(.largeTitle)
                Text(task.startToEnd)
                Text("")
                Text(task.summary!)
                Spacer()
            }
            .padding(.leading)
            Spacer()
        }
        .padding(.horizontal)
        .toolbar {
            // functioning not implemetened yet
            Button("Edit") { print("edit") }
        }
    }
}









//struct TaskDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        TaskDetailView()
//    }
//}
