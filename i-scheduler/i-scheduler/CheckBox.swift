//
//  Checkbox.swift
//  i-scheduler
//
//  Created by sun on 2021/12/13.
//

import SwiftUI

struct CheckBox: View {
    @Environment(\.managedObjectContext) var context
    @ObservedObject var task: Task

    var body: some View {
        Button {
            task.isFinished.toggle()
            PersistenceController.shared.save(
                errorDescription: "Error in Checkbox"
            )
        } label: {
            Image(systemName: task.isFinished ? "checkmark.square" : "square")
                .scaleEffect(1.3)
        }
        .buttonStyle(.plain)
    }
}












//struct Checkbox_Previews: PreviewProvider {
//    static var previews: some View {
//        Checkbox()
//    }
//}
