
import UIKit
import Alamofire
import SDWebImage

class HomeViewController: UIViewController {
    
    //MARK: - Properties
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var productCollectionView: UICollectionView!
  
    private let viewModel = NetworkViewModel()
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionSetup()
        tabBarSetup()
        setupNotificationObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchCategories()
        fetchProducts()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        viewModel.categoryList = []
    }
    
    private func setupNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateCartBadge(_:)), name: .cartCountDidChange, object: nil)
    }
    @objc private func updateCartBadge(_ notification: Notification) {
        if let userInfo = notification.userInfo, let count = userInfo["count"] as? Int {
            if let tabBarItem = self.tabBarController?.tabBar.items?[1] {
                tabBarItem.badgeValue = "\(count)"
            }
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: .cartCountDidChange, object: nil)
    }
    //MARK: - Functions
    func fetchProducts() {
        viewModel.fetchProducts { [weak self] in
                   DispatchQueue.main.async {
                       self?.productCollectionView.reloadData()
                   }
               }
    }
    
    func fetchCategories() {
        viewModel.fetchCategories { [weak self] in
                    DispatchQueue.main.async {
                        self?.categoryCollectionView.reloadData()
                    }
                }
    }
    
    func tabBarSetup() {
        self.tabBarController?.navigationItem.hidesBackButton = true
        tabBarController!.tabBar.items?[1].badgeValue = "0"
    }
    
    //MARK: - CollectionCells Setup
    func collectionSetup() {
        categoryCollectionView.register(UINib(nibName: K.CollectionViews.topCollectionViewNibNameAndIdentifier, bundle: nil), forCellWithReuseIdentifier: K.CollectionViews.topCollectionViewNibNameAndIdentifier)
        
        categoryCollectionView.collectionViewLayout = TopCollectionViewColumnFlowLayout(columnNumber: 2, minColSpace: 5, minRowSpace: 5)
        
        
        productCollectionView.register(UINib(nibName: K.CollectionViews.bottomCollectionViewNibNameAndIdentifier, bundle: nil), forCellWithReuseIdentifier: K.CollectionViews.bottomCollectionViewNibNameAndIdentifier)
        
        productCollectionView.collectionViewLayout = BottomCollectionViewColumnFlowLayout(sutunSayisi: 2, minSutunAraligi: 5, minSatirAraligi: 5)
    }
    
    //MARK: - Functions
    func changeVCcategoryToTableView(category: String) {
        switch category {
            
        case "electronics":
            let cat = "electronics"
            CategorizedViewController.selectedCategory = cat
            
        case "jewelery":
            let cat = "jewelery"
            CategorizedViewController.selectedCategory = cat
            
        case "men's clothing":
            let cat = "men's%20clothing"
            CategorizedViewController.selectedCategory = cat
            
        case "women's clothing":
            let cat = "women's%20clothing"
            CategorizedViewController.selectedCategory = cat
            
        default:
            DuplicateFuncs.alertMessage(title: "Category Error", message: "", vc: self)
        }
        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: K.Segues.categoryTableView)
//        show(vc, sender: self)
        guard let navigationController = self.navigationController else {
            print("Error: Current view controller is not embedded in a navigation controller.")
            return
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: K.Segues.categoryTableView)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func changeVCHomeToProductDetail(id: Int) {
        ProductDetailViewController.selectedProductID = id
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: K.Segues.productDetailViewController)
        show(vc, sender: self)
    }
}

//MARK: - Extensions
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
            
        case categoryCollectionView:
            return viewModel.categoryList.count
            
        case productCollectionView:
            return viewModel.productList.count
            
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
            
        case categoryCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.CollectionViews.topCollectionViewNibNameAndIdentifier, for: indexPath) as! CategoriesCollectionViewCell
            let category = viewModel.categoryList[indexPath.row].category
            cell.categoryLabel.text = category?.capitalized
            
            switch category {
            case "electronics":
                cell.categoryImageView.image = UIImage(named: "electronics.png")
            case "jewelery":
                cell.categoryImageView.image = UIImage(named: "jewellery.png")
            case "men's clothing":
                cell.categoryImageView.image = UIImage(named: "men.png")
            case "women's clothing":
                cell.categoryImageView.image = UIImage(named: "women.png")
            default:
                cell.categoryImageView.image = UIImage(systemName: "questionmark.square.dashed")
            }
            return cell
            
        case productCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.CollectionViews.bottomCollectionViewNibNameAndIdentifier, for: indexPath) as! ProductsCollectionViewCell
            let u = viewModel.productList[indexPath.row]
            cell.productImageView.sd_setImage(with: URL(string: u.image!), placeholderImage: UIImage(systemName: "photo.on.rectangle.angled"))
            cell.productNameLabel.text = u.title
            cell.productRateLabel.text = "★ \(u.rate!) "
            cell.productPriceLabe.text = "$\(u.price!)"
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
}


extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
            
        case categoryCollectionView:
            if let category = viewModel.categoryList[indexPath.row].category {
            changeVCcategoryToTableView(category: category)
                        }
        case productCollectionView:
            if let idd = viewModel.productList[indexPath.row].id {
                changeVCHomeToProductDetail(id: idd)
            }
            
        default:
            print("")
        }
    }
}
