//
//  Extension+UIViewController.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/07/12.
//

import SnapKit
import UIKit

extension UIViewController {
    
    func addChildView(_ viewController: UIViewController) {
        
        // Add the view controller to the container.
        addChild(viewController)
        view.addSubview(viewController.view)

        // Create and activate the constraints for the child’s view.
        viewController.view.snp.makeConstraints {
            $0.top.equalTo(view.snp.top)
            $0.bottom.equalTo(view.snp.bottom)
            $0.left.equalTo(view.snp.left)
            $0.right.equalTo(view.snp.right)
        }

        // Notify the child view controller that the move is complete.
        viewController.didMove(toParent: self)
    }

}
