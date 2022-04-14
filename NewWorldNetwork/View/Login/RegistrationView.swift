//
//  RegistrationView.swift
//  NewWorldNetwork
//
//  Created by Oğuz Coşkun on 23.08.2021.
//

import SwiftUI
import ToastSwiftUI

struct RegistrationView: View {
    @State private var loadingToast: Bool = false
    @State private var customErrorToast: Bool = false
    
    @State private var showError: Bool = false
    @State private var errorText = ""
    
    @State private var isChecked: Bool = false
    @State private var isChecked2: Bool = false
    
    @State private var value: CGFloat = 0
    
    @State var email = ""
    @State var password = ""
    @State var passwordAgain = ""
    @State var fullname = ""
    @State var username = ""
    @State var showImagePicker = false
    @State var selectedUIImage: UIImage?
    @State var image: Image?
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @EnvironmentObject var viewModel: AuthViewModel
    
    func loadImage() {
        guard let selectedImage = selectedUIImage else { return }
        image = Image(uiImage: selectedImage)
    }
    
    var body: some View {
        ScrollView {
            VStack {
                VStack {
                    Button(action: { showImagePicker.toggle() }, label: {
                        ZStack {
                            if let image = image {
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipped()
                                    .cornerRadius(70)
                                    .padding(.bottom, 16)
                            } else {
                                Image("plus_photo")
                                    .resizable()
                                    .renderingMode(.template)
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .padding(.bottom, 16)
                                    .foregroundColor(Color("NWorange"))
                            }
                        }
                        .padding(.top, UIScreen.main.bounds.height * 0.06)
                    })
                    .sheet(isPresented: $showImagePicker, onDismiss: loadImage, content: {
                        ImagePicker(image: $selectedUIImage)
                    })
                    
                    VStack(spacing: 20) {
                        CustomTextField(text: $email, placeholder: Text("Email"), imageName: "envelope")
                            .padding(.horizontal)
                            .padding(.vertical, 10)
                            .background(Color(.init(white: 1, alpha: 0.15)))
                            .cornerRadius(10)
                            .foregroundColor(.white)
                        
                        CustomTextField(text: $fullname, placeholder: Text("Full Name"), imageName: "person")
                            .padding(.horizontal)
                            .padding(.vertical, 10)
                            .background(Color(.init(white: 1, alpha: 0.15)))
                            .cornerRadius(10)
                            .foregroundColor(.white)
                        
                        CustomTextField(text: $username, placeholder: Text("Username"), imageName: "person")
                            .padding(.horizontal)
                            .padding(.vertical, 10)
                            .background(Color(.init(white: 1, alpha: 0.15)))
                            .cornerRadius(10)
                            .foregroundColor(.white)
                        
                        CustomSecureField(text: $password, placeholder: Text("Password"))
                            .padding(.horizontal)
                            .padding(.vertical, 10)
                            .background(Color(.init(white: 1, alpha: 0.15)))
                            .cornerRadius(10)
                            .foregroundColor(.white)
                        CustomSecureField(text: $passwordAgain, placeholder: Text("Password Again"))
                            .padding(.horizontal)
                            .padding(.vertical, 10)
                            .background(Color(.init(white: 1, alpha: 0.15)))
                            .cornerRadius(10)
                            .foregroundColor(.white)
                    }
                    .font(.system(size: 14))
                    .frame(width: 360)
                }
                //.padding(.horizontal, 30)
                
                Group {
                    HStack(alignment: .center) {
                        Button {
                            self.isChecked.toggle()
                        } label: {
                            Image(systemName: isChecked ? "checkmark.square.fill": "square")
                        }
                        .foregroundColor(Color("NWorange"))
                        .font(.system(size: 25))
                        
                        
                        Link(destination: URL(string: "https://newworldnetworkoguzcoskun.tr.gg/End_user-License-Agreement.htm")!) {
                            Group {
                                Text("I've read the") + Text(" 'Terms of Use'").bold() + Text(" and") + Text(" 'End-user License Agreement'").bold() + Text(" I accept.")
                            }
                            .foregroundColor(.white)
                        }.buttonStyle(FlatLinkStyle())
                        
                        
                        Spacer()
                    }
                    .frame(height: 35)

                    HStack(alignment: .center) {
                        Button {
                            self.isChecked2.toggle()
                        } label: {
                            Image(systemName: isChecked2 ? "checkmark.square.fill": "square")
                        }
                        .foregroundColor(Color("NWorange"))
                        .font(.system(size: 25))
                        
                        Link(destination: URL(string: "https://newworldnetworkoguzcoskun.tr.gg/")!) {
                            Group {
                                Text("I've read the") + Text(" 'Privacy Policies'").bold() + Text(" and I accept.")
                            }
                            .foregroundColor(.white)
                        }.buttonStyle(FlatLinkStyle())

                        Spacer()
                    }
                }
                .padding(.top, 10)
                .font(.system(size: 12))
                .padding(.horizontal, 35)
                .frame(width: 400)
                
                Button(action: {
                    if !email.isEmpty && !fullname.isEmpty && !username.isEmpty && !password.isEmpty && !passwordAgain.isEmpty {
                        if checkForIllegalCharacters(string: username) {
                            self.errorText = "You can't use space or special character in your username!"
                            self.showError.toggle()
                        } else {
                            if password == passwordAgain {
                                if let currentImage = selectedUIImage {
                                    if !isChecked || !isChecked2 {
                                        self.errorText = "Please indicate that you have read and agree to the Terms of Use, EULA, and Privacy Policy."
                                        self.showError.toggle()
                                        return
                                    }
                                    self.viewModel.loadingNow = true
                                    viewModel.registerUser(email: email, password: password, username: username, fullname: fullname, profileImage: currentImage)
                                } else {
                                    self.errorText = "Choose a photo!"
                                    self.showError.toggle()
                                }
                            } else {
                                self.errorText = "Your passwords are not matching!"
                                self.showError.toggle()
                            }
                        }
                    } else {
                        self.errorText = "All areas must be filled!"
                        self.showError.toggle()
                    }
                    
                }, label: {
                    Text("Sign Up")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.black)
                        .padding(.vertical,7)
                        .frame(width: 150)
                        .background(Color("NWorange"))
                        .clipShape(Capsule())
                    
                })
                    .padding(.top, 20)
                                    
                Button(action: { mode.wrappedValue.dismiss() }, label: {
                    HStack {
                        Text("Already have an account?")
                            .font(.system(size: 14))
                            .foregroundColor(.white)
                        
                        Text("Sign In")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color("NWorange"))
                    }
                })
                    .padding(.top, UIScreen.main.bounds.height * 0.03)
                Spacer()
            }
            Color("NWbackground")
                .frame(height: self.value * 1.3)
        }
        .navigationBarHidden(true)
        .background(Color("NWbackground"))
        .onAppear {
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { noti in
                let value = noti.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
                let height = value.height
                
                self.value = height-20
            }
            
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { noti in
                self.value = 0
            }
        }
        .onChange(of: self.viewModel.loadingNow, perform: { value in
            self.loadingToast = value
        })
        .onChange(of: self.viewModel.customError, perform: { value in
            if !value.isEmpty {
                self.customErrorToast.toggle()
            }
        })
        .onChange(of: self.viewModel.error?.localizedDescription) { newValue in
            if let newValue = newValue {
                if !newValue.isEmpty {
                    self.errorText = newValue
                    self.showError.toggle()
                }
            }
        }
        .alert(isPresented: $customErrorToast) {
                    Alert(title: Text("\(self.viewModel.customError)"))
                }
        .alert(isPresented: $showError) {
            Alert(title: Text("\(self.errorText)"),
                  dismissButton: .default(Text("OK")) {
                self.viewModel.error = nil
            }
            )
        }
    }
}

struct ViewOffsetKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}

func checkForIllegalCharacters(string: String) -> Bool {
    let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_-.")
    if string.rangeOfCharacter(from: characterset.inverted) != nil {
        return true
    } else {
        return false
    }
}
