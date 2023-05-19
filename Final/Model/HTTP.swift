//
//  Http.swift
//  Final
//
//  Created by Yuqing Yang on 3/29/23.
//

import Foundation
import SwiftUI

class HTTP: ObservableObject {

    
    @Published var account: Account = Account(id:0, account: "Default", psw: "Default", cards_id: nil);
    
    
    func getAccount(){
        guard let url = URL(string: "http://localhost/test.php") else {fatalError("Missing URL")}
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest){(data, response, error) in
            if let error = error{
                print("Request error:", error)
                return
            }
            
            guard let response = response as? HTTPURLResponse else {return}
            
            if response.statusCode == 200 {
                
               
                guard let data = data else {return}

                DispatchQueue.main.async {
                    
                    do{
                        let decodedAccount = try JSONDecoder().decode(Account.self, from: data)
                        self.account = decodedAccount
                        print(self.account);
                        
                    } catch let error {
                        print("Error decoding:", error)
                    }
                    
                }
            }
            
        }
        
        dataTask.resume()
    }
}
