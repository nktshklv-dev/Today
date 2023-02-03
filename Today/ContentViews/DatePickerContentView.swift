//
//  DatePickerContentView.swift
//  Today
//
//  Created by Nikita  on 1/31/23.
//

import Foundation
import UIKit

class DatePickerContentView: UIView, UIContentView {
    struct Configuration: UIContentConfiguration{
        var date = Date.now
        var onChange: (Date) -> Void = { _ in }
        func makeContentView() -> UIView & UIContentView {
            return DatePickerContentView(self)
        }
    }
    var datePicker = UIDatePicker()
    var configuration: UIContentConfiguration {
        didSet{
            configure(configuration: configuration)
        }
    }
    
    init(_ configuration: UIContentConfiguration){
        self.configuration = configuration
        super.init(frame: .zero)
        addPinnedSubview(datePicker)
        datePicker.preferredDatePickerStyle = .inline
        datePicker.addTarget(self, action: #selector(didChange(_:)), for: .valueChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(configuration: UIContentConfiguration) {
        guard let configuration = configuration as? Configuration else {return}
        datePicker.date = configuration.date
    }
    
    @objc private func didChange(_ sender: UIDatePicker) -> Void{
        guard let configuration = configuration as? DatePickerContentView.Configuration else {return}
        configuration.onChange(sender.date)
    }
}
extension UICollectionViewListCell{
    func dateViewConfiguration() -> DatePickerContentView.Configuration {
        return DatePickerContentView.Configuration()
    }
}
