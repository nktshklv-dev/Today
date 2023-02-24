//
//  TodayError.swift
//  Today
//
//  Created by Nikita  on 2/24/23.
//

import Foundation

enum TodayError: LocalizedError{
    
     case failedReadingReminders
     case reminderHasNoDueDate
     case accessDenied
    
    
    var errorDescription: String? {
        switch self {
        case .failedReadingReminders:
            return NSLocalizedString("Failed to read reminders.", comment: "failed reading reminders error description")
        case .reminderHasNoDueDate:
            return NSLocalizedString("A reminder has no due date.", comment: "reminder has no due date error description")
        case .accessDenied:
           return NSLocalizedString("The app doesn't have permission to read reminders.", comment: "access denied error description")
        }
    }
}
