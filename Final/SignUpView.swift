//
//  SignUpView.swift
//  Final
//
//  Created by Yuqing Yang on 4/3/23.
//

import SwiftUI
import Firebase


struct signupData{
    let email: String
    let username: String
    let image: UIImage
    let psw: String
}

struct SignUpView: View {
    
    @EnvironmentObject var login: LoginModel
    @EnvironmentObject var signup: SignUpModel
    
    @State var email: String = ""
    @State var account: String = ""
    @State var psw: String = ""
    @State var confirm: String = ""
    @State var same: Bool = true
    @State var info: String = ""
    @State private var image = UIImage()
    @State private var showSheet = false
    @State private var done: Bool = true
    
    //    var ref: DatabaseReference! = Database.database().reference()
    
    
    var body: some View {
        VStack{
            if(self.done == false){
                LoadingView()
            }
            else{
                ScrollView{
                    Image(uiImage: self.image)
                        .resizable()
                        .cornerRadius(50)
                        .padding(.all, 4)
                        .frame(width: 100, height: 100)
                        .background(Color.white.opacity(0.2))
                        .aspectRatio(contentMode: .fill)
                        .clipShape(Circle())
                        .padding(8)
                    Text("Change photo")
                        .frame(minWidth: 0, maxWidth: 410)
                        .padding()
                        .foregroundColor(.white)
                        .background(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.262745098, green: 0.0862745098, blue: 0.8588235294, alpha: 1)), Color(#colorLiteral(red: 0.5647058824, green: 0.462745098, blue: 0.9058823529, alpha: 1))]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(40)
                        .font(.system(size: 20, design: .rounded))
                        .bold()
                        .foregroundColor(.white)
                        .onTapGesture {
                            showSheet = true
                        }
                        .sheet(isPresented: $showSheet) {
                            ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image)
                        }
                    
                    Text("New Account")
                        .font(.title)
                        .padding()
                    
                    TextField("Email", text: $email)
                        .padding(15)
                        .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(Color.cyan, lineWidth: 1)
                        )
                        .frame(maxWidth: 400)
                        .padding(1)
                    
                    TextField("UserName", text: $account)
                        .padding(15)
                        .overlay(
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(Color.cyan, lineWidth: 1)
                        )
                        .frame(maxWidth: 400)
                        .padding(1)
                    
                    TextField("Password", text: $psw)
                        .padding(15)
                        .overlay(
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(Color.cyan, lineWidth: 1)
                        )
                        .frame(maxWidth: 400)
                        .padding(1)
                    
                    TextField("Confirm Password", text: $confirm)
                        .padding(15)
                        .overlay(
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(Color.cyan, lineWidth: 1)
                        )
                        .frame(maxWidth: 400)
                        .padding(1)
                    
                    Text(info)
                        .padding()
                    
                    Button {
                        
                        let data:signupData = signupData(email: email, username: account, image: image, psw: psw)
                        if(psw == confirm && psw != ""){
                            self.done = false
                            self.signup.createUser(data: data)
                            self.info = signup.info
                            self.email = ""
                            self.account = ""
                            self.psw = ""
                            self.confirm = ""
                        }
                        else{
                            info = "Doesn't match!"
                            self.done = true
                        }
                        
                    } label: {
                        Text("Done")
                            .frame(minWidth: 0, maxWidth: 410)
                            .padding()
                            .foregroundColor(.white)
                            .background(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1)), Color(#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1))]), startPoint: .leading, endPoint: .trailing))
                            .cornerRadius(40)
                            .font(.system(size: 20, design: .rounded))
                            .bold()
                    }
                    .buttonStyle(BStyle())
                }
                .padding()
            }
        }
        .onAppear{
            image = UIImage(systemName: "person.circle")!
            self.info = ""
        }
        .onReceive(signup.$info){ info in
            self.info = info
        }
        .onReceive(signup.$done){ done in
            self.done = done
            
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
