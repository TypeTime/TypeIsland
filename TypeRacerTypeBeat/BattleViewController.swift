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
   
    
    
    @IBOutlet weak var labelImage: UIImageView!
    @IBOutlet weak var enemyImage: UIImageView!
    @IBOutlet weak var goldEarnedLabel: UILabel!
    @IBOutlet weak var gameOverLabel: UILabel!
    @IBOutlet weak var challengeLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var echoLabel: UILabel!
    @IBOutlet weak var returnHomeButton: UIButton!
    @IBOutlet weak var returnHomeImage: UIImageView!
    
    //animal unlocks
    //game over animals
    @IBOutlet weak var cowPic: UIImageView!
    @IBOutlet weak var pigPic: UIImageView!
    @IBOutlet weak var duckPic: UIImageView!
    @IBOutlet weak var turtlePic: UIImageView!
    @IBOutlet weak var catPic: UIImageView!
    //main screen animals
    @IBOutlet weak var turtlePic1: UIImageView!
    @IBOutlet weak var turtlePic2: UIImageView!
    @IBOutlet weak var duckPic1: UIImageView!
    @IBOutlet weak var duckPic2: UIImageView!
    @IBOutlet weak var duckPic3: UIImageView!
    @IBOutlet weak var cowPic1: UIImageView!
    @IBOutlet weak var pigPic1: UIImageView!
    @IBOutlet weak var catPic1: UIImageView!
    
    
    
    //hearts
    @IBOutlet weak var heart3: UIImageView!
    @IBOutlet weak var heart2: UIImageView!
    @IBOutlet weak var heart1: UIImageView!
    
    //hitmarkers
    
    @IBOutlet weak var hit3: UIImageView!
    @IBOutlet weak var hit2: UIImageView!
    @IBOutlet weak var hit1: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialization()
        
        levelStart()
        
    }
    
    func initialization () {
        
        //removing predictive bar on keyboard
        textField.autocorrectionType = .no

        textLabel.text?.removeFirst()
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
        
        catPic1.image = UIImage(cgImage: (catPic.image?.cgImage!)!, scale: 1.0, orientation: .upMirrored)

        returnHomeButton.isHidden = true
        returnHomeImage.isHidden = true
        gameOverLabel.isHidden = true
        
        //game over animals
        turtlePic.isHidden = true
        catPic.isHidden = true
        duckPic.isHidden = true
        pigPic.isHidden = true
        cowPic.isHidden = true
        
        //unlocks
        turtlePic1.isHidden = true
        turtlePic2.isHidden = true
        duckPic1.isHidden = true
        duckPic2.isHidden = true
        duckPic3.isHidden = true
        cowPic1.isHidden = true
        catPic1.isHidden = true
        pigPic1.isHidden = true
        
        
        print("init completed")
    }
    
    
    
    func levelStart() {
        noErrorChal = false
        cpsChal = false
        wordsChal = false
        randEnemy()
        randomChallenge()
    }
    
    func randomChallenge() {
        runCount = 0
        let challenges = [1, 2, 3] //,self.wpmChal,self.noErrChal,self.numWordsChal]
        chosenChallenge = challenges.randomElement()!
        var tmp = chosenChallenge
        
        if chosenChallenge == 1 {
            noErrorCall()
            tmp = 1
        }
        if chosenChallenge == 2 {
            cpsCall()
            tmp = 2
        }
        if chosenChallenge == 3 {
            wordsCall()
            tmp = 3
        }
        
        return
    }
    
    func updateNoErrLabel() {
        challengeLabel.text = "Type " + String(wordsToType) + " words WITHOUT ERRORS within " + String(format: "%.1f", self.timeRemaining) + " seconds!"
    }
    
    func updateCpsLabel() {
        challengeLabel.text = "Maintain " + String(charPer) + " / " + String(level) + " char per second for " + String(format: "%.1f", self.timeRemaining) + " seconds!"
    }
    
    func updateWordsLabel() {
        challengeLabel.text = "Type " + String(wordsToType) + " words within " + String(format: "%.1f", self.timeRemaining) + " seconds!"
    }
    
    func wordsCall() {
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
                        //self.gameOver()
                        return
                    }
                    self.wordsChal = false
                    self.levelStart()
                    return
                }
            }
            
            self.updateWordsLabel()
            
        })
    }
    
    func noErrorCall() {
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
                        //self.gameOver()
                        return
                    }
                    self.levelStart()
                    return
                }
            }
            
            self.updateNoErrLabel()
            
        })
    }
    
    func cpsCall(){
        timeRemaining = 6
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
        if lives == 0 {
            gameOver()
        }
    }
    
    
    @objc func randEnemy() {
        let enemyImages = [UIImage(named: "Animal_Cow(Scaled).png")!,UIImage(named: "Animal_Turtle(Scaled).png")!,UIImage(named: "Animal_Duck(Scaled).png")!,UIImage(named: "Animal_Piglet(Scaled).png")!, UIImage(named: "Animal_Saimese(Scaled).png")!]
        enemyImage.image = UIImage(cgImage: ((enemyImages.randomElement())?.cgImage!)!, scale: 1.0, orientation: .upMirrored)
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
        challengeStart = false
        levelStart()
    }
    
    func gameOver(){
        home.totalGold += gold
        home.save()
        self.view.endEditing(true)
        returnHomeButton.isHidden = false
        returnHomeImage.isHidden = false
        gameOverLabel.isHidden = false
        goldEarnedLabel.text = ("+" + String(gold) + " Gold Earned!")
        let purchasedItems = UserDefaults.standard.array(forKey: "purchasedItems")
        if purchasedItems![0] as! Int == 1 {
            turtlePic.image = UIImage(cgImage: (turtlePic.image?.cgImage!)!, scale: 1.0, orientation: .upMirrored)
            turtlePic.isHidden = false
        }
        if purchasedItems![1] as! Int == 1 {
            catPic.image = UIImage(cgImage: (catPic.image?.cgImage!)!, scale: 1.0, orientation: .upMirrored)
            catPic.isHidden = false
        }
        if purchasedItems![2] as! Int == 1 {
            duckPic.isHidden = false
        }
        if purchasedItems![3] as! Int == 1 {
            pigPic.isHidden = false
        }
        if purchasedItems![4] as! Int == 1 {
            cowPic.isHidden = false
        }
        
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
        //textLabel.text?.removeFirst()
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
        let listOfAllWords = ["yummy", "would", "move", "you", "mad", "mountain", "cut", "yawn", "style", "reading", "typing", "hospital", "cat", "dog", "bear", "turtle", "forest", "beach", "airplane", "beautiful", "courage", "dumpster", "tasty", "shower", "nice", "dirty", "me", "stinky", "clean", "chicken", "pottery", "waffle", "pancake", "calm", "vibe", "illuminate", "vacuum", "beans", "crib", "swag", "yolo", "strap", "vibrations", "espouse", "macrocosm", "type", "island", "waffles", "saimese", "balinese", "tabby", "dalmatian", "corgi", "husky", "shepherd", "keyboard", "codepath", "university", "ios", "waitlist", "pizza", "pasta", "broccoli", "cabbage", "hummus", "conglomerate", "hegemony", "barbeque", "tortoise", "video", "games", "space", "ship", "crane", "rose", "mitsubishi", "toyota", "honda", "notebook", "system", "font", "label", "attack", "view", "animate", "duration", "point", "ice", "cream", "milk","orange", "apple", "eggs", "juice", "ham", "bat", "monkey", "orangutan", "create", "extension", "size", "requirement", "explore", "collection", "swift", "yuji", "muny", "hot", "meta", "post", "membership", "open", "book", "parameter", "family", "regular", "location", "guilty", "gear", "among", "us", "suspect", "simple", "combo", "mom", "dad", "sister", "brother", "cousin", "beat", "windows", "activate", "setting", "go", "build", "frequent", "visit", "mischievous", "shameless", "female", "male", "placement", "onomatopoeia", "cascade", "brewery", "octopus", "squid", "salmon", "tentacles", "starfish", "sponge", "crab", "plankton", "sand", "mississippi", "massachusetts", "ceaser", "anemone", "database", "whippersnapper", "incubation", "flabbergast", "hullabaloo", "abracadabra", "accoutrements", "aloof", "alfredo", "burrito", "apparatus", "electron", "proton", "neutron", "atom", "molecule", "asparagus", "tomato", "barnacle", "thunder", "lightning", "poison", "ground", "grass", "water", "fire", "dark", "steel", "bug", "psychic", "flying", "configuration", "highlight", "maintain", "content", "scale", "fill", "cow", "pig", "volcano", "water", "hydro", "flask", "phone", "led", "ocean", "forest", "tree","bush","razor","insanity","termite","butterfly","ethereum","mazda","program","blizzard","slushie","beach","snow","mountain","icicle","collect","gold","ruby","python","swift","github","advancement","impact","strong","weak"]
        
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
        print(textLabel.text)
        
        if challengeStart == false {
            challengeStart = true
            if chosenChallenge == 1 {
                noErrorCall()
            }
            if chosenChallenge == 2 {
                cpsCall()
            }
            if chosenChallenge == 3 {
                wordsCall()
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
            //label.center = CGPoint(x: locations.keys.randomElement()!, y: locations.values.randomElement()!)
            label.center = CGPoint(x: 40, y: 566)
            label.textColor = .white
            label.textAlignment = .center
            label.font = UIFont(name: "Press Start", size: 14)
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
                if (wordsChal) {
                    wordsToType -= 1
                    updateWordsLabel()
                    if Int(wordsToType) == 0 {
                        timer?.invalidate()
                        levelPassed()
                    }
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
            labelImage.shake()
            
            if noErrorChal {
                loseLife()
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

        let right = self.view.frame.width + 25
        let bottom = self.view.frame.height + 25
        let locations = [-100.0:0.0,-100.1:-100.1,-0.5:-100.2,100.3:-100.3,200.4:-100.4, 300:-100, 400:-100, 500:-100, 500.1:0,550:50 ]
        //let locations = [-25.03:400,-25.02:350,-25.0:300.0,-25.01:250,-24.9:200,-24.99:150, -24.8:100,-24.999:50, -25.1:0]
            
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        label.center = CGPoint(x: locations.keys.randomElement()!, y: locations.values.randomElement()!)
        label.textAlignment = .center
        label.font = UIFont(name: "Press Start", size: 14)
        label.text = character
        

        self.view.addSubview(label)
              
        charAttack(label)

     }
     
     func charAttack(_ Sender:UILabel) {
        
        
        
        UIView.animate(withDuration: 1, animations: {
        
            Sender.center = CGPoint(x: (self.view.layer.frame.width)/2, y: (self.view.layer.frame.height)/3)


        }, completion: {_ in
            
            Sender.removeFromSuperview()
            
            
            var i = 0
            var tmpTimer: Timer?
            tmpTimer = Timer.init(timeInterval: 0.1, repeats: true) { _ in
                print("wdfasdfasdf")
                if i == 0 {
                    return
                }
                if i == 2 {
                    tmpTimer!.invalidate()
                }
                i += 1
                
                
            }
            
            UIView .animate(withDuration: 0.5, animations: {
                let attacks = [UIImage(named: "Hit_X.png")!,UIImage(named: "Hit_Simple")!,UIImage(named: "Hit_Impact.png")!]
                let rand = [1,2,3]
                    
                let tmp = rand.randomElement()
                if tmp == 1 {
                    self.hit1.image = attacks.randomElement()
                    self.hit1.isHidden = false
                    
                }
                if tmp == 2 {
                    self.hit2.image = attacks.randomElement()
                    
                    self.hit2.isHidden = false
                    
                }
                if tmp == 3 {
                    

                    self.hit3.image = attacks.randomElement()
                    
                    self.hit3.isHidden = false
                    
                }
            }, completion: {_ in
                let seconds = 0.1
                DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                    self.hit1.isHidden = true
                    self.hit2.isHidden = true
                    self.hit3.isHidden = true
                }
                })
            
        
            
        })
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


