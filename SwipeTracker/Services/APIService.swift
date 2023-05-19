//
//  APIService.swift
//  SwipeTracker
//
//  Created by Praveen Pinjala on 5/13/23.
//

import Foundation

import Foundation

class APIManager {
    static let shared = APIManager()

//    private let SWIPE_SERVICE: String = "http://ec2-18-191-253-123.us-east-2.compute.amazonaws.com:8080"
    private let SWIPE_SERVICE: String = "http://localhost:8080"
    private let GROUP_SERVICE: String = "http://localhost:8083"
    private let TRACKING_SERVICE: String = "https://api.example.com"
    private var service = "com.pin.SwipeTracker" // Unique service identifier for your app

    private init() {}
    
    func getBaseURL(appChoice: String) -> String{
        switch appChoice {
        case "SWIPE_SERVICE" : return SWIPE_SERVICE
        case "GROUP_SERVICE": return GROUP_SERVICE
        case "TRACKING_SERVICE": return TRACKING_SERVICE
        default: return SWIPE_SERVICE
        }
    }
    
    func makeRequest<T: Decodable>(baseURL: String, endpoint: String, method: String, parameters: [String: Any]?, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: getBaseURL(appChoice: baseURL) + endpoint) else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        print("Parameters:",parameters)
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        guard let accessToken = getAuthTokenFromKeychain() else {return}
        print("Fetching auth token from keychain:",accessToken)

        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        if let parameters = parameters {
            let jsonData = try? JSONSerialization.data(withJSONObject: parameters,options: .prettyPrinted)
            request.httpBody = jsonData
        }
        
        DispatchQueue.global().async {
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(APIError.noData))
                    return
                }
                
                do {
                    print("rea",request.value(forHTTPHeaderField: "Authorization"),T.self)
//                    do {
//                            let json = try JSONSerialization.jsonObject(with: data, options: [])
//                        print("json: ",json)
//                            if let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
//                               let jsonString = String(data: jsonData, encoding: .utf8) {
//                                print("JSON String: \(jsonString)")
//                            }
//                        } catch {
//                            print("Error converting Data to JSON: \(error)")
//                        }
                    
                    print("**************************Completed**************************")
                    let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                    
                    completion(.success(decodedResponse))
                } catch {
                    completion(.failure(error))
                }
            }
            
            task.resume()
        }
    }
    
    func saveAuthTokenToKeychain(_ token: String) {

        if let data = token.data(using: .utf8) {
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrService as String: service,
                kSecValueData as String: data,
                kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked
            ]

            // Delete any existing token before saving the new one
            SecItemDelete(query as CFDictionary)

            // Add the new token to the Keychain
            let status = SecItemAdd(query as CFDictionary, nil)
            if status != errSecSuccess {
                print("Failed to save auth token to Keychain")
            }
        }
    }

    func removeAuthTokenFromKeychain() {

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service
        ]

        // Delete the auth token from the Keychain
        let status = SecItemDelete(query as CFDictionary)
        if status != errSecSuccess {
            print("Failed to remove auth token from Keychain")
        }
    }

    func getAuthTokenFromKeychain() -> String? {

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnData as String: true
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        if status == errSecSuccess, let data = result as? Data {
            return String(data: data, encoding: .utf8)
        } else {
            print("Failed to retrieve auth token from Keychain")
            return nil
        }
    }
}

enum APIError: Error {
    case invalidURL
    case noData
}
