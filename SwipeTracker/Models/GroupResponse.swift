//
//  GroupResponse.swift
//  SwipeTracker
//
//  Created by Praveen Pinjala on 5/14/23.
//

import Foundation

struct GetGroupResponse: Hashable, Decodable{
    
    struct LeaderBoard: Hashable, Decodable{
        let username: String
        let score: Int
        
        enum CodingKeys: String, CodingKey {
            case username = "Username"
            case score = "Score"
        }
    }
    
    let groupName: String
    let groupId: String
    let createdAt: String
    let groupTime: Int
//    let leaderBoard: String
    let createdBy: String
    let links: String
    
    enum CodingKeys: String, CodingKey {
        case groupName = "GroupName"
        case groupId = "GroupID"
        case createdAt = "CreatedAt"
        case groupTime = "GroupTime"
//        case leaderBoard = "LeaderBoard"
        case links = "Links"
        case createdBy = "CreatedBy"
    }
}
