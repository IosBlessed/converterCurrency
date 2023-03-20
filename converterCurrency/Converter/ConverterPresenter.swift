//
//  ConverterPresenter.swift
//  converterCurrency
//
//  Created by Никита Данилович on 11.03.2023.
//

import Foundation


protocol ConverterPresenterProtocol:AnyObject{
    
    var converterView:ConverterViewProtocol? {get set}
    
    var converterInteractor:ConverterInteractorProtocol? {get set}
    
    var converterRouter:ConverterRouterProtocol? {get set}
    
    var converterViewOutput:ConverterViewOutputProtocol? {get set}
        
    func interactorDidReceiveCurrency(with result:Result<CurrencyValues,Error>)
    
    
}

protocol ConverterPresenterOutputProtocol:AnyObject{
    
    func processCurrenciesData(amount currencyAmount:Float, from currencyFrom:String, to currencyTo:String)
    
}

final class ConverterPresenter:ConverterPresenterProtocol,ConverterPresenterOutputProtocol{
    
    weak var converterView: ConverterViewProtocol?
    
    weak var converterInteractor: ConverterInteractorProtocol?{
        
        didSet{
            
           // converterInteractor?.getCurrenciesFromServer()
            converterInteractor?.getCurrencyConversation()
            
        }
    }
    
    weak var converterViewOutput: ConverterViewOutputProtocol?
    
    weak var converterRouter: ConverterRouterProtocol?
    
    var currenciesRates: CurrencyValues!

    func interactorDidReceiveCurrency(with result: Result<CurrencyValues, Error>) {
            
        switch result {
            
        case .success(let currencies):
            
            self.currenciesRates = currencies
            
            converterView?.updateView(with: currencies)
            
            break;
            
        case .failure(let error as NSError):
            
            converterView?.updateView(with: error)
            
            break;
        }
    
    }
    
    func processCurrenciesData(amount currencyAmount:Float, from currencyFrom:String, to currencyTo:String) {
            
        let result = Float(currenciesRates[currencyTo]! / currenciesRates[currencyFrom]!) * currencyAmount
            
        self.converterViewOutput?.updateCurrenciesTextField(with: result)
    }
    
    
}
