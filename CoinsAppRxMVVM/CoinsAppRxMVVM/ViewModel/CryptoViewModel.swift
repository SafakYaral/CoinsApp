//
//  CryptoViewModel.swift
//  CoinsAppRxMVVM
//
//  Created by Safak Yaral on 25.11.2024.
//

import Foundation
import RxSwift
import RxCocoa // view model içersinde publishing(yayın) yapacagız view modeldan view a abone olacağız. ve bu sayede view model da bir değişiklik olursa bunları gözlemleme imkanımız olacak.

class CryptoViewModel {
    
    let currencies: PublishSubject<[Crypto]> = PublishSubject()
    let error : PublishSubject<Error> = PublishSubject()
    let loading : PublishSubject<Bool> = PublishSubject() //yüklenme aşamasında olduğunu kullanıcıya gösterilir.
    
    func requestData() {
        self.loading.onNext(true)
       
        let url = URL(string:"https://raw.githubusercontent.com/atilsamancioglu/K21-jSONDataSet/master/crypto.json")!
        Webservice().downloadCurrencies(url: url) { result in
            self.loading.onNext(false)
      
            switch result{
            case .success(let currencies):
                self.currencies.onNext(currencies)
            case .failure(let error):
                switch error {
                case .serverError:
                    self.error.onNext("Server Error" as! Error)
                case .parsingError:
                    self.error.onNext("Parsing Error" as! Error)
                }
            }
            
        }
    }
    
}
