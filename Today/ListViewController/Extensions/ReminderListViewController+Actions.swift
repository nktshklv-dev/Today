//
//  ReminderListViewController+Actions.swift
//  Today
//
//  Created by Nikita  on 1/22/23.
//

import Foundation
import UIKit

extension ReminderListViewController {
    
    @objc func didPressDoneButton(_ sender: ReminderDoneButton){
        guard let id = sender.id else {return}
        
        completeReminder(with: id)
                
    }
}
