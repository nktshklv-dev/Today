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
    
    func updateSnapshot(reloading idsThatChanged: [Reminder.ID] = []) {
        let ids = idsThatChanged.filter {id in filteredReminders.contains(where: {$0.id == id})}
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(filteredReminders.map{$0.id})
        if !ids.isEmpty {
            snapshot.reloadItems(ids)
        }
        dataSource.apply(snapshot)
        progressHeaderView?.progress = progress
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
        cell.accessories = [.customView(configuration: doneButtonConfiguration), .disclosureIndicator(displayed: .always)]
        var backGroundConfiguration = UIBackgroundConfiguration.listGroupedCell()
        backGroundConfiguration.backgroundColor = UIColor(named: "TodayListCellBackground")
        cell.backgroundConfiguration = backGroundConfiguration
        
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
    
    func completeReminder(with id: Reminder.ID) {
        var reminder = reminder(for: id)
        reminder.isComplete.toggle()
        update(reminder, with: id)
        updateSnapshot(reloading: [id])
    }
    
    func addReminder(_ reminder: Reminder){
        reminders.append(reminder)
    }
    
    func deleteReminder(with id: Reminder.ID){
        let index = reminders.indexOfReminder(with: id)
        reminders.remove(at: index)
    }
    
    
    func reminder(for id: Reminder.ID) -> Reminder {
        let index = reminders.indexOfReminder(with: id)
        return reminders[index]
    }
    
    func update(_ reminder: Reminder, with id: Reminder.ID){
        let index = reminders.indexOfReminder(with: id)
        reminders[index] = reminder
    }
    
    func updateReminder(_ reminder: Reminder) {
        let index = reminders.indexOfReminder(with: reminder.id)
        reminders[index] = reminder
    }
    
     func makeSwipeActions(for indexPath: IndexPath?) -> UISwipeActionsConfiguration?{
        guard let indexPath = indexPath, let id = dataSource.itemIdentifier(for: indexPath) else {
            return nil 
        }
        let deleteActionTitle = NSLocalizedString("Delete", comment: "Delete action title")
        let deleteAction = UIContextualAction(style: .destructive, title: deleteActionTitle) { [weak self] _, _, completion in
            self?.deleteReminder(with: id)
            self?.updateSnapshot()
            completion(false)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
 }
