
import Foundation
class GetResponseData{
    fileprivate let getRemoteReplicator:GetResponseRepositry!
    init() {        
        self.getRemoteReplicator = GetResponseRepositry()
    }
    
    func postLoginfromRemote(_ userProfileDict: Dictionary<String, String> , callback:@escaping (_ successResponse: Bool, _ error: NSError? ) -> Void) {
        getRemoteReplicator.postLoginfromRemote(userProfileDict) { (data, error) -> Void in
            if data != nil{
                if data!["isError"] as! Bool == false{
                    let loginData = data!["data"] as! NSArray
                    let dict = loginData[0] as! NSDictionary
                    UserDefaults.standard.set(dict.value(forKey: "code")!, forKey: "code")
                    UserDefaults.standard.set(dict.value(forKey: "userId")!, forKey: "userId")
                    UserDefaults.standard.set(dict.value(forKey: "userType")!, forKey: "userType")
                   
                    if(dict.value(forKey: "verfied")! as! Bool == true) {
                        callback(true, nil)
                    }
                    else{
                        UserDefaults.standard.set(dict.value(forKey: "token")!, forKey: "token")  //get token from login api
                        
                        callback(false,nil)
                    }
               }else{
                   KAppDelegate.showNotification("Error")
                }
            }else{
               KAppDelegate.showNotification("Slow internet! Please Try to connect wifi or check your data connection.")
                
            }
        }
    }
    
    func getDashboardDatafromRemote(_ dashboardData: Dictionary<String, String> , callback:@escaping (_ response:Dictionary<String, AnyObject>?, _ error: NSError? ) -> Void) {
        getRemoteReplicator.getdashboardDatafromRemote(dashboardData) { (data, error) -> Void in
            if data != nil{
                if data!["isError"] as! Bool == false{
                    callback(data, nil)
                }
            }else{
                KAppDelegate.showNotification("Slow internet! Please Try to connect wifi or check your data connection.")
                
            }
        }
    }
    // verify otp
    func postOtpfromRemote(_ userProfileDict: Dictionary<String, String> , callback:@escaping (_ successResponse: Bool, _ error: NSError? ) -> Void) {
        getRemoteReplicator.postOtpfromRemote(userProfileDict) { (data, error) -> Void in
            if data != nil{
                 if data!["isError"] as! Bool == false{
                        
                        callback(true, nil)
                } else{
                        let message = data!["msg"]//error msg
                        KAppDelegate.showNotification(message as! String)
                       // callback(false,nil)
                    }
            }else{
                KAppDelegate.showNotification("Slow internet! Please Try to connect wifi or check your data connection.")
                
            }
        }
    }
    func getResendOtpfromRemote(_ resendOTP: Dictionary<String, String> , callback:@escaping (_ successResponse: Bool, _ error: NSError? ) -> Void) {
        getRemoteReplicator.getResendOtpfromRemote(resendOTP) { (data, error) -> Void in
            if data != nil{
                if data!["isError"] as! Bool == false{
                    
                    callback(true, nil)
                } else{
                     callback(false,nil)
                }
            }else{
                KAppDelegate.showNotification("Slow internet! Please Try to connect wifi or check your data connection.")
                
            }
        }
    }

    func getInvoiceDatafromRemote(_ invoiceData: Dictionary<String, String> , callback:@escaping (_ response:Dictionary<String, AnyObject>?, _ error: NSError? ) -> Void) {
        getRemoteReplicator.getInvoiceDatafromRemote(invoiceData) { (data, error) -> Void in
            if data != nil{
                if data!["isError"] as! Bool == false{
                    let invoiceDataKeys = data!["data"] as! NSArray
                    let dict = invoiceDataKeys[0] as! NSDictionary
                    UserDefaults.standard.set(dict.value(forKey: "invoiceno")!, forKey: "invoiceno")
                    UserDefaults.standard.set(dict.value(forKey: "invoicedate")!, forKey: "invoicedate")
                    
                    callback(data, nil)
                } else{
                    let message = data!["msg"]//error msg
                    KAppDelegate.showNotification(message as! String)
                }
            }else{
                KAppDelegate.showNotification("Slow internet! Please Try to connect wifi or check your data connection.")
                
            }
        }
    }
    
   
    
    // invoice detailed data
    func getInvoiceDetailedDatafromRemote(_ invoiceDetailedData: Dictionary<String, String> , callback:@escaping (_ response:Dictionary<String, AnyObject>?, _ error: NSError? ) -> Void) {
        getRemoteReplicator.getInvoiceInDetailsDatafromRemote(invoiceDetailedData) { (data, error) -> Void in
            if data != nil{
                if data!["isError"] as! Bool == false{
                    callback(data, nil)
                } else{
                    let message = data!["msg"]//error msg
                    KAppDelegate.showNotification(message as! String)
                }
            }else{
                KAppDelegate.showNotification("Slow internet! Please Try to connect wifi or check your data connection.")
                
            }
        }
    }
    
    
  
}
