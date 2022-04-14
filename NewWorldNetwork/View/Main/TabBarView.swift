//
//  TabBarView.swift
//  NewWorldNetwork
//
//  Created by Oğuz Coşkun on 14.09.2021.
//

import SwiftUI

struct TabBarView: View {
    @ObservedObject var viewModel = NotificationCountViewModel()
    
    @Binding var isShowingNewTweetView: Bool
    @Binding var isShowingNewMessageView: Bool
    @Binding var selectedIndex: Int
    
    let tabBarImageNames = ["house", "magnifyingglass", "plus.app.fill", "bell", "message"]
    let tabBarFillImageNames = ["house.fill", "magnifyingglass", "plus.app.fill", "bell.fill", "message.fill"]
    
    var body: some View {
        HStack {
            Spacer()
            ForEach(0..<5) { num in
                Group {
                    if num != 2 || ((selectedIndex == 0 || selectedIndex == 4 || selectedIndex == 5) && num == 2) {
                        Button(action: {
                            
                            if num == 2 {
                                if selectedIndex == 0 {
                                    isShowingNewTweetView.toggle()
                                    return
                                } else if selectedIndex == 4 {
                                    isShowingNewMessageView.toggle()
                                    return
                                } else if selectedIndex == 5 {
                                    isShowingNewMessageView.toggle()
                                    return
                                }
                            }
                            
                            selectedIndex = num
                        }, label: {
                            
                            if num == 2 {
                                if selectedIndex == 0 {
                                    Image(systemName: "plus.app.fill")
                                        .font(.system(size: 44, weight: .bold))
                                        .foregroundColor(Color("NWorange"))
                                } else if selectedIndex == 4 {
                                    Image(systemName: "plus.bubble.fill")
                                        .font(.system(size: 38, weight: .bold))
                                        .foregroundColor(Color("NWorange"))
                                } else if selectedIndex == 5 {
                                    Image(systemName: "person.fill.questionmark")
                                        .font(.system(size: 38, weight: .bold))
                                        .foregroundColor(Color("NWorange"))
                                }
                                
                            } else {
                                if num == 3 && viewModel.notificationCount > 0 && selectedIndex != num {
                                    ZStack {
                                        Image(systemName: "bell")
                                            .font(.system(size: 24))
                                            .foregroundColor(Color("NWgray"))
                                        Text("\(viewModel.notificationCount)")
                                            .foregroundColor(Color(.black))
                                            .scaledToFill()
                                            .frame(width: 17, height: 17)
                                            .background(Color("NWorange"))
                                            .clipped()
                                            .cornerRadius(56 / 2)
                                            .offset(x: 9,y:-9)
                                    }
                                } else if num == 4 && viewModel.messageNotificationCount > 0 && selectedIndex != num {
                                    ZStack {
                                        Image(systemName: "message")
                                            .font(.system(size: 24))
                                            .foregroundColor(Color("NWgray"))
                                        Text("\(viewModel.messageNotificationCount)")
                                            .foregroundColor(Color(.black))
                                            .scaledToFill()
                                            .frame(width: 17, height: 17)
                                            .background(Color("NWorange"))
                                            .clipped()
                                            .cornerRadius(56 / 2)
                                            .offset(x: 9,y:-9)
                                    }
                                }else {
                                    if selectedIndex == num {
                                        Image(systemName: tabBarFillImageNames[num])
                                            .font(.system(size: 24, weight: .bold))
                                            .foregroundColor(Color(.white))
                                    } else {
                                        Image(systemName: tabBarImageNames[num])
                                            .font(.system(size: 20))
                                            .foregroundColor(Color("NWgray"))
                                    }
                                }
                                
                            }
                        })
                    } else {
                        Button {
                            self.selectedIndex = 0
                        } label: {
                            Image("NWNLogo")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .padding(.horizontal, 14)
                        }.buttonStyle(FlatLinkStyle())
                    }
                }.frame(width: 24, height: 24)
                Spacer()
            }
        }
        .frame(width: UIScreen.main.bounds.width, height: 45)
        .padding(.vertical, 1)
        .padding(.bottom, 30)
    }
}

