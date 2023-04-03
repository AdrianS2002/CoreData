

import Foundation

class UsersManager {
    
    static let shared = UsersManager()
    private let usersAPI = UsersAPI()
    private let usersDatabase = UsersDatabase()
    
    private init() {}
    
    func getUsers(
        completionHandler: @escaping ([User]?, Error?) -> Void
    ) {
        let usersFromDb = usersDatabase.getUsers()
        if usersFromDb.isEmpty == false {
            completionHandler(usersFromDb, nil)
        } else {
            usersAPI.getUsers { [weak self] users, error in
                guard let self else {return}
                if let users {
                    self.usersDatabase.removeAllUsers()
                    self.usersDatabase.add(users: users)
                }
                completionHandler(users, error)
            }
        }
        /*
         daca avem user in baza de date -> da ne userii
         daca nu -> fa call-ul, da-ne userii, salveaza -i pt datile urmatoare
         */
    }
    
    func refresh(
        completionHandler: @escaping ([User]?, Error?) -> Void
    ) {
        usersAPI.getUsers { [weak self] users, error in
            guard let self else {return}
            if let users {
                self.usersDatabase.removeAllUsers()
                self.usersDatabase.add(users: users)
            }
            completionHandler(users, error)
        }
    }
    
    func deleteUser(id: Int) {
        usersDatabase.removeUser(id: id)
    }
    
    func editUser(id: Int, newName: String) {
        usersDatabase.editUser(id: id, newName: newName)
    }
}
