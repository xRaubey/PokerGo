//
//  RankeView.swift
//  Final
//
//  Created by Yuqing Yang on 5/3/23.
//

import SwiftUI

struct RankeView: View {
    
    var wins: Int
    var body: some View {
        VStack{
            if(self.wins<10){
                Image("rank-1")
                    .resizable()
            }
            else if(self.wins>=10 && self.wins<100){
                Image("rank-2")
                    .resizable()
            }
            else if(self.wins>=100 && self.wins<500){
                Image("rank-3")
                    .resizable()
            }
            else if(self.wins>=500 && self.wins<1000){
                Image("rank-4")
                    .resizable()
            }
            else if(self.wins>=1000 && self.wins<5000){
                Image("rank-5")
                    .resizable()
            }
            else{
                Image("rank-6")
                    .resizable()
            }
        }
        .frame(minWidth: 0, maxWidth: 35)
        .frame(minHeight: 0, maxHeight: 35)
        .padding()
    }
}

struct RankeView_Previews: PreviewProvider {
    static var previews: some View {
        RankeView(wins: 0)
    }
}
