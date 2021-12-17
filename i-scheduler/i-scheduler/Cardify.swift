//
//  Cardify.swift
//  i-scheduler
//
//  Created by sun on 2021/12/16.
//

import SwiftUI

struct Cardify: ViewModifier {
    var size: CGSize
    func body(content: Content) -> some View {
        content
            .overlay(RoundedRectangle(cornerRadius: 30).stroke(Color.gray.opacity(0.2), lineWidth: 2))
            .shadow(color: Color.gray.opacity(0.4), radius: 4)
            .frame(width: size.width * 0.8, height: size.height * 0.7)
            .cornerRadius(30)
    }
}

