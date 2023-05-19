//
//  LoadingView.swift
//  Final
//
//  Created by Yuqing Yang on 5/2/23.
//

import SwiftUI

struct LoadingView: View {
    @State private var isLoading = false
    
    @State private var animationValue = true
    
    var body: some View {
        VStack{
            Circle()
                .trim(from: 0, to: 0.7)
                .stroke(Color.green, lineWidth: 3)
                .frame(width:70,height:70)
                .rotationEffect(Angle(degrees: isLoading ? 360: 0))
                .animation(Animation.easeInOut.repeatForever(autoreverses: false))
                .padding(8)
                .onAppear{
                    self.isLoading = true
                }
        }
        .background(.white)

    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
