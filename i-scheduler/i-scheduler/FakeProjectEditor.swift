//
//  FakeProjectEditor.swift
//  i-scheduler
//
//  Created by sun on 2021/12/08.
//

import SwiftUI

struct FakeProjectEditor: View {
    
//    @FetchRequest var project: FetchedResults<Project>
    @Environment(\.managedObjectContext) var context
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name: String = "foo project"
    @State private var description: String = "summary for foo project"
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
        TextEditor(text: $description)
    }
    
    private var startDateSection: some View {
        DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
    }
    
    private var endDateSection: some View {
        DatePicker("End Date", selection: $endDate, displayedComponents: .date)
    }
    
    private func save() {
        let newProject = Project(context: context)
        newProject.name = name
        newProject.summary = description
        newProject.id = UUID()
        newProject.startDate = startDate
        newProject.endDate = endDate
        newProject.isFinished = isFinished
        
        let newTask = Task(context: context)
        newTask.name = "ask1"
        newTask.summary = "some summary"
        newTask.id = UUID()
        newTask.startDate = startDate
        newTask.endDate = startDate.addingTimeInterval(86400 * 3)
        newTask.isFinished = false
        
//        let newTask2 = Task(context: context)
//        newTask2.name = "task2"
//        newTask2.summary = "some summary"
//        newTask2.id = UUID()
//        newTask2.startDate = startDate.addingTimeInterval(86400)
//        newTask2.endDate = startDate.addingTimeInterval(86400 * 3)
//        newTask2.isFinished = false
//
//        let newTask3 = Task(context: context)
//        newTask3.name = "task3"
//        newTask3.summary = "some summary"
//        newTask3.id = UUID()
//        newTask3.startDate = startDate.addingTimeInterval(86400)
//        newTask3.endDate = startDate.addingTimeInterval(86400 * 3)
//        newTask3.isFinished = false
//
        newProject.allTasks = [newTask] //, newTask2, newTask3]
        
        try? context.save()
        print("save successful")
        print("saved \(newProject.id)")
        
    }
    
}

//struct FakeTaskEditor_Previews: PreviewProvider {
//    static var previews: some View {
//        FakeTaskEditor()
//    }
//}
