//
//  UserData.swift
//  shoppingFab
//
//  Created by susmita on 30/06/24.
//

import Foundation
import CoreData
import UIKit

@objc(UserData)
public class UserData: NSManagedObject {
}

extension UserData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserData> {
        return NSFetchRequest<UserData>(entityName: "UserData")
    }

    @NSManaged public var name: String?
    @NSManaged public var mail: String?
    @NSManaged public var address: String?
    @NSManaged public var password: String?

}
