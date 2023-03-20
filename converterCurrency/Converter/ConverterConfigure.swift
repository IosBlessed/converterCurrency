//
//  ConverterConfigure.swift
//  converterCurrency
//
//  Created by Никита Данилович on 11.03.2023.
//

import Foundation
import UIKit

class ConfigureConverter{
    
    static var configuration = ConfigureConverter()
    
    var converterView: ConverterViewProtocol?
    var converterInteractor:ConverterInteractorProtocol?
    var converterPresenter:ConverterPresenterProtocol?
    var converterRouter:ConverterRouterProtocol?
    
    func initializeConverterConfiguration() -> UIViewController{
        
        converterView = ConverterViewController()
        converterInteractor = ConverterInteractor()
        converterPresenter = ConverterPresenter()
        converterRouter = ConverterRouter()
        
        converterView!.converterPresenter = converterPresenter
        converterView!.converterRouter = converterRouter
        
        converterInteractor!.converterPresenter = converterPresenter
        
        converterPresenter!.converterView = converterView
        converterPresenter!.converterInteractor = converterInteractor
        converterPresenter!.converterRouter = converterRouter
        
        converterRouter!.converterView = converterView
        converterRouter!.converterPresenter = converterPresenter
        
        converterView!.converterPresenterOutput = converterPresenter as? any ConverterPresenterOutputProtocol
        converterPresenter!.converterViewOutput = converterView as? any ConverterViewOutputProtocol
        
        return converterView as! UIViewController
    }
    
}
