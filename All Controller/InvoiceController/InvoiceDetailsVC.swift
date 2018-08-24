
import UIKit
import SVProgressHUD

class InvoiceDetailsVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var setTotalTax: UILabel!
    @IBOutlet var setTotalValue: UILabel!
    @IBOutlet var setTotalQty: UILabel!
    @IBOutlet var setInvoiceNo: UILabel!
    @IBOutlet var setInvoicDate: UILabel!
    @IBOutlet var invoiceDetailsTableView: UITableView!
    var getInvoiceNo : String = ""
    var getInoviceDate : String = ""
    var getTotalQty : String = ""
    var getNetValue : String = ""
    var getNetTax : String = ""
    var showInvoiceCount = [[String: String]]()
    let defaultValues = UserDefaults.standard
    fileprivate var invoicesDetailsAPI: GetResponseData!
    
    
    var newStatusOfInvoicetitle : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInvoiceNo.text =  ("Invoice No:") + getInvoiceNo
        setInvoicDate.text = ("Invoice Date:") + getInoviceDate
        setTotalQty.text = ("Total Qty:") + getTotalQty
        setTotalValue.text = ("Net value :") + getNetValue
        setTotalTax.text = ("Net tax :") + getNetTax
        self.invoicesDetailsAPI = GetResponseData()
        invoiceDetailsTableView.estimatedRowHeight = 44
        invoiceDetailsTableView.rowHeight = UITableViewAutomaticDimension
        getDetailDataForInvoice()
    }
    
    @IBAction func getDetailDataForInvoice(){
        if Reachability.isConnectedToNetwork() == true {
            var invoiceDetailsData: Dictionary<String,String>
            invoiceDetailsData = ["invoiceNo": getInvoiceNo , "invoiceDate": getInoviceDate ]
            self.showInvoiceCount.removeAll()
            self.invoiceDetailsTableView.reloadData()
          self.invoicesDetailsAPI.getInvoiceDetailedDatafromRemote(invoiceDetailsData){ (issuccess, error) -> Void in
                if(((issuccess)) != nil){
                        self.showInvoiceCount.removeAll()
                        let detailedDataOfInvoice = issuccess!["data"] as! NSArray
                        for index in 0..<detailedDataOfInvoice.count {
                        let dict = detailedDataOfInvoice[index] as! NSDictionary
                           let materialdescription = dict.value(forKey: "materialdescription") as? String
                            let billedqty = dict.value(forKey: "billedqty") as? Int
                            let receivedQty =  dict.value(forKey: "receivedQty")  as? Int
                            let totalqty = "\(billedqty!)"
                            let materialDesc = "\(materialdescription!)"
                            let Qtyreceived = "\(receivedQty!)"
                            let transporterstatus = "\(dict.value(forKey: "transporterstatus")!)"
                            let dealerstatus = "\(dict.value(forKey: "dealerstatus")!)"
                            
                    let values = ["materialdescription": materialDesc, "billedqty":totalqty, "receivedQty": Qtyreceived,
                                  "transporterstatus" : transporterstatus , "dealerstatus" : dealerstatus] as [String : Any]
                    
                    self.showInvoiceCount.append(values as! [String : String])
                    }
                     self.invoiceDetailsTableView.reloadData()
                    }else{
                        KAppDelegate.showNotification("no data found")
                    }
            }
        }else{
            KAppDelegate.showNotification("No Internet Connection")
        }
        
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showInvoiceCount.count
    }
    
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! InvoiceDetailsTableVC
        let invoiceInfo = showInvoiceCount[indexPath.row]
        cell.invoiceMaterialLbl.numberOfLines = 0
        cell.invoiceMaterialLbl.text =  invoiceInfo["materialdescription"]
        cell.invoiceQtyLbl.text = invoiceInfo["billedqty"]
        cell.invoiceReceivedQtyLbl.text  = invoiceInfo["receivedQty"]
        cell.inoviceRemarksLbl.text = "na"
        cell.selectionStyle = .none
        let userType  = defaultValues.string(forKey: "userType")
        if (userType == "Dealer")
        {
            cell.invoicePODBtn.setTitle(invoiceInfo["dealerstatus"], for: .normal)
            if (invoiceInfo["dealerstatus"] == "Received" ){
                cell.invoicePODBtn.backgroundColor = UIColor(red:0.15, green:0.68, blue:0.38, alpha:1.0)
            }else if(invoiceInfo["dealerstatus"] == "Received Damaged"){
                cell.invoicePODBtn.backgroundColor = UIColor(red:0.91, green:0.30, blue:0.24, alpha:1.0)
            }else if(invoiceInfo["dealerstatus"] == "Received Partially"){
                cell.invoicePODBtn.backgroundColor = UIColor(red:1.00, green:0.79, blue:0.34, alpha:1.0)
                
            }else{
                cell.invoicePODBtn.setTitle("POD", for: .normal)
                cell.invoicePODBtn.backgroundColor = UIColor(red:0.91, green:0.30, blue:0.24, alpha:1.0)
                cell.onButtonTapped = {
                    print("hello pod")
                    let popvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChangeDealerStatusOfInvoiceVC") as! ChangeDealerStatusOfInvoiceVC
                    popvc.receivedQty = cell.invoiceQtyLbl.text!
                    self.addChildViewController(popvc)
                    popvc.view.frame = self.view.frame
                    self.view.addSubview(popvc.view)
                    popvc.didMove(toParentViewController: self)
                }
            }
        }
        else{
            cell.invoicePODBtn.setTitle(invoiceInfo["transporterstatus"], for: .normal)
            if (invoiceInfo["transporterstatus"] == "Received" ){
                cell.invoicePODBtn.backgroundColor = UIColor(red:0.15, green:0.68, blue:0.38, alpha:1.0)
            }else if(invoiceInfo["transporterstatus"] == "Received Damaged"){
                cell.invoicePODBtn.backgroundColor = UIColor(red:0.91, green:0.30, blue:0.24, alpha:1.0)
            }else if(invoiceInfo["transporterstatus"] == "Received Partially"){
                cell.invoicePODBtn.backgroundColor = UIColor(red:1.00, green:0.79, blue:0.34, alpha:1.0)
            }else{
                cell.invoicePODBtn.setTitle("POD", for: .normal)
                cell.invoicePODBtn.backgroundColor = UIColor(red:0.91, green:0.30, blue:0.24, alpha:1.0)
                cell.onButtonTapped = {
                    print("hello transporter")
                    let popvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChangeStatusOfInvoiceVC") as! ChangeStatusOfInvoiceVC
                    self.addChildViewController(popvc)
                    popvc.view.frame = self.view.frame
                    self.view.addSubview(popvc.view)
                    popvc.didMove(toParentViewController: self)
                }
                }
        }
        invoiceDetailsTableView.tableFooterView = UIView(frame: .zero)
        return cell
    }
  
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    @IBAction func goToPreviousScreen(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "InoviceVC") as! InoviceVC
        self.navigationController?.pushViewController(vc, animated: false)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
}
