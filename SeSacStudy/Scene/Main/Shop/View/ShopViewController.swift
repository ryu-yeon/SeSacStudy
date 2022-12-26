//
//  ShopViewController.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/11.
//

import UIKit
import StoreKit

import RxCocoa
import RxSwift
import Tabman
import Pageboy
import Toast

final class ShopViewController: BaseViewController {
    
    let mainView = ShopView()
    let viewModel = ShopViewModel()
    private let disposeBag = DisposeBag()
    
    let productIdentifiers: Set<String> = SesacItem.productIdentifiers.union(BackgroundItem.productIdentifiers)
    
    var productArray = Array<SKProduct>()
    var product: SKProduct?
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        setContainerView()
        bindProfile()
        setSaveButton()
        requestProductData()
    }
    
    override func setNavigationBar() {
        navigationItem.title = "새싹샵"
    }
    
    private func bindProfile() {
        viewModel.user
            .bind { [self] value in
                guard let value else { return }
                mainView.backgroundImageView.image = UIImage(named: BackgroundImage(rawValue: value.background)?.image ?? "")
                mainView.profileImagView.image = UIImage(named: SesacImage(rawValue: value.sesac)?.image ?? "")
            }
            .disposed(by: disposeBag)
    }
    
    private func setSaveButton() {
        mainView.saveButton.rx.tap
            .bind { [self] _ in
                viewModel.updateItem()
            }
            .disposed(by: disposeBag)
        
        viewModel.vaild
            .asDriver(onErrorJustReturn: false)
            .drive { [self] value  in
                if value {
                    viewModel.updateProfile()
                    mainView.makeToast(ShopItemStatusCode.Success.message, duration: 1.0, position: .top)
                } else {
                    mainView.makeToast(ShopItemStatusCode.NotHaveItem.message, duration: 1.0, position: .top)
                }
            }
            .disposed(by: disposeBag)
        
    }
    private func setContainerView() {
        let vc = ShopTabViewController()
        
        self.addChild(vc)
        mainView.containerView.addSubview(vc.view)
        vc.view.frame = mainView.containerView.bounds
        vc.didMove(toParent: self)
        
        vc.firstVC.sesacDelegate = self
        vc.secondVC.backgroundDelegate = self
        
        viewModel.user
            .bind { value in
                vc.firstVC.user = value
                vc.firstVC.mainView.collecionView.reloadData()
                vc.secondVC.user = value
                vc.secondVC.mainView.collecionView.reloadData()
            }
            .disposed(by: disposeBag)
    }
    
    func requestProductData() {
        if SKPaymentQueue.canMakePayments() {
            print("인앱 결제 가능")
            let request = SKProductsRequest(productIdentifiers: productIdentifiers)
            request.delegate = self
            request.start() //인앱 상품 조회
        } else {
            print("In App Purchase Not Enabled")
        }
    }
    
    var buyIndex = 0
}

extension ShopViewController: SesacTabDelegate {
    func buySesac(index: Int) {
        buyIndex = BackgroundItem.productIdentifiers.count + index - 1
        let payment = SKPayment(product: productArray[buyIndex])
        SKPaymentQueue.default().add(payment)
        SKPaymentQueue.default().add(self)
    }
    
    func getSesacNumber(index: Int) {
        mainView.profileImagView.image = UIImage(named: SesacImage(rawValue: index)!.image)
        viewModel.selectSesac = index
    }
}

extension ShopViewController: BackgroundTabDelegate {
    func buyBackground(index: Int) {
        buyIndex = index - 1
        let payment = SKPayment(product: productArray[index - 1])
        SKPaymentQueue.default().add(payment)
        SKPaymentQueue.default().add(self)
    }
    
    func getBackgroundNumber(index: Int) {
        mainView.backgroundImageView.image = UIImage(named: BackgroundImage(rawValue: index)!.image)
        viewModel.selectBackground = index
    }
}

extension ShopViewController: SKProductsRequestDelegate {
    
    //3. 인앱 상품 정보 조회
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let products = response.products
        
        if products.count > 0 {
            for i in products {
                productArray.append(i)
                product = i //옵션. 테이블뷰 셀에서 구매하기 버튼 클릭시
                
                print(i.localizedTitle, i.price, i.priceLocale, i.localizedDescription)
            }
        } else {
            print("No Product Found") //계약 업데이트, 유료계약X, Capabilites X
        }
    }
    
    func receiptValidation(transaction: SKPaymentTransaction, productIdentifier: String) {
        // SandBox: “https://sandbox.itunes.apple.com/verifyReceipt”
        // iTunes Store : “https://buy.itunes.apple.com/verifyReceipt”
        
        //구매 영수증 정보
        let receiptFileURL = Bundle.main.appStoreReceiptURL
        let receiptData = try? Data(contentsOf: receiptFileURL!)
        let receiptString = receiptData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        
        viewModel.buyItem(receipt: receiptString ?? "", product: productIdentifier)
        
//        print(receiptString)
        //거래 내역(transaction)을 큐에서 제거
        SKPaymentQueue.default().finishTransaction(transaction)
        
    }
}

extension ShopViewController: SKPaymentTransactionObserver {
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction in transactions {
            
            switch transaction.transactionState {
                
            case .purchased: //구매 승인 이후에 영수증 검증
                
                print("Transaction Approved. \(transaction.payment.productIdentifier)")
                receiptValidation(transaction: transaction, productIdentifier: transaction.payment.productIdentifier)
            case .failed: //실패 토스트, transaction
                
                print("Transaction Failed")
                SKPaymentQueue.default().finishTransaction(transaction)
                
            default:
                break
            }
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, removedTransactions transactions: [SKPaymentTransaction]) {
        print("removedTransactions")
    }
}
