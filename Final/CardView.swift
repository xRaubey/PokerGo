//
//  CardView.swift
//  Final
//
//  Created by Yuqing Yang on 5/3/23.
//

import SwiftUI

struct CardView: View {
    
    @State var suit: String = ""
    @State var value: String = ""
    var card: Card = Card(id: "unknown", name: "unkonwn", value: "unknown")
    
    var body: some View {
        
        VStack{
            Image("\(value)_of_\(suit)")
                .resizable()
                .frame(minWidth: 0, maxHeight: 150)
                
        }
        .onAppear{
            
            switch card.name{
            case "Diamond":
                self.suit = "diamonds"
            case "Spade":
                self.suit = "spades"
            case "Club":
                self.suit = "clubs"
            default:
                self.suit = "hearts"
            }
            
            switch card.value{
            case "K":
                self.value = "king"
            case "Q":
                self.value = "queen"
            case "J":
                self.value = "jack"
            case "A":
                self.value = "ace"
            default:
                self.value = card.value
            }
            
        }
        .onChange(of: card){ newValue in
            
            print("new value = \(newValue)")
            switch newValue.name{
            case "Diamond":
                self.suit = "diamonds"
            case "Spade":
                self.suit = "spades"
            case "Club":
                self.suit = "clubs"
            default:
                self.suit = "hearts"
            }
            
            switch newValue.value{
            case "K":
                self.value = "king"
            case "Q":
                self.value = "queen"
            case "J":
                self.value = "jack"
            case "A":
                self.value = "ace"
            default:
                self.value = newValue.value
            }
            

        }
    }
        
    
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView()
    }
}
