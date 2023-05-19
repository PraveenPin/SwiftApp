//
//  ContentView.swift
//  SwipeTracker
//
//  Created by Praveen Pinjala on 5/13/23.
//

import SwiftUI
import Combine

final class SignUpViewModel: ObservableObject {
    
  // Input values from View
    @Published var userName  = ""
    @Published var userEmail = ""
    @Published var userPassword = ""
    @Published var userRepeatedPassword = ""
  
  // Output subscribers
  @Published var formIsValid = false
  
  private var publishers = Set<AnyCancellable>()
  
  init() {
    isSignupFormValidPublisher
      .receive(on: RunLoop.main)
      .assign(to: \.formIsValid, on: self)
      .store(in: &publishers)
  }
}

// MARK: - Setup validations
private extension SignUpViewModel {
    
  var isUserNameValidPublisher: AnyPublisher<Bool, Never> {
    $userName
      .map { name in
          return name.count >= 5
      }
      .eraseToAnyPublisher()
  }
  
  var isUserEmailValidPublisher: AnyPublisher<Bool, Never> {
    $userEmail
      .map { email in
          let emailPredicate = NSPredicate(format:"SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
          return emailPredicate.evaluate(with: email)
      }
      .eraseToAnyPublisher()
  }
  
  var isPasswordValidPublisher: AnyPublisher<Bool, Never> {
    $userPassword
      .map { password in
          return password.count >= 8
      }
      .eraseToAnyPublisher()
  }
  
  
  var passwordMatchesPublisher: AnyPublisher<Bool, Never> {
    Publishers.CombineLatest($userPassword, $userRepeatedPassword)
      .map { password, repeated in
          return password == repeated
      }
      .eraseToAnyPublisher()
  }
  
  var isSignupFormValidPublisher: AnyPublisher<Bool, Never> {
    Publishers.CombineLatest4(
      isUserNameValidPublisher,
      isUserEmailValidPublisher,
      isPasswordValidPublisher,
      passwordMatchesPublisher)
      .map { isNameValid, isEmailValid, isPasswordValid, passwordMatches in
          return isNameValid && isEmailValid && isPasswordValid && passwordMatches
      }
      .eraseToAnyPublisher()
  }
}

struct CreateAccountView: View {
    
    @ObservedObject private var viewModel: SignUpViewModel
    @State var signUpSuccess = false
      
    init(viewModel: SignUpViewModel = SignUpViewModel()) {
      self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
          Form {
            Section {
              TextField("Name", text: $viewModel.userName)
              TextField("Email", text: $viewModel.userEmail)
                            .keyboardType(.emailAddress)
              SecureField("Password", text: $viewModel.userPassword)
              SecureField("Repete the Password", text: $viewModel.userRepeatedPassword)
            }
            
            Button("Sign Up") {
                createAccount()
            }
            .alert(signUpSuccess ? "Sign Up Successful" : "Sign Up Failed", isPresented: $signUpSuccess) {
                Button("Click to Home Screen", role: .cancel) {
                    
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.black)
            .foregroundColor(.white)
            .opacity(buttonOpacity)
            .disabled(!viewModel.formIsValid)
          }
        }
      }
      
      var buttonOpacity: Double {
        return viewModel.formIsValid ? 1 : 0.5
      }
}

extension CreateAccountView{
    func createAccount(){
        let apiManager = APIManager.shared
        
        var postData:[String:Any] = [
            "username":viewModel.userName,
            "email": viewModel.userEmail,
            "password": viewModel.userPassword,
            "totaltime": 0.0,
            "creationdate": getCurrentTimestamp()
        ]
        
//        print("PostData",postData)
        
        apiManager.makeRequest(baseURL: "SWIPE_SERVICE", endpoint: "/signup", method: "POST", parameters: postData) { (result: Result<UserSignUpResponse, Error>) in
            // Handle the result of the API request
            switch result {
            case .success(let resp):
                // Handle the successful response
                print(resp)
                signUpSuccess = true
            case .failure(let error):
                // Handle the error
                print(error)
            }
        }
        
    }
}

struct Previews_HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        CreateAccountView()
    }
}


