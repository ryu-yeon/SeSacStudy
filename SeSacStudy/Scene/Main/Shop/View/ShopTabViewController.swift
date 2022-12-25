//
//  ShopTabViewController.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/12/25.
//
import UIKit

import Tabman
import Pageboy

final class ShopTabViewController: TabmanViewController {

    var viewControllers: [UIViewController] = []
    let firstVC = SesacShopTabViewController()
    let secondVC = BackgroundShopTabViewController()
    
    var sesacDelegate: SesacTabDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewControllers.append(firstVC)
        viewControllers.append(secondVC)
        
        self.dataSource = self
        
        let bar = TMBar.ButtonBar()
        bar.layout.transitionStyle = .snap
        bar.layout.alignment = .centerDistributed
        bar.layout.contentMode = .fit
        bar.backgroundView.style = .clear
        bar.backgroundColor = .white
        
        bar.buttons.customize { button in
            button.tintColor = .gray6
            button.selectedTintColor = .brandGreen
            button.font = .title4_R14 ?? .systemFont(ofSize: 14)
        }
        
        bar.indicator.weight = .medium
        bar.indicator.overscrollBehavior = .bounce
        bar.indicator.tintColor = .brandGreen
        addBar(bar, dataSource: self, at:.top)
    }
}

extension ShopTabViewController: TMBarDataSource, PageboyViewControllerDataSource {
    func numberOfViewControllers(in pageboyViewController: Pageboy.PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: Pageboy.PageboyViewController, at index: Pageboy.PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: Pageboy.PageboyViewController) -> Pageboy.PageboyViewController.Page? {
        nil
    }
    
    func barItem(for bar: Tabman.TMBar, at index: Int) -> Tabman.TMBarItemable {
        switch index {
                case 0:
                    return TMBarItem(title: "새싹")
                case 1:
                    return TMBarItem(title: "배경")
                
                default:
                    let title = "Page \(index)"
                   return TMBarItem(title: title)
                }
    }
}
