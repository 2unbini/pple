//
//  UtilityExtensions.swift
//  i-scheduler
//
//  Created by sun on 2021/12/13.
//

import SwiftUI

extension Date {
    /// Returns a Tuple of two Dates where each represents the startDate and endDate
    /// predicates to be used when creating a fetch request to fetch projects/tasks to be
    /// done on this Date from Core Data
    ///
    /// To fetch all existing tasks on the given Date,  the predicates for startDate and
    /// EndDate must be `startDate < mm/dd/yy 00:00:00 + 1 day` AND
    /// `endDate >= mm/dd/yy 00:00:00`
    /// - e.g. if the given Date is Jan 1, 2000 predicate for
    ///     - startDate needs to be Jan 2, 2000, 00:00:00
    ///     - endDate needs to be Jan 1, 2000, 00:00:00
    /// - To get these predicates, this method calculates the date of the given Date's
    ///   next day, converts each of the two Dates into a String and converts them back
    ///   to Date
    /// - `DateComponents` are used to get the next day's date because everyday
    ///   is not 24 hours due to issues like summer time etc.
    /// - then `DateFormatter` is used to convert Date into String in `mm/dd/yy`
    ///   format (without time) and then back to Date again which then results in
    ///   `mm/dd/yy 00:00:00`
    ///
    /// - Returns: `Tuple` of two `Dates` named `start` and `end` where
    ///   each repsents the Date to be used as predicates for StartDate and EndDate
    func modifiedForPredicates() -> (start: Date, end: Date) {
        var components = DateComponents()
        components.day = 1
        let tomorrow = Calendar.current.date(byAdding: components, to: self)
        
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        
        let startDateString = formatter.string(from: tomorrow ?? Date())
        let endDateString = formatter.string(from: self)
        
        let startDate = formatter.date(from: startDateString) ?? Date()
        let endDate = formatter.date(from: endDateString) ?? Date()
        
        return (startDate, endDate)
    }
}


extension View {
    func popup<Content>(isPresented: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) -> some View where Content : View {
        let popupContent = content()
            .transition(.move(edge: .bottom))
        return self.overlay(isPresented.wrappedValue ? popupContent : nil)
    }
    
    func cardify(size: CGSize) -> some View {
        self.modifier(Cardify(size: size))
    }
}
