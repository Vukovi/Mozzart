//
//  WebView.swift
//  Mozzart
//
//  Created by Vuk Knezevic on 29.05.24.
//

import SwiftUI
import WebKit


struct LoadingWebView: View {
    
    @State private var isLoading = true
    @State private var error: Error? = nil
    let url: URL
    
    var body: some View {
        ZStack {
            if let error = error {
                Text(error.localizedDescription)
                    .foregroundColor(.kinoYellow)
            } else {
                WebView(url: url,
                        isLoading: $isLoading,
                        error: $error)
                .ignoresSafeArea()
                
                if isLoading {
                    ProgressView()
                }
                
            }
        }
    }
}

struct WebView: UIViewRepresentable {
    
    let url: URL
    @Binding var isLoading: Bool
    @Binding var error: Error?
    
    init(url: URL, isLoading: Binding<Bool>, error: Binding<Error?> = .constant(nil)) {
        self._isLoading = isLoading
        self._error = error
        self.url = url
    }
    
    func makeUIView(context: Context) -> WKWebView  {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
        webView.load(request)
        return webView
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(isLoading: $isLoading, error: $error)
    }
    
    
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        //
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        @Binding var isLoading: Bool
        @Binding var error: Error?
        
        init(isLoading: Binding<Bool>, error: Binding<Error?> = .constant(nil)) {
            self._isLoading = isLoading
            self._error = error
        }
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            isLoading = true
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            isLoading = false
        }
        
        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            print("loading error: \(error)")
            self.isLoading = false
            self.error = error
        }
        
    }
    
    
}
