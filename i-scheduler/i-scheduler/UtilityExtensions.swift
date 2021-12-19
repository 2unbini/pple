//
//  UtilityExtensions.swift
//  i-scheduler
//
//  Created by sun on 2021/12/13.
//

import SwiftUI

extension Date {
    var midnight: Date {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        let midnightString = formatter.string(from: self)
        return formatter.date(from: midnightString) ?? self
    }
    
    var tomorrowMidnight: Date {
        var components = DateComponents()
        components.day = 1
        return Calendar.current.date(byAdding: components, to: midnight) ?? midnight
    }
}


// TODO: UIActivityView 와 비슷한 녀석을
// 혹은 Gesture

extension View {
    @ViewBuilder
    func popup<Content>(isPresented: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) -> some View where Content : View {
        if isPresented.wrappedValue == true {
            let popupContent = content()
                .transition(.move(edge: .bottom))
            self.overlay(popupContent)
        } else {
            self
        }
    }
    
    func cardify(size: CGSize) -> some View {
        self.modifier(Cardify(size: size))
    }
}
