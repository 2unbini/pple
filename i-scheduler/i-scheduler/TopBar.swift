//
//  TopBar.swift
//  i-scheduler
//
//  Created by 권은빈 on 2021/12/08.
//

import SwiftUI

enum Bar {
    case editSheet
    case addSheet
}

enum Subject {
    case project
    case task
}

struct TopBar: View {
    @Environment(\.presentationMode) var presentationMode
    
    var barText: String
    var leftBtnLabel: String
    var rightBtnLabel: String
    var saveData: TestProject
    
    init(bar: Bar, subject: Subject, data: TestProject) {
        var prefix = ""
        
        if subject == .project {
            prefix = "프로젝트 "
        } else if subject == .task {
            prefix = "할 일 "
        }
        
        switch bar {
        case .editSheet:
            self.barText = prefix + "수정"
            self.leftBtnLabel = "닫기"
            self.rightBtnLabel = "저장"
        case .addSheet:
            self.barText = prefix + "생성"
            self.leftBtnLabel = "닫기"
            self.rightBtnLabel = "저장"
        }
        
        self.saveData = data
    }
    
    var body: some View {
        HStack {
            
            Button(leftBtnLabel) {
                print("left button - 닫기")
                presentationMode.wrappedValue.dismiss()
            }
            .padding()

            Spacer()
            Text(barText)
                .font(.system(size: 20))
            Spacer()
            
            Button(rightBtnLabel) {
                print("right button - 저장")
                

                if let i = findEditDataIndex() {
                    testProjects[i].name = saveData.name
                    testProjects[i].summary = saveData.summary
                }
                else {
                    testProjects.append(saveData)
                }
                
                print("save Data: \(saveData)")
                presentationMode.wrappedValue.dismiss()
            }
            .padding()
        }
    }
    
    func findEditDataIndex() -> Int? {
        
        for i in 0..<testProjects.count {
            if testProjects[i].id == saveData.id {
                return i
            }
        }
        
        return nil
    }
}

//
//struct TopBar_Previews: PreviewProvider {
//    static var previews: some View {
//        TopBar(bar: Bar.editSheet, subject: Subject.project)
//    }
//}
