
import UIKit

class InvoiceDetailsTableVC: UITableViewCell {
    var onButtonTapped : (() -> Void)? = nil
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet var inoviceRemarksLbl: UILabel!
    @IBOutlet var invoicePODBtn: UIButton!
    @IBOutlet var invoiceReceivedQtyLbl: UILabel!
    @IBOutlet var invoiceQtyLbl: UILabel!
    @IBOutlet var invoiceMaterialLbl: UILabel!
    @IBOutlet var invoiceDetailView: UIView!
    
    
    @IBAction func podButtonclicked(_ sender: UIButton) {
        if let onButtonTapped = self.onButtonTapped {
            onButtonTapped()
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
