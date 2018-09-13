//
//  Extension.swift
//  Wondate
//
//  Created by a on 3/27/18.
//  Copyright © 2018 YoungBrainz Infotech. All rights reserved.
//
//EBEBEB
import Foundation
import UIKit


enum borderType {
    case TimeLine
    case TimeLineFilter
}

extension UIApplication {
    var statusBarView: UIView? {
        if responds(to: Selector(("statusBar"))) {
            return value(forKey: "statusBar") as? UIView
        }
        return nil
    }
    
    var appdel : AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func gettopMostViewController() -> UIViewController? {
        return        self.keyWindow?.rootViewController?.findtopViewController()
    }
    
    func getrootViewControler() -> MainTabbarController {
        guard  let rootController = self.keyWindow?.rootViewController as? MainTabbarController else {
             preconditionFailure("there must be MainTabr Controller as Set")
            
        }
        return rootController
    }
}

enum AppStoryboard : String {
    
    case Main,TimeLine,Account,Dating,Partners
    
    var instance : UIStoryboard {
        
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    
    func viewController<T : UIViewController>(viewControllerClass : T.Type, function : String = #function, line : Int = #line, file : String = #file) -> T {
        
        let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID
        
        guard let scene = instance.instantiateViewController(withIdentifier: storyboardID) as? T else {
            
            fatalError("ViewController with identifier \(storyboardID), not found in \(self.rawValue) Storyboard.\nFile : \(file) \nLine Number : \(line) \nFunction : \(function)")
        }
        
        return scene
    }
    
    func initialViewController() -> UIViewController? {
        
        return instance.instantiateInitialViewController()
    }
}

extension UIViewController {
    
    // Not using static as it wont be possible to override to provide custom storyboardID then
    class var storyboardID : String {
        
        return "\(self)"
    }
    
    static func instantiate(fromAppStoryboard appStoryboard: AppStoryboard) -> Self {
        
        return appStoryboard.viewController(viewControllerClass: self)
    }
    
    
    func presentAlerterror(title:String,message:String, okclick:(()->())?) {
        let AlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            if okclick != nil {
                    okclick!()
            }
        }
        AlertController.addAction(okAction)
        self.present(AlertController, animated: true) {
            
        }
    }
    
    func findtopViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return findtopViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return findtopViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return findtopViewController(controller: presented)
        }
        return controller
    }
}






//}

extension NSLayoutConstraint {
    
    @IBInspectable var preciseConstant: CGFloat {
        get {
            return constant * UIScreen.main.scale
        }
        set {
            
            constant =  (newValue * UIScreen.main.bounds.size.height)  / 736
            //print(constant)
        }
    }
    
    
    @IBInspectable var preciseWidthConstant: CGFloat {
        get {
            return constant * UIScreen.main.scale
        }
        set {
            
            constant =  (newValue * UIScreen.main.bounds.size.width)  / 414
            
        }
    }
    
    
}


extension NSMutableAttributedString {
    
    public func setAsLink(textToFind:String, linkURL:String)  {
        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            self.addAttribute(NSAttributedStringKey.link, value: URL(string: linkURL)!, range: foundRange)
        }
    }
}



extension UIColor {
  class  func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}



//MARK:- add border to View
extension UIView {
    func addTopBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
    
    func addRightBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: self.frame.size.width - width, y: 0, width: width, height: self.frame.size.height)
        self.layer.addSublayer(border)
    }
    
    func addBottomBorderWithColor(color: UIColor, width: CGFloat,_ type:borderType) -> CALayer {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        if type == .TimeLine {
            border.frame = CGRect(x: 0 , y: self.frame.size.height - width, width: self.frame.size.width + 10 , height: width)
        }
        else {
            border.frame = CGRect(x: 0 , y: self.frame.size.height - width, width: self.frame.size.width , height: width)

        }
        self.layer.addSublayer(border)
        return border
    }
    
    func addLeftBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
        self.layer.addSublayer(border)
    }
}



extension UIView {
    
    func topBottomRadius() {
        let path = UIBezierPath(roundedRect:self.bounds,
                                byRoundingCorners:[.topRight, .bottomRight],
                                cornerRadii: CGSize(width: 5, height:  5))
        
        let maskLayer = CAShapeLayer()
        maskLayer.shadowColor = UIColor.hexStringToUIColor(hex:textBoxBorderColor).cgColor
        maskLayer.path = path.cgPath
        maskLayer.masksToBounds = false
        maskLayer.shadowOpacity = 1
        maskLayer.shadowOffset = CGSize(width: 1,height: 1)
        self.layer.mask = maskLayer
    }
    
    
    func onleyShadow() {
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
    
    
    public func maskCircle() {
        self.contentMode = UIViewContentMode.scaleAspectFill
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = false
        self.clipsToBounds = true
    }
    
    
    public func applyBorder() {
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.hexStringToUIColor(hex:textBoxBorderColor).cgColor
        self.layer.shadowColor = UIColor.hexStringToUIColor(hex:textBoxBorderColor).cgColor
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 3
        self.layer.masksToBounds = false
        self.clipsToBounds = true
    }
    
    
    public func removeGradiantView() {
        self.layer.sublayers?.forEach {
            if $0 is CAGradientLayer {
                $0.removeFromSuperlayer()
            }
        }
    }
    
    
    public func ApplyGradiantView() {
        let gradientLayer:CAGradientLayer = CAGradientLayer()
        gradientLayer.frame.size = self.frame.size
        gradientLayer.colors = [UIColor(red:0.89, green:0.12, blue:0.30, alpha:1.0).cgColor,UIColor(red:0.89, green:0.61, blue:0.67, alpha:1.0).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.cornerRadius = 5.0
        self.layer.insertSublayer(gradientLayer, at: 0)
        shadow()
        
       // self.layoutSubviews()
    }
    
    
    public func ApplyGradiantViewWithAlpha() {
        let gradientLayer:CAGradientLayer = CAGradientLayer()
        gradientLayer.frame.size = self.frame.size
        gradientLayer.colors = [UIColor(red:0.89, green:0.12, blue:0.30, alpha:0.2).cgColor,UIColor(red:0.82, green:0.52, blue:0.59, alpha:0.2).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        self.layer.insertSublayer(gradientLayer, at: 0)
       // shadow()
        
        
        
        // self.layoutSubviews()
    }
    
    func shadow() {
        //    func applyshadow() {
                self.layer.shadowColor = UIColor(red:0.52, green:0.52, blue:0.52, alpha:0.21).cgColor
                self.layer.shadowOffset = CGSize(width: 6, height: 6)
                self.layer.shadowOpacity = 1.0
                self.layer.shadowRadius = 3.0
                self.layer.cornerRadius = 5.0
                self.layer.shadowRadius = 5.0
        //
        //    }
    }
    
    
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}


public enum SwapRootVCAnimationType {
    case push
    case pop
    case present
    case dismiss
}


extension UIWindow {
    public func swapRootViewControllerWithAnimation(newViewController:UIViewController, animationType:SwapRootVCAnimationType, completion: (() -> ())? = nil)
    {
        guard let currentViewController = rootViewController else {
            return
        }
        
        let width = currentViewController.view.frame.size.width;
        let height = currentViewController.view.frame.size.height;
        
        var newVCStartAnimationFrame: CGRect?
        var currentVCEndAnimationFrame:CGRect?
        
        var newVCAnimated = true
        
        switch animationType
        {
        case .push:
            newVCStartAnimationFrame = CGRect(x: width, y: 0, width: width, height: height)
            currentVCEndAnimationFrame = CGRect(x: 0 - width/4, y: 0, width: width, height: height)
        case .pop:
            currentVCEndAnimationFrame = CGRect(x: width, y: 0, width: width, height: height)
            newVCStartAnimationFrame = CGRect(x: 0 - width/4, y: 0, width: width, height: height)
            newVCAnimated = false
        case .present:
            newVCStartAnimationFrame = CGRect(x: 0, y: height, width: width, height: height)
        case .dismiss:
            currentVCEndAnimationFrame = CGRect(x: 0, y: height, width: width, height: height)
            newVCAnimated = false
        }
        
        newViewController.view.frame = newVCStartAnimationFrame ?? CGRect(x: 0, y: 0, width: width, height: height)
        
        addSubview(newViewController.view)
        
        if !newVCAnimated {
            bringSubview(toFront: currentViewController.view)
        }
        
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut], animations: {
            if let currentVCEndAnimationFrame = currentVCEndAnimationFrame {
                currentViewController.view.frame = currentVCEndAnimationFrame
            }
            
            newViewController.view.frame = CGRect(x: 0, y: 0, width: width, height: height)
        }, completion: { finish in
            self.rootViewController = newViewController
            completion?()
            
        })
        self.makeKeyAndVisible()
       
}
}

public extension UIDevice {
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
        case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
        case "iPhone10,3", "iPhone10,6":                return "iPhone X"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad6,11", "iPad6,12":                    return "iPad 5"
        case "iPad7,5", "iPad7,6":                      return "iPad 6"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,3", "iPad6,4":                      return "iPad Pro 9.7 Inch"
        case "iPad6,7", "iPad6,8":                      return "iPad Pro 12.9 Inch"
        case "iPad7,1", "iPad7,2":                      return "iPad Pro 12.9 Inch 2. Generation"
        case "iPad7,3", "iPad7,4":                      return "iPad Pro 10.5 Inch"
        case "AppleTV5,3":                              return "Apple TV"
        case "AppleTV6,2":                              return "Apple TV 4K"
        case "AudioAccessory1,1":                       return "HomePod"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
}



extension UITextView: UITextViewDelegate {
    
    /// Resize the placeholder when the UITextView bounds change
    override open var bounds: CGRect {
        didSet {
            self.resizePlaceholder()
        }
    }
    
    /// The UITextView placeholder text
    public var placeholder: String? {
        get {
            var placeholderText: String?
            
            if let placeholderLabel = self.viewWithTag(100) as? UILabel {
                placeholderText = placeholderLabel.text
            }
            
            return placeholderText
        }
        set {
            if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
                placeholderLabel.text = newValue
                placeholderLabel.sizeToFit()
            } else {
                self.addPlaceholder(newValue!)
            }
        }
    }
    
    /// When the UITextView did change, show or hide the label based on if the UITextView is empty or not
    ///
    /// - Parameter textView: The UITextView that got updated
    public func textViewDidChange(_ textView: UITextView) {
        if let placeholderLabel = self.viewWithTag(100) as? UILabel {
            placeholderLabel.isHidden = self.text.count > 0
        }
    }
    
    /// Resize the placeholder UILabel to make sure it's in the same position as the UITextView text
    private func resizePlaceholder() {
        if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
            let labelX = self.textContainer.lineFragmentPadding
            let labelY = self.textContainerInset.top - 2
            let labelWidth = self.frame.width - (labelX * 2)
            let labelHeight = placeholderLabel.frame.height
            placeholderLabel.frame = CGRect(x: labelX, y: labelY, width: labelWidth, height: labelHeight)
        }
    }
    
    /// Adds a placeholder UILabel to this UITextView
    private func addPlaceholder(_ placeholderText: String) {
        let placeholderLabel = UILabel()
        placeholderLabel.text = placeholderText
        placeholderLabel.sizeToFit()
        placeholderLabel.font = self.font
        placeholderLabel.textColor = UIColor(red:0.33, green:0.33, blue:0.35, alpha:1.0)
        placeholderLabel.tag = 100
        placeholderLabel.isHidden = self.text.count > 0
        self.addSubview(placeholderLabel)
        self.resizePlaceholder()
        self.delegate = self
    }
    
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}


extension OperationQueue {
    
    /// Creates a debounced function that delays invoking `action` until after `delay` seconds have elapsed since the last time the debounced function was invoked.
    ///
    /// - Parameters:
    ///   - delay: The number of seconds to delay.
    ///   - underlyingQueue: An optional background queue to run the function
    ///   - action: The function to debounce.
    /// - Returns: Returns the new debounced function.
    open class func debounce(delay: TimeInterval, underlyingQueue: DispatchQueue? = nil, action: @escaping () -> Void) -> (() -> Void) {
        // Init a new serial queue
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        queue.underlyingQueue = underlyingQueue
        
        let sleepOpName = "__SleepOp"   // Sleep operation name
        let actionOpName = "__ActionOp" // Action operation name
        
        
        return {
            // Check if the first not cancelled or finished operation is executing
            var isExecuting = false
            for op in queue.operations {
                if op.isFinished || op.isCancelled {
                    continue
                }
                
                isExecuting = op.isExecuting && op.name == actionOpName
                break
            }
            // print("isExecuting: \(isExecuting), count: \(queue.operations.count)")
            if !isExecuting {
                queue.cancelAllOperations()
            }
            
            let sleepOp = BlockOperation(block: {
                Thread.sleep(forTimeInterval: delay)
            })
            sleepOp.name = sleepOpName
            
            let actionOp = BlockOperation(block: {
                action()
            })
            
            actionOp.name = actionOpName
            
            queue.addOperation(sleepOp)
            queue.addOperation(actionOp)
        }
    }
}

extension Sequence {
    func groupBy<G: Hashable>(closure: (Iterator.Element)->G) -> [G: [Iterator.Element]] {
        var results = [G: Array<Iterator.Element>]()
        
        forEach {
            let key = closure($0)
            
            if var array = results[key] {
                array.append($0)
                results[key] = array
            }
            else {
                results[key] = [$0]
            }
        }
        
        return results
    }
}




