

import Foundation
import UIKit

@IBDesignable
open class TextBoxView: UIView  {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commoninit()
        
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commoninit()
    }
    
    func commoninit() {
        self.layer.borderColor = UIColor.hexStringToUIColor(hex:textBoxBorderColor).cgColor
        self.layer.borderWidth = 1
    }
}


@IBDesignable
open class roundView: UIView {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commoninit()
        
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commoninit()
    }
    
    func commoninit() {
        self.layer.cornerRadius = self.layer.frame.height / 2
        self.layer.masksToBounds = true
        
        
    }
}


@IBDesignable
open class OuterView: UIView {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commoninit()
        
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commoninit()
    }
    
    func commoninit() {
        self.layer.cornerRadius = 3
        
        // border
        self.layer.borderWidth = 1.0
       self.layer.borderColor = UIColor.hexStringToUIColor(hex:textBoxBorderColor).cgColor
        
        // shadow
        self.layer.shadowColor = UIColor.hexStringToUIColor(hex:textBoxBorderColor).cgColor
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 3.0

    }
}

@IBDesignable
open class CollectinShadow: UIView {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commoninit()
        
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commoninit()
    }
    
    func commoninit() {
        self.layer.shadowColor = UIColor.hexStringToUIColor(hex:textBoxBorderColor).cgColor
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 3.0
        
    }
}

@IBDesignable
open class yellowButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        commoninit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commoninit()
    }
    
    override open func prepareForInterfaceBuilder() {
        commoninit()
    }
    
    public func commoninit() {
        self.backgroundColor = UIColor(red:0.98, green:0.62, blue:0.16, alpha:1.0)
        self.layer.shadowColor = UIColor(red:0.52, green:0.52, blue:0.52, alpha:0.21).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 5)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 3.0
        self.layer.cornerRadius = 25.2
    }
}


