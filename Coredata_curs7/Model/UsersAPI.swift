

import Foundation

class UsersAPI {
    
    func getUsers(
        completionHandler: @escaping ([User]?, Error?) -> Void
    ) {
        let url = URL(string: "https://jsonplaceholder.typicode.com/users")!
        let urlRequest = URLRequest(url: url)
        let task = URLSession.shared.dataTask(
            with: urlRequest) { data, response, error in
                DispatchQueue.main.async {
                    if let error {
                        completionHandler(nil, error)
                    } else if let data {
                        do {
                            let users = try JSONDecoder().decode([User].self, from: data)
                            completionHandler(users, nil)
                        } catch {
                            completionHandler(nil, error)
                        }
                    } else {
                        let unknownError = MessageError(message: "Sth went wrong!")
                        completionHandler(nil, unknownError)
                    }
                }
            }
        task.resume()
    }
}

struct MessageError: Error {
    let message: String
}
