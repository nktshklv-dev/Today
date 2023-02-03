//
//  TextFieldContentView.swift
//  Today
//
//  Created by Nikita  on 1/31/23.
//

import Foundation
import UIKit

class TextFieldContentView: UIView, UIContentView{
    struct Configuration: UIContentConfiguration {
        var text: String? = ""
        var onChange: (String) -> Void = { _ in }
        
        func makeContentView() -> UIView & UIContentView {
            return TextFieldContentView(self)
        }
    }
    
    let textField = UITextField()
    var configuration: UIContentConfiguration {
        didSet {
            configure(configuration: configuration)
        }
    }
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: 0, height: 44)
    }
    
    init(_ configuration: UIContentConfiguration){
        self.configuration = configuration
        super.init(frame: .zero)
        textField.addTarget(self, action: #selector(didChange(_:)), for: .editingChanged)
        addPinnedSubview(textField, insets: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
        textField.clearButtonMode = .whileEditing
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(configuration: UIContentConfiguration) {
        guard let configuration = configuration as? Configuration else {return}
        textField.text = configuration.text
    }
    
    @objc private func didChange(_ sender: UITextField){
        guard let configuration = configuration as? TextFieldContentView.Configuration else {return}
        configuration.onChange(textField.text ?? "")
    }
}
extension UICollectionViewListCell{
    func textFieldConfiguration() -> TextFieldContentView.Configuration{
        return TextFieldContentView.Configuration()
    }
}
