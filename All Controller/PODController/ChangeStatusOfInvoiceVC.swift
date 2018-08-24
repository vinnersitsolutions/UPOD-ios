
import UIKit

class ChangeStatusOfInvoiceVC: UIViewController , AKRadioButtonsControllerDelegate , UINavigationControllerDelegate ,
    UIImagePickerControllerDelegate {
    
    
    @IBOutlet var chooseImageBtn: UIButton!
    
    @IBOutlet var cancelBtn: UIButton!
    
    @IBOutlet var changeStatusBtn: UIButton!
    @IBOutlet var PODImageView: UIImageView!
    var radioButtonsController : AKRadioButtonsController!
    
    @IBOutlet var radioButtons: [AKRadioButton]!
    var getNewInvoiceStatus : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showAnimate()
        self.radioButtonsController = AKRadioButtonsController(radioButtons: self.radioButtons)
        self.radioButtonsController.delegate = self
        
        chooseImageBtn.layer.cornerRadius = 2
        chooseImageBtn.clipsToBounds = true
        
        changeStatusBtn.layer.cornerRadius = 2
        changeStatusBtn.clipsToBounds = true
        
        cancelBtn.layer.cornerRadius = 2
        cancelBtn.clipsToBounds = true
        
        
        PODImageView.layer.masksToBounds = true
    }
    func selectedButton(sender: AKRadioButton) {
        getNewInvoiceStatus = sender.title(for: .normal)!
    }
    
    @IBAction func chooseImageFunc(_ sender: Any) {
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
            PODImageView.image = image
        }
        else{
            print("error")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func changeStatusOfPOD(_ sender: Any) {
        let myVC = storyboard?.instantiateViewController(withIdentifier: "InvoiceDetailsVC") as! InvoiceDetailsVC
        myVC.newStatusOfInvoicetitle = getNewInvoiceStatus
        navigationController?.pushViewController(myVC, animated: true)
    }
    
    @IBAction func cancelpopup(_ sender: Any) {
        removeAnimate()
        
    }
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
 

}
