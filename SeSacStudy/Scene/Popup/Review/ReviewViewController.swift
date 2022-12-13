//
//  ReviewViewController.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/12/13.
//

import UIKit

import RxCocoa
import RxSwift
import RxKeyboard
import Toast

final class ReviewViewController: BaseViewController {
    
    private let mainView = ReviewView()
    private let disposeBag = DisposeBag()
    
    let queueSerive = QueueAPIService()
    
    var uid = ""
    
    var reputation = [0, 0, 0, 0, 0, 0, 0, 0]
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        setCancleButton()
        setCollectionView()
        setTextView()
        setKeyboard()
        setOkButton()
    }
    
    private func setCancleButton() {
        mainView.cancleButton.addTarget(self, action: #selector(tap), for: .touchUpInside)
    }
    
    @objc func tap() {
        self.dismiss(animated: true)
    }
    
    func setTitle(title: String) {
        mainView.titleLabel.text = title
    }
    
    func setSubtitle(subtitle: String) {
        mainView.subtitleLabel.text = subtitle
    }
    
    func setSubtitleColor(_ color: UIColor) {
        mainView.subtitleLabel.textColor = color
    }
    
    private func setKeyboard() {
        RxKeyboard.instance.visibleHeight
                .drive(onNext: { [weak self] keyboardVisibleHeight in
                    guard let self = self else { return }
                    
                    UIView.animate(withDuration: 0) {
                        self.mainView.updatePopupContainer(keyboardVisibleHeight: keyboardVisibleHeight)
                        self.view.layoutIfNeeded()
                    }
                }).disposed(by: disposeBag)
    }
    
    private func setCollectionView() {
        mainView.titleCollectionView.dataSource = self
        mainView.titleCollectionView.delegate = self
        mainView.titleCollectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.reusableIdentifier)
    }
    
    private func setTextView() {
        
        mainView.textView.delegate = self
        
        mainView.textView.rx.text
            .orEmpty
            .map { $0.isEmpty ? .gray6 : .brandGreen}
            .bind(to: mainView.okButton.rx.backgroundColor)
            .disposed(by: disposeBag)
    }
    
    private func setOkButton() {
        mainView.okButton.rx.tap
            .withUnretained(self)
            .bind { (vc, _) in
                
                let idToken = UserDefaultsHelper.standard.idToken
                vc.queueSerive.registerReview(idToken: idToken, uid: vc.uid, reputation: vc.reputation, comment: vc.mainView.textView.text ?? "") { statusCode in
                    print(statusCode)
                    guard let pvc = self.presentingViewController else { return }
                    vc.dismiss(animated: true) {
                        guard let viewControllerStack = pvc.navigationController?.viewControllers else { return }
                        for viewController in viewControllerStack {
                            pvc.navigationController?.popToViewController(viewController, animated: true)
                        }
                    }
                }
            }
            .disposed(by: disposeBag)
    }
}

extension ReviewViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let title = ["좋은 매너", "정확한 시간 약속", "빠른 응답", "친절한 성격", "능숙한 실력", "유익한 시간"]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.reusableIdentifier, for: indexPath) as! TitleCollectionViewCell
        cell.titleLabel.text = title[indexPath.item]
        
        if reputation[indexPath.item] > 0 {
            cell.contentView.backgroundColor = .brandGreen
            cell.contentView.layer.borderWidth = 0
            cell.titleLabel.textColor = .white
        } else {
            cell.contentView.backgroundColor = .white
            cell.contentView.layer.borderWidth = 1
            cell.contentView.layer.borderColor = UIColor.gray4.cgColor
            cell.titleLabel.textColor = .black
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        reputation[indexPath.item] = reputation[indexPath.item] > 0 ? 0 : 1
        mainView.titleCollectionView.reloadData()
    }
}

extension ReviewViewController: UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text =  "자세한 피드백은 다른 새싹들에게 도움이 됩니다 (500자 이내 작성)"
            textView.textColor = .gray7
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .gray7 {
            textView.text = nil
            textView.textColor = .black
        }
    }
}
