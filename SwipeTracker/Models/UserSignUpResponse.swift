//
//  CustomResponse.swift
//  SwipeTracker
//
//  Created by Praveen Pinjala on 5/13/23.
//

import Foundation
//
//struct UserSignUpResponse: Decodable{
//    let Username: String
//    let Creationdate: String
//    let Email: String
//    let swipeData: Any?
//    let Totaltime: Double
//    let profilePic: String
//    let groups: Any?
//
//    enum CodingKeys: String, CodingKey {
//        case Username, Creationdate, Email, Totaltime
//    }
//
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        Username = try container.decode(String.self, forKey: .Username)
//        Creationdate = try container.decode(String.self, forKey: .Creationdate)
//        Email = try container.decode(String.self, forKey: .Email)
//        Totaltime = try container.decode(Double.self, forKey: .Totaltime)
//    }
//}
//
//struct CustomResponse: Decodable {
//    let error: String
//    let code: Int
//    let message: String
//    let response: UserSignUpResponse
//    let picture: String
//    let updatedAt: String
//
//    enum CodingKeys: String, CodingKey {
//        case error, code, message, response, picture, updatedAt
//    }
//
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        error = try container.decode(String.self, forKey: .error)
//        code = try container.decode(Int.self, forKey: .code)
//        message = try container.decode(String.self, forKey: .message)
//        response = try container.decode(UserSignUpResponse.self, forKey: .response)
//        picture = try container.decode(String.self, forKey: .picture)
//        updatedAt = try container.decode(String.self, forKey: .updatedAt)
//    }
//}
struct UserSignUpResponse: Hashable,Decodable {
    let username: String
    let creationDate: String
    let email: String
    let totalTime: Int
    let profilePic: String
    
    enum CodingKeys: String, CodingKey {
        case username = "Username"
        case creationDate = "Creationdate"
        case email = "Email"
        case totalTime = "Totaltime"
        case profilePic = "ProfilePic"
    }
}
