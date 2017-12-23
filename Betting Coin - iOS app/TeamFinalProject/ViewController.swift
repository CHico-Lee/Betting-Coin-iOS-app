//
//  ViewController.swift
//  Mobile App Dev TeamFinalProject
//  Team: Mrunalini Askam
//        Sikhaben Patel
//        Chi Ho Lee
//  Date: 11/30/17
//  Description: This is the viewController for Coin Betting Game.
//               Player can will hit the "Place Bet" button after they input the bet amount.
//               The coin image will animate for 2 seconds follow by the result head or tail.
//               If the player win, he/she will earn the bet amount, otherwise he/she will lose
//               the bet. The game will finish after 30 plays or player is out of money.
//               After that player can review the static result of the game, restart for a new game,
//               or exit the game.

import UIKit

class ViewController: UIViewController {

    let headTail = ["head", "tail"]
    
    let coinImages = [
        UIImage(named: "coin1.png")!,   // head
        UIImage(named: "coin2.png")!,   // tail
        UIImage(named: "coin3.png")!,   // side
    ]
    
    var totalMoney = 100
    var numOfPlays = 30
    
    // For static
    var numHeads = 0
    var numTails = 0
    var numWins = 0
    var numLoses = 0
    var maxBet = 0
    
    @IBOutlet weak var totalMoneyLabel: UILabel!
    @IBOutlet weak var playsLeftLabel: UILabel!
    
    @IBOutlet weak var coinImageView: UIImageView!
    
    @IBOutlet weak var headTailSegmentControl: UISegmentedControl!
    
    @IBOutlet weak var betAmountTextField: UITextField!
    
    @IBOutlet weak var placeBetButton: UIButton!
    @IBOutlet weak var seeResultButton: UIButton!
    @IBOutlet weak var restartButton: UIButton!
    
    @IBAction func placeButtonClicked(_ sender: Any) {
        
        // checking bet amount must be valid number
        if let betAmount = Int(betAmountTextField.text!)
        {
            if betAmount > totalMoney || betAmount <= 0
            {
                invalidInput()
                return
            }
            else
            {
                // update max bet for static
                if betAmount > maxBet
                {
                    maxBet = betAmount
                }
            }
        }
        else
        {
            // bet amount field is empty
            invalidInput()
            return
        }

        // disble UI, no betting value should change during coin is flipping
        placeBetButton.isEnabled = false
        seeResultButton.isEnabled = false
        restartButton.isEnabled = false
        headTailSegmentControl.isEnabled = false
        betAmountTextField.isEnabled = false
        
        
        // Update number of plays remaining
        numOfPlays -= 1
        playsLeftLabel.text = "\(numOfPlays)"
        
        let betAmount = Int(betAmountTextField.text!)
        totalMoney -= betAmount!
        totalMoneyLabel.text = "\(totalMoney)$"
        
        // start playing animate of flipping coin
        coinImageView.animationImages = coinImages
        coinImageView.startAnimating()
        
        // duration of coin flipping animation
        let delayInSeconds = 2.0
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayInSeconds) {
            // after 2 second, execute func coinFlipResult()
            self.coinFlipResult()
        }
    }
    

    // Function to display alert message for invaild bet amount.
    func invalidInput() {
        let alertController = UIAlertController(title: "Incorrect bet amount", message: "Please enter the bet between 0 to \(totalMoney).", preferredStyle: UIAlertControllerStyle.alert)
        let alertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: {(alertAction:UIAlertAction)in self.handleEndofGame()})
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
    
    // Function to handler result after coin flipping.
    func coinFlipResult() {
        
        // Stop coin animation, and display the resulting coin
        coinImageView.stopAnimating()
        let rnd = Int (arc4random_uniform(2))
        coinImageView.image = coinImages[rnd]
        
        let betAmount = Int(betAmountTextField.text!)

        var alertTitle = ""
        var alertMessage = ""
        
        // Determine player win or lose
        if rnd == headTailSegmentControl.selectedSegmentIndex
        {
            // win
            totalMoney += betAmount! * 2
            alertTitle = "It's a \(headTail[rnd])!"
            alertMessage = "You earn \(betAmount!)$."
            numWins += 1
        }
        else
        {
            // lose
            alertTitle = "It's a \(headTail[rnd])!"
            alertMessage = "You lose \(betAmount!)$."
            numLoses += 1
        }
        
        // calculate total number of heads and tails for static
        if rnd == 0
        {
            numHeads += 1
        }
        else
        {
            numTails += 1
        }
        
        // Update total money after win or lose
        totalMoneyLabel.text = "\(totalMoney)$"
        
        // Enable all UI for the next play
        placeBetButton.isEnabled = true
        seeResultButton.isEnabled = true
        restartButton.isEnabled = true
        headTailSegmentControl.isEnabled = true
        betAmountTextField.isEnabled = true
        
        // Display result for this game using alert message.
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        let alertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: {(alertAction:UIAlertAction)in self.handleEndofGame()})
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
        
    }
    
    // Function to check if the game is over.
    func handleEndofGame() {
        var alertTitle = ""
        
        if numOfPlays <= 0
        {
            alertTitle = "You've finish all 30 plays"
        }
        else if totalMoney <= 0
        {
            alertTitle = "You've spent all the money"
        }
        else
        {
            return  // Game continue.
        }
        
        // Disable UI for next game.
        placeBetButton.isEnabled = false
        headTailSegmentControl.isEnabled = false
        betAmountTextField.isEnabled = false
        
        // Display alert message to ask player to play again, see result or exit.
        let alertController = UIAlertController(title: alertTitle, message: "You finish the game with \(totalMoney)$.", preferredStyle: UIAlertControllerStyle.alert)
        
        let playAgainAction = UIAlertAction(title: "Play Again", style: UIAlertActionStyle.default, handler: {
            (alertAction:UIAlertAction) in
            self.gameRestart()
        })
        let seeResultsAction = UIAlertAction(title: "See Results", style: UIAlertActionStyle.default, handler: {
            (alertAction:UIAlertAction) in
            self.performSegue(withIdentifier: "toResultScene", sender: nil) // Go to seeReultScene
        })
        let exitAction = UIAlertAction(title: "Exit", style: UIAlertActionStyle.cancel, handler: {
            (alertAction:UIAlertAction) in
            exit(0)
        })
        
        alertController.addAction(playAgainAction)
        alertController.addAction(seeResultsAction)
        alertController.addAction(exitAction)
        present(alertController, animated: true, completion: nil )
        
    }
    
    // Function to reset all variable for restarting a new game.
    func gameRestart() {
        totalMoney = 100
        totalMoneyLabel.text = "\(totalMoney)$"
        numOfPlays = 30
        playsLeftLabel.text = "\(numOfPlays)"
        numHeads = 0
        numTails = 0
        numWins = 0
        numLoses = 0
        maxBet = 0
        
        betAmountTextField.text = nil
        
        // enable UI for new game.
        placeBetButton.isEnabled = true
        headTailSegmentControl.isEnabled = true
        betAmountTextField.isEnabled = true
    }
    
    @IBAction func restartButtonClicked(_ sender: Any) {
        gameRestart()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // Hide keyborad if player clicked on blank area.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

