//
//  ReminderListViewController+DataSource.swift
//  Today
//
//  Created by Nikita  on 1/18/23.
//

import Foundation
import UIKit

extension ReminderListViewController {
    
    typealias DataSource = UICollectionViewDiffableDataSource<Int, Reminder.ID>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Reminder.ID>
    
    func updateSnapshot(reloading ids: [Reminder.ID] = []) {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(reminders.map{$0.id})
        if !ids.isEmpty {
            snapshot.reloadItems(ids)
            
        }
        dataSource.apply(snapshot)
    }
    
    func cellRegistrationHandler(cell: UICollectionViewListCell, indexPath: IndexPath, id: Reminder.ID){
        let reminder = reminder(for: id)
        var cellConfiguration = cell.defaultContentConfiguration()
        cellConfiguration.text = reminder.title
        cellConfiguration.secondaryText = reminder.dueDate.dayAndTimeText
        cellConfiguration.secondaryTextProperties.font = UIFont.preferredFont(forTextStyle: .caption1)
        cell.contentConfiguration = cellConfiguration
        
        var doneButtonConfiguration = doneButtonConfiguration(for: reminder)
        doneButtonConfiguration.tintColor = UIColor(named: "TodayListCellDoneButtonTint")
        cell.accessories = [.customView(configuration: doneButtonConfiguration), .disclosureIndicator(displayed: .always) ]
        var backGroundConfiguration = UIBackgroundConfiguration.listGroupedCell()
        backGroundConfiguration.backgroundColor = UIColor(named: "TodayListCellBackground")
        cell.backgroundConfiguration = backGroundConfiguration
        
    }
    
    func completeReminder(with id: Reminder.ID) {
        var reminder = reminder(for: id)
        reminder.isComplete.toggle()
        update(reminder, with: id)
        updateSnapshot(reloading: [id])
    }
    
    private func doneButtonConfiguration(for reminder: Reminder) -> UICellAccessory.CustomViewConfiguration{
        let symbolName = reminder.isComplete ? "circle.fill" : "circle"
        let symbolConfiguration = UIImage.SymbolConfiguration(textStyle: .title1)
        let image = UIImage(systemName: symbolName, withConfiguration: symbolConfiguration)
        
        let button = ReminderDoneButton()
        button.addTarget(self, action: #selector(didPressDoneButton), for: .touchUpInside)
        button.id = reminder.id
        button.setImage(image, for: .normal)
        return UICellAccessory.CustomViewConfiguration(customView: button, placement: .leading(displayed: .always))
    }
    
    func reminder(for id: Reminder.ID) -> Reminder {
        let index = reminders.indexOfReminder(with: id)
        return reminders[index]
    }
    
    func update(_ reminder: Reminder, with id: Reminder.ID){
        let index = reminders.indexOfReminder(with: id)
        reminders[index] = reminder
    }
 }
