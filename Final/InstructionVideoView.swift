//
//  InstructionVideoView.swift
//  Final
//
//  Created by Shao-Peng Yang on 5/1/23.
//

import SwiftUI
import WebKit

struct InstructionVideoView: UIViewRepresentable {
    
    @Binding var showLoading: Bool
    
    func makeUIView(context: Context) ->  WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        let videoURL = URL(string: "https://www.youtube.com/watch?v=5JhP6Y2J_y0")
        let request = URLRequest(url: videoURL!)
        webView.load(request)
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {

    }
    
    func makeCoordinator() -> WebViewCoordinator {
        WebViewCoordinator(didStart: {
            print("Start Loading")
            showLoading = true
        },didFinished: {
            print("Done Loading")
            showLoading = false
        })
    }
}

class WebViewCoordinator: NSObject, WKNavigationDelegate{
    
    var didStart: () -> Void
    var didFinished: () -> Void
    
    init(didStart: @escaping () -> Void, didFinished: @escaping () -> Void) {
        self.didStart = didStart
        self.didFinished = didFinished
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        didStart()
    }
    
    func webView(_ webVIew: WKWebView, didFinish navigation: WKNavigation!){
        didFinished()
    }
}

struct InstructionVideoView_Previews: PreviewProvider {
    static var previews: some View {
        InstructionVideoView(showLoading: .constant(false))
    }
}
