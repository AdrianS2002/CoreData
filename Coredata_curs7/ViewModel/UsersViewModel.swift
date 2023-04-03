

import Foundation

protocol UsersViewModelDelegate: AnyObject {
    func usersAreLoading()
    func usersAreLoaded()
    func usersHaveError(error: Error)
}

class UsersViewModel {
    
    private let usersMangers = UsersManager.shared
    weak var delegate: UsersViewModelDelegate?
    
    private(set) var users: [User]?
    
    func getUsers() {
        delegate?.usersAreLoading()
        usersMangers.getUsers { [weak self] users, error in
            guard let self else {return}
            if let error {
                self.delegate?.usersHaveError(error: error)
            } else if let users {
                self.users = users
                self.delegate?.usersAreLoaded()
            }
        }
    }
    
    func refresh() {
        delegate?.usersAreLoading()
        usersMangers.refresh { [weak self] users, error in
            guard let self else {return}
            if let error {
                self.delegate?.usersHaveError(error: error)
            } else if let users {
                self.users = users
                self.delegate?.usersAreLoaded()
            }
        }
    }
    
    func deleteUser(id: Int) {
        usersMangers.deleteUser(id: id)
        getUsers()
    }
    
    func editUser(id: Int, newName: String) {
        usersMangers.editUser(id: id, newName: newName)
        getUsers()
    }
}
