//
//  ConverterInteractor.swift
//  converterCurrency
//
//  Created by Никита Данилович on 11.03.2023.
//

import Foundation


protocol ConverterInteractorProtocol:AnyObject{
    
    var converterPresenter:ConverterPresenterProtocol? {get set}
    
    func getCurrenciesFromServer()
    
    func getCurrencyConversation()
    
}



class ConverterInteractor:ConverterInteractorProtocol{
    
    weak var converterPresenter: ConverterPresenterProtocol?
    
    fileprivate var currencyRates:CurrencyValues!
    
    func getCurrenciesFromServer(){
        
        let url = URL(string: "https://api.apilayer.com/fixer/latest?symbols=GBP%2CEUR%2CMDL%2CRON%2CRUB%2CUAH%2C%20USD&base=CHF")!
        
        var currencyRequest = URLRequest(url: url)
        
        currencyRequest.httpMethod = "GET"
        currencyRequest.addValue("tVipbqZ9HicX40VLClFFGuT0IOdvqJOM", forHTTPHeaderField: "apikey")
        
        
        let dataExtraction = URLSession.shared.dataTask(with: currencyRequest){
            
            data, response, error in
            
            do{
                
                let jsonString = String(data: data!, encoding: .utf8)!
                
                print(jsonString)
                
                let jsonData = try JSONDecoder().decode(CurrencyConversion.self, from: data!)
                
                // Realize data flow into presenter -> view
                
                print(jsonData)
                
            }catch let error as NSError{
                print(error.localizedDescription)
            }
            
            
        }
        
        dataExtraction.resume()
        
        
        
        
    }
    
    func getCurrencyConversation() {
        
    let jsonString = """
    {
      "base": "USD",
      "date": "2023-03-09",
      "rates": {
        "EUR": 0.94485,
        "GBP": 0.838665,
        "MDL": 18.761296,
        "RON": 4.64289,
        "RUB": 75.850218,
        "UAH": 36.946503,
        "USD": 1.0000
      },
      "success": true,
      "timestamp": 1678402443
    }
"""
        
        do{
            let jsonObject = jsonString.data(using: .utf8)!
            
            let currencies = try JSONDecoder().decode(CurrencyConversion.self, from: jsonObject)
            
            currencyRates = CurrencyValues()
            
            currencyRates[CurrenciesTypes.EUR.rawValue] = currencies.rates.EUR
            currencyRates[CurrenciesTypes.MDL.rawValue] = currencies.rates.MDL
            currencyRates[CurrenciesTypes.USD.rawValue] = currencies.rates.USD
            currencyRates[CurrenciesTypes.GBP.rawValue] = currencies.rates.GBP
            currencyRates[CurrenciesTypes.RON.rawValue] = currencies.rates.RON
            currencyRates[CurrenciesTypes.RUB.rawValue] = currencies.rates.RUB
            currencyRates[CurrenciesTypes.UAH.rawValue] = currencies.rates.UAH
            
            converterPresenter?.interactorDidReceiveCurrency(with: .success(currencyRates))
           
        }catch let error as NSError{
            
            converterPresenter?.interactorDidReceiveCurrency(with: .failure(error))
            
            
        }
    }
   
    
    
}
