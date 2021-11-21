//
//  Context.swift
//  FilipeJessicaCarol
//
//  Created by Filipe Pereira Colaquecez on 18/11/21.
//

import UIKit
import CoreData

extension NSObject {
    var context: NSManagedObjectContext {
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        return appdelegate.persistentContainer.viewContext
    }
}

