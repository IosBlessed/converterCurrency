//
//  ConverterRouter.swift
//  converterCurrency
//
//  Created by Никита Данилович on 11.03.2023.
//

import Foundation
import UIKit

protocol ConverterRouterProtocol:AnyObject{
    
    var converterView:ConverterViewProtocol?{get set}
    
    var converterPresenter: ConverterPresenterProtocol? {get set}
        
    func closeViewController()
    
    func moveToViewController(from viewControllerFrom:UIViewController, to viewControllerTo:UIViewController)
}

class ConverterRouter:ConverterRouterProtocol{
    
    var converterView: ConverterViewProtocol?
    
    var converterPresenter: ConverterPresenterProtocol?
    
    func closeViewController() {
        
        print("Router will close VC")
        
    }
    
    func moveToViewController(from viewControllerFrom: UIViewController, to viewControllerTo: UIViewController) {
        
        print("Router will move to VC")
        
    }
    
    
}

