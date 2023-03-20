//
//  ConverterViewController.swift
//  converterCurrency
//
//  Created by Никита Данилович on 11.03.2023.
//

import Foundation
import UIKit

protocol ConverterViewProtocol:AnyObject{
    
    var converterPresenter:ConverterPresenterProtocol? {get set}
    var converterRouter:ConverterRouterProtocol? {get set}
    
    var converterPresenterOutput:ConverterPresenterOutputProtocol? {get set}
    
    func updateView(with currencies:CurrencyValues)
    
    func updateView(with error:NSError )
    
}

enum TextFieldState{
    
    case converterViewFirstTextField
    case converterViewSecondTextField
    
}

protocol ConverterViewOutputProtocol:AnyObject{
    
    func updateCurrenciesTextField(with result:Float)
}


class ConverterView:UIView,UICollectionViewDelegate,UICollectionViewDataSource{
    
    
    var currencyInputTextField:UITextField!
    var currencyCurrentLabel: UILabel!
    var currencyButtons:UIStackView!
    var currencySelection:UIButton!
    var currenciesSection:UICollectionView!
    
    
    fileprivate func setupInputTextField(){
        
        currencyInputTextField = UITextField(frame: .zero)
        
        currencyInputTextField.translatesAutoresizingMaskIntoConstraints = false
        
        currencyInputTextField.placeholder = "Input amount..."
        currencyInputTextField.textAlignment = .center
        currencyInputTextField.keyboardType = .decimalPad

        
        currencyInputTextField.layer.masksToBounds = true
        currencyInputTextField.layer.cornerRadius = 10
        currencyInputTextField.layer.backgroundColor = UIColor.yellow.cgColor
        
        
        self.addSubview(currencyInputTextField)
    }
    
    fileprivate func setupCurrencyCurrentLabel(){
        
        currencyCurrentLabel = UILabel(frame: .zero)
        
        currencyCurrentLabel.translatesAutoresizingMaskIntoConstraints = false
        
        currencyCurrentLabel.textAlignment = .center
        currencyCurrentLabel.textColor = .black
        currencyCurrentLabel.backgroundColor = .orange
        
        currencyCurrentLabel.layer.masksToBounds = true
        currencyCurrentLabel.layer.cornerRadius = 10
        
        
        self.addSubview(currencyCurrentLabel)
    }
    
    fileprivate func setupCurrenciesSection(){
        
        let currenciesSectionLayout = UICollectionViewFlowLayout()
        currenciesSectionLayout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        currenciesSectionLayout.itemSize = CGSize(width: 60, height: 35)
        currenciesSectionLayout.scrollDirection = .horizontal
        
        currenciesSection = UICollectionView(frame: .zero,collectionViewLayout: currenciesSectionLayout)
        currenciesSection.register(CurrencyCell.self, forCellWithReuseIdentifier: "currencyCell")
        
        
        currenciesSection.translatesAutoresizingMaskIntoConstraints = false
        
        currenciesSection.delegate = self
        currenciesSection.dataSource = self
        currenciesSection.allowsSelection = true
        currenciesSection.isUserInteractionEnabled = true
        
        currenciesSection.showsVerticalScrollIndicator = false
        currenciesSection.showsHorizontalScrollIndicator = false
        
        currenciesSection.layer.masksToBounds = true
        currenciesSection.layer.cornerRadius = 10
        
        currenciesSection.backgroundColor = .yellow
        
        
        self.addSubview(currenciesSection)
    }
    
    init(){
        
        super.init(frame: CGRect())
        
        setupInputTextField()
        setupCurrencyCurrentLabel()
        setupCurrenciesSection()
        
    }
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
        
    }
    let currencyData:[String] = ["USD","MDL","EUR","RUB","RON","UAH","GBP"]
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currencyData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        if let cell = currenciesSection.dequeueReusableCell(withReuseIdentifier: "currencyCell", for: indexPath) as? CurrencyCell{
            
            cell.initializeViews(title: currencyData[indexPath.row])
            
            return cell
        }
        fatalError("Unable to execute collection's view cell")
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currencyCurrentLabel.text = currencyData[indexPath.row]
    }

}


final class CurrencyCell:UICollectionViewCell{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    
   lazy var currencyLabel = { titleText in
       
       let label = UILabel(frame: .zero)
       label.translatesAutoresizingMaskIntoConstraints = false
       label.frame = self.bounds
       label.textAlignment = .center
       label.layer.masksToBounds = true
       label.layer.cornerRadius = 10
       label.layer.backgroundColor = UIColor.green.cgColor
       
       label.text = titleText
       
       return label
    }
    
    func initializeViews(title currencyTitle:String){
        
        self.addSubview(currencyLabel(currencyTitle))

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

final class ConverterViewController:UIViewController,ConverterViewProtocol,ConverterViewOutputProtocol{
    
    func updateCurrenciesTextField(with result:Float) {
        
        switch textFieldState{
            
        case .converterViewFirstTextField:
            
            converterViewSecond?.currencyInputTextField.text = String(format: "%.4f", result)
            
            break;
            
        case .converterViewSecondTextField:
        
            converterViewFirst?.currencyInputTextField.text = String(format: "%.4f", result)
            
            break;
            
        case .none:
            print("None from the switch was selected")
        }
    }
    
    fileprivate var textFieldState:TextFieldState?
    
    weak var converterPresenter: ConverterPresenterProtocol?
    
    weak var converterRouter: ConverterRouterProtocol?
    
    weak var converterPresenterOutput: ConverterPresenterOutputProtocol?
    
    fileprivate var tapHideKeyboard:UITapGestureRecognizer?
    
    fileprivate var converterViewFirst:ConverterView?
    
    fileprivate var converterViewSecond: ConverterView?
    
    private var mainView:UIView?
    
    
    func updateView(with currencies: [String:Float]) {
        
        DispatchQueue.main.async {
            
            [weak self] in
            
            self?.converterViewFirst?.currencyCurrentLabel.text = currencies.keys.randomElement()
            
            self?.converterViewSecond?.currencyCurrentLabel.text = currencies.keys.randomElement()
            
        }
        
    }
    
    func updateView(with error: NSError) {
        
        print(error.localizedDescription)
        
    }
    
    private func initializeFirstConverterView(){
        
        converterViewFirst = ConverterView()
        
        converterViewFirst!.translatesAutoresizingMaskIntoConstraints = false
        
        converterViewFirst!.backgroundColor = .gray
        
        converterViewFirst!.layer.cornerRadius = 10
        
        
        view.addSubview(converterViewFirst!)
        
    }
    private func initializeSecondConverterView(){
        
        converterViewSecond = ConverterView()
        
        converterViewSecond!.translatesAutoresizingMaskIntoConstraints = false
        
        converterViewSecond!.backgroundColor = .gray
        
        converterViewSecond!.layer.cornerRadius = 10
        
        view.addSubview(converterViewSecond!)
    }
    
    private func initializeTapGestureRecognizer(){
        
        tapHideKeyboard = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        
        mainView!.addGestureRecognizer(tapHideKeyboard!)
        
    }
    
    @objc func hideKeyboard(){
        
       view.endEditing(true)
        
    }
    
    private func initializeMainView(){
        
        mainView = UIView()
        mainView!.frame = view.bounds
        mainView!.backgroundColor = .white
        
        view.addSubview(mainView!)
    }
    
    private func addTargetsToTextFields(){
        
        converterViewFirst?.currencyInputTextField.addTarget(self, action: #selector(changeFirstTextField), for: .editingChanged)
        
        converterViewSecond?.currencyInputTextField.addTarget(self, action: #selector(changeSecondTextField), for: .editingChanged)
        
    }
    
    // Section with the listenere of changing TextFields
    
    @objc func changeFirstTextField(){
        
        guard converterViewFirst != nil else {
            print("Nil instance of the first ConverterView")
            return
        }
        
        textFieldState = .converterViewFirstTextField
        
        let amount = Float(converterViewFirst?.currencyInputTextField.text ?? "0.0") ?? 0.0
        let convertFrom = converterViewFirst?.currencyCurrentLabel.text ?? "USD"
        let convertTo = converterViewSecond?.currencyCurrentLabel.text ?? "MDL"
        
        self.converterPresenterOutput?.processCurrenciesData(amount: amount, from: convertFrom, to: convertTo)
        
    }
    
    @objc func changeSecondTextField(){
        
        guard converterViewSecond != nil else {
            print("Nil instance of the second ConverterView")
            return
        }
        
        textFieldState = .converterViewSecondTextField
        
        let amount = Float(converterViewSecond?.currencyInputTextField.text ?? "0.0") ?? 0.0
        let convertFrom = converterViewSecond?.currencyCurrentLabel.text ?? "USD"
        let convertTo = converterViewFirst?.currencyCurrentLabel.text ?? "MDL"
        
        self.converterPresenterOutput?.processCurrenciesData(amount: amount, from: convertFrom, to: convertTo)
        
    }
    
    //MARK: - Lifecycle ConverterViewController
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        initializeMainView()
        
        initializeFirstConverterView()
        
        initializeSecondConverterView()
        
        initializeTapGestureRecognizer()
        
        addTargetsToTextFields()
        
        
    }
    
    override func viewWillLayoutSubviews() {
        
        let converterViewFirst:ConverterView! = self.converterViewFirst
        let converterViewSecond:ConverterView! = self.converterViewSecond
        
        var currencyFirstViewTextField: UITextField!
        var currencyFirstViewCurrentLabel:UILabel!
        var currencyFirstViewCurrenciesSection:UICollectionView!
        
        var currencySecondViewTextField: UITextField!
        var currencySecondViewCurrentLabel:UILabel!
        var currencySecondViewCurrenciesSection:UICollectionView!
        
        
        guard converterViewFirst != nil, converterViewSecond != nil else {return}
        
            // First Converter View Section
            currencyFirstViewTextField = converterViewFirst!.currencyInputTextField
            currencyFirstViewCurrentLabel = converterViewFirst!.currencyCurrentLabel
            currencyFirstViewCurrenciesSection = converterViewFirst!.currenciesSection
            
            // First Converter View Constraints
            converterViewFirst.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
            converterViewFirst.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 15).isActive = true
            converterViewFirst.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -15).isActive = true
            converterViewFirst.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
            
            // First Converter View Text Field
            currencyFirstViewTextField.topAnchor.constraint(equalTo: converterViewFirst.topAnchor, constant: 15).isActive = true
            currencyFirstViewTextField.leftAnchor.constraint(equalTo: converterViewFirst.leftAnchor, constant: 15).isActive = true
            currencyFirstViewTextField.rightAnchor.constraint(equalTo: converterViewFirst.rightAnchor, constant: -130).isActive = true
            currencyFirstViewTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
                
            // First Converter View Current Currency Label
            currencyFirstViewCurrentLabel.topAnchor.constraint(equalTo: currencyFirstViewTextField.topAnchor).isActive = true
            currencyFirstViewCurrentLabel.leftAnchor.constraint(equalTo: currencyFirstViewTextField.rightAnchor, constant: 10).isActive = true
            currencyFirstViewCurrentLabel.rightAnchor.constraint(equalTo: converterViewFirst.rightAnchor, constant: -15).isActive = true
            currencyFirstViewCurrentLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
                
            // First Converter View Currencies Section
            currencyFirstViewCurrenciesSection.topAnchor.constraint(equalTo: currencyFirstViewTextField.bottomAnchor, constant: 30).isActive = true
            currencyFirstViewCurrenciesSection.leftAnchor.constraint(equalTo: currencyFirstViewTextField.leftAnchor).isActive = true
            currencyFirstViewCurrenciesSection.rightAnchor.constraint(equalTo: converterViewFirst.rightAnchor, constant: -80).isActive = true
            currencyFirstViewCurrenciesSection.heightAnchor.constraint(equalToConstant: 60).isActive = true
            
            // Second Converter View Section
            currencySecondViewTextField = converterViewSecond.currencyInputTextField
            currencySecondViewCurrentLabel = converterViewSecond.currencyCurrentLabel
            currencySecondViewCurrenciesSection = converterViewSecond.currenciesSection
            
            // Second Converter View Constraints
            converterViewSecond.topAnchor.constraint(equalTo: converterViewFirst.bottomAnchor,constant: 150).isActive = true
            converterViewSecond.leftAnchor.constraint(equalTo: converterViewFirst.leftAnchor).isActive = true
            converterViewSecond.rightAnchor.constraint(equalTo: converterViewFirst.rightAnchor).isActive = true
            converterViewSecond.heightAnchor.constraint(equalTo: converterViewFirst.heightAnchor).isActive = true
            
            // Second Converter View Text Field
            currencySecondViewTextField.topAnchor.constraint(equalTo: converterViewSecond.topAnchor,constant: 15).isActive = true
            currencySecondViewTextField.leftAnchor.constraint(equalTo: currencyFirstViewTextField.leftAnchor).isActive = true
            currencySecondViewTextField.rightAnchor.constraint(equalTo: currencyFirstViewTextField.rightAnchor).isActive = true
            currencySecondViewTextField.heightAnchor.constraint(equalTo: currencyFirstViewTextField.heightAnchor).isActive = true
            
            // Second Converter View Current Currency Label
            currencySecondViewCurrentLabel.topAnchor.constraint(equalTo: converterViewSecond.topAnchor, constant: 15).isActive = true
            currencySecondViewCurrentLabel.leftAnchor.constraint(equalTo: currencyFirstViewCurrentLabel.leftAnchor).isActive = true
            currencySecondViewCurrentLabel.rightAnchor.constraint(equalTo: currencyFirstViewCurrentLabel.rightAnchor).isActive = true
            currencySecondViewCurrentLabel.heightAnchor.constraint(equalTo: currencyFirstViewCurrentLabel.heightAnchor).isActive = true
            
            // Second Converter View Currencies Section
            currencySecondViewCurrenciesSection.topAnchor.constraint(equalTo: currencySecondViewTextField.bottomAnchor,constant: 30).isActive = true
            currencySecondViewCurrenciesSection.leftAnchor.constraint(equalTo: currencyFirstViewCurrenciesSection.leftAnchor).isActive = true
            currencySecondViewCurrenciesSection.rightAnchor.constraint(equalTo: currencyFirstViewCurrenciesSection.rightAnchor).isActive = true
            currencySecondViewCurrenciesSection.heightAnchor.constraint(equalTo: currencyFirstViewCurrenciesSection.heightAnchor).isActive = true
        
    }
    
}
