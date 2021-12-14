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
            // maybe take this to the extension
            // make sth like func publish and put it in all the computed properties
            task.isFinished.toggle()
//          replace this with
//          PersistenceController.shared.saveContext()
            save()
        } label: {
            Image(systemName: task.isFinished ? "checkmark.square" : "square")
                .scaleEffect(1.3)
        }
        .buttonStyle(.plain)
    }
    
    private func save() {
        do {
            try context.save()
        } catch(let error) {
            print("태스크 저장에 실패했습니다: \(error.localizedDescription)")
        }
    }
}












//struct Checkbox_Previews: PreviewProvider {
//    static var previews: some View {
//        Checkbox()
//    }
//}
