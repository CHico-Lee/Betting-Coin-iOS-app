//
//  ResultScenceViewController.swift
//  Mobile App Dev TeamFinalProject
//  Team: Mrunalini Askam
//        Sikhaben Patel
//        Chi Ho Lee
//  Date: 11/30/17
//  Description: This is the ResultScenceViewController for Coin Betting Result.
//               Before the view appear, static data will be loaded form other
//               viewcontroller and fomat to display on the textView.
//               When the player hit the return button, the view will dismiss
//               and player will return to the game.

import UIKit

class ResultScenceViewController: UIViewController {

    @IBOutlet weak var resultTextView: UITextView!
    
    @IBAction func returnButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let numPlays = (presentingViewController as! ViewController).numOfPlays
        let numHeads = (presentingViewController as! ViewController).numHeads
        let numTails = (presentingViewController as! ViewController).numTails
        let numWins = (presentingViewController as! ViewController).numWins
        let numLoses = (presentingViewController as! ViewController).numLoses
        let maxBet = (presentingViewController as! ViewController).maxBet
        let money = (presentingViewController as! ViewController).totalMoney
        
        resultTextView.text = """
        Number of plays: \(30 - numPlays)
        Number of heads: \(numHeads)
        Number of tails: \(numTails)
        
        Number of wins: \(numWins)
        Number of loses: \(numLoses)
        
        Maximum bet: \(maxBet)$
        Profit on money: \(money - 100)$
        """
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
