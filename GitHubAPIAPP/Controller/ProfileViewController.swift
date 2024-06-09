//
//  ViewController.swift
//  GitHubAPIAPP
//
//  Created by Noel H. Yusta on 7/6/24.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var followersTableView: UITableView!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var reposTableView: UITableView!
    
    var networkManager = NetworkManager()
    var user: GitHubUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileName.text = user?.login
        loadImage(from: user!.avatarUrl)
        bioLabel.text = user?.bio
        followersTableView.dataSource = self
        followersTableView.delegate = self
        reposTableView.dataSource = self
        reposTableView.delegate = self
        followersTableView.isHidden = true
        reposTableView.isHidden = true
        
        Task { @MainActor in
            await self.getFollowers()
            await self.getRepos()
        }
        generalConfigureImage(image: userImageView)
        generalConfigureTableView(table: followersTableView)
                generalConfigureTableView(table: reposTableView)
        generalConfigureButton(button: backButton)
        bioLabel.adjustsFontSizeToFitWidth = true
        
                // para observar cambios en los traits
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == followersTableView {
            return networkManager.followers.count
        } else if tableView == reposTableView {
            return networkManager.repos.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == followersTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "profileTableViewCell", for: indexPath) as! profileTableViewCell
            cell.setValues(name: self.networkManager.followers[indexPath.row].login, imageUrl: self.networkManager.followers[indexPath.row].avatarUrl)
            cell.selectionStyle = .none
            return cell
        } else if tableView == reposTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "repoTableViewCell", for: indexPath) as! repoTableViewCell
            cell.setValues(name: self.networkManager.repos[indexPath.row].name)
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.layer.frame.height/3
    }
    
    func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.userImageView.image = image
                }
            }
        }
    }
    
    func getFollowers() async {
        do {
            try await networkManager.getFollowers(followerApi: user!.followersUrl)
            DispatchQueue.main.async {
                self.followersTableView.reloadData()
                self.followersTableView.isHidden = false
            }
        } catch let error as GHError {
            handleError(error, viewController: self)
        } catch {
            handleError(.invalidResponse, viewController: self)
        }
    }
    
    func getRepos() async {
        do {
            try await networkManager.getRepos(reposApi: user!.reposUrl)
            DispatchQueue.main.async {
                self.reposTableView.reloadData()
                self.reposTableView.isHidden = false
            }
        } catch let error as GHError {
            handleError(error, viewController: self)
        } catch {
            handleError(.invalidResponse, viewController: self)
        }
    }
    
    @IBAction func backPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    private func handleError(_ error: GHError, viewController: UIViewController) {
        var message = ""
        switch error {
        case .invalidURL:
            message = "URL inválida. Por favor, verifica la dirección."
        case .invalidResponse:
            message = "Respuesta inválida del servidor. Por favor, intenta nuevamente."
        case .invalidData:
            message = "Datos inválidos recibidos. Por favor, intenta nuevamente."
        case .invalidUser:
            message = "Usuario no encontrado."
        }
        showAlert(message: message, viewController: viewController)
    }
    
    private func showAlert(message: String, viewController: UIViewController) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            viewController.present(alertController, animated: true, completion: nil)
        }
    }
}


