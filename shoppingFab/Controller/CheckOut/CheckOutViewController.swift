
import UIKit

class CheckOutViewController: UIViewController {
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var itemsPrice: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var payButton: UIButton!
    var totalItemsPrice = ""
    private var viewModel = userViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAddress() 
        totalPrice.text = totalItemsPrice
        itemsPrice.text = totalItemsPrice
    }
    func fetchAddress(){
        viewModel.fetchUserData { success in
            if success {
                DispatchQueue.main.async {
                    self.addressLabel.text = self.viewModel.userAddress
                }
            } else {
                print("Failed to fetch user details")
            }
        }
    }
}
