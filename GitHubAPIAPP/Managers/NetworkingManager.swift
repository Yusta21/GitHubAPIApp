
import Foundation

enum GHError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
    case invalidUser
}

class NetworkManager: ObservableObject {
    @Published var githubUsers: [GitHubUser] = []
    @Published var followers: [GitHubFollower] = []
    @Published var repos: [GitHubRepo] = []
    static let urlString = "https://api.github.com/users/"
    
    @MainActor
    func getUsers(api: String, user: String) async throws {
        let endpoint = api + user
        
        guard let url = URL(string: endpoint) else {
            throw GHError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw GHError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let user = try decoder.decode(GitHubUser.self, from: data)
                githubUsers = [user]
            } catch {
                throw GHError.invalidData
            }
        case 404:
            throw GHError.invalidUser
        default:
            throw GHError.invalidResponse
        }
    }
    
    @MainActor
    func getFollowers(followerApi: String) async throws {
        guard let url = URL(string: followerApi) else {
            throw GHError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw GHError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                followers = try decoder.decode([GitHubFollower].self, from: data)
            } catch {
                throw GHError.invalidData
            }
        default:
            throw GHError.invalidResponse
        }
    }
    
    @MainActor
    func getRepos(reposApi: String) async throws {
        guard let url = URL(string: reposApi) else {
            throw GHError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw GHError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                repos = try decoder.decode([GitHubRepo].self, from: data)
            } catch {
                throw GHError.invalidData
            }
        default:
            throw GHError.invalidResponse
        }
    }
}
