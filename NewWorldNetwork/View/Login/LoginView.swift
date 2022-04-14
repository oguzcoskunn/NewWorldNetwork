//
//  LoginView.swift
//  NewWorldNetwork
//
//  Created by Oğuz Coşkun on 23.08.2021.
//

import SwiftUI
import ToastSwiftUI

struct LoginView: View {
    @State private var loadingToast: Bool = false
    @State private var customErrorToast: Bool = false
    @State var email = ""
    @State var password = ""
    @EnvironmentObject var viewModel: AuthViewModel
    
    @State private var showFirebaseError: Bool = false
    @State private var fireBaseError = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    Image("NewWorldNetworkLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.main.bounds.width * 0.9)
                        .padding(.top, 88)
                        .padding(.bottom, 32)
                    
                    VStack(spacing: 20) {
                        CustomTextField(text: $email, placeholder: Text("Email"), imageName: "envelope")
                            .padding()
                            .background(Color(.init(white: 1, alpha: 0.15)))
                            .cornerRadius(10)
                            .foregroundColor(.white)
                        
                        CustomSecureField(text: $password, placeholder: Text("Password"))
                            .padding()
                            .background(Color(.init(white: 1, alpha: 0.15)))
                            .cornerRadius(10)
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 20)
                    .frame(width: 400)
                    
                    
//                    HStack {
//                        Spacer()
//
//                        Button(action: {}, label: {
//                            Text("Forgot Password?")
//                                .font(.footnote)
//                                .bold()
//                                .foregroundColor(.white)
//                                .padding(.top, 16)
//                                .padding(.trailing, 32)
//                        })
//                    }
                    
                    Button(action: {
                        self.viewModel.loadingNow = true
                        viewModel.login(withEmail: email, password: password)
                    }, label: {
                        Text("Sign In")
                            .font(.headline)
                            .foregroundColor(.black)
                            .frame(width: 360, height: 50)
                            .background(Color("NWorange"))
                            .clipShape(Capsule())
                            .padding()
                        
                    })
                                        
                    NavigationLink(
                        destination: RegistrationView()
                            .navigationBarBackButtonHidden(true)
                            .edgesIgnoringSafeArea(.all)
                            .background(Color("NWbackground").scaledToFill())
                            .phoneOnlyStackNavigationView()
                        ,
                        label: {
                            HStack {
                                Text("Don't have an account?")
                                    .font(.system(size: 14))
                                    .foregroundColor(.white)
                                
                                Text("Sign Up")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(Color("NWorange"))
                            }
                        })
                        .padding(.top, UIScreen.main.bounds.height * 0.03)
                    
                    NavigationLink(
                        destination: ResetPasswordView()
                            .edgesIgnoringSafeArea(.all)
                            .background(Color("NWbackground").scaledToFill())
                            .phoneOnlyStackNavigationView()
                        ,
                        label: {
                            HStack {
                                Text("Forgot password?")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(Color("NWorange"))
                            }
                        })
                        .padding(.top, UIScreen.main.bounds.height * 0.02)
                    
                    Spacer()
                }
            }
            .background(Color("NWbackground").scaledToFill())
            .ignoresSafeArea()
            .navigationTitle("")
        }
        .alert(isPresented: $customErrorToast) {
            Alert(title: Text("\(self.viewModel.customError)"),
                  dismissButton: .default(Text("OK")) {
                self.viewModel.customError = ""
            }
            )
        }
        .alert(isPresented: $showFirebaseError) {
                    Alert(title: Text("\(self.fireBaseError)"))
                }
        .onChange(of: self.viewModel.error?.localizedDescription) { newValue in
            if let newValue = newValue {
                if !newValue.isEmpty {
                    self.fireBaseError = newValue
                    self.showFirebaseError.toggle()
                    self.viewModel.error = nil
                }
            }
        }
        
        .onChange(of: self.viewModel.loadingNow, perform: { value in
            self.loadingToast = value
        })
        .toast(isPresenting: $loadingToast, message: "Loading", icon: .loading, backgroundColor: Color("NWgray"), autoDismiss: .after(5))
        .onChange(of: self.viewModel.customError, perform: { value in
            if !value.isEmpty {
                self.customErrorToast.toggle()
            }
        })
        
    }
}
