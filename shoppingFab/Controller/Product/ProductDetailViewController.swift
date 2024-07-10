import UIKit
import SDWebImage

class ProductDetailViewController: UIViewController {
    
    //MARK: - Properties
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var productSalesCount: UILabel!
    @IBOutlet weak var productRate: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    
    static var selectedProductID: Int  = 0
    private let viewModel = NetworkViewModel()

    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCategoryProducts(selectedId: ProductDetailViewController.selectedProductID)
    }
    
    //MARK: - Interaction handlers
    @IBAction func addBasketButtonClicked(_ sender: UIButton) {
        if let productImage = self.productImage {
            CoreDataManager.shared.saveCartProduct(productId: Int64(ProductDetailViewController.selectedProductID), productImage: productImage, productPrice: productPrice.text!, productQuantity: 1, productTitle: productTitle.text!)
            }
    }
    
    func fetchCategoryProducts(selectedId: Int) {
        viewModel.fetchProductDetails(productId: ProductDetailViewController.selectedProductID) { [weak self] in
                  guard let self = self, let productData = self.viewModel.product else { return }
                  DispatchQueue.main.async {
                      self.productImage.sd_setImage(with: URL(string: productData.image), placeholderImage: UIImage(systemName: "photo"))
                      self.productRate.text = "⭐️\(productData.rating.rate)"
                      self.productPrice.text = "$\(productData.price)"
                      self.productTitle.text = productData.title
                      self.productDescription.text = productData.description
                      self.productSalesCount.text = "\(productData.rating.count) sold"
                  }
              }
    }
}
