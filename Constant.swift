//
//  Constant.swift
//  Wondate
//
//  Created by a on 3/27/18.
//  Copyright © 2018 YoungBrainz Infotech. All rights reserved.
//

import Foundation
import UIKit

let textBoxBorderColor = "EBEBEB"
let cellBorder = (red:192.0,green:192.0,blue:192.0)
let theremeColor = #colorLiteral(red: 0.8941176471, green: 0.1215686275, blue: 0.3019607843, alpha: 1)
let calnderDateSelectedColour = #colorLiteral(red: 0.1960784314, green: 0.2352941176, blue: 0.2509803922, alpha: 1)
let calanderDatenormalColour = #colorLiteral(red: 0.9254901961, green: 0.9294117647, blue: 0.937254902, alpha: 1)
let calanderUnselectedColour = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
let iamcommingcolor = #colorLiteral(red: 0.03529411765, green: 0.8039215686, blue: 0.7137254902, alpha: 1)
let iamlatecolor = #colorLiteral(red: 0.9803921569, green: 0.6235294118, blue: 0.1607843137, alpha: 1)
let cancelcolor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
let deviceInfokey = "deviceInfo"
let lightgrayText = UIColor(red: 56.0 / 255.0, green: 42.0 / 255.0, blue: 42.0 / 255.0, alpha: 1.0)
let mapcircleRed = UIColor(red:0.89, green:0.12, blue:0.30, alpha:0.2)
let mapcircleRedBorder =  UIColor(red:0.89, green:0.12, blue:0.30, alpha:0.5)
let mapcircleBlue = UIColor(red:0.04, green:0.50, blue:1.00, alpha:0.2)



enum userDefaultKey : String {
    case deviceInfokey
    case userInfoMe
    case termsAndConditionsLink
    case privacyLink
    case createEventLastLocation
}

//AIzaSyDKnxSp-vaodeo4JeoLgb-BauEE1_DjLP0

enum ApiKey : String {
    case googlePlace = "AIzaSyDKnxSp-vaodeo4JeoLgb-BauEE1_DjLP0"
    case googleMap   = "AIzaSyA-y_xbbluHNvePhhJEYk6a3ve_DXe3lJc"
    case oneSignal   = "868b0951-e4ab-4a1a-8e9c-ca545b601ce5"
}

enum WondateFontType: String {
    case RobotoRegular = "Roboto-Regular"
    case RobotoMedium = "Roboto-Medium"
    case Robotoblack = "Roboto-Black"
    case RobotoBold = "Roboto-Bold"
    case AgenBold = "Agane65-Bold"
    
     case Agen75Bold = "Agane75"
    func of(size: CGFloat) -> UIFont {
        return UIFont(name: self.rawValue, size: size)!
    }
}

struct WondateFont {
    static let RobotoRegular15 = WondateFontType.RobotoRegular.of(size: 15.3)
    static let RobotoRegular10 = WondateFontType.RobotoRegular.of(size: 10)
    static let RobotoMidum20 = WondateFontType.RobotoMedium.of(size: 20)
    static let RobotoRegular20 = WondateFontType.RobotoRegular.of(size: 20)
    static let RobotoBlack20 = WondateFontType.Robotoblack.of(size: 20)
    static let AgenBold20 = WondateFontType.AgenBold.of(size: 20)
    static let Agen75Bold = WondateFontType.Agen75Bold.of(size: 20)
    static let  RobotoBold20 = WondateFontType.RobotoBold.of(size: 20)
}




