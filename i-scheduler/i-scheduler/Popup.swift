//
//  Popup.swift
//  i-scheduler
//
//  Created by sun on 2021/12/07.
//

import SwiftUI

struct Popup: ViewModifier {
    @Binding var isPresented: Bool
    @Environment(\.managedObjectContext) var context
    var projectId: UUID
    var size: CGSize
    var date: Date

    
    func body(content: Content) -> some View {
        content
            .overlay(isPresented ? popupContent() : nil)
    }
    
    private func popupContent() -> some View {
        ZStack {
            withAnimation {
                DailyTaskList(isPresented: $isPresented, projectId: projectId, date: date)
                    .clipShape(RoundedRectangle(cornerRadius: 30))
                    .overlay(RoundedRectangle(cornerRadius: 30).stroke(Color.gray.opacity(0.2), lineWidth: 1))
                    .shadow(color: Color.gray.opacity(0.4), radius: 4)
                    .environment(\.managedObjectContext, context)
            }
        }
        .frame(width: size.width * 0.8, height: size.height * 0.75)
        .transition(.move(edge: .bottom))
    }
}



extension View {
    func popup(isPresented: Binding<Bool>, projectId: UUID, size: CGSize, date: Date) -> some View {
        self.modifier(Popup(isPresented: isPresented, projectId: projectId, size: size, date: date))

    }
}
















//struct Popup_Previews: PreviewProvider {
//    static var previews: some View {
//        Popup()
//    }
//}
