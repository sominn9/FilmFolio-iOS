//
//  ReviewViewController.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/08/14.
//

import Resource
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
    
    @Inject private var reviewViewModel: ReviewViewModel
    private lazy var textView = UITextView()
    private let disposeBag = DisposeBag()
    
    
    // MARK: Initializing
    
    init(review: Review) {
        self._reviewViewModel = Inject(argument: review)
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
        textViewPlaceholder()
    }
    
    
    // MARK: Methods
    
    private func configure() {
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
        
        guard let barButton = navigationItem.rightBarButtonItem else { return }
        
        let input = ReviewViewModel.Input(
            text: textView.rx.text.asObservable()
                .compactMap { $0 }
                .filter { $0 != Text.placeholder },
            saveButtonPressed: barButton.rx.tap.asObservable()
        )
        
        let output = reviewViewModel.transform(input)
        
        output.title
            .bind(to: navigationItem.rx.title)
            .disposed(by: disposeBag)
        
        output.content
            .subscribe(onNext: { [weak self] in
                if $0.isEmpty {
                    self?.textView.text = ReviewViewController.Text.placeholder
                    self?.textView.textColor = .gray
                } else {
                    self?.textView.text = $0
                    self?.textView.textColor = .label
                }
            })
            .disposed(by: disposeBag)
        
        barButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
   
    }
    
    private func textViewPlaceholder() {
        textView.rx.didBeginEditing
            .subscribe(with: self, onNext: { owner, _ in
                if owner.textView.text == ReviewViewController.Text.placeholder {
                    owner.textView.text = ""
                    owner.textView.textColor = .label
                }
            })
            .disposed(by: disposeBag)
        
        textView.rx.didEndEditing
            .subscribe(with: self, onNext: { owner, _ in
                if owner.textView.text.isEmpty {
                    owner.textView.text = ReviewViewController.Text.placeholder
                    owner.textView.textColor = .gray
                }
            })
            .disposed(by: disposeBag)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textView.resignFirstResponder()
    }
    
}
