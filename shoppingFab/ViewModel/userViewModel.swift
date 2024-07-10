//
//  userViewModel.swift
//  shoppingFab
//
//  Created by susmita on 01/07/24.
//

import Foundation

class userViewModel {
    var userEmail = ""
    var userPassword = ""
    var userName = ""
    var userAddress = ""
    
    func fetchUserData(completion: @escaping (Bool) -> Void) {
        if let userData = CoreDataManager.shared.fetchUserData() {
            for user in userData {
                // Utilize fetched user data
                userEmail = user.mail ?? ""
                userPassword = user.password ?? ""
                userName = user.name ?? ""
                userAddress = user.address ?? ""
                UserDefaults.standard.set(true, forKey: "isLoggedIn")
                UserDefaults.standard.synchronize()
            }
            completion(true)
        } else {
            print("No user data found")
            completion(false)
        }
    }
}
