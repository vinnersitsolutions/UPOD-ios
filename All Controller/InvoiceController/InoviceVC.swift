
import UIKit
import SVProgressHUD

class InoviceVC: UIViewController,UIToolbarDelegate,UITableViewDelegate,UITableViewDataSource{
   @IBOutlet var inoviceTableView: UITableView!
    @IBOutlet var totalInvoiceLbl: UILabel!
    @IBOutlet var setStartDate: UIButton!
    @IBOutlet var setEndDate: UIButton!
    
    fileprivate var showInvoiceData: GetResponseData!
    let defaults  =  UserDefaults.standard
    let today = Date()
    let dateFormatter = DateFormatter()
    var startDate = ""
    var endDate = ""
    let picker  : UIDatePicker = UIDatePicker()
    let toolbar  = UIToolbar()
    var btnClickVar : String = ""
    var showInvoicelist = [[String: String]]()
    var getInoviceListCount : String = ""
    var getIndexValueOfTableCell = 0
    var transportStatus : String = ""
    var dealerStatus: String = ""
   
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.datePickerMode = .date
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let sevenDaysAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date())
        startDate = dateFormatter.string(from: sevenDaysAgo!)
        setStartDate.setTitle(startDate, for: .normal)
        endDate = dateFormatter.string(from: today)
        setEndDate.setTitle(endDate, for: .normal)
        self.showInvoiceData = GetResponseData()
      
   }
    @objc func doneTapped(sender: UIBarButtonItem){
        if btnClickVar == "start"
        {
            setStartDate.setTitle(dateFormatter.string(from: picker.date), for: .normal)
            startDate =  setStartDate.title(for: .normal)!
            btnClickVar = ""
        }
        else if btnClickVar == "end"
        {
            setEndDate.setTitle(dateFormatter.string(from: picker.date), for: .normal)
            endDate  = setEndDate.title(for: .normal)!
            
        }
        if(startDate.compare(endDate) == .orderedDescending){
            KAppDelegate.showNotification("Start date should be less then or equal to End date")
            setStartDate.setTitle("Start Date", for: .normal)
        }
        picker.removeFromSuperview()
        toolbar.removeFromSuperview()
        
    }
    @objc func cancelTapped(sender: UIBarButtonItem){
        picker.removeFromSuperview()
        toolbar.removeFromSuperview()
        
    }
    @IBAction func startDateBtnAction(_ sender: Any) {
        btnClickVar = "start"
        PickerView()
    }
    @IBAction func endDateBtnAction(_ sender: Any) {
        btnClickVar = "end"
        PickerView()
    }
    func PickerView(){
        picker.datePickerMode = UIDatePickerMode.date
        picker.frame =  CGRect(x: 0, y: self.view.frame.size.height - 200, width: self.view.frame.size.width, height: 216)
        picker.backgroundColor = UIColor.darkGray
      
        //add picker view
        let toolBarSize : CGSize = picker.sizeThatFits(CGSize.zero)
        toolbar.frame = CGRect(x: 0, y: self.view.frame.size.height - 230, width: toolBarSize.width, height: 50)
        toolbar.barStyle = UIBarStyle.blackTranslucent
        toolbar.tintColor = UIColor.white
        toolbar.sizeToFit()
        let doneButton: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneTapped))
        
        let spaceButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let cancelButton: UIBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelTapped))
        
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        self.view.addSubview(toolbar)
        self.view.addSubview(picker)
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return(showInvoicelist.count)
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
       let cell = tableView.dequeueReusableCell(withIdentifier: "invoiceDataCell", for: indexPath) as! inoviceTableVC
        let invoiceInfo = showInvoicelist[indexPath.row]
        cell.invoiceQty.text = invoiceInfo["getQty"]
        cell.inoviceNoLbl.text = invoiceInfo["getinoviceNo"]
        cell.invoiceTrpdStatus.setTitle(invoiceInfo["getTransportStatus"], for: .normal)
        cell.invoiceDealerStatus.setTitle(invoiceInfo["getDealerStatus"], for: .normal)
        cell.showInvoiceDate.text  = invoiceInfo["getInvoiceDate"]
        cell.selectionStyle = .none
        
        if (invoiceInfo["getTransportStatus"] == "Pending" ){
            cell.invoiceTrpdStatus.backgroundColor = UIColor(red:0.91, green:0.30, blue:0.24, alpha:1.0)
        }else {
             cell.invoiceTrpdStatus.backgroundColor = UIColor(red:0.15, green:0.68, blue:0.38, alpha:1.0)
        }
        if (invoiceInfo["getDealerStatus"] == "Pending" ){
            cell.invoiceDealerStatus.backgroundColor = UIColor(red:0.91, green:0.30, blue:0.24, alpha:1.0)
        }else {
            cell.invoiceDealerStatus.backgroundColor = UIColor(red:0.15, green:0.68, blue:0.38, alpha:1.0)
        }
        return(cell)
    }
    
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let invoiceDVC = self.storyboard?.instantiateViewController(withIdentifier: "InvoiceDetailsVC") as! InvoiceDetailsVC
        let invoice = showInvoicelist[indexPath.row]
        invoiceDVC.getInvoiceNo = invoice["getinoviceNo"]!
        invoiceDVC.getInoviceDate = invoice["getInvoiceDate"]!
        invoiceDVC.getTotalQty = invoice["getQty"]!
        invoiceDVC.getNetValue = invoice["getInvoiceNetValue"]!
        invoiceDVC.getNetTax = invoice["getInvoiceTax"]!
        self.navigationController?.pushViewController(invoiceDVC, animated: true)
    }
    
    
   @IBAction func getInvoiceDetails(_ sender: Any) {
            let getStartdate = dateFormatter.date(from: startDate)
            let getEnddate  = dateFormatter.date(from: endDate)
            let differnceBetweenDates = Calendar.current.dateComponents([.day], from: getStartdate!, to: getEnddate!)
            if Reachability.isConnectedToNetwork() == true {
            var invoicedata: Dictionary<String,String>
            invoicedata = ["userId": "\(defaults.string(forKey: "userId")!)" , "sDate": startDate , "eDate": endDate]
                self.showInvoicelist.removeAll()
                self.inoviceTableView.reloadData()
                self.showInvoiceData.getInvoiceDatafromRemote(invoicedata){ (issuccess, error) -> Void in
                    if differnceBetweenDates.day! <= 31 {
                    if((issuccess) != nil){
                       let invoiceData = issuccess!["data"] as! NSArray
                        for index in 0..<invoiceData.count {
                            let dict = invoiceData[index] as! NSDictionary
                            let getinoviceNo = dict.value(forKey: "invoiceno") as? String
                            let getQty = dict.value(forKey: "billedqty") as? Int
                            let getTransportStatus =  dict.value(forKey: "transporterstatus")  as? String
                            let getDealerStatus = dict.value(forKey: "dealerstatus")  as? String
                            let getInvoiceDate =  dict.value(forKey: "invoicedate") as? String
                            let getInvoiceNetValue = dict.value(forKey: "netvalue") as? Double
                            let getInvoiceTax = dict.value(forKey: "tax") as? Double
                            let qty = "\(getQty!)"
                            let invoiceNo = "\(getinoviceNo!)"
                            let invoiceNetValue = "\(getInvoiceNetValue!)"
                            let invoiceTax = "\(getInvoiceTax!)"
                            self.transportStatus = "\(getTransportStatus!)"
                            self.dealerStatus = "\(getDealerStatus!)"
                            let values = ["getinoviceNo": invoiceNo, "getQty":qty, "getTransportStatus":self.transportStatus , "getDealerStatus":self.dealerStatus , "getInvoiceDate": getInvoiceDate! ,"getInvoiceNetValue": invoiceNetValue ,
                                          "getInvoiceTax" : invoiceTax] as [String : Any]
                            self.showInvoicelist.append(values as! [String : String])
                      }
                        self.totalInvoiceLbl.text = ("Total Invoice :") + "\(invoiceData.count)"
                        self.inoviceTableView.reloadData()
                    }else{
                       KAppDelegate.showNotification("no data found")
                    }
                    }
                    else{
                        SVProgressHUD.dismiss()
                         KAppDelegate.showNotification("Date range should not be greater then 31 days")
                    }
                }
        }else{
                
                    KAppDelegate.showNotification("No Internet Connection")
        }
    
    }
   
    @IBAction func goToPreviousScreen(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        self.navigationController?.pushViewController(vc, animated: false)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
