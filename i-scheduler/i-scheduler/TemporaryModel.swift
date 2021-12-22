//
//  TemporaryModel.swift
//  i-scheduler
//
//  Created by 권은빈 on 2021/12/14.
//

import Foundation

class TempData: ObservableObject {
    @Published var name: String = ""
    @Published var summary: String = ""
    @Published var startDate: Date = Date()
    @Published var endDate: Date = Date(timeInterval: 60 * 60 * 24, since: Date())
    @Published var isFinished: Bool = false
}
