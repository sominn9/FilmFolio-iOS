//
//  ReviewViewController.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/08/14.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit

final class ReviewViewController: BaseViewController {
    
    // MARK: Constants
    
    struct Metric {
        static let textViewInset: CGFloat = 16.0
        static let fontSize: CGFloat = 17.0
    }
    
    struct Text {
        static let placeholder = String(localized: "Write a review.")
    }
    
    
    // MARK: Properties
    
    private lazy var textView = UITextView()
    private let disposeBag = DisposeBag()
    private var reviewViewModel: ReviewViewModel
    
    
    // MARK: Initializing
    
    init(viewModel: ReviewViewModel) {
        self.reviewViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        bind()
    }
    
    
    // MARK: Methods
    
    private func configure() {
        textView.text = Text.placeholder
        textView.textColor = .gray
        textView.showsVerticalScrollIndicator = false
        textView.showsHorizontalScrollIndicator = false
        textView.font = .systemFont(ofSize: Metric.fontSize)
        view.addSubview(textView)
        
        textView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.snp.edges).inset(Metric.textViewInset)
        }
    }
    
    override func configureNavigationBar() {
        super.configureNavigationBar()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .save)
    }
    
    private func bind() {
        
        textView.rx.didBeginEditing
            .subscribe(with: self, onNext: { owner, _ in
                if owner.textView.text == type(of: owner).Text.placeholder {
                    owner.textView.text = ""
                    owner.textView.textColor = .label
                }
            })
            .disposed(by: disposeBag)
        
        textView.rx.didEndEditing
            .subscribe(with: self, onNext: { owner, _ in
                if owner.textView.text.isEmpty {
                    owner.textView.text = type(of: owner).Text.placeholder
                    owner.textView.textColor = .gray
                }
            })
            .disposed(by: disposeBag)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textView.resignFirstResponder()
    }
    
}
