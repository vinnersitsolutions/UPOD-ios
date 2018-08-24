import UIKit
import SVProgressHUD

class LoginVC: UIViewController , UITextFieldDelegate {
    var iconClick : Bool!
    @IBOutlet var passwordIcon: UIButton!
    @IBOutlet var userPassword: UITextField!
    @IBOutlet var userMobileNo: UITextField!
    @IBOutlet var userNumberData: UITextField!
    let defaultValues = UserDefaults.standard
    fileprivate var loginAPI: GetResponseData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userNumberData.delegate = self
        userPassword.delegate = self
        userMobileNo.delegate = self
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.loginAPI = GetResponseData()
        if defaultValues.string(forKey: "loginId") != nil{
            userNumberData.text = defaultValues.string(forKey: "loginId")
            userPassword.text=defaultValues.string(forKey: "password")
            userMobileNo.text=defaultValues.string(forKey: "mobile")
            
        }else{
            print("name and password is empty")
        }
    }
    // for digits only
   func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(textField == self.userMobileNo){
            let allowedCharacter = CharacterSet.decimalDigits
            let characterset = CharacterSet(charactersIn: string)
            return allowedCharacter.isSuperset(of: characterset)
        }
        return true
    }
 
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    @IBAction func showPasswordAction(_ sender: Any) {
        if(iconClick == true) {
            userPassword.isSecureTextEntry = false
            passwordIcon.setImage(UIImage(named: "showPasswordIcon"), for: UIControlState.normal)
            iconClick = false
        } else {
            passwordIcon.setImage(UIImage(named: "hidePasswordIcon"), for: UIControlState.normal)
            userPassword.isSecureTextEntry = true
            iconClick = true
        }
    }
  @IBAction func goToNextScreen(_ sender: Any) {
        if Reachability.isConnectedToNetwork() == true {
        if userNumberData.text!.isEmpty != true {
            if userPassword.text!.isEmpty != true{
                if userMobileNo.text!.isEmpty != true{
                    let mobileTrimmedString = userMobileNo.text?.trimmingCharacters(in: .whitespaces)
                    if mobileTrimmedString != "" {
                        if isValidPhone(phone: mobileTrimmedString!) == false{
                            KAppDelegate.showNotification("enter valid ph number")
                        }else{
                            var userLoginDetials: Dictionary<String,String>
                            userLoginDetials = ["loginId":userNumberData.text!, "mobile":userMobileNo.text!, "password": userPassword.text! ]
                            SVProgressHUD.setBackgroundColor(UIColor.white)
                            SVProgressHUD.setBackgroundLayerColor(UIColor.blue)
                            SVProgressHUD.setRingThickness(3)
                           SVProgressHUD.show() 
                            
                            self.loginAPI.postLoginfromRemote(userLoginDetials){ (issuccess, error) -> Void in
                                if(issuccess){
                                    SVProgressHUD.dismiss()
                                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                                    self.navigationController?.pushViewController(vc, animated: false)
                                }else{
                                    SVProgressHUD.dismiss()
                                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "OTPVC") as! OTPVC
                                    self.navigationController?.pushViewController(vc, animated: false)
                                }
                        }
                    }
                }
                }else{
                    KAppDelegate.showNotification("Please enter mobile no")
                }
            }else{
                KAppDelegate.showNotification("Please enter Password")
            }
        }else{
                KAppDelegate.showNotification("Please Enter UserNumber")
            }
        }else{
                KAppDelegate.showNotification("No Internet Connection")
            }
    }
    
    //validate phone number
    func isValidPhone(phone: String) -> Bool {
        let phoneRegex = "^((0091)|(\\+91)|0?)[6789]{1}\\d{9}$";
        let valid = NSPredicate(format: "SELF MATCHES %@", phoneRegex).evaluate(with: phone)
        return valid
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
