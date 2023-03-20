//
//  ConverterEntity.swift
//  converterCurrency
//
//  Created by Никита Данилович on 11.03.2023.
//

import Foundation

typealias CurrencyValues = [String:Float]

struct CurrencyConversion:Codable{
    
    var base:String
    var date:String
    var rates:CurrenciesRates
    var success:Bool
    var timestamp:Int
    
}

struct CurrenciesRates:Codable{
    
    var EUR:Float
    var MDL:Float
    var USD:Float
    var GBP:Float
    var RON:Float
    var RUB:Float
    var UAH:Float
    
}

enum CurrenciesTypes:String{
    
    case EUR = "EUR"
    case MDL = "MDL"
    case USD = "USD"
    case GBP = "GBP"
    case RON = "RON"
    case RUB = "RUB"
    case UAH = "UAH"
    
}
