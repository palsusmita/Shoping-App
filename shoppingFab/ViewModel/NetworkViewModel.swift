//
//  NetworkViewModel.swift
//  shoppingFab
//
//  Created by susmita on 30/06/24.
//

import Foundation
import Alamofire

class NetworkViewModel {
    
    var productList: [ProductModel] = []
    var categoryList: [CategoryModel] = []
    var product: ProductData?
    var filteredProductList: [ProductModel] = []
    // fetch all products
    func fetchProducts(completion: @escaping () -> Void) {
        guard let url = URL(string: K.Network.baseURL) else {
            print("Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching products: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                let productData = try JSONDecoder().decode([ProductData].self, from: data)
                self.productList = productData.map { data in
                    ProductModel(id: data.id, title: data.title, price: Float(data.price), image: data.image, rate: Float(data.rating.rate), category: data.category, description: data.description, count: data.rating.count)
                }
                DispatchQueue.main.async {
                    completion()
                }
            } catch let error {
                print("Decoding error: \(error)")
            }
        }
        
        task.resume()
    }
    // fetch list of categories
    func fetchCategories(completion: @escaping () -> Void) {
        AF.request(K.Network.categoriesURL).response { response in
            switch response.result {
            case .success(let data):
                do {
                    let categories = try JSONDecoder().decode([String].self, from: data!)
                    self.categoryList = categories.map { CategoryModel(category: $0) }
                    completion()
                } catch let error {
                    print(error)
                }
            case .failure(let error):
                print("error on fetchCategories func: \(error.localizedDescription)")
            }
        }
    }
    // fetch product detaills
    func fetchProductDetails(productId: Int, completion: @escaping () -> Void) {
        AF.request("\(K.Network.baseURL)/\(productId)").response { response in
            switch response.result {
            case .success(let data):
                do {
                    let productData = try JSONDecoder().decode(ProductData.self, from: data!)
                    self.product = productData
                    completion()
                } catch let error {
                    print("DECODING ERROR:", error)
                }
            case .failure(let error):
                print("NETWORK ERROR: ", error)
            }
        }
    }
    //fetch category product list
    func fetchCategoryProducts(category: String, completion: @escaping () -> Void) {
          AF.request("\(K.Network.categoryURL)/\(category)").response { response in
              switch response.result {
              case .success(let data):
                  do {
                      let productData = try JSONDecoder().decode([ProductData].self, from: data!)
                      self.filteredProductList = productData.map { data in
                          ProductModel(id: data.id, title: data.title, price: Float(data.price), image: data.image, rate: Float(data.rating.rate), category: data.category, description: data.description, count: data.rating.count)
                      }
                      completion()
                  } catch let error {
                      print("DECODING ERROR:", error)
                  }
              case .failure(let error):
                  print("NETWORK ERROR: ", error)
              }
          }
      }
}
