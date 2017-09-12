//
//  ViewController.swift
//  RXSwiftDemo
//
//  Created by Fisland_Z on 2017/8/31.
//  Copyright © 2017年 Zehuihong. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

class ViewController: UIViewController {

    let disposeBag = DisposeBag()
    @IBOutlet weak var myButton: UIButton!
    @IBOutlet weak var myTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let textfieldvalid =  myTextField.rx.text.orEmpty.map { (text) -> Bool in
            text.characters.count >= 6
        }.shareReplay(1)
        
        textfieldvalid.bind(to: myButton.rx.isEnabled).addDisposableTo(disposeBag)
        _ = textfieldvalid.subscribe(onNext: { (valid) in
            if valid{
                self.myButton.setTitle("可用", for: .normal)
                self.myButton.backgroundColor = UIColor(red: 45/255.0, green: 179/255.0, blue: 114/255.0, alpha: 1)
                self.myButton.setTitleColor(UIColor.white, for: .normal)

            }
            else{
                self.myButton.setTitle("不可用", for: .normal)
                self.myButton.backgroundColor = UIColor(red: 223/255.0, green: 223/255.0, blue: 223/255.0, alpha: 1)
                self.myButton.setTitleColor(UIColor(red: 86/255.0, green: 86/255.0, blue: 86/255.0, alpha: 1), for: .normal)

            }
        })
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

