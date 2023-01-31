//
//  TextViewContentView .swift
//  Today
//
//  Created by Nikita  on 1/31/23.
//

import Foundation
import UIKit
class TextViewContentView: UIView, UIContentView{
    struct Configuration: UIContentConfiguration{
        var text: String? = ""
        func makeContentView() -> UIView & UIContentView {
            return TextViewContentView(self)
        }
    }
    var textView = UITextView()
    var configuration: UIContentConfiguration {
        didSet{
            configure(configuration: configuration)
        }
    }
    
    init(_ configuration: UIContentConfiguration){
        self.configuration = configuration
        super.init(frame: .zero)
        addPinnedSubview(textView, height: 200,  insets: UIEdgeInsets(top: 0,left: 16, bottom: 0, right: 16))
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.backgroundColor = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(configuration: UIContentConfiguration) {
        guard let configuration = configuration as? Configuration else {return}
        textView.text = configuration.text
    }
    
}
extension UICollectionViewListCell{
    func textViewConfiguration() -> TextViewContentView.Configuration{
        return TextViewContentView.Configuration()
    }
}
