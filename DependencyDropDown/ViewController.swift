//
//  ViewController.swift
//  DependencyDropDown
//
//  Created by soumya.rajashekhar on 07/11/17.
//  Copyright © 2017 soumya.rajashekhar. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
  
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    var myPickerView: UIPickerView?
    var countries :NSArray?
    var states:NSArray?
    var countryAbbrivation = String()
    var selectedTextField:Int?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countryTextField.delegate = self
        stateTextField.delegate = self
        
        myPickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 100, height: 300))
        myPickerView?.delegate = self
        myPickerView?.dataSource = self
        countryTextField.inputView = myPickerView
        stateTextField.inputView = myPickerView
   
}
    
    
    func getCountryNames()
    {
        if let path = Bundle.main.path(forResource: "data", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                do{

                    let json =  try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    // JSONObjectWithData returns AnyObject so the first thing to do is to downcast to dictionary type
//                    print(json)
                    let jsonDictionary =  json as! Dictionary<String,Any>
                    //print all the key/value from the json
                    
                    for (key, value) in jsonDictionary {

                        countries = value as? NSArray

                    }
                    

                }catch let error{

                    print(error.localizedDescription)
                }

            } catch let error {
                print(error.localizedDescription)
            }
        } else {
            print("Invalid filename/path.")
        }

    }
    
func getStatesNames(state:String) {
        if let path = Bundle.main.path(forResource: state, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                do{
                    
                    let json =  try JSONSerialization.jsonObject(with: data, options: .allowFragments)

                    let jsonDictionary =  json as! Dictionary<String,Any>
                    
                    for (key, value) in jsonDictionary {
                        
                        states = value as? NSArray
                        
                    }
                    
                    
                }catch let error{
                    
                    print(error.localizedDescription)
                }
                
            } catch let error {
                print(error.localizedDescription)
            }
        } else {
            print("Invalid filename/path.")
        }    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var arrayCount:Int?
        if(selectedTextField == 100) {
            arrayCount = countries!.count
        } else if(selectedTextField == 200){
            arrayCount = states!.count
        }
        return arrayCount!
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var string = String()
        if(selectedTextField == 100) {
            let dict = countries![row] as? NSDictionary
            string = (dict!["country"] as? String)!
        } else if(selectedTextField == 200) {
            let dict = states![row] as? NSDictionary
            string = (dict!["name"] as? String)!
        }
        return string
        

    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(selectedTextField == 100) {
            let dict = countries![row] as? NSDictionary
            countryAbbrivation = (dict!["abbreviation"] as? String)!
            countryTextField.text = dict!["country"] as? String
        } else if(selectedTextField == 200) {
            let dict = states![row] as? NSDictionary
            stateTextField.text = dict!["name"] as? String
        }
        self.view.endEditing(false)
 
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        myPickerView?.isHidden = true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        selectedTextField = textField.tag
        if(selectedTextField == 100) {
            self.getCountryNames()
        } else if(selectedTextField == 200){
            self.getStatesNames(state: countryAbbrivation)
        }

    }
    

}
