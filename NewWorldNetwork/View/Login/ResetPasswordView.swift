//
//  ResetPasswordView.swift
//  NewWorldNetwork
//
//  Created by Oğuz Coşkun on 30.11.2021.
//

import SwiftUI
import ToastSwiftUI

struct ResetPasswordView: View {
    @State private var customErrorToast: Bool = false
    @State private var loadingToast: Bool = false
    @State var email = ""
    @EnvironmentObject var viewModel: AuthViewModel
    
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
                    }
                    .padding(.horizontal, 20)
                    .frame(width: 400)
                    
                    
                    Button(action: {
                        self.viewModel.loadingNow = true
                        viewModel.resetPassword(email: email)
                    }, label: {
                        Text("Send Password Reset")
                            .font(.headline)
                            .foregroundColor(.black)
                            .frame(width: 360, height: 50)
                            .background(Color("NWorange"))
                            .clipShape(Capsule())
                            .padding()
                        
                    })
                    
                    Spacer()
                }
                .padding(.top, 25)
            }
            .background(Color("NWbackground").scaledToFill())
            .ignoresSafeArea()
            .navigationTitle("")
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
        .alert(isPresented: $customErrorToast) {
            Alert(title: Text("\(self.viewModel.customError)"),
                  dismissButton: .default(Text("OK")) {
                self.viewModel.customError = ""
            }
            )
        }
    }
}
