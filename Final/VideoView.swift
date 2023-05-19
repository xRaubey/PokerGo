//
//  VideoView.swift
//  Final
//
//  Created by Yuqing Yang on 5/1/23.
//

import SwiftUI

extension View{
    func toAnyView() -> AnyView{
        AnyView(self)
    }
}

struct VideoView: View {
    @Binding var tab: Tab
    
    @State var showLoading = false
    var body: some View {
        ScrollView{
            InstructionVideoView(showLoading: $showLoading )
                .overlay(showLoading ? LoadingView().toAnyView() : EmptyView().toAnyView())
                .frame(width: 300, height: 300)
                .padding()
        }
    }
}

struct VideoView_Previews: PreviewProvider {
    static var previews: some View {
        let t = Tab.second
        VideoView(tab: .constant(t))
    }
}
