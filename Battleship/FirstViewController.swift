//
//  FirstViewController.swift
//  Battleship
//
//  Created by Jason Gresh on 9/16/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    let brain = BattleShipBrain()
    
    @IBOutlet weak var buttonContainer: UIView!
    @IBOutlet weak var gameLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpGameButtons(v: buttonContainer)
        // Do any additional setup after loading the view, typically from a nib.
    }

    func setUpGameButtons(v: UIView) {
        for i in 0...99 {
            let y = ((i) / 10)
            let x = ((i) % 10)
            let side : CGFloat = v.bounds.size.width / CGFloat(10)
            
            let rect = CGRect(origin: CGPoint(x: side * CGFloat(x), y: (CGFloat(y) * side)), size: CGSize(width: side, height: side))
            let button = UIButton(frame: rect)
            button.tag = i
            button.setTitle("\(brain.board[i].0)\(brain.board[i].1)", for: UIControlState())
            button.backgroundColor = UIColor.blue
            button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
            v.addSubview(button)
        }
    }
    func buttonTapped (button: UIButton) {
        let result = brain.checkYourShot(boardPosition: button.tag)
        gameLabel.text = result.0
        if result.1 {
            button.backgroundColor = UIColor.red
        } else {
            button.backgroundColor = UIColor.cyan
        }
    }
}

