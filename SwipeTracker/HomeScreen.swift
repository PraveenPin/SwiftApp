//
//  HomeScreen.swift
//  SwipeTracker
//
//  Created by Praveen Pinjala on 5/13/23.
//

import Foundation
import SwiftUI

struct ContentView: View{
    var body: some View {
            NavigationView {
                ZStack {
                    Color("BgColor").edgesIgnoringSafeArea(.all)
                    VStack {
//                        Spacer()
//                        Image(uiImage: #imageLiteral(resourceName: "onboard"))
//                        Spacer()
                HStack {
                    Text("New around here? ")
                    Text("Sign in")
                        .foregroundColor(Color("PrimaryColor"))
                }
                NavigationLink(
                    destination: CreateAccountView().navigationBarHidden(false),
                    label: {
                        Text("Get Started")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(Color.black)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .cornerRadius(50.0)
                            .shadow(color: Color.black.opacity(0.08), radius: 60, x: 0.0, y: 16)
                            .padding(.vertical)
                    })
                    .navigationBarHidden(true)
                HStack {
                    Text("Already a user? ")
                    Text("Sign in")
                        .foregroundColor(Color("PrimaryColor"))
                }
                NavigationLink(
                    destination: LoginView().navigationBarHidden(false),
                    label: {
                        Text("Sign In")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(Color.black)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .cornerRadius(50.0)
                            .shadow(color: Color.black.opacity(0.08), radius: 60, x: 0.0, y: 16)
                            .padding(.vertical)
                    })
                    .navigationBarHidden(true)
                        
                       
                    }
                    .padding()
                }
            }
        }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
