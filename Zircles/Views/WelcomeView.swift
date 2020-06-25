//
//  WelcomeView.swift
//  Zircles
//
//  Created by Francisco Gindre on 6/23/20.
//  Copyright © 2020 Electric Coin Company. All rights reserved.
//

import SwiftUI
import MnemonicSwift
struct WelcomeView: View {
    @State var username: String = ""
    @State var seedPhrase: String = ""
    @State var isWelcome = false
    var body: some View {
        ZStack {
            Color.background.edgesIgnoringSafeArea(.all)
            VStack(alignment: .leading, spacing: 16) {
                Spacer()
                Text("It looks like you are a new user, let's get to know you! What is your name?")
                    .fontWeight(.heavy)
                    .foregroundColor(Color.textDarkGray)
                    .frame(alignment: .leading)
                VStack(alignment: .leading, spacing: 3) {
                    Text("Name or Nickname")
                        .foregroundColor(.textLightGray)
                        .fontWeight(.heavy)
                        .font(.footnote)
                        .frame(alignment: .leading)
                    Card(isOn: .constant(true),cornerRadius: 5,padding: 8) {
                        
                        TextField("some title text", text: $username)
                            .foregroundColor(Color.textDarkGray)
                            .font(.system(size: 14, weight: .heavy, design: .default))
                        
                    }
                }.padding(.all, 0)
                Text("Import an existing Zcash wallet by entering the seed words of that wallet here")
                    .fontWeight(.heavy)
                    .foregroundColor(Color.textDarkGray)
                    .frame(alignment: .leading)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Existing Wallet Seed Phrase")
                        .foregroundColor(.textLightGray)
                        .fontWeight(.heavy)
                        .font(.footnote)
                        .frame(alignment: .leading)
                    Card(isOn: .constant(true),cornerRadius: 5,padding: 8) {
                    TextField("Existing Wallet Seed Phrase", text: $seedPhrase)
                        .foregroundColor(Color.textDarkGray)
                        .font(.system(size: 14, weight: .heavy, design: .default))
                    }
                }.padding(.all, 0)
                Spacer()
                Text("The Zircles app will only send ZEC to other Zircles app.")
                    .foregroundColor(.textLightGray)
                    .fontWeight(.heavy)
                    .font(.footnote)
                    .frame(alignment: .center)
                Spacer()
                Button(action: {
                    
                    self.isWelcome = true
                }) {
                    Text("Add Wallet to Zircles")
                        .font(.system(size: 20, weight: .bold, design: .default))
                        .shadow(color:Color(.sRGBLinear, red: 0.2, green: 0.2, blue: 0.2, opacity: 0.5), radius: 1, x: 0, y: 2)
                        .foregroundColor(Color.background)
                        .modifier(ZcashButtonBackground(buttonShape: .roundedCorners(fillStyle: .gradient(gradient: LinearGradient.zButtonGradient))))
                        
                        .shadow(color: Color(red: 0.2, green: 0.2, blue: 0.2).opacity(0.5), radius: 25, x: 10, y: 10)
                        .frame(height: 50)
                }.disabled(!validInput())
                NavigationLink(
                    destination: SplashScreen(),
                    isActive: $isWelcome,
                    label: {
                        EmptyView()
                    })
                
            }
            .padding([.horizontal,.bottom], 30)
            
            
        }.navigationBarTitle(Text("Welcome"))
    }
    
    
    func validInput() -> Bool {
        validSeedPhrase() && validName()
    }
    
    func validSeedPhrase() -> Bool {
        Mnemonic.validate(mnemonic: seedPhrase)
    }
    
    func validName() -> Bool {
        !username.isEmpty
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
