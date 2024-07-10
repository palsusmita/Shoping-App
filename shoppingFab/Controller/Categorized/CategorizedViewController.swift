import UIKit
import SDWebImage

class CategorizedViewController: UIViewController {
    
    //MARK: - Properties
    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    static var selectedCategory: String = ""
    private let viewModel = NetworkViewModel()
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewCellSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.filteredProductList = []
        fetchCategoryProducts(category: CategorizedViewController.selectedCategory)
        categoryNameLabelSetup(name: CategorizedViewController.selectedCategory)
    }
    
    //MARK: - Functions
    func tableViewCellSetup() {
        tableView.register(UINib(nibName: K.TableView.categorizedTableViewCell, bundle: nil), forCellReuseIdentifier: K.TableView.categorizedTableViewCell)
    }
    
    func categoryNameLabelSetup(name: String) {
        switch name {
        case "electronics":
            categoryNameLabel.text = "Electronics"
        case "jewelery":
            categoryNameLabel.text = "Jewelery"
        case "men's%20clothing":
            categoryNameLabel.text = "Men's clothing"
        case "women's%20clothing":
            categoryNameLabel.text = "Women's clothing"
        default:
            print("category name error")
        }
    }
    
    func changeVCCategoryToProductDetail(id: Int) {
        ProductDetailViewController.selectedProductID = id
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: K.Segues.productDetailViewController)
        show(vc, sender: self)
    }
    
    func fetchCategoryProducts(category: String) {
        viewModel.fetchCategoryProducts(category: CategorizedViewController.selectedCategory) { [weak self] in
                   DispatchQueue.main.async {
                       self?.tableView.reloadData()
                   }
               }
   }
}

//MARK: - Extensions
extension CategorizedViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredProductList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.TableView.categorizedTableViewCell, for: indexPath) as! CategorizedTableViewCell
        let u = viewModel.filteredProductList[indexPath.row]
        cell.productNameLabel.text = u.title
        cell.productDescriptionLabel.text = u.description
        cell.productRateLabel.text = "⭐️ \(u.rate!) "
        cell.productPriceLabel.text = "\(u.price!)$"
        cell.productImageView.sd_setImage(with: URL(string: u.image!), placeholderImage: UIImage(systemName: "photo"))
        return cell
    }
}

extension CategorizedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let productIdAtSelectedRow = viewModel.filteredProductList[indexPath.row].id {
            changeVCCategoryToProductDetail(id: productIdAtSelectedRow)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
