
import Foundation
import CoreData
import UIKit

class UsersDatabase {
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Coredata_curs7")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print(error)
            }
        })
        return container
    }()
    
    init() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(saveContext),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
    }
    
    @objc
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print(error)
            }
        }
    }
    
    func add(users: [User]) {
         users.forEach { user in
            let entityDescription = NSEntityDescription.insertNewObject(
                forEntityName: "UserEntity",
                into: persistentContainer.viewContext
            )
            entityDescription.setValue(user.id, forKey: "id")
            entityDescription.setValue(user.name, forKey: "name")
        }
        saveContext()
    }
    
    func getUsers() -> [User] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserEntity")
        do {
            if let result = try persistentContainer.viewContext.fetch(fetchRequest) as? [NSManagedObject] {
                return result.map { nsManagedObject in
                    User(
                        id: nsManagedObject.value(forKey: "id") as? Int ?? 0,
                        name: nsManagedObject.value(forKey: "name") as? String ?? ""
                    )
                }
            } else {
                return []
            }
        } catch {
            return []
        }
    }
    
    func removeUser(id: Int) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserEntity")
        do {
            if let result = try persistentContainer.viewContext.fetch(fetchRequest) as? [NSManagedObject] {
                if let objectForDelete = result.first(where: { nsManagedObject in
                    (nsManagedObject.value(forKey: "id") as? Int) == id
                }) {
                    persistentContainer.viewContext.delete(objectForDelete)
                    saveContext()
                }
            }
        } catch {
            print(error)
        }
    }
    
    func removeAllUsers() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserEntity")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try persistentContainer.viewContext.execute(batchDeleteRequest)
            saveContext()
        } catch {
            print(error)
        }
    }
    
    func editUser(id: Int, newName: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserEntity")
        do {
            if let result = try persistentContainer.viewContext.fetch(fetchRequest) as? [NSManagedObject] {
                if let objectForEdit = result.first(where: { nsManagedObject in
                    (nsManagedObject.value(forKey: "id") as? Int) == id
                }) {
                    objectForEdit.setValue(newName, forKey: "name")
                    saveContext()
                }
            }
        } catch {
            print(error)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
