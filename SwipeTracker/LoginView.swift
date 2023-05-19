//
//  LoginView.swift
//  SwipeTracker
//
//  Created by Praveen Pinjala on 5/13/23.
//

import Foundation
import SwiftUI
import Auth0

struct LoginView: View {
    
    @State private var isAuthenticated = false
    @State var userProfile = Profile.empty
    
    let apiManager = APIManager.shared
    
    
    let clientId = "x6wao4Kk3h8YPQ1kEO6wvSrBsWVY9eHZ"
    let domain = "dev-1fjzeag2i8t5jnxs.us.auth0.com"
    let audience = "https://pin-swipe-group/"
    
    
    
    var body: some View {
          
        if isAuthenticated {
          
          VStack {
            
            Text("You’re logged in!")
              .modifier(TitleStyle())
      
            UserImage(urlString: userProfile.picture)
            
            VStack {
              Text("Name: \(userProfile.name)")
              Text("Email: \(userProfile.email)")
            }
            .padding()
            
            Button("Log out") {
              logout()
            }
            .buttonStyle(MyButtonStyle())
            
          } // VStack
        
        } else {
          
          // “Logged out” screen
          // ------------------
          // When the user is logged out, they should see:
          //
          // - The title text “SwiftUI Login Demo”
          // - The ”Log in” button
          
          VStack {
            
            Text("SwiftUI Login demo")
              .modifier(TitleStyle())
            
            Button("Log in") {
              login()
            }
            .buttonStyle(MyButtonStyle())
            
          } // VStack
          
        } // if isAuthenticated
        
      } // body
    
    // MARK: Custom views
      // ------------------
      
      struct UserImage: View {
        // Given the URL of the user’s picture, this view asynchronously
        // loads that picture and displays it. It displays a “person”
        // placeholder image while downloading the picture or if
        // the picture has failed to download.
        
        var urlString: String
        
        var body: some View {
          AsyncImage(url: URL(string: urlString)) { image in
            image
              .frame(maxWidth: 128)
          } placeholder: {
            Image(systemName: "person.circle.fill")
              .resizable()
              .scaledToFit()
              .frame(maxWidth: 128)
              .foregroundColor(.blue)
              .opacity(0.5)
          }
          .padding(40)
        }
      }
      
      
      // MARK: View modifiers
      // --------------------
      
      struct TitleStyle: ViewModifier {
        let titleFontBold = Font.title.weight(.bold)
        let navyBlue = Color(red: 0, green: 0, blue: 0.5)
        
        func body(content: Content) -> some View {
          content
            .font(titleFontBold)
            .foregroundColor(navyBlue)
            .padding()
        }
      }
      
      struct MyButtonStyle: ButtonStyle {
        let navyBlue = Color(red: 0, green: 0, blue: 0.5)
        
        func makeBody(configuration: Configuration) -> some View {
          configuration.label
            .padding()
            .background(navyBlue)
            .foregroundColor(.white)
            .clipShape(Capsule())
        }
      }
}

extension LoginView {

    
    func login() {
        
      Auth0
            .webAuth()
        .audience("https://pin-swipe-group/")
        .scope("openid profile email offline_access")
        .start { result in
          switch result {
            case .failure(let error):
              print("Failed with: \(error)")

            case .success(let credentials):
              self.isAuthenticated = true
              self.userProfile = Profile.from(credentials.idToken)
              print("Credentials: \(credentials)")
              print("ID token: \(credentials.idToken)")
              print("Access token: \(credentials.accessToken)")
              apiManager.saveAuthTokenToKeychain(credentials.accessToken)

              var groupId: String = "Ftftndi2jUtmnXhJsLJo56"
              var username: String = "praveenpin-4"
              var getData:[String:Any] = [
                  "username": username,
                  "groupId": groupId
              ]

              print("type of getData:",type(of: getData))

              apiManager.makeRequest(baseURL: "GROUP_SERVICE", endpoint: "/getGroup", method: "POST", parameters: getData){ (result: Result<GetGroupResponse, Error>) in
                  // Handle the result of the API request
                  switch result {
                  case .success(let resp):
                      // Handle the successful response
                      print(resp)
                  case .failure(let error):
                      // Handle the error
                      print(error)
                  }
              }
          }
        }
    }
  
  func logout() {
    Auth0
      .webAuth()
      .clearSession { result in
        switch result {
          case .success:
            self.isAuthenticated = false
            self.userProfile = Profile.empty
            apiManager.removeAuthTokenFromKeychain()
          case .failure(let error):
            print("Failed with: \(error)")
        }
      }
  }
  
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
