//
//  ViewController.swift
//  CoinsAppRxMVVM
//
//  Created by Safak Yaral on 25.11.2024.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController ,UITableViewDataSource, UITableViewDelegate{
 
    

    @IBOutlet weak var tableView: UITableView!
   
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    
    var cryptoList : [Crypto] = []
    var disposeBag = DisposeBag() //hafızada durmaması için bir çantaya atıyoruz.
    
    let cryptoVM = CryptoViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        setupBindings()
        cryptoVM.requestData()
        
        
    }
    
    private func setupBindings(){ // veriler değiştirildikce kullanıcının yeni verileri göreceği yer.
        
        cryptoVM
            .loading
            .bind(to: self.indicatorView.rx.isAnimating) // proje yüklenirken dönen yüklenme çubuğu.
            .disposed(by: disposeBag)
        
        cryptoVM
            .error
            .observe(on: MainScheduler.asyncInstance)
            .subscribe {errorString in
                print(errorString)
            }
            .disposed(by: disposeBag)
        cryptoVM
            .currencies
            .observe(on: MainScheduler.asyncInstance)
            .subscribe {cryptos in
                self.cryptoList = cryptos
                self.tableView.reloadData()
            }
            .disposed(by: disposeBag)
            
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cryptoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
        content.text = cryptoList[indexPath.row].currency
        content.secondaryText = cryptoList[indexPath.row].price
        cell.contentConfiguration = content
        return cell
    }


}

