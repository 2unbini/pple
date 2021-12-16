//
//  TemporaryModel.swift
//  i-scheduler
//
//  Created by 권은빈 on 2021/12/14.
//

import Foundation

// ProjectList에서 첫번째 sheet 업데이트되지 않는 것 -> @State 버그
// 해결하기 위해 ObservableObject 사용

class TempData: ObservableObject {
        var id: UUID = UUID()
        @Published var name: String = ""
        @Published var summary: String = ""
        @Published var startDate: Date = Date()
        @Published var endDate: Date = Date(timeInterval: 60 * 60 * 24, since: Date())
        @Published var isFinished: Bool = false
}
