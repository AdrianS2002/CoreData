
import UIKit

protocol UserTableCellDelegate: AnyObject {
    func deleteUser(id: Int)
    func editUser(id: Int)
}

class UserTableCell: UITableViewCell {

    @IBOutlet weak private var nameLabel: UILabel!
    
    weak var delegate: UserTableCellDelegate?
    private var user: User!
    
    func configure(user: User) {
        self.user = user
        nameLabel.text = user.name
    }
    
    @IBAction func onEditPressed(_ sender: Any) {
        delegate?.editUser(id: user.id)
    }
    
    @IBAction private func onDeletePressed(_ sender: Any) {
        delegate?.deleteUser(id: user.id)
    }
    
}
