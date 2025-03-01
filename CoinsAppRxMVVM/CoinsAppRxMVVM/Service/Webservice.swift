//
//  Webservice.swift
//  CoinsAppRxMVVM
//
//  Created by Safak Yaral on 25.11.2024.
//

import Foundation

enum errorCrypto : Error{
    case serverError
    case parsingError
    
}

class Webservice {
    
    func downloadCurrencies(url: URL, completion: @escaping (Result<[Crypto], errorCrypto>) -> ()){ //döndürülcek parametreleri yazabilriiz. yani crypto değerleri bir dizi şeklinde geliyor eğer bir hata olursa hata mesajını errorCrypto şeklinde döndürüyoruz.
        
        URLSession.shared.dataTask(with: url) { data, response, error in //isteği atıp cevap geldikten sonra onu ele alabiliriz.
            if let _ = error { // " _ " eğer o fonksiyonu kullanmayacaksak yazılıyor.
                completion(.failure(.serverError)) // hata mesajı varsa bunu döndürür.
            } else if let data = data {
                
                let cryptoList = try? JSONDecoder().decode([Crypto].self, from: data) // eğer liste gelmezse sistem çökmesin diye try optional kullandık.
                
                   if let cryptoList = cryptoList {
                       completion(.success(cryptoList))
                   }else {
                       completion(.failure(.parsingError))
                   }
                
            }
            
        }.resume()
        
    }
}
