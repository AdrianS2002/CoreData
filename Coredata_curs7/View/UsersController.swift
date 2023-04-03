

import Foundation
import UIKit

class UsersController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    
    private let viewModel = UsersViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideLoader()
        tableView.delegate = self
        tableView.dataSource = self
        viewModel.delegate = self
        viewModel.getUsers()
    }
    
    private func showLoader() {
        activityIndicatorView.isHidden = false
        activityIndicatorView.startAnimating()
    }
    
    private func hideLoader() {
        activityIndicatorView.stopAnimating()
        activityIndicatorView.isHidden = true
    }
    
    @IBAction private func onRefreshPressed() {
        viewModel.refresh()
    }
}

extension UsersController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.users?.count ?? 0
        
//        if let users = viewModel.users {
//            return users.count
//        } else {
//            return 0
//        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserTableCell", for: indexPath) as! UserTableCell
        cell.configure(user: viewModel.users![indexPath.row])
        cell.delegate = self
        return cell
    }
}

extension UsersController: UserTableCellDelegate {
    func deleteUser(id: Int) {
        viewModel.deleteUser(id: id)
    }
    
    func editUser(id: Int) {
        let alertController = UIAlertController(
            title: "Edit user",
            message: "Insert new name",
            preferredStyle: .alert
        )
        
        alertController.addTextField { textField in
            textField.placeholder = "Name"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let editAction = UIAlertAction(
            title: "Edit",
            style: .default) { [weak self] _ in
                guard let self else {return}
                let name = alertController.textFields?[0].text ?? ""
                if name.isEmpty == false {
                    self.viewModel.editUser(id: id, newName: name)
                }
            }
        
        alertController.addAction(cancelAction)
        alertController.addAction(editAction)
        present(alertController, animated: true)
    }
}

extension UsersController: UsersViewModelDelegate {
    func usersAreLoading() {
        showLoader()
    }
    
    func usersAreLoaded() {
        hideLoader()
        tableView.reloadData()
    }
    
    func usersHaveError(error: Error) {
        // TODO: HANDLE ERROR
    }
}

/*
 Traseul informatiei atunci cand stergem un user:
 Table Cell ->(prin delegat) Controller -> ViewModel (aici se face si refresh dupa ce se sterge user-ul) -> UsersManager -> Userdatabase
 
 
 */
