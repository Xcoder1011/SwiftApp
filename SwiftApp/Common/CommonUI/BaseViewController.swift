//
//  BaseViewController.swift
//  SwiftApp
//
//  Created by KUN on 2023/12/6.
//

import UIKit
import RxSwift
import RxCocoa
import DZNEmptyDataSet
import SwiftUI
import SnapKit
import SVProgressHUD

class BaseViewController: UIViewController, NavigatorProtocol {
    
    var viewModel: ViewModel?
    var navigator: Navigator!
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
        _disposeBag = self.viewModel?.disposeBag ??  DisposeBag()
        return _disposeBag!
    }

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
        view.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        return view
    }()
    
    override func viewDidLoad() {
        makeUI()
        bindViewModel()
        
        NotificationCenter.default.rx.notification(NSNotification.Name.SKLanguageChangeNotification).subscribe({ [weak self] (event) in
            self?.languageChanged.accept(())
        }).disposed(by: disposeBag)
        
        viewDidLoadSubject.onNext(())
        viewDidLoadSubject.onCompleted()
    }
    
    func makeUI() {
        self.contentView.backgroundColor = .white
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
}

extension BaseViewController: DZNEmptyDataSetSource {

    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: emptyDataSetTitle )
    }

    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: emptyDataSetDescription)
    }

    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return emptyDataSetImage
    }

    func imageTintColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        return emptyDataSetImageTintColor.value
    }

    func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        return .clear
    }

    func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return -60
    }
}

extension BaseViewController: DZNEmptyDataSetDelegate {

    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return !isLoading.value
    }

    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }

    func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
        emptyDataSetButtonTap.onNext(())
    }
}
