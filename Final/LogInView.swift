//
//  LogInView.swift
//  Final
//
//  Created by Yuqing Yang on 3/31/23.
//

import SwiftUI
import Firebase

struct BStyle: ButtonStyle{
    
    func makeBody(configuration: Self.Configuration) -> some View {
        
         return configuration.label.scaleEffect(configuration.isPressed ? 0.9 : 1)
            .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct LogInView: View {
    
    
    @EnvironmentObject var login: LoginModel
    @EnvironmentObject var signupModel: SignUpModel
    
    @EnvironmentObject var userInfo: UserInfoModel
    @EnvironmentObject var locationViewModel : LocationViewModel
    
    @State var username: String = ""
    @State var psw: String = ""
    @State var remember: Bool = false
    //    @State var login: Bool = false;
    
    @State var signup: Bool = false;
    
    @State var wonrPasw: Bool = false
    
    
    var body: some View {
        
        if(login.getSession() == true) {
            ContentView()
                .environmentObject(login)
                .environmentObject(userInfo)
                .environmentObject(locationViewModel)
        }
        else{
            
            if(login.loginLoading == true){
                LoadingView()
            }
            else{
                NavigationStack{
                    ScrollView{
                        Image("title")
                            .resizable()
                            .frame(minWidth: 0, maxWidth: 500)
                            .aspectRatio(contentMode: .fit)
                            .padding()
//                        Text("Poker Go")
//                            .font(.title)
//                            .bold()
                        TextField("Email", text: $username)
                            .padding(15)
                            .overlay(
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(self.wonrPasw ? Color.red : Color.cyan, lineWidth: 1)
                            )
                            .frame(maxWidth: 400)
                            .padding(1)
                            .animation(.easeIn(duration: 1.5), value: wonrPasw)
                        
                        SecureField("Password", text: $psw)
                            .padding(15)
                            .overlay(
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(self.wonrPasw ? Color.red : Color.cyan, lineWidth: 1)
                            )
                            .frame(maxWidth: 400)
                            .padding(1)
                            .animation(.easeIn(duration: 1.5), value: wonrPasw)
                        
                        
                        Spacer()
                            .frame(height: 50)
                        
                        VStack{
                            Toggle(isOn: $remember) {
                                        Text("Remember Me")
                                    }
                                    .toggleStyle(.button)

                            Button (action: {
                                self.wonrPasw  = false
                                
                                login.loginLoading = true
                                Auth.auth().signIn(withEmail: username, password: psw){ (user, error) in
                                    if error != nil {
                                        login.loginLoading = false
                                        self.wonrPasw = true
                                        print("error!")
                                    }
                                    else {
                                        login.loginLoading = false
                                        if (remember){
                                            UserDefaults.standard.set(remember, forKey: "Remember")
                                            UserDefaults.standard.set(username, forKey: "Username")
                                            UserDefaults.standard.set(psw, forKey: "Password")
                                        }else{
                                            UserDefaults.standard.removeObject(forKey: "Remember")
                                            UserDefaults.standard.removeObject(forKey: "Username")
                                            UserDefaults.standard.removeObject(forKey: "Password")

                                        }
                                        psw = ""
                                        userInfo.getUserImage(uid: user?.user.uid ?? "unknown id")
                                        userInfo.getUserName(uid: user?.user.uid ?? "unknow id")
                                        userInfo.getUserWins(uid: user?.user.uid ?? "unknow id")
                                        
                                        login.logIn(uid: user?.user.uid ?? "unknown id")
                                    }
                                }
                            } ) {
                                Text("Log In")
                                    .frame(minWidth: 0, maxWidth: 400)
                                    .padding(15)
                                    .foregroundColor(.white)
                                    .background(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)), Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1))]), startPoint: .leading, endPoint: .trailing))
                                    .cornerRadius(40)
                                    .font(.system(size: 20, design: .rounded))
                                    .bold()
                                    .padding(.top, 15)
                            }
                            .buttonStyle(BStyle())
                            
                            
                            Button (action: { signup = true} ) {
                                Text("Sign Up")
                                    .frame(minWidth: 0, maxWidth: 400)
                                    .padding(15)
                                    .foregroundColor(.white)
                                    .background(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1)), Color(#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1))]), startPoint: .leading, endPoint: .trailing))
                                    .cornerRadius(40)
                                    .font(.system(size: 20, design: .rounded))
                                    .bold()
                                    .padding(.top, 15)
                            }
                            .navigationDestination(isPresented: $signup){
                                SignUpView()
                                    .environmentObject(signupModel)
                            }
                            .buttonStyle(BStyle())
                            
                        }
                    }
                    
                    .padding()
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                .onAppear{
                    remember = UserDefaults.standard.bool(forKey: "Remember")
                    username = UserDefaults.standard.string(forKey: "Username") ?? ""
                    psw = UserDefaults.standard.string(forKey: "Password") ?? ""
                }
            }
            
        }
    }
    
}

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
            .environmentObject(HTTP())
    }
}
