//
//  BattleViewController.swift
//  TypeRacerTypeBeat
//
//  Created by Ethan Fox on 3/19/22.
//

import UIKit

class BattleViewController: UIViewController{

    //game vars
    var word = String()
    var character = String()
    var difficulty = 1
    var alive = true
    let game = GameManager()
    
    //vars for keeping track of WPM/CPS
    var wordInputted = false
    var oldTime = Double(0)
    var charPerSecond = Int()
    var wordTimes = [Double]()
    var wordPerSec = [Double]()
    
    //enable/disable depending on challenge (one at a time, they use the same label currently)
    var WPM = true
    var CPS = false
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var echoLabel: UILabel!
    @IBOutlet weak var perSecondLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //hiding the blinking cursor and elipses in main text label
        textField.tintColor = UIColor.clear
        textLabel.lineBreakMode = .byClipping
        
        constantRandomWords(0)
        
        //Ensuring infinite random words
        textField.addTarget(self, action: #selector(constantRandomWords(_:)), for: .editingChanged)
        
        //calling textFieldDidChange for each key press
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        //Animations
        textField.addTarget(self, action: #selector(self.loop), for: .editingChanged)
        
        //Enables CPS fields
        if (CPS){
            charsPerSecond()
            Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.charsPerSecond), userInfo: nil, repeats: true)
        }
        
        //Enables WPM fields
        if(WPM){
            wordsPerMinute()
            Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.wordsPerMinute), userInfo: nil, repeats: true)
        }
    }
    
    //Adds the time dif between words to an array
    func wpmCalc() {
        _ = Double(0)
        let currentTime = CACurrentMediaTime()
        if oldTime.isZero{
            oldTime = currentTime
            return
        }
        let dif = currentTime - oldTime
        
        wordTimes.append(dif)
        oldTime = currentTime
    }
    
    //called each second - calculates the WPM each second based on averages of average WPS
    @objc func wordsPerMinute() {
        var sum = Double(0)
        var ctr = Double(0)
        
        //averaging the words per second
        while(!wordTimes.isEmpty) {
            let tmp = wordTimes.removeFirst()
            sum += tmp
            ctr += 1
        }
        
        var total = sum / ctr
        
        //injecting WPS into array
        if (total.isNaN){
            total = 0
        }
        
        if (wordPerSec.count > 59){
            wordPerSec.removeFirst()
        }
        
        if (wordPerSec.count < 61){
            if wordInputted {
                wordPerSec.append(total)
            }
            //if no words were added to the array within the past second, append a 0 as WPS
            else {
                wordPerSec.append(0)
            }
        }
        var final = Double()
        var i = Int(0)
        
        //if >60 different WPS in array, add and multiply for WPM
        if wordPerSec.count < 60{
            i=0
            let multi = 60 / wordPerSec.count
            while i < wordPerSec.count {
                let asd = wordPerSec[i]
                final += asd
                i += 1
            }
            final *= Double(multi)
        }
        
        //if full 60 WPS, add them all for WPM
        if wordPerSec.count == 60 {
        i=0
            while i < wordPerSec.count {
                let asd = wordPerSec[i]
                final += asd
                i += 1
            }
        }
        
        if final.isNaN {
            final = 0.0
        }
        
        if final.isInfinite {
            final = 999
        }
        
        perSecondLabel.text = String(final)
        
        wordInputted = false
    }
    
    //sets CPS
    @objc func charsPerSecond() {
        self.perSecondLabel.text = String(self.charPerSecond)
        self.charPerSecond = 0
    }
    
    //called on each key press
    @objc func constantRandomWords(_ Sender: Any) {
        var length = Int()
        length = self.textLabel.text!.count
        
        //while >60 chars of random words, add a new random word to end
        while (length < 60){
            let tmp = randomWordCreation()
            textLabel.text!.append(tmp+" ")
            length = length + 1
        }
    }
    
    //returns a random word based on difficulty
    func randomWordCreation() -> String {
        let listOfAllWords = ["asdf"]
        let word = listOfAllWords.randomElement()
            
        //following ifs are for when difficulty is implemented
        if (difficulty < 2){
            if (word!.count < 6 && word!.count > 1){
                return(word!)
            }
        }
        if (difficulty >= 2 && difficulty < 3) {
            if (word!.count < 8 && word!.count > 2){
                return(word!)
            }
        }
        if (difficulty >= 3 && difficulty < 4) {
            if (word!.count < 10 && word!.count > 4){
                return(word!)
            }
        }
        return("failure")
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
    func resetRandomString() {
        let text = textLabel.text!
        textLabel.text = String(text.dropFirst())
    }

    
    //called on each key press
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        //setting input to key pressed by user
        let input = textField.text
        
        //Once random words are empty, I'd like the text box to shake from extra input, which it doesn't if it's empty
        if (character.isEmpty) {
            shake()
        }
        
        //if user input matches first letter from string of random words
        if ((input?.hasPrefix(character)) != false) {
            
            //removing the user input
            textField.text = String(input!.dropFirst())
            
            //putting the popped character to echo label
            echoLabel.text = character

            if (CPS){
                charPerSecond += 1
            }
            if (WPM){
                if (textLabel.text?.first == " ") {
                    wordInputted = true
                    wpmCalc()
                }
            }
            
            //updating random word string and new first character to check against
            resetRandomString()
            setFirstChar()
        }
        
        else {
            //removing the user input
            textField.text = String(input!.dropFirst())
            
            //shake textbox when wrong
            shake()
        }
    }
    
    //Calling attack animation for each key press
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
        label.text = character

        self.view.addSubview(label)
              
        charAttack(label)

        //timer.invalidate()
     }
     
    //Attack animation
     func charAttack(_ Sender:UILabel) {
        
        UIView.animate(withDuration: 6, animations: {
        
            Sender.center = CGPoint(x: (self.view.layer.frame.width)/8, y: (self.view.layer.frame.height)/2)
            
        }, completion: {_ in
            
            Sender.removeFromSuperview()
            
        })
    }
    
    //shaking text box on bad input
    func shake(){
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.08
        animation.repeatCount = 1
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.textLabel.center.x - 10, y: self.textLabel.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.textLabel.center.x + 10, y: self.textLabel.center.y))
        textLabel.layer.add(animation, forKey: "position")
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



