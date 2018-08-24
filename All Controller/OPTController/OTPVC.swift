import UIKit

class OTPVC: UIViewController {
    
    @IBOutlet var otpTimer: UILabel!
    let defaults = UserDefaults.standard
    fileprivate var OTPAPI: GetResponseData!
    fileprivate var ResnedOTPAPI: GetResponseData!
    
    @IBOutlet var enterOTP: UITextField!
    var countdownTimer: Timer!
    var totalTime = 60

    override func viewDidLoad() {
        startTimer()
        super.viewDidLoad()
        let data = defaults.object(forKey: "token")  // get token from login api
        print(data!)
        self.OTPAPI = GetResponseData()
        self.ResnedOTPAPI = GetResponseData()
    }
   
    @IBAction func confirmOTP(_ sender: Any) {
        if Reachability.isConnectedToNetwork() == true {
            if enterOTP.text!.isEmpty != true {
                            var userOTPDetails: Dictionary<String,String>
                userOTPDetails = ["token": "\(defaults.string(forKey: "token")!)" , "imei": "\(defaults.string(forKey: "UUIDValue")!)"
                    , "otp":enterOTP.text! ,"androidId": "\(defaults.string(forKey: "UUIDValue")!)"]
                                self.OTPAPI.postOtpfromRemote(userOTPDetails){ (issuccess, error) -> Void in
                                    if(issuccess){
                                        self.endTimer()
                                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                                        self.navigationController?.pushViewController(vc, animated: false)
                                    }else{
                                        KAppDelegate.showNotification("Please enter correct OTP")
                                    }
                            }
            }else{
                KAppDelegate.showNotification("Please Enter OTP")
            }
        }else{
            KAppDelegate.showNotification("No Internet Connection")
        }
    }
    
    
    // show timer
    func startTimer() {
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime() {
        otpTimer.text = "\(timeFormatted(totalTime))"
        if totalTime != 0 {
            totalTime -= 1
        } else {
            endTimer()
        }
    }
    func endTimer() {
        countdownTimer.invalidate()
    }
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    @IBAction func resendOTP(_ sender: Any) {
        if Reachability.isConnectedToNetwork() == true {
                var userOTPDetails: Dictionary<String,String>
                userOTPDetails = ["token": "\(defaults.string(forKey: "token")!)"]
                self.ResnedOTPAPI.getResendOtpfromRemote(userOTPDetails){ (issuccess, error) -> Void in
                    if(issuccess){
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                        self.navigationController?.pushViewController(vc, animated: false)
                    }else{
                        KAppDelegate.showNotification("Please enter correct OTP")
                    }
                }
            
        }else{
            KAppDelegate.showNotification("No Internet Connection")
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
