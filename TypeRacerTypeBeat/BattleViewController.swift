//
//  BattleViewController.swift
//  TypeRacerTypeBeat
//
//  Created by Ethan Fox on 3/19/22.
//

import UIKit
import random_swift

class BattleViewController: UIViewController {

    var word = String()
    var character = String()
    var difficulty = 1        //0=easy, 1=normal, 2=hard
    var timer: Timer!
    var alive = true
    
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var echoLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //hiding the blinking cursor
        textField.tintColor = UIColor.clear
        textLabel.lineBreakMode = .byClipping
        
        //RANDOM WORD INPUT
        
        //normal difficulty
        if difficulty == 1 {
            //we will make our own array of words eventually
            var randWords = [String]()
            var temp = 0
            //normal difficulty gives 20 words? or maybe we will give infinite words and they need to hit a certain score before the time is up.
            while(temp < 20){
                let word = Random.word
                if (word.count < 10 && word.count > 4){
                    randWords.append(word)
                    temp = temp + 1
                }
            }
            //joining array of words into a long string. we would have to continually check and update the string with additional words if we go score based
            let randStringOfWords = randWords.joined(separator: " ")
            textLabel.text = randStringOfWords
            setFirstChar()
        }
        
        //calling textFieldDidChange for each key press
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        
        //below are for features in testing
        //textField.addTarget(self, action: #selector(self.loop), for: .editingChanged)
        //timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.callAttack), userInfo: nil, repeats: true)
        
    }
    
    
    
    //immediately loading keyboard with view controller
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textField.becomeFirstResponder()
    }
    
    //function to set the character var to the first character in the string on initial load or when user gets input correct and removes a letter
    func setFirstChar() {
        let text = textLabel.text!
        character = String(text.prefix(1))
    }
            
    
    //function to reset the text label containing the random words, which is hovering above the text field for user input
    func resetRandString() {
        let text = textLabel.text!
        textLabel.text = String(text.dropFirst())
    }

    
    //called on each key press
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        //setting input to key pressed by user
        let input = textField.text
        
        //Once random words are empty, I'd like the text box to shake from extra input, which it doesn't if it's empty
        if (character.isEmpty) {
            self.textField.shake()
        }
        
        //if user input matches first letter from string of random words
        if ((input?.hasPrefix(character)) != false) {
            
            //removing the user input
            textField.text = String(input!.dropFirst())
            
            //putting the popped character to echo label
            echoLabel.text = character
            
            //updating random word string and new first character to check againt
            resetRandString()
            setFirstChar()
            
        }
        
        else {
            //removing the user input
            textField.text = String(input!.dropFirst())
            
            //shake textbox when wrong
            self.textField.shake()
        }
        
    }
    
    //Testing features until end of class - may not be used
    
    /*
    @objc func loop() {

        let possibleChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ💣❄️🧨🌈⭐️🍄"
        var char = ""
        char.append(possibleChars.randomElement()!)

        //let chars = ["a":"a","b":"b","c":"c"]
        let right = self.view.frame.width + 25
        let bottom = self.view.frame.height + 25
        //let locations = [-100.0:0.0,-100.1:-100.1,-0.5:-100.2,100.3:-100.3,200.4:-100.4, 300:-100, 400:-100, 500:-100, 500.1:0,550:50 ]
        let locations = [-25.03:400,-25.02:350,-25.0:300.0,-25.01:250,-24.9:200,-24.99:150, -24.8:100,-24.999:50, -25.1:0]
            
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        label.center = CGPoint(x: locations.keys.randomElement()!, y: locations.values.randomElement()!)
        label.textAlignment = .center
        label.text = char
        char = ""

        self.view.addSubview(label)
              
        charAttack(label)

        timer.invalidate()
     }

     
     @objc func callAttack() {
         
     }
     
     
     func charAttack(_ Sender:UILabel) {
        
        UIView.animate(withDuration: 9, animations: {
        
        Sender.center = CGPoint(x: (self.view.layer.frame.width)/2, y: (self.view.layer.frame.height)/2 - 200)

        //Sender.center.x = CGFloat(locations.keys.randomElement()!)
        //Sender.center.y = CGFloat(locations.values.randomElement()!)
        

        }, completion: {_ in
            
            //self.alive = false
            //Sender.textColor = .clear
            Sender.removeFromSuperview()
            
        })
    }
    
     
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

*/
}
//shaking text box on bad input
extension UIView {
    func shake(){
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.08
        animation.repeatCount = 1
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 10, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 10, y: self.center.y))
        self.layer.add(animation, forKey: "position")
    }
}
