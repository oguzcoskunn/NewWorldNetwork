//
//  ContentView.swift
//  NewWorldNetwork
//
//  Created by Oğuz Coşkun on 14.08.2021.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedIndex = 0
    @EnvironmentObject var viewModel: AuthViewModel
    @State var showSideBar: Bool = false
    @State var goProfile: Bool = false
    @State var user: User?
    
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.shadowColor = .clear
        appearance.backgroundColor = .clear
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        if viewModel.userSession != nil {
            
            if let currentUser = viewModel.user {
                SideBarStack(sidebarWidth: UIScreen.main.bounds.width * 0.7, showSidebar: $showSideBar) {
                    NavigationView {
                        SideBarContentView(user: currentUser, selectedIndex: $selectedIndex, showSideBar: $showSideBar, goProfile: $goProfile, goUser: $user)
                            .navigationBarHidden(true)
                            .navigationTitle("")
                            .edgesIgnoringSafeArea(.all)
                    }
                    
                } content: {
                    NavigationView {
                        ZStack {
                            if let user = self.user {
                                NavigationLink(
                                    destination: LazyView(UserProfileView(user: user, isActive: $goProfile)),
                                    isActive: $goProfile,
                                    label: {})
                            }
                            MainTabView(selectedIndex: $selectedIndex, showSidebar: $showSideBar)
                                .navigationBarHidden(true)
                                .navigationTitle("")
                                .phoneOnlyStackNavigationView()
                        }
                        
                    }
                }
                .phoneOnlyStackNavigationView()
                .edgesIgnoringSafeArea(.all)
            }
            
        } else {
            LoginView().phoneOnlyStackNavigationView()
        }
    }
    
    
}



extension View{
    func phoneOnlyStackNavigationView() ->some View{

        if UIDevice.current.userInterfaceIdiom == .phone{
            return AnyView(self)
        }else{
            return AnyView(self.navigationViewStyle(StackNavigationViewStyle()))
        }
    }
}
