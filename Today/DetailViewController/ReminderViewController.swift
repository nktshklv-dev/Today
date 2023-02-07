//
//  ReminderViewController.swift
//  Today
//
//  Created by Nikita  on 1/23/23.
//

import Foundation
import UIKit

class ReminderViewController: UICollectionViewController{
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Row>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Row>
    
    var reminder: Reminder {
        didSet{
            onChange(reminder)
        }
    }
    var workingReminder: Reminder
    var onChange: (Reminder) -> Void 
    private var dataSource: DataSource!

    init(reminder: Reminder, onChange: @escaping (Reminder) -> Void) {
        self.reminder = reminder
        self.workingReminder = reminder
        self.onChange = onChange
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        listConfiguration.showsSeparators = false
        listConfiguration.headerMode = .firstItemInSection
        let listLayout = UICollectionViewCompositionalLayout.list(using:  listConfiguration)
        super.init(collectionViewLayout: listLayout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cellRegistration = UICollectionView.CellRegistration(handler: cellRegistrationHandler)
        dataSource = DataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
            
        })
        
        if #available(iOS 16, *){
            navigationItem.style = .navigator
        }
        navigationItem.title = NSLocalizedString("Reminder", comment: "Reminder ViewController title ")
        navigationItem.rightBarButtonItem = editButtonItem
        updateSnapshotForViewing()
        
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if editing{
            preparForEditing()
        }
        else {
            prepareForViewing()
        }
    }
    
    @objc func didCancelEdit(){
        workingReminder = reminder
        setEditing(false, animated: true)
    }
    
    func cellRegistrationHandler(cell: UICollectionViewListCell, indexPath: IndexPath, row: Row){
        let section = section(for: indexPath)
        switch (section, row) {
        case (_, .header(let title)):
            cell.contentConfiguration = headerConfiguration(for: cell, with: title)
        case (.view, _):
            cell.contentConfiguration = defaultConfiguration(for: cell, at: row)
        case (.title, .editableText(let title)):
            cell.contentConfiguration = titleConfiguration(for: cell, with: title)
        case (.notes, .editableText(let notes)):
            cell.contentConfiguration = notesConfiguration(for: cell, with: notes)
        case(.date, .editableDate(let date)):
            cell.contentConfiguration = dateConfiguration(for: cell, with: date)
        default:
            fatalError("Unexpected combination of section and row")
        }
        
        cell.tintColor = UIColor(named: "todayPrimaryTint")
    }
    private func preparForEditing(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didCancelEdit))
        updateSnapshotForEditing()
    }
    private func updateSnapshotForEditing(){
        var snapshot = Snapshot()
        snapshot.appendSections([Section.title, Section.date, Section.notes])
        snapshot.appendItems([.header(Section.title.name), .editableText(reminder.title)], toSection: .title)
        snapshot.appendItems([.header(Section.date.name), .editableDate(reminder.dueDate)], toSection: .date)
        snapshot.appendItems([.header(Section.notes.name), .editableText(reminder.notes ?? "")], toSection: .notes)
        
        dataSource.apply(snapshot)
    }
    
    private func prepareForViewing() {
        navigationItem.leftBarButtonItem = nil
        if workingReminder != reminder{
            reminder = workingReminder
        }
        updateSnapshotForViewing()
    }
    private func updateSnapshotForViewing() {
        var snapshot = Snapshot()
        snapshot.appendSections([Section.view])
        snapshot.appendItems([Row.header("") ,Row.viewTitle, Row.viewDate, Row.viewTime, Row.viewNotes], toSection: Section.view)
        dataSource.apply(snapshot)
    }

    private func section(for indexPath: IndexPath) -> Section {
        let sectionNumber = isEditing ? indexPath.section + 1 : indexPath.section
        guard let section = Section(rawValue: sectionNumber) else {
            fatalError("Unable to find matching section.")
        }
        return section
    }
}
