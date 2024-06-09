//
//  SearchViewController.swift
//  GitHubAPIAPP
//
//  Created by Noel H. Yusta on 8/6/24.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {
   
    

    
    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var profileTableView: UITableView!
    
    
    var networkManager = NetworkManager()
    let apiIntial = "https://api.github.com/users/"
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        profileTableView.dataSource = self
        profileTableView.delegate = self
        profileTableView.isHidden = true
        generalConfigureButton(button: searchButton)
        addDoneButtonToKeyboard()
        
        
      //  searchBar.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
           
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        profileTableView.dataSource = self
        profileTableView.delegate = self
        
        generalConfigureButton(button: searchButton)
        addDoneButtonToKeyboard()
    }
    

    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        self.networkManager.githubUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let celda = tableView.dequeueReusableCell(withIdentifier: "profileTableViewCell", for: indexPath) as! profileTableViewCell
        
        celda.setValues(name: self.networkManager.githubUsers[indexPath.row].login, imageUrl: self.networkManager.githubUsers[indexPath.row].avatarUrl)
        
        celda.selectionStyle = .none
        print("generado celda")
        return celda
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let profileViewController: ProfileViewController = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        
        profileViewController.user = networkManager.githubUsers[indexPath.row]
        self.navigationController?.pushViewController(profileViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.layer.frame.height/3
    }
    

    func getUsers() async {
        
     
            do{
                try await networkManager.getUsers(api: apiIntial, user: self.searchBar.text ?? "")
                
                DispatchQueue.main.async {
                    
                    self.profileTableView.reloadData()
                    self.profileTableView.isHidden = false
                  //  """ser?.login
                    
                }
                
            }  catch let error as GHError {
                handleError(error, viewController: self)
            } catch {
                handleError(.invalidResponse, viewController: self)
            }
        }

    func addDoneButtonToKeyboard() {
           let toolbar = UIToolbar()
           toolbar.sizeToFit()
           
           let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissKeyboard))
           toolbar.setItems([doneButton], animated: false)
           
           searchBar.inputAccessoryView = toolbar
       }
    
    @objc func keyboardWillShow(_ notification: Notification) {
            guard let userInfo = notification.userInfo,
                  let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
                return
            }
            let keyboardHeight = keyboardFrame.size.height
            self.view.frame.origin.y = (-keyboardHeight + 195)
        }
        
        // Función para restaurar la posición de la vista cuando el teclado se oculta
    @objc func keyboardWillHide(_ notification: Notification) {
            self.view.frame.origin.y = 0
        }
    
    @objc func dismissKeyboard() {
            view.endEditing(true)
        }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        Task {
            await getUsers()
        }
    }
    
    @IBAction func searchPressed(_ sender: Any) {
        
        dismissKeyboard()
        
        Task { @MainActor in
            
            await self.getUsers()
        }
    }
    
}
