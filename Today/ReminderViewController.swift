//
//  ReminderViewController.swift
//  Today
//
//  Created by Nikita  on 1/23/23.
//

import Foundation
import UIKit

class ReminderViewController: UICollectionViewController{
    var reminder: Reminder
    
    init(reminder: Reminder) {
        self.reminder = reminder
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        listConfiguration.showsSeparators = false
        let listLayout = UICollectionViewCompositionalLayout.list(using:  listConfiguration)
        super.init(collectionViewLayout: listLayout)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
