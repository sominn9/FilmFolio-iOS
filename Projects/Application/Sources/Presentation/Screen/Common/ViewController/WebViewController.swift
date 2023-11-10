//
//  WebViewController.swift
//  FilmFolio
//
//  Created by 신소민 on 10/23/23.
//

import WebKit
import Foundation

final class WebViewController: BaseViewController {
    
    // MARK: Properties
    
    private lazy var webView: WKWebView = {
        let configuration = WKWebViewConfiguration()
        configuration.defaultWebpagePreferences.allowsContentJavaScript = true
        configuration.preferences.javaScriptCanOpenWindowsAutomatically = true
        let webView = WKWebView(frame: .zero, configuration: configuration)
        return webView
    }()
    
    private var url: URL
    
    
    // MARK: Initializing
    
    init(_ url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        load()
    }
    
    func layout() {
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.bottom.equalTo(view.snp.bottom)
        }
    }
    
    func load() {
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
}
