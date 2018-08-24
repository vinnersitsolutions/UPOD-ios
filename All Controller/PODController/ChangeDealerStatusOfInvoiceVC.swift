
import UIKit

class ChangeDealerStatusOfInvoiceVC: UIViewController, AKRadioButtonsControllerDelegate , UINavigationControllerDelegate ,UIImagePickerControllerDelegate , UITextFieldDelegate {
      
    @IBOutlet var enterQtyOfInvoice: UITextField!
    @IBOutlet var changeStatus: UIButton!
    @IBOutlet var cancelBtn: UIButton!
    @IBOutlet var chooseImage: UIButton!
    @IBOutlet var dealerInvoiceImg: UIImageView!
    
    var radioButtonsController : AKRadioButtonsController!
    @IBOutlet var radioButtons: [AKRadioButton]!
    var getNewDealerInvoiceStatus : String = ""
    
    var receivedQty : String = ""
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.enterQtyOfInvoice.delegate = self
        
        self.radioButtonsController = AKRadioButtonsController(radioButtons: self.radioButtons)
        self.radioButtonsController.delegate = self
        
        chooseImage.layer.cornerRadius = 2
        chooseImage.clipsToBounds = true
        changeStatus.layer.cornerRadius = 2
        changeStatus.clipsToBounds = true
        cancelBtn.layer.cornerRadius = 2
        cancelBtn.clipsToBounds = true
        dealerInvoiceImg.layer.masksToBounds = true
        
        enterQtyOfInvoice.text = receivedQty
        
        // Do any additional setup after loading the view.
    }
    func selectedButton(sender: AKRadioButton) {
        getNewDealerInvoiceStatus = sender.title(for: .normal)!
    }
    
    
    @IBAction func changestatusAction(_ sender: Any) {
        let myVC = storyboard?.instantiateViewController(withIdentifier: "InvoiceDetailsVC") as! InvoiceDetailsVC
        myVC.newStatusOfInvoicetitle = getNewDealerInvoiceStatus
        navigationController?.pushViewController(myVC, animated: true)
    }
    
    
    @IBAction func chooseImageAction(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let image  = UIImagePickerController()
            image.delegate = self
            image.sourceType = UIImagePickerControllerSourceType.camera
            image.allowsEditing = false
            self.present(image, animated: true, completion: nil)
        }
        else{
            let image  = UIImagePickerController()
            image.delegate = self
            image.sourceType = UIImagePickerControllerSourceType.photoLibrary
            image.allowsEditing = false
            self.present(image, animated: true, completion: nil)
        }
    }
   
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            dealerInvoiceImg.image = image
        }
        else{
            print("error")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func cancelBtn(_ sender: Any) {
        removeAnimate()
    }
    

     // animate pop up
    
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0
        }, completion: {(finished : Bool) in
            if(finished)
            {
                self.willMove(toParentViewController: nil)
                self.view.removeFromSuperview()
                self.removeFromParentViewController()
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
  

}
