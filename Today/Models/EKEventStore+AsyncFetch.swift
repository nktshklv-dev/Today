//
//  EKEventStore+AsyncFetch.swift
//  Today
//
//  Created by Nikita  on 2/24/23.
//

import Foundation
import EventKit

extension EKEventStore{
    func reminders(matching predicate: NSPredicate) async throws -> [EKReminder] {
        try await withCheckedThrowingContinuation { continuation in
            fetchReminders(matching: predicate) { reminders in
                if let reminders {
                    continuation.resume(returning: reminders)
                }
                else {
                    continuation.resume(throwing: TodayError.failedReadingReminders)
                }
            }
        }
    }
 }
