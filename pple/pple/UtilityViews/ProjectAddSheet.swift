//
//  ProjectAddSheet.swift
//  i-scheduler
//
//  Created by 권은빈 on 2021/12/08.
//

import SwiftUI
import CoreData

struct ProjectAddSheet: View {
    @Environment(\.managedObjectContext) private var viewContext: NSManagedObjectContext
    @State private var projectDataHolder: DataHolder = DataHolder()
    
    private var prefix: String = "프로젝트"

    var body: some View {
        VStack {
            ProjectToolBar(.add, project: nil, with: projectDataHolder)
            Form {
                Section(content: {
                    TextField("", text: $projectDataHolder.name)
                }, header: {
                    Text("\(prefix) 이름")
                })
                
                Section(content: {
                    TextEditor(text: $projectDataHolder.summary)
                        .modifier(TextEditorModifier())
                }, header: {
                    Text("\(prefix) 설명")
                })
                
                Section(content: {
                    DatePicker("시작 날짜", selection: $projectDataHolder.startDate, displayedComponents: .date)
                    DatePicker("종료 날짜", selection: $projectDataHolder.endDate,
                               in: PartialRangeFrom(projectDataHolder.startDate), displayedComponents: .date)
                }, header: {
                    Text("\(prefix) 기간")
                })
            }
        }
    }
}
