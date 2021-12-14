//
//  Popup.swift
//  i-scheduler
//
//  Created by sun on 2021/12/07.
//

import SwiftUI

struct PopUpTaskList: ViewModifier {
    @Binding var isPresented: Bool
    var date: Date
    var projectId: UUID
    var size: CGSize
    
    func body(content: Content) -> some View {
        content
            .overlay(isPresented ? popupContent() : nil)
    }
        
    private func popupContent() -> some View {
        TaskList(isPresented: $isPresented, projectId: projectId, date: date)
            .clipShape(RoundedRectangle(cornerRadius: 30))
            .overlay(RoundedRectangle(cornerRadius: 30).stroke(Color.gray.opacity(0.2), lineWidth: 1))
            .shadow(color: Color.gray.opacity(0.4), radius: 4)
            .frame(width: size.width * 0.8, height: size.height * 0.75)
            .transition(.move(edge: .bottom))
    }
}

extension View {
    func popUpTaskList(isPresented: Binding<Bool>, date: Date, projectId: UUID, size: CGSize) -> some View {
        self.modifier(PopUpTaskList(isPresented: isPresented, date: date, projectId: projectId, size: size))
    }
}
















//struct Popup_Previews: PreviewProvider {
//    static var previews: some View {
//        Popup()
//    }
//}
