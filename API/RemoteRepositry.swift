import Foundation
import Alamofire
class RemoteRepository {
    //MARK:-- Properties
    
    fileprivate let baseUrl = ConstantAPI.baseUrl
 
    //Login API
    func remotePOSTServiceWithParameters(_ urlString : String! , params : Dictionary<String, String> , callback:@escaping (_ data: Dictionary<String, AnyObject>?, _ error: NSError? ) -> Void)  {
       let url =  "\(baseUrl)\(urlString!)"
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 20.0
         manager.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil)
            .validate()
            .responseJSON {
                response in
                guard response.result.error == nil else {
                    print("Error for POST :\(urlString):\(response.result.error!)")
                    //print("Error==\(response.result.error!)")
                    callback(nil , response.result.error! as NSError )
                    return
                }
                if let value = response.result.value {
                    if let result = value as? Dictionary<String, AnyObject> {
                        callback(result , nil )
                    }
                }
        }
        
    }
    
    // show dashoard details
    func showDashboardGETServicewithParameter(_ urlString : String! , params : Dictionary<String, String>, callback:@escaping (_ data: Dictionary<String,AnyObject>?, _ error: NSError? ) -> Void)  {
            let userID = UserDefaults.standard.string(forKey: "userId")
            let url =  "\(baseUrl)\(urlString!)/\(params["summaryDetails"]!)/\(userID!)"
            let manager = Alamofire.SessionManager.default
            manager.session.configuration.timeoutIntervalForRequest = 20.0
            manager.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil)
            .validate()
            .responseJSON {
                response in
                guard response.result.error == nil else {
                    print(response.result.error!)
                    callback(nil , response.result.error! as NSError )
                    return
                }
                if let value = response.result.value {
                    if let result = value as? Dictionary<String, AnyObject> {
                        callback(result , nil )
                    }
                }
        }
        
    }
    //Get API Request Method
    func remoteGETServiceWithoutHeader(_ urlString : String! , callback:@escaping (_ data: Dictionary<String,AnyObject>?, _ error: NSError? ) -> Void)  {
        let appversion = UserDefaults.standard.string(forKey: "AppVersion")
        let username = UserDefaults.standard.string(forKey: "UserID")
        let channelName = "storeType"
        
        let url =  "\(baseUrl)\(urlString!)AppVersion=\(appversion!)&UserName=\(username!)&Channel=\(channelName)"
        print("API==\(url)")
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 20.0
        
        manager.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil)
            
            .validate()
            .responseJSON {
                
                response in
                guard response.result.error == nil else {
        //            print(response.result.error!)
                    //KAppDelegate.showNotification("Slow internet! Please Try to connect wifi or check your data connection.")//last
                    callback(nil , response.result.error! as NSError )
                    return
                }
                
                if let value = response.result.value {
           //         print("Response for GET:\(urlString!):\(value)")
                    if let result = value as? Dictionary<String, AnyObject> {
                        callback(result , nil )
                    }
                }
        }
        
    }
    // Verify OTP API
    func remotePOSTServiceWithParametersOtp(_ urlString : String! , params : Dictionary<String, String> , callback:@escaping (_ data: Dictionary<String, AnyObject>?, _ error: NSError? ) -> Void)  {
        let url =  "\(baseUrl)\(urlString!)"
 //       print("Request POST URL:\(url) PARAMS:\(params) HEADER: ")
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 20.0
        manager.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil)
            .validate()
            .responseJSON {
                response in
                guard response.result.error == nil else {
                   callback(nil , response.result.error! as NSError )
                    return
                }
                if let value = response.result.value {
                    if let result = value as? Dictionary<String, AnyObject> {
                        callback(result , nil )
                    }
                }
        }
        
    }
    //resendOTP
    func resendOTPGETServicewithParameter(_ urlString : String! , callback:@escaping (_ data: Dictionary<String,AnyObject>?, _ error: NSError? ) -> Void)  {
            let sessionToken = UserDefaults.standard.string(forKey: "token")
            let url =  "\(baseUrl)\(urlString!)sessionToken=\(sessionToken!)"
            let manager = Alamofire.SessionManager.default
            manager.session.configuration.timeoutIntervalForRequest = 20.0
            manager.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil)
            .validate()
            .responseJSON {
                response in
                guard response.result.error == nil else {
                    callback(nil , response.result.error! as NSError )
                    return
                }
                if let value = response.result.value {
                    if let result = value as? Dictionary<String, AnyObject> {
                        callback(result , nil )
                    }
                }
        }
        
    }
   
    //getInvoice Data
    func getInovicesDetailsServiceWithParameter(_ urlString : String! ,  params : Dictionary<String, String>, callback:@escaping (_ data: Dictionary<String,AnyObject>?, _ error: NSError? ) -> Void)  {
        let userID = UserDefaults.standard.string(forKey: "userId")
        let url =  "\(baseUrl)\(urlString!)\(userID!)?sDate=\(params["sDate"]!)&eDate=\(params["eDate"]!)"
       let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 20.0
        manager.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil)
            .validate()
            .responseJSON {
                response in
                guard response.result.error == nil else {
                    callback(nil , response.result.error! as NSError )
                    return
                }
                if let value = response.result.value {
                    if let result = value as? Dictionary<String, AnyObject> {
                        callback(result , nil )
                    }
                }
        }
        
    }
    
    
    //invoice data with details
    func getInovicesDataWithDetailsServiceWithParameter(_ urlString : String! ,  params : Dictionary<String, String>, callback:@escaping (_ data: Dictionary<String,AnyObject>?, _ error: NSError? ) -> Void)  {
        let url =  "\(baseUrl)\(urlString!)/\(params["invoiceNo"]!)?invoiceDate=\(params["invoiceDate"]!)"
        print("invoice details = " , url)
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 20.0
        manager.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil)
            .validate()
            .responseJSON {
                response in
                guard response.result.error == nil else {
                    callback(nil , response.result.error! as NSError )
                    return
                }
                if let value = response.result.value {
                    if let result = value as? Dictionary<String, AnyObject> {
                        callback(result , nil )
                    }
                }
        }
        
    }
    
    
}
