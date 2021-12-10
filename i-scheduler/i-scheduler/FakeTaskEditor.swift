//
//  FakeTaskEditor.swift
//  i-scheduler
//
//  Created by sun on 2021/12/08.
//

import SwiftUI

struct FakeTaskEditor: View {
    
//    @FetchRequest var project: FetchedResults<Project>
    @Environment(\.managedObjectContext) var context
    @Environment(\.presentationMode) var presentationMode
    var projectId: UUID
    
    
    @State private var name: String = "task"
    @State private var summary: String = "summary for foo task summary for foo task summary for foo task summary for foo task summary for foo task summary for foo task summary for foo task summary for foo task"
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    @State private var isFinished = false

    var body: some View {
        NavigationView {
        Form {
            nameSection
            descriptionSection
            startDateSection
            endDateSection
            Toggle("Finished?", isOn: $isFinished)
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    save()
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
        }
    }
    
    private var nameSection: some View {
        TextField("Name", text: $name)
    }
    
    private var descriptionSection: some View {
        TextEditor(text: $summary)
    }
    
    private var startDateSection: some View {
        DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
    }
    
    private var endDateSection: some View {
        DatePicker("End Date", selection: $endDate, displayedComponents: .date)
    }
    
    private func save() {
        let newTask = Task(context: context)
        newTask.name = name
        newTask.summary = summary
        newTask.id = UUID()
        newTask.startDate = startDate.addingTimeInterval(86400)
        newTask.endDate = startDate.addingTimeInterval(86400 * 3)
        newTask.isFinished = false
        newTask.project = Project.withId(projectId, context: context)
        newTask.objectWillChange.send()
        newTask.project?.objectWillChange.send()
        try? context.save()
        print("save successful")
        print("saved: \(newTask.name)")
    }
}

//struct FakeTaskEditor_Previews: PreviewProvider {
//    static var previews: some View {
//        FakeTaskEditor()
//    }
//}


