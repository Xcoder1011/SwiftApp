//
//  BaseViewController.swift
//  SwiftApp
//
//  Created by KUN on 2023/12/6.
//

import Combine
import DZNEmptyDataSet
import RxCocoa
import RxSwift
import SnapKit
import SVProgressHUD
import SwiftUI
import UIKit

class BaseViewController: UIViewController, NavigatorProtocol {
    var viewModel: ViewModel?
    var navigator: Navigator!

    /// RxSwift
    let viewDidLoadSubject = PublishSubject<Void>()
    let isLoading = BehaviorRelay(value: false)

    let emptyDataSetButtonTap = PublishSubject<Void>()
    var emptyDataSetTitle = R.string.localizable.commonNoResults.key.localized()
    var emptyDataSetDescription = ""
    var emptyDataSetImage = R.image.empty()
    var emptyDataSetImageTintColor = BehaviorRelay<UIColor?>(value: nil)

    let languageChanged = BehaviorRelay<Void>(value: ())
    private var _disposeBag: DisposeBag?
    var disposeBag: DisposeBag {
        if let existingBag = _disposeBag {
            return existingBag
        }
        _disposeBag = viewModel?.disposeBag ?? DisposeBag()
        return _disposeBag!
    }

    /// Combine
    var cancellables = Set<AnyCancellable>()

    init(viewModel: ViewModel?, navigator: Navigator) {
        self.viewModel = viewModel
        self.navigator = navigator
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(nibName: nil, bundle: nil)
    }

    lazy var contentView: UIView = {
        let view = UIView(frame: self.view.bounds)
        self.view.addSubview(view)
        view.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        return view
    }()

    override func viewDidLoad() {
        makeUI()
        bindViewModel()

        /// RxSwift
        NotificationCenter.default.rx.notification(NSNotification.Name.SKLanguageChangeNotification).subscribe { [weak self] _ in
            self?.languageChanged.accept(())
        }.disposed(by: disposeBag)

        viewDidLoadSubject.onNext(())
        viewDidLoadSubject.onCompleted()
    }

    func makeUI() {
        contentView.backgroundColor = .white
    }

    func startAnimating() {
        SVProgressHUD.show()
    }

    func stopAnimating() {
        SVProgressHUD.dismiss()
    }

    func bindViewModel() {
        viewModel?.loading.asObservable().bind(to: isLoading).disposed(by: disposeBag)
        isLoading.subscribe(onNext: { [weak self] isLoading in
            isLoading ? self?.startAnimating() : self?.stopAnimating()
        }).disposed(by: disposeBag)

        languageChanged.subscribe(onNext: { [weak self] () in
            self?.emptyDataSetTitle = R.string.localizable.commonNoResults.key.localized()
        }).disposed(by: disposeBag)
    }

    deinit {
        cancellables.removeAll()
        logDebug("\(type(of: self)): Deinited")
    }
}

extension BaseViewController: DZNEmptyDataSetSource {
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        NSAttributedString(string: emptyDataSetTitle)
    }

    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        NSAttributedString(string: emptyDataSetDescription)
    }

    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        emptyDataSetImage
    }

    func imageTintColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        emptyDataSetImageTintColor.value
    }

    func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        .clear
    }

    func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        -60
    }
}

extension BaseViewController: DZNEmptyDataSetDelegate {
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        !isLoading.value
    }

    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        true
    }

    func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
        emptyDataSetButtonTap.onNext(())
    }
}
