import Foundation

class GetResponseRepositry{
    
    fileprivate let loginApi = "/api/account/login"
    fileprivate let verifyOTP = "/api/verify/mobile"
    fileprivate let resendOTP = "/api/resend/otp/"
    fileprivate let dashboardData = "/api/dashboard/summary"
    fileprivate let invoicesData = "/api/invoices/"
    fileprivate let invoiceDetailsApi = "/api/invoices/details"
    
    fileprivate var remoteRepo:RemoteRepository!
    
    init(){
        self.remoteRepo = RemoteRepository()
    }
    
    // login
    func postLoginfromRemote(_ userDetails:Dictionary<String,String>, callback:@escaping (_ responseData: Dictionary<String, AnyObject>?, _ error: NSError? ) -> Void ) {
        remoteRepo.remotePOSTServiceWithParameters(loginApi, params: userDetails) { (data,error) -> Void in
            callback(data, error)
            
        }
    }
    
    
   
    // verify OTP
    func postOtpfromRemote(_ userDetails:Dictionary<String,String>, callback:@escaping (_ responseData: Dictionary<String, AnyObject>?, _ error: NSError? ) -> Void ) {
        remoteRepo.remotePOSTServiceWithParametersOtp(verifyOTP, params: userDetails) { (data,error) -> Void in
            callback(data, error)
            
        }
    }
    
    // resend OTP
    func getResendOtpfromRemote(_ resentOTP:Dictionary<String,String>, callback:@escaping (_ responseData: Dictionary<String, AnyObject>?, _ error: NSError? ) -> Void ) {
        remoteRepo.resendOTPGETServicewithParameter(resendOTP) { (data,error) -> Void in
            callback(data, error)
        }
    }
    
    // get dashboard data
    func getdashboardDatafromRemote(_ showdashboardData:Dictionary<String,String>, callback:@escaping (_ responseData: Dictionary<String, AnyObject>?, _ error: NSError? ) -> Void ) {
        remoteRepo.showDashboardGETServicewithParameter(dashboardData  , params: showdashboardData) { (data,error) -> Void in
            callback(data, error)
        }
    }

    // get invoiceData
    func getInvoiceDatafromRemote(_ invoiceData:Dictionary<String,String>, callback:@escaping (_ responseData: Dictionary<String, AnyObject>?, _ error: NSError? ) -> Void ) {
        remoteRepo.getInovicesDetailsServiceWithParameter(invoicesData, params: invoiceData) { (data,error) -> Void in
            callback(data, error)
        }
    }
    
    
    // get inovice detailed data
    func getInvoiceInDetailsDatafromRemote(_ invoiceDetailData:Dictionary<String,String>, callback:@escaping (_ responseData: Dictionary<String, AnyObject>?, _ error: NSError? ) -> Void ) {
        remoteRepo.getInovicesDataWithDetailsServiceWithParameter(invoiceDetailsApi, params: invoiceDetailData) { (data,error) -> Void in
            callback(data, error)
        }
    }
    
    
   
}

