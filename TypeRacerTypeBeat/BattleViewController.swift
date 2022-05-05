//
//  BattleViewController.swift
//  TypeRacerTypeBeat
//
//  Created by Ethan Fox on 3/19/22.
//

import UIKit
import CoreData

class BattleViewController: UIViewController {

    //game vars
    var word = String()
    var character = String()
    var lives = 3
    public var gold = 0
    var level = 1
    var alive = true
    let game = GameManager()
    let home = ViewController()
    var timer: Timer?
    var runCount = 0
    var noErrorChal = false
    var cpsChal = false
    var wordsChal = false
    var wordsToType = 10
    var timeRemaining = 10.0
    var challengeStart = false
    var chosenChallenge = 0
    
    //vars for keeping track of WPM/CPS
    var wordInputted = false
    var oldTime = Double(0)
    @objc var charPer = Int()
    var wordPer = Int()
    var wordTimes = [Double]()
    var wordPerSec = [Double]()
    
    //enable/disable depending on challenge
    var WPM = false
    var CPS = true
   
    
    @IBOutlet weak var goldEarnedLabel: UILabel!
    @IBOutlet weak var gameOverLabel: UILabel!
    @IBOutlet weak var challengeLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var playerHealthLabel: UILabel!
    @IBOutlet weak var goldLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var echoLabel: UILabel!
    @IBOutlet weak var CPMLabel: UILabel!
    @IBOutlet weak var returnHomeButton: UIButton!
    
    @IBOutlet weak var heart3: UIImageView!
    @IBOutlet weak var heart2: UIImageView!
    @IBOutlet weak var heart1: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialization()
        
        levelStart()
        
    }
    
    func initialization () {
        //build list of enemy images
        enemyList()
        
        //removing predictive bar on keyboard
        textField.autocorrectionType = .no
        
        //hiding the blinking cursor and elipses in text label
        textField.tintColor = UIColor.clear
        textLabel.lineBreakMode = .byClipping
        
        //loading random words at start
        constantRandomWords(0)
        
        //calling textFieldDidChange for each key press
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        //Ensuring infinite random words
        textField.addTarget(self, action: #selector(constantRandomWords(_:)), for: .editingChanged)
        
        //Enables WPM fields
        if(WPM){
            wordsPerMinute()
            Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.wordsPerMinute), userInfo: nil, repeats: true)
        }
        
        playerHealthLabel.text = String(lives)
        goldLabel.text = String(gold)
        levelLabel.text = String(level)
        timerLabel.text = String(runCount)
        returnHomeButton.isHidden = true
        gameOverLabel.isHidden = true
        
        
        print("init completed")
    }
    
    func levelStart() {
        noErrorChal = false
        cpsChal = false
        randEnemy()
        randomChallenge()
    }
    
    func randomChallenge() {
        runCount = 0
        let challenges = [1, 2] //,self.wpmChal,self.noErrChal,self.numWordsChal]
        chosenChallenge = challenges.randomElement()!
        if chosenChallenge == 1 {
            noErrorCall()
        }
        if chosenChallenge == 2 {
            cpsCall()
        }
        if chosenChallenge == 3 {
            wordsCall()
        }
        
        return
    }
    
    func updateNoErrLabel() {
        challengeLabel.text = "Type " + String(wordsToType) + " words without errors within " + String(format: "%.1f", self.timeRemaining) + " seconds!"
    }
    
    func updateCpsLabel() {
        challengeLabel.text = "Maintain " + String(charPer) + " / " + String(level) + " char per second for " + String(format: "%.1f", self.timeRemaining) + " seconds!"
    }
    
    func updateWordsLabel() {
        challengeLabel.text = "Type " + String(wordsToType) + " within " + String(format: "%.1f", self.timeRemaining) + " seconds!"
    }
    
    func wordsCall() {
        print("called wordscall")
        wordsToType = 5
        self.timeRemaining = 10
        wordsToType = wordsToType + level - 1
        updateWordsLabel()
        if challengeStart == false {
            return
        }
        wordsChal = true
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { timer in
            
            if self.lives < 1 {
                timer.invalidate()
                //self.gameOver()
                //self.noErrorChal = false
            }
            self.timeRemaining -= 0.1
            if self.timeRemaining < 0 {
                self.timeRemaining = 0.0
            }
            if String(format: "%.1f",self.timeRemaining) == "0.0" {
                self.updateWordsLabel()
                timer.invalidate()
                //self.noErrorChal = false
                if self.wordsToType > 0 {
                    self.loseLife()
                    if self.lives < 1 {
                        self.gameOver()
                    }
                    self.levelStart()
                }
            }
            
            self.updateNoErrLabel()
            
        })
    }
    
    func noErrorCall() {
        print("called actualnoerr")
        wordsToType = 3
        self.timeRemaining = 10
        wordsToType = wordsToType + level - 1
        updateNoErrLabel()
        if challengeStart == false {
            return
        }
        noErrorChal = true
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { timer in
            
            if self.lives < 1 {
                timer.invalidate()
                //self.gameOver()
                //self.noErrorChal = false
            }
            self.timeRemaining -= 0.1
            if self.timeRemaining < 0 {
                self.timeRemaining = 0.0
            }
            if String(format: "%.1f",self.timeRemaining) == "0.0" {
                self.updateNoErrLabel()
                timer.invalidate()
                //self.noErrorChal = false
                if self.wordsToType > 0 {
                    self.loseLife()
                    if self.lives < 1 {
                        self.gameOver()
                    }
                    self.levelStart()
                }
            }
            
            self.updateNoErrLabel()
            
        })
    }
    
    func cpsCall(){
        print("called actualcps")
        timeRemaining = 10
        updateCpsLabel()
        //calling a check per second
        if challengeStart == false {
            return
        }
        cpsChal = true
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { [self] timer in
            
            
            self.timeRemaining -= 0.1
            if self.timeRemaining < 0 {
                self.timeRemaining = 0.0
            }
            
            if self.lives < 1 {
                timer.invalidate()
                return
            }

            if (String(format: "%.1f", self.timeRemaining.truncatingRemainder(dividingBy: 1))) == "0.0" {
                if (charPer < level) {
                    loseLife()
                    if lives < 1 {
                        return
                    }
                }
                charPer = 0
            }
            
            if (String(format: "%.1f", self.timeRemaining) == "0.0") {
                timer.invalidate()
                levelPassed()
                return
            }
            
            self.updateCpsLabel()
            
        })
    }
    
    func loseLife() {
        lives -= 1
        if lives == 2 {
            heart1.isHidden = true
        }
        if lives == 1 {
            heart2.isHidden = true
        }
        if lives == 0 {
            heart3.isHidden = true
        }
        playerHealthLabel.text = String(lives)
        if lives == 0 {
            gameOver()
        }
    }
    
    
    @objc func randEnemy() {
        //randImage.image = enemyImages.randomElement()
    }
    
    func wpmCalc() { //called every complete word
        _ = Double(0)
        let currentTime = CACurrentMediaTime()
        if oldTime.isZero{
            oldTime = currentTime
            return
        }
        
        var dif = currentTime - oldTime
        
        wordTimes.append(dif)
        oldTime = currentTime
    }
    
    func levelPassed() {
        gold += (100 * level)
        level += 1
        goldLabel.text = String(gold)
        levelLabel.text = String(level)
        challengeStart = false
        levelStart()
    }
    
    func gameOver(){
        //heart1.isHidden = true
        //heart2.isHidden = true
        //heart3.isHidden = true
        home.totalGold += gold
        home.save()
        print(home.totalGold, gold)
        //home.save()
        //game over label
        //show level reached or score
        //show buttons to return home
        self.view.endEditing(true)
        returnHomeButton.isHidden = false
        gameOverLabel.isHidden = false
        goldEarnedLabel.text = ("+" + String(gold) + " Gold Earned!")
        
    }
    
    
    @objc func wordsPerMinute() { //called each second
        
        var total = Double(0)
        
        //averaging the words per second
        while(!wordTimes.isEmpty) {
            wordTimes.removeFirst()
            
            total += 1
        }
        
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
            CPMLabel.text = String(final)
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
        
        CPMLabel.text = String(final)
        
        wordInputted = false
        /*
            if (self.wordPer < Int(final)){
                print("real v")
            }
            else {
                print("real ^")
            }
         */
    }
    
    @objc func constantRandomWords(_ Sender: Any) {
        var length = Int()
        length = self.textLabel.text!.count
        var finalRandom = [String]()
        
        while (length < 60){
            let tmp = randomWordCreation()
            
            textLabel.text!.append(tmp+" ")
            length = length + 1
        }

    }
    
    func randomWordCreation() -> String {
        let listOfAllWords = ["asdf"]
        
        let word = listOfAllWords.randomElement()
        /*
        if (level < 2){
            if (word!.count < 6 && word!.count > 1){
                return(word!)
            }
        }
        if (level >= 2 && level < 3) {
            if (word!.count < 8 && word!.count > 2){
                return(word!)
            }
        }
        if (level >= 3 && level < 4) {
            if (word!.count < 10 && word!.count > 4){
                return(word!)
            }
        }
        */
        
        setFirstChar()
        return(word!)
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
        if challengeStart == false {
            challengeStart = true
            if chosenChallenge == 1 {
                print("calling 1")
                noErrorCall()
            }
            if chosenChallenge == 2 {
                print("calling 2")
                cpsCall()
            }
            
        }
        
        //setting input to key pressed by user
        let input = textField.text
        
        //if user input matches first letter from string of random words
        if (input?.hasPrefix(character) == true) {
            
            //removing the user input
            textField.text = String(input!.dropFirst())
            
            //putting the popped character to echo label
            echoLabel.text = character
            
            let locations = [-25.03:400,-25.02:350,-25.0:300.0,-25.01:250,-24.9:200,-24.99:150, -24.8:100,-24.999:50, -25.1:0]
               
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            label.center = CGPoint(x: locations.keys.randomElement()!, y: locations.values.randomElement()!)
            label.textAlignment = .center
            label.text = character

            self.view.addSubview(label)
                  
            charAttack(label)
            
            if (cpsChal == true){
                charPer += 1
            }
            
            if (textLabel.text!.first == " ") {
                if (WPM) {
                    wordInputted = true
                    wordPer += 1
                    wpmCalc()
                }
                if (noErrorChal) {
                    wordsToType -= 1
                    updateNoErrLabel()
                    if Int(wordsToType) == 0 {
                        timer?.invalidate()
                        levelPassed()
                    }
                }
            }
            resetRandomString()
            setFirstChar()
        }
        else {
            //removing the user input
            textField.text = String(input!.dropFirst())
            
            //shake textbox when wrong
            textField.shake()
            
            if noErrorChal {
                loseLife()
                playerHealthLabel.text = String(lives)
                if lives == 0 {
                    if timeRemaining < 0 {
                        timeRemaining = 0
                    }
                    noErrorChal = false
                    gameOver()
                    return
                }
            }
        }
        
    }
    
    
    
    //Testing features until end of class - may not be used
    
    
    @objc func loop() {

        let possibleChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ💣❄️🧨🌈⭐️🍄"
        var char = ""
        char.append(possibleChars.randomElement()!)

        //let chars = ["a":"a","b":"b","c":"c"]
        let right = self.view.frame.width + 25
        let bottom = self.view.frame.height + 25
        let locations = [-100.0:0.0,-100.1:-100.1,-0.5:-100.2,100.3:-100.3,200.4:-100.4, 300:-100, 400:-100, 500:-100, 500.1:0,550:50 ]
        //let locations = [-25.03:400,-25.02:350,-25.0:300.0,-25.01:250,-24.9:200,-24.99:150, -24.8:100,-24.999:50, -25.1:0]
            
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        label.center = CGPoint(x: locations.keys.randomElement()!, y: locations.values.randomElement()!)
        label.textAlignment = .center
        label.text = character

        self.view.addSubview(label)
              
        charAttack(label)

     }
     
     func charAttack(_ Sender:UILabel) {
        
        UIView.animate(withDuration: 3, animations: {
        
        Sender.center = CGPoint(x: (self.view.layer.frame.width)/8, y: (self.view.layer.frame.height)/2)


        }, completion: {_ in
            
            Sender.removeFromSuperview()
            
        })
    }
    
    
    func enemyList () {
        var enemyImages = [UIImage(named: "Animal_Cow.png")!,UIImage(named: "Animal_Turtle.png")!,UIImage(named: "Animal_Duck.png")!,UIImage(named: "Animal_Piglet.png")!]
    }
    
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


