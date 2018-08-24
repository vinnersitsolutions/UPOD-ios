
import UIKit

class HomeVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout,UIActionSheetDelegate{

    @IBOutlet var showTotalInoviceCount: UILabel!
    let defaults = UserDefaults.standard
    @IBOutlet var thisMonthBtn: UIButton!
    @IBOutlet var dashboardCollectionview: UICollectionView!
    let identifier = "dashboardCell"
    var images=["invoiceIcon","InovicePending","approvaldateIcon","pendingIconDate"]
    var count = ["0","0","0","0"]
    var status = ["Done","Pending","Damaged","Partially Delivered"]
    fileprivate var showDashBoardData :GetResponseData!
    var emptyArray: [Int] = []
    var getSumOfCountInString : String = ""
    var dbFilter : String = "currentMonth"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showDashBoardData = GetResponseData()
        dashboardCollectionview.delegate = self
        dashboardCollectionview.dataSource = self
        getDashBoardData()
      }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:dashboardCollectionview.frame.width/2 - 3 , height:100)
    }
  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "dashboardCell", for:indexPath as IndexPath) as! HomeCollectionVC
        myCell.dashboardImage.image = UIImage(named: images[indexPath.row])
        myCell.dashbordCount.text = count[(indexPath.row)]
        myCell.dashboardStatus.text = status[(indexPath.row)]
        return myCell
    }
    
    
    @IBAction func selectDataShownOnDashboard(_ sender: Any) {
        let alert = UIAlertController(title: "Title", message: "Please Select an Option", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Yesterday", style: .default , handler:{ (UIAlertAction)in
            self.thisMonthBtn.setTitle(UIAlertAction.title, for: .normal)
            self.dbFilter = "yesterday"
            self.getDashBoardData()
        
        }))
        alert.addAction(UIAlertAction(title: "Today", style: .default , handler:{ (UIAlertAction)in
            self.thisMonthBtn.setTitle(UIAlertAction.title, for: .normal)
            self.dbFilter = "today"
            self.getDashBoardData()
        }))
        alert.addAction(UIAlertAction(title: "Previous Month", style: .default , handler:{ (UIAlertAction)in
            self.thisMonthBtn.setTitle(UIAlertAction.title, for: .normal)
            self.dbFilter = "previousMonth"
            self.getDashBoardData()
        }))
        alert.addAction(UIAlertAction(title: "Current Month", style: .default, handler:{ (UIAlertAction)in
            self.thisMonthBtn.setTitle(UIAlertAction.title, for: .normal)
            self.dbFilter = "currentMonth"
            self.getDashBoardData()
          }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))        
        self.present(alert, animated: true, completion: {
            
        })
    }
    @IBAction func goToInvoiceScreen(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "InoviceVC") as! InoviceVC
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    
    @IBAction func getDashBoardData(){
       
        if Reachability.isConnectedToNetwork() == true {
            var dashBoardData: Dictionary<String,String>
            dashBoardData = ["summaryDetails" : dbFilter , "userId": "\(defaults.string(forKey: "userId")!)"]
            
            self.showDashBoardData.getDashboardDatafromRemote(dashBoardData){ (issuccess, error) -> Void in
                if((issuccess) != nil){
                    self.count.removeAll()
                    let dashboardresult = issuccess!["data"] as! NSArray
                    let dict = dashboardresult[0] as! NSDictionary
                  
                    // Done Data
                    let DoneData = dict.value(forKey: "Done") as! NSDictionary
                    let DoneDataCount = DoneData.value(forKey: "count")
                    let DoneQty = "\(DoneDataCount!)"
                    self.count.append(DoneQty)
                   
                    // Pending Data
                    let PendingData = dict.value(forKey: "Pending") as! NSDictionary
                    let PendingDataCount = PendingData.value(forKey: "count")
                    let PendingQty = "\(PendingDataCount!)"
                    self.count.append(PendingQty)
                    
                    // Damaged Data
                    let DamagedData = dict.value(forKey: "Damaged") as! NSDictionary
                    let DamagedDataCount = DamagedData.value(forKey: "count")
                    let DamagedQty = "\(DamagedDataCount!)"
                    self.count.append(DamagedQty)
                    
                    // Partial Data
                    let PartialData = dict.value(forKey: "Partial") as! NSDictionary
                    let PartialDataCount = PartialData.value(forKey: "count")
                    let PartialQty = "\(PartialDataCount!)"
                    self.count.append(PartialQty)
                  
                    // set count of invoice in label
                    self.emptyArray = self.count.map { Int($0)!}  // convert string array to int array
                    let sumOfInoviceCount = self.emptyArray.reduce(0) { $0 + $1 } // sum of array
                    self.getSumOfCountInString = "\(sumOfInoviceCount)"  // convert int value to String
                    self.showTotalInoviceCount.text = self.getSumOfCountInString  // set value in label
 
                    // reload collection data
                    self.dashboardCollectionview.reloadData()
                }else{
                    KAppDelegate.showNotification("incorrect")
                }
            }
        }else{
            KAppDelegate.showNotification("No Internet Connection")
        }
    
    }
    
    @IBAction func logoutAction(_ sender: Any) {
        let logoutVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC")
        self.navigationController?.pushViewController(logoutVC, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
