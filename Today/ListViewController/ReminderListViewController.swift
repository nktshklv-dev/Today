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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let listLayout = listLayout()
        collectionView.collectionViewLayout = listLayout
        
        let cellRegistration = UICollectionView.CellRegistration(handler: cellRegistrationHandler)
        
        dataSource = DataSource(collectionView: collectionView) { (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: Reminder.ID) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        }
        
       updateSnapshot()
        
        collectionView.dataSource = dataSource
    }
    
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let id = reminders[indexPath.row].id
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
        return UICollectionViewCompositionalLayout.list(using: listConfiguration)
    }
}

