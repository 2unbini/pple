//
//  Checkbox.swift
//  i-scheduler
//
//  Created by sun on 2021/12/13.
//

import SwiftUI

struct CheckBox: View {
    @ObservedObject var task: Task
    @State private var showCoreDataAlert = false

    var body: some View {
        Button {
            task.isFinished.toggle()
            let saved = PersistenceController.shared.save(
                errorDescription: "Error in Checkbox"
            )
            saved == true ? nil : showCoreDataAlert.toggle()
        } label: {
            Image(systemName: task.isFinished ? "checkmark.square" : "square")
                .scaleEffect(1.3)
        }
        .buttonStyle(.plain)
        .alert(
            isPresented: $showCoreDataAlert,
            title: "저장 오류",
            message: "저장에 실패했습니다",
            buttonLabel: "확인"
        )
    }
}












//struct Checkbox_Previews: PreviewProvider {
//    static var previews: some View {
//        Checkbox()
//    }
//}
