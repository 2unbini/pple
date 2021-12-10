//
//  ProjectCalendarView.swift
//  i-scheduler
//
//  Created by Kim TaeSoo on 2021/12/07.
//

import SwiftUI

struct ModifyView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var bindingTest: Int
    var body: some View {
        VStack(spacing: 50) {
            Text("Modal view.")
                .font(.largeTitle)
            
            Button(action: {
                presentationMode.wrappedValue.dismiss()
                print(bindingTest)
            }, label: {
                Image(systemName: "xmark.circle")
                
            })
        }
    }
}

var day1 = Date(timeIntervalSinceNow: 1000000)
var day2 = Date()
var test = daysBetween(start: day2, end: day1)

struct ProjectCalendarView: View {
    @Environment(\.managedObjectContext) var context
    @FetchRequest(
      entity: Project.entity(),
      sortDescriptors: [
        NSSortDescriptor(keyPath: \Project.id, ascending: true)
      ]
    ) var project: FetchedResults<Project>
    
    @State var showModifyView: Bool = false
    let dayData: [String] = Array(1...test).map { "Day\n\($0)" }
    @State var bindingTest = test
    
    func addMovie() {
        let newProject = Project(context: context)
        newProject.endDate = Date()
        newProject.startDate = Date(timeIntervalSinceNow: 1000000)
        newProject.id = UUID()
        newProject.isFinished = false
        newProject.name = "project Name1"
        newProject.summary = "nothing wroten"
        saveContext()
    }
    
    func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
    }
    
    var body: some View {
        ScrollView {
            ZStack {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 60))]) {
                    ForEach(dayData, id: \.self) { day in
                        Button {
                            self.showModifyView = !self.showModifyView
                            addMovie()
                            print("--------------------------------------------------")
                            print(project)
                            print("--------------------------------------------------")
                        } label: {
                            ZStack {
                                Image(systemName: "square.fill")
                                    .resizable()
                                    .frame(width: 60, height: 70)
                                    .aspectRatio(0.8, contentMode: .fit)
                                    .foregroundColor(.white)
                                    .shadow(color: .black, radius: 2)
                                Text(day)
                                    .multilineTextAlignment(.center)
                                    .frame(width: 80, height: 80, alignment: .center)
                                    .foregroundColor(.black)
                            }
                        }
                    }.sheet(isPresented: self.$showModifyView) {
                        ModifyView(bindingTest: bindingTest)
                    }
                }
            }
        }
        .padding()
    }
}

func daysBetween(start: Date, end: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: start, to: end).day!
    }

struct ProjectCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectCalendarView()
    }
}
