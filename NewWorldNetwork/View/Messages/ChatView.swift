//
//  ChatView.swift
//  NewWorldNetwork
//
//  Created by Oğuz Coşkun on 15.08.2021.
//

import SwiftUI

struct ChatView: View {
    @State var isProfileViewActive: Bool = false
    let user: User
    @ObservedObject var viewModel: ChatViewModel
    @State var messageText : String = ""
    @State var value: CGFloat = 0
    @State var uploadedTweet = false
    @State private var showIntersitialAd : Bool = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var offset = CGFloat.zero
    
    init(user: User) {
        self.user = user
        self.viewModel = ChatViewModel(user: user)
    }
    
    
    var body: some View {
        NavigationView {
            VStack {
                HStack(spacing: 20) {
                    if let user = user {
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Image(systemName: "chevron.backward")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 18, height: 18)
                                .offset(x:-11)
                        })
                        NavigationLink(
                            destination: LazyView(UserProfileView(user: user, isActive: $isProfileViewActive)),
                            isActive: $isProfileViewActive,
                            label: {
                                AsyncImage(
                                    url: URL(string: user.profileImageUrl)!,
                                    placeholder: { ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color("NWorange"))) },
                                    image: { Image(uiImage: $0).resizable()}
                                )
                                    .scaledToFill()
                                    .clipped()
                                    .frame(width: 32, height: 32)
                                    .cornerRadius(16)
                                
                                VStack(alignment: .leading) {
                                    Text(user.fullname)
                                        .fontWeight(.bold)
                                        .foregroundColor(Color("NWorange"))
                                        .font(.system(size: 16))
                                    Text("@\(user.username)")
                                        .foregroundColor(Color("NWgray"))
                                        .font(.system(size: 14))
                                }
                            })
                        Spacer()
                    }
                }
                .padding(.vertical, 1)
                .padding(.horizontal, 15)
                .frame(width: UIScreen.main.bounds.width, height: 50)
                .padding(.top, 40)
                .background(Color("NWtoolbar"))
                
                ScrollView {
                    ScrollViewReader { scrollView in
                        VStack(alignment: .leading, spacing: 12) {
                            ForEach(viewModel.messages) { message in
                                MessageView(message: message)
                                    .id(message.id)
                            }
                        }
                        .padding(.top, 20)
                        .offset(y: -self.value)
                        .onChange(of: viewModel.messages.last?.id) { messages in
                            withAnimation {
                                if let lastId = viewModel.messages.last?.id {
                                    scrollView.scrollTo(lastId)
                                }
                                
                            }
                        }
                    }.background(GeometryReader {
                        Color.clear.preference(key: ViewOffsetKey.self,
                            value: -$0.frame(in: .named("scroll")).origin.y)
                    })
                    .onPreferenceChange(ViewOffsetKey.self) { offset = $0 }
                    
                }
                .coordinateSpace(name: "scroll")
                .padding(.vertical, 1)
                

                MessageInputView(messageText: $messageText, action: sendMessage)
                    .offset(y: -self.value)
            }
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
//            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("")
            .navigationBarHidden(true)
            .edgesIgnoringSafeArea(.all)
        }
        .phoneOnlyStackNavigationView()
        .presentInterstitialAd(isPresented: $showIntersitialAd, adUnitId: fullScreenAdKey)
        .onChange(of: self.viewModel.showChatAd) { newValue in
            if newValue {
                self.showIntersitialAd = true
            }
        }
        .onChange(of: self.showIntersitialAd) { newValue in
            if !newValue {
                self.viewModel.showChatAd = false
            }
        }
    }
    
    func sendMessage() {
        if !self.messageText.isEmpty {
            self.viewModel.sendMessage(messageText)
            messageText = ""
        }
    }
    
    struct ViewOffsetKey: PreferenceKey {
        typealias Value = CGFloat
        static var defaultValue = CGFloat.zero
        static func reduce(value: inout Value, nextValue: () -> Value) {
            value += nextValue()
        }
    }
}


