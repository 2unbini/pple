//
//  ProjectEditSheet.swift
//  i-scheduler
//
//  Created by 권은빈 on 2021/12/08.
//

import SwiftUI
import CoreData

struct ProjectEditSheet: View {
    @Environment(\.managedObjectContext) private var viewContext: NSManagedObjectContext
    @State private var projectDataHolder: DataHolder = DataHolder()
    
    private var prefix: String = "프로젝트"
    private var project: Project
    
    init(editWith selectedProject: Project) {
        self.project = selectedProject
    }
    
    var body: some View {
        VStack {
            ProjectToolBar(.edit, project: project, with: projectDataHolder)
            Form {
                Section(content: {
                    VStack{
                        TextField("", text: $projectDataHolder.name)
                    }
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
                
                Section(content: {
                    Toggle("\(prefix) 완료", isOn: $projectDataHolder.isFinished)
                        .toggleStyle(.switch)
                }, header: {
                    Text("\(prefix) 완료")
                })
            }
        }
        .onAppear {
            self.projectDataHolder.setSpecificProject(with: project)
        }
    }
}

struct TextEditorModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color.clear)
            .foregroundColor(Color.primary)
            .font(.body)
            .lineSpacing(5)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 100, maxHeight: 100, alignment: .center)
    }
}
