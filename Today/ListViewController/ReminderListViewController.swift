//
//  ViewController.swift
//  Today
//
//  Created by Nikita  on 1/13/23.
//

import UIKit

class ReminderListViewController: UICollectionViewController {
    
    var reminders: [Reminder] = Reminder.sampleData
    var dataSource: DataSource!
    var listStyle: ReminderListStyle = .today
    
    var filteredReminders: [Reminder] {
        return reminders.filter { listStyle.shouldInclude(date: $0.dueDate)}.sorted {
            $0.dueDate < $1.dueDate
        }
    }
    
    let listStyleSegmentedControl = UISegmentedControl(items: [ReminderListStyle.today.name, ReminderListStyle.future.name, ReminderListStyle.all.name])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let listLayout = listLayout()
        collectionView.collectionViewLayout = listLayout
        
        let cellRegistration = UICollectionView.CellRegistration(handler: cellRegistrationHandler)
        
        dataSource = DataSource(collectionView: collectionView) { (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: Reminder.ID) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        }
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didPressAddButton(_:)))
        addButton.accessibilityLabel = NSLocalizedString("Add reminder", comment: "Add button accesibility label")
        navigationItem.rightBarButtonItem = addButton
        
        listStyleSegmentedControl.selectedSegmentIndex = listStyle.rawValue
        listStyleSegmentedControl.addTarget(self, action: #selector(didChangeListStyle(_:)), for: .valueChanged)
        navigationItem.titleView = listStyleSegmentedControl
        
        
        if #available(iOS 16, *){
            navigationItem.style = .navigator
        }
       updateSnapshot()
       collectionView.dataSource = dataSource
    }
    
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let id = filteredReminders[indexPath.row].id
        showDetail(for: id)
        return false
    }
    
    func showDetail(for id: Reminder.ID){
        let reminder = reminder(for: id)
        let viewController = ReminderViewController(reminder: reminder) { [weak self] reminder in
            self?.updateReminder(reminder)
            self?.updateSnapshot(reloading: [reminder.id])
        }
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    //creating layout
    private func listLayout() -> UICollectionViewCompositionalLayout{
        
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped)
        listConfiguration.showsSeparators = false
        listConfiguration.backgroundColor = .clear
        listConfiguration.trailingSwipeActionsConfigurationProvider = makeSwipeActions
        return UICollectionViewCompositionalLayout.list(using: listConfiguration)
    }
}

