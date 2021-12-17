//
//  Cardify.swift
//  i-scheduler
//
//  Created by sun on 2021/12/16.
//

import SwiftUI

// TODO: 위치 위로 더 올리기

struct Cardify: ViewModifier {
    var size: CGSize
    func body(content: Content) -> some View {
        content
            .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.gray.opacity(0.2), lineWidth: 2))
            .cornerRadius(15)
            .shadow(color: Color.gray.opacity(0.4), radius: 4)
            .frame(width: size.width * 0.8, height: size.height * 0.7)
    }
}

