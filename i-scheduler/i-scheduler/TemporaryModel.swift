//
//  TemporaryModel.swift
//  i-scheduler
//
//  Created by 권은빈 on 2021/12/14.
//

import Foundation

//Edit시 계속 init 되는 현상때문에 사용X
//class TempData: ObservableObject {
//    @Published var name: String = ""
//    @Published var summary: String = ""
//    @Published var startDate: Date = Date()
//    @Published var endDate: Date = Date(timeInterval: 60 * 60 * 24, since: Date())
//    @Published var isFinished: Bool = false
//
//    func setSpecificProject(with project: Project) {
//        self.name = project.name
//        self.summary = project.summary
//        self.startDate = project.startDate
//        self.endDate = project.endDate
//        self.isFinished = project.isFinished
//    }
//
//    func setSpecificTask(with task: Task) {
//        self.name = task.name
//        self.summary = task.summary
//        self.startDate = task.startDate
//        self.endDate = task.endDate
//        self.isFinished = task.isFinished
//    }
//
//    func setSpecificDate(with startDate: Date, _ endDate: Date) {
//        self.startDate = startDate
//        self.endDate = endDate
//    }
//}

struct TempData {
    var name: String
    var summary: String
    var startDate: Date
    var endDate: Date
    var isFinished: Bool = false
    
    init() {
        self.name = ""
        self.summary = ""
        self.startDate = Date()
        self.endDate = Date(timeInterval: 60 * 60 * 24, since: Date())
        self.isFinished = false
    }
    
    mutating func setSpecificProject(with project: Project) {
            self.name = project.name
            self.summary = project.summary
            self.startDate = project.startDate
            self.endDate = project.endDate
            self.isFinished = project.isFinished
        }
    
    mutating func setSpecificTask(with task: Task) {
            self.name = task.name
            self.summary = task.summary
            self.startDate = task.startDate
            self.endDate = task.endDate
            self.isFinished = task.isFinished
        }
    
    mutating func setSpecificDate(with startDate: Date, _ endDate: Date) {
            self.startDate = startDate
            self.endDate = endDate
        }
}
