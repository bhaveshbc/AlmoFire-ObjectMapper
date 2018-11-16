

import Foundation


enum Local : String {
    case en = "en"
    case fr = "fr"
}

enum ActivityCase : String {
    case category 
    case payer
    case gender
}

enum selectedType {
    case geolocation
    case searchByaddress(String)
}

enum PickerState : String {
    case minage = "min"
    case maxage = "max"
//    case hours = "hours"
    case minite = "minite"
    case radious = "radious"
}

enum signupstate {
    case facebook
    case gmail
    case normal
}

enum viewtype {
    case follow
    case unfollow
    case block
}

enum PartnerViewState {
    case  nearme
    case youliked
    case likedyou
}



enum profileTopviewState : Int {
    case editProfile
    case userDetails
    case myaccount
    case partnerProfile
}

enum PersonCollectionViewStae : Int {
    case editProfile
    case userDetails
}

enum cameraAction : String {
    case camera
    case gallary
    case video
}


enum ReviewState : Int {
    case ownerFilled
    case PartnerFilled
    case bothFilled
    case bothunFilled
}

enum profileViewState {
    enum commingSoon : Int {
        case today
        case normal
    }
}






