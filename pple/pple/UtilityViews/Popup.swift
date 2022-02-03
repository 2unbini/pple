//
//  Popup.swift
//  i-scheduler
//
//  Created by sun on 2022/01/25.
//

import SwiftUI

struct Popup<PopupContent: View>: ViewModifier {
    let item: Int?
    let popupContent: (Int) -> PopupContent
    
    @ViewBuilder
    func body(content: Content) -> some View {
        content
            .overlay(
                item != nil ? popupBody : nil
            )
    }
    private var popupBody: some View {
        ZStack {
            backgroundShadow
            popupContent(item!)
                .offset(x: 0, y: -40)
        }
    }
    
    private var backgroundShadow: some View {
        Color.primary
            .opacity(0.15)
            .ignoresSafeArea()
            .frame(
                width: UIScreen.main.bounds.width,
                height: UIScreen.main.bounds.height * 1.5
            )
    }
}
