import Foundation
import Alamofire


enum errorCode : Int {
    case Error200 = 200
    case Error400 = 400
    case Error401 = 401
    case Error500 = 500
    case Error503 = 503
}


enum erorStatus : String {
    case SUCCESS
    case ERROR
}


protocol Endpoint {
    var baseURL: String { get } // https://example.com
    var path: String { get } // /users/
    var fullURL: String { get } // This will automatically be set. https://example.com/users/
    var method: HTTPMethod { get } // .get
    var encoding: ParameterEncoding { get } // URLEncoding.default
    var body: Parameters { get } // ["foo" : "bar"]
    var headers: HTTPHeaders { get } // ["Authorization" : "Bearer SOME_TOKEN"]
}


extension Endpoint {
    // The encoding's are set up so that all GET requests parameters
    // will default to be url encoded and everything else to be json encoded
    var encoding: ParameterEncoding {
        return method == .get ? URLEncoding.default : JSONEncoding.prettyPrinted
    }

    // Should always be the same no matter what
    var fullURL: String {
        
        return baseURL + path
    }

    // A lot of requests don't require parameters
    // so we just set them to be empty
    var body: Parameters {
        return Parameters()
    }
}


enum UserEndpoints {
    case getUsers(userid:String)
    case createUser(userModel:[String:Any])
    case authenticate(userModel:[String:Any])
    case resetPassword(userModel:[String:Any])
    case googleSignin(userModel:[String:Any])
    case facebookSignin(userModel:[String:Any])
    case Applogout(userModel:[String:Any])
    case googleoAuth
    case createEvent(userModel:[String:Any])
    case getme
    case ListEventsByLatLng(latlong:String,date:String,paramter:String)
    case GetEvent(eventid:String)
    case getEventPartnerList(latitude:String,longtitude:String)
    case getEventPartner(partnerid:String)
    case Listusersnearme(latlong:String,searchOption:String)
    case updateme(userModel:[String:Any])
    case ListPublicEventofuser(userid:String)
    case SubscribeEvent(eventId:String)
    case UnsubscribeeEvent(eventId:String)
    case followUser(userid:String)
    case unfollowUser(userid:String)
    case banusers(userid:String)
    case listFollowrs
    case publicSetting
    case signalUser(userid:String)
    case getmyfollowers
    case followedbyme(pageid:Int,limit:Int)
    case commingSoon(status:String)
    case rateEvent(eventid:String)
    case gerRate(eventid:String)
    case SelectPretenderOK(eventid:String,pretenderid:String)
    case SelectPretenderMaybe(eventid:String,pretenderid:String)
    case getshopbyevent(eventid:String,searchobj:String)
    case getProductbyshopid(shopid : String,eventid:String)
    case listnotification(limit : String,page:String)
    case listPaymentCard
    case createCard(cardDetails:[String:Any])
    case OfferGiftbyStripeCardId(cardData:[String:Any],shopid:String)
}

enum facebookEndPoint {
    case FacebookUserInfo(facebookid:String,facebooktoken:String)
}

enum googleEndPointstate {
    case googleoAuth
    case googleMap
}

extension facebookEndPoint: Endpoint {
    
    var baseURL: String {
        return "https://graph.facebook.com/"
    }
    
    // Set up the paths
    var path: String {
        switch self {
        case .FacebookUserInfo(let userid,let accesstoken):
            return "\(userid)?access_token=\(accesstoken)"
        }
    }
    
    // Set up the methods
    var method: HTTPMethod {
        switch self {
        case .FacebookUserInfo :
            return .get
        default :
            return .post
        }
    }
    
    // Set up any headers you may have. You can also create an extension on `Endpoint` to set these globally.
    var headers: HTTPHeaders {
       
        return ["Content-Type" : "application/json"]
    }
    
    // Lastly, we set the body. Here, the only route that requires parameters is create.
    var body: Parameters {
        var body: Parameters = Parameters()
        
        return body
    }
}


struct googleEndpoint : Endpoint {
    var baseURL: String {
        return "https://www.googleapis.com"
    }
    var path: String {
        switch state {
        case googleEndPointstate.googleoAuth:
             return "/oauth2/v3/userinfo?access_token="
        case googleEndPointstate.googleMap:
            return "/maps/api/place/nearbysearch/json?location="
        }
    }
    var method: HTTPMethod {
        return .get
    }
    var headers: HTTPHeaders {
        return ["Content-Type" : "application/json"]
    }
    var fullURL = ""
    init(token:String,endpointState:googleEndPointstate) {
        state = endpointState
        fullURL = baseURL + path + token
    }
    var state : googleEndPointstate
}

extension UserEndpoints: Endpoint {
    
    var baseURL: String {
        return "http://customer.api.wondate.dewez.co/v1/"
    }

    // Set up the paths
    var path: String {
        switch self {
        case .getUsers(let userid): return "users/\(userid)"
        case .createUser: return "users/"
        case .authenticate : return "users/authenticate/"
        case .resetPassword : return "reset-passwords"
        case .googleSignin : return "google/authenticate/"
        case .Applogout : return "me/logout/"
        case .googleoAuth : return "/userinfo?access_token"
        case .createEvent : return "events/"
        case .getme : return "me"
        case .ListEventsByLatLng(let latlong ,let date , let parameter) : return "events/latlng/\(latlong)?date=\(date)&search=\(parameter)"
        case .GetEvent(let eventid): return "events/\(eventid)"
        case .getEventPartnerList(let latitude, let longtitude ): return "partners/places/latlng/\(latitude),\(longtitude)"
        case .getEventPartner(let partnerid) : return "partners/places/\(partnerid)"
        case .Listusersnearme(let latlong,let searchOption) : return "users/latlng/\(latlong)?search=\(searchOption)"
        case .updateme : return  "me"
        case .ListPublicEventofuser(let userid) : return "users/\(userid)/events"
        case .facebookSignin : return "facebook/authenticate"
        case .SubscribeEvent(let eventid) : return "events/\(eventid)/subscribe"
        case .UnsubscribeeEvent(let eventid) : return "events/\(eventid)/unsubscribe"
        case .followUser(let userid) : return "users/\(userid)/follow"
        case .unfollowUser(let userid) : return "users/\(userid)/unfollow"
        case .banusers(let userid) : return "users/\(userid)/ban"
        case .listFollowrs : return "me/follows-ids"
        case .publicSetting : return "settings/public"
        case .signalUser(let userid) : return "users/\(userid)/flag"
        case .getmyfollowers : return "me/followers"
        case .followedbyme(let pageid,let limit) : return "me/follows?page=\(pageid)&limit=\(limit)"
        case .commingSoon(let status) : return "me/events?status=\(status)"
        case .rateEvent(let eventid) : return "me/events/\(eventid)/rate"
        case .gerRate(let eventid) : return "me/events/\(eventid)/rates"
        case .SelectPretenderOK(let eventid,let pretenderid) : return "me/events/\(eventid)/pretenders/\(pretenderid)/ok"
        case .SelectPretenderMaybe(let eventid,let pretenderid) : return "me/events/\(eventid)/pretenders/\(pretenderid)/maybe"
        case .getshopbyevent(let eventid, let searchobj) : return "partners/shops?event=\(eventid)&search=\(searchobj)"
        case .getProductbyshopid(let shopid,let eventid) :  return "partners/shops/\(shopid)?event=\(eventid)"
        case .listnotification(let limit,let page) : return "me/notifications?limit=\(limit)&page=\(page)"
        case .listPaymentCard : return "me/cards"
        case .createCard : return "me/cards"
        case .OfferGiftbyStripeCardId( _ ,let shopid ): return "partners/shops/\(shopid)/order"
        }
    }

    // Set up the methods
    var method: HTTPMethod {
        switch self {
        case .getUsers,.googleoAuth,.getme , .ListEventsByLatLng,.GetEvent,.getEventPartnerList , .getEventPartner,.Listusersnearme,.ListPublicEventofuser,.listFollowrs , .publicSetting , .getmyfollowers , .followedbyme ,.commingSoon,.gerRate,.getshopbyevent,.listnotification,.getProductbyshopid,.listPaymentCard :
            return .get
            
        case .updateme :
            return .put
        default :
            return .post
        }
    }

    // Set up any headers you may have. You can also create an extension on `Endpoint` to set these globally.
    var headers: HTTPHeaders {
        var Usertoken = ""
        if let deviceInfo = UserDefaults.standard.value(forKey: deviceInfokey) as? [String:String?] {
            if let token = deviceInfo["token"] as? String , token != ""  {
                 Usertoken =  "JWT " + token
                print("userToken = \(Usertoken)")
            }
        }
        return ["Content-Type" : "application/json","Authorization":Usertoken]
    }

    // Lastly, we set the body. Here, the only route that requires parameters is create.
    var body: Parameters {
        var body: Parameters = Parameters()
        switch self {
        case .getUsers:
            break
        case .createUser(let selectedUser):
            body = selectedUser
        case .authenticate(let selectedUser):
             body = selectedUser
        case .resetPassword(let selectedUser):
            body = selectedUser
        case .googleSignin(let selectedUser):
            body = selectedUser
        case .Applogout(let selectedUser):
            body = selectedUser
        case .createEvent(let selectedUser):
            body = selectedUser
        case .updateme(let data) :
            body = data
        case .facebookSignin(let selectedUser) :
            body = selectedUser
        case .createCard(let cardDetail):
            body = cardDetail
        case .OfferGiftbyStripeCardId(let cardDetail , _):
            body = cardDetail
        default:
            break
        }
        return body
    }
}


protocol BuckoErrorHandler {
    func buckoRequest(request: URLRequest, error: Error)
}

typealias ResponseClosure = (([String:Any]) -> Void)

struct ApiManager {
    // You can set this to a var if you want
    // to be able to create your own SessionManager
    let manager: SessionManager = SessionManager()
    static let shared = ApiManager()
    var delegate: BuckoErrorHandler?
}

struct CustomEncoding: ParameterEncoding {
    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try! URLEncoding().encode(urlRequest, with: parameters)
        let urlString = request.url?.absoluteString.replacingOccurrences(of: "%5B%5D=", with: "=")
        request.url = URL(string: urlString!)
        return request
    }
}

extension ApiManager {
    func request(endpoint: Endpoint, completion: @escaping ResponseClosure)  {
        if Connectivity.isReachable {
            print("endpoint.fullURL = \(endpoint.fullURL)")
            print("endpoint.body = \(endpoint.body)")
            print("endpoint.headers = \(endpoint.headers)")
            let prefix = endpoint.fullURL.components(separatedBy: "/").last
            if prefix != "follow" &&  prefix != "unfollow" && prefix != "ban" {
                (UIApplication.shared.delegate as! AppDelegate).addProgressView()
            }
            

            var endcodings : ParameterEncoding!
            if endpoint.fullURL.contains("search")  {
               endcodings = CustomEncoding()
            }
            else {
                endcodings = endpoint.encoding
            }
            
            let request = manager.request(
                endpoint.fullURL,
                method: endpoint.method,
                parameters:  endpoint.body,
                encoding: endcodings,
                headers: endpoint.headers
                ).responseJSON { response in
                   
                    print("response of \(endpoint.fullURL) == \(response)")
                    // hide Loader
                    
                    
                    
                   
                        DispatchQueue.main.async {
                            (UIApplication.shared.delegate as! AppDelegate).hideProgrssVoew()
                        }
                    

                    var facebook = false
                    
                    
                    
                    // Handel Response
                    if let responseData = response.result.value as? [String:Any] {
                        if let errorcode = responseData["code"] as? String ,  errorcode == erorStatus.SUCCESS.rawValue {
                            if let response = responseData["data"] as? [String:Any] {
                                  if  endpoint.fullURL.components(separatedBy: "/").suffix(3).joined(separator: "/") == "v1/facebook/authenticate" ||   endpoint.fullURL.components(separatedBy: "/").suffix(3).joined(separator: "/") == "google/authenticate/"  {
                                    facebook = true
                                }
                                
                                completion(response)
                            }
                            else {
                                completion(responseData)
                            }
                        }
                        if endpoint.self is googleEndpoint {
                             completion(responseData)
                        }
                        else if endpoint.self is facebookEndPoint {
                            completion(responseData)
                        }
                        else {
                            if let endpointSuffix = endpoint.fullURL.components(separatedBy: "/").suffix(3).joined(separator: "/") as? String {
                                if endpointSuffix == "google/authenticate/" || endpointSuffix == "v1/facebook/authenticate" {
                                    if !facebook {
                                        completion(responseData)
                                    }
                                }
                                else {
                                    if let errorcode = responseData["code"] as? String ,  errorcode == erorStatus.ERROR.rawValue , let responsedata =   responseData["data"] as? [String:Any]{
                                        if var message = responsedata["message"] as? String {
                                            DispatchQueue.main.async {
                                                if message == "User not found" {
                                                    message = "Entered email id does not found!"
                                                }
                                                UIApplication.shared.gettopMostViewController()?.presentAlerterror(title: AlertLbael, message: message, okclick: nil)
                                            }
                                        }
                                        else if let response =   responseData["data"] as? [String:Any] , let invaidattr =  response["invalidAttributes"] as? [String:Any] , let email =  invaidattr["email"] as? [[String:String]] {
                                            UIApplication.shared.gettopMostViewController()?.presentAlerterror(title: AlertLbael, message: inputValidate.duplicateemail.rawValue, okclick: nil)
                                        }
                                    }
                                    else if let response =   responseData["data"] as? [String:Any] , let invaidattr =  response["invalidAttributes"] as? [String:Any] , let email =  invaidattr["email"] as? [[String:String]] {
                                        UIApplication.shared.gettopMostViewController()?.presentAlerterror(title: AlertLbael, message: inputValidate.duplicateemail.rawValue, okclick: nil)
                                    }
                                }
                                
                            }
                            else {
                                if let errorcode = responseData["code"] as? String ,  errorcode == erorStatus.ERROR.rawValue  {
                                    if let message = responseData["message"] as? String {
                                        DispatchQueue.main.async {
                                            UIApplication.shared.gettopMostViewController()?.presentAlerterror(title: AlertLbael, message: message, okclick: nil)
                                        }
                                    }
                                    
                                }
                            }
                        }
                    }
                    else {
                       if let statusCode = response.response?.statusCode,statusCode == errorCode.Error503.rawValue {
                            DispatchQueue.main.async {
                                UIApplication.shared.gettopMostViewController()?.presentAlerterror(title: AlertLbael, message: serverNotAvilabel, okclick: nil)
                            }
                        }
                    }
            }
            print(request.description)
        }
        else {
            (UIApplication.shared.delegate as! AppDelegate).hideProgrssVoew()
            UIApplication.shared.gettopMostViewController()?.presentAlerterror(title: AlertLbael, message: nointerConnection, okclick: nil)
        }
    }
    
    
    func uploadmultipart(endUrl: String,fileName:String, imageData: Data?, parameters: [String : Any],mimeType:String,header:[String:String], onCompletion: @escaping ResponseClosure, onError: ((Error?) -> Void)? = nil) {
        
        let url = endUrl /* your API url */
        
        let headers: HTTPHeaders = header
        DispatchQueue.main.async {
            (UIApplication.shared.delegate as! AppDelegate).addProgressView()
        }
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
//            multipartFormData.append(imageData!, withName: "file")
            if let data = imageData{
                multipartFormData.append(data, withName: "file", fileName: fileName, mimeType: mimeType)
            }
            
        }, usingThreshold: UInt64.init(), to: url, method: .post, headers: headers) { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    //print("Succesfully uploaded")
                    if let err = response.error{
                        onError?(err)
                        return
                    }
                    print("uploading response = \(response)")
                    if let data = response.result.value as? [String:Any] {
                        onCompletion(data)
                    }
                    
                    DispatchQueue.main.async {
                        (UIApplication.shared.delegate as! AppDelegate).hideProgrssVoew()
                    }
                    
                }
            case .failure(let error):
                print("Error in upload: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    (UIApplication.shared.delegate as! AppDelegate).hideProgrssVoew()
                }
                onError?(error)
            }
        }
    }
}

class Connectivity {
    class var isReachable:Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}



//jsonconbverter


func json(from object:Any) -> String? {
    do {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            
            preconditionFailure("String not encoded")
            return nil
        }
        
        return String(data: data, encoding: String.Encoding.utf8)!.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
    }
    return ""
}

