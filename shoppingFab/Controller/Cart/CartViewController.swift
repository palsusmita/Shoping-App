import UIKit
import SDWebImage

class CartViewController: UIViewController {
    
    //MARK: - Properties
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyCartView: UIView!
    
    private var totalCartCost: Double = 0
    private var cart: [String: Int]? = [:]
    private var isQuantityButtonTapped = false

  //  var cartItems: [CartProductModel] = []
    private let viewModel = CartViewModel()
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchItems()
        updateTotalCost()
        tableViewSetup()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        totalCartCost = 0
    }
    override func viewWillAppear(_ animated: Bool) {
        fetchItems()
    }
    
    //MARK: - Interaction handlers
    @IBAction func checkoutButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: K.Segues.checkOutViewController, sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Segues.checkOutViewController {
            if let checkOutVC = segue.destination as? CheckOutViewController {
                if let price = totalPriceLabel.text {
                    checkOutVC.totalItemsPrice = price
                }
            }
        }
    }
    //MARK: - Functions
    func tableViewSetup() {
        tableView.register(UINib(nibName: K.TableView.cartTableViewCell, bundle: nil), forCellReuseIdentifier: K.TableView.cartTableViewCell)
//        tableView.rowHeight = CGFloat(160)
    }
    
    func cartBadge(count: Int) {
        NotificationCenter.default.post(name: .cartCountDidChange, object: nil, userInfo: ["count": count])
        if let tabBarController = self.tabBarController {
            if let tabBarItem = tabBarController.tabBar.items?[1] {
                tabBarItem.badgeValue = "\(count)"
            }
        }
    }
    func fetchItems(){
        viewModel.fetchItems { [weak self] in
              guard let self = self else { return }
              for cartItem in self.viewModel.cartItems {
                  print("Product ID: \(cartItem.productId), Quantity: \(cartItem.productQuantity)")
              }
              DispatchQueue.main.async {
                  self.updateTotalCost()
                  self.tableView.reloadData()
                  self.emptyCartView.isHidden = !self.viewModel.cartItems.isEmpty
                  print("UI updated")
              }
          }
    }

    @objc func minusButtonTapped(_ sender: UIButton) {
        if isQuantityButtonTapped {
            return
        }
        isQuantityButtonTapped = true
        
        let index = sender.tag
        if viewModel.cartItems[index].productQuantity > 1 {
                    viewModel.cartItems[index].productQuantity -= 1
                }
        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        updateTotalCost()
        CoreDataManager.shared.updateCartProduct(productId: viewModel.cartItems[index].productId, productQuantity: viewModel.cartItems[index].productQuantity)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.isQuantityButtonTapped = false
        }
    }

    @objc func plusButtonTapped(_ sender: UIButton) {
        if isQuantityButtonTapped {
            return
        }
        isQuantityButtonTapped = true
        
        let index = sender.tag
        viewModel.cartItems[index].productQuantity += 1
        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        updateTotalCost()
        CoreDataManager.shared.updateCartProduct(productId: viewModel.cartItems[index].productId, productQuantity: viewModel.cartItems[index].productQuantity)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.isQuantityButtonTapped = false
        }
    }
}

//MARK: - Extensions
extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.cartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.TableView.cartTableViewCell, for: indexPath) as! CartTableViewCell
        let u = viewModel.cartItems[indexPath.row]
        cell.productImageView.image = u.productImage
        cell.productPriceLabel.text = "\(u.productPrice)"
        cell.productTitleLabel.text = u.productTitle
        cell.productQuantity.text = "\(String(describing: u.productQuantity))"
        
        cell.plusButton.tag = indexPath.row
        cell.plusButton.addTarget(self, action: #selector(plusButtonTapped(_:)), for: .touchUpInside)
        
        cell.minusButton.tag = indexPath.row
        cell.minusButton.addTarget(self, action: #selector(minusButtonTapped(_:)), for: .touchUpInside)
        
        return cell
    }
}

extension CartViewController: UITableViewDelegate {
    //Disable cell click behavior
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
          if editingStyle == .delete {
              let productId = viewModel.cartItems[indexPath.row].productId
              CoreDataManager.shared.deleteCartProduct(withProductId: productId)

              // Remove the item from the local array and update the table view
              viewModel.cartItems.remove(at: indexPath.row)
              tableView.deleteRows(at: [indexPath], with: .fade)
              updateTotalCost()
          }
      }
    func updateTotalCost() {
        totalCartCost = viewModel.cartItems.reduce(0) { total, item in
            let priceString = item.productPrice.replacingOccurrences(of: "[^0-9.]", with: "", options: .regularExpression)
            let price = Double(priceString) ?? 0.0
            let quantity = Double(item.productQuantity)
            print("Item: \(item.productTitle), Price: \(price), Quantity: \(quantity), Subtotal: \(price * quantity)")
            return total + (price * quantity)
        }
        print("Total Cart Cost: \(totalCartCost)")
        let formattedTotalCartCost = String(format: "%.2f", totalCartCost)
        totalPriceLabel.text = "$\(formattedTotalCartCost)"
        cartBadge(count: viewModel.cartItems.count)
    }
}
