//
//  DataModel.swift
//  GitHubAPIAPP
//
//  Created by Noel H. Yusta on 8/6/24.
//

import Foundation


struct GitHubUser: Codable {
    let avatarUrl: String
    let login: String
    let followersUrl: String
    let reposUrl: String
    let bio: String
}


struct GitHubFollower: Codable {
    let login: String
    let avatarUrl: String
}


struct GitHubRepo: Codable {
    let name: String
}
