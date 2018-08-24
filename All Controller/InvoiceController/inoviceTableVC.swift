
import UIKit

class inoviceTableVC: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    @IBOutlet var showAllData: UIView!
    
    @IBOutlet var showInvoiceDate: UILabel!
    @IBOutlet var invoiceDealerStatus: UIButton!
    @IBOutlet var invoiceTrpdStatus: UIButton!
    @IBOutlet var invoiceQty: UILabel!
    @IBOutlet var inoviceNoLbl: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
     
}
