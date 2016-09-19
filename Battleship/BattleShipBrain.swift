//
//  File.swift
//  Battleship
//
//  Created by C4Q on 9/17/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import Foundation

class BattleShipBrain {
    
    
    //this will allow me to set up the orientation randomly later in my code
    func vertOrHor() -> State {
        let randomNum = Int(arc4random_uniform(2))
        if randomNum == 0 {
            return .verticle
        } else {
            return .horizontal
        }
    }
    
    
    //this stores the value of the orientation for use in my code
    enum State {
        case verticle
        case horizontal
    }
    
    //this allows me to store the length of the different ships in the game. it annoys me to no end that cruiser and sub arent different. oh well.
    enum Ship: Int {
        case destroyer = 2
        case cruiserOrSubmarineWeNeedBetterRadarToConfirm = 3
        case battleship = 4
        case carrier = 5
        case openWater = 0
    }
    
    //this allows me to set a value to each row in the code
    private let alphabet = ["A","B","C","D","E","F","G","H","I","J"]
    
    //this is the board which i will fill later on
    var board = [(Int, String, Ship)]()
    
    
    //this looks through the board and checks to see if there is space for your ship to sit, the following two do the same thing, but for vertical.
    private func checkBoardHorizontally(range: CountableRange<Int>) -> Bool {
        for i in range {
            if board[i].2 != .openWater {
                return false
            }
        }
        return true
    }
    
    private func checkBoardVerticallyUp (x: Int, z: Int) -> Bool{
        for i in 0..<z {
            if board[x + (i * 10)].2 != .openWater {
                return false
            }
        }
        return true
    }
    
    private func checkBoardVerticallyDown (x: Int, z: Int) -> Bool{
        for i in 0..<z {
            if board[x - (i * 10)].2 != .openWater {
                return false
            }
        }
        return true
    }
    
    //this allows you to apply all your functions to make sure you can set your shit nicely
    
    private func setShip(ship: Ship, y: State) {
        let z = ship.rawValue
        
        switch y {
        case .horizontal:
            setHorizontal(z: z, ship: ship)
        case .verticle :
            setVerticle(z: z, ship: ship)
        }
    }
    
    //this sets horizontally. the ranges are based on moving forward when i can and backwards when i cant. the reason for the while loop is that i dont know how many times i will be checking through my board to find the right spot based on random numbers. the following is the same basic principle, but you do not need to check a range you are checking multiples of 10. there is probably a way to go about this utilizing the numbers and letters i assigned earlier but i am very tired of this homework :/.
    
    // z is always the length of the ship, the ship will always be the one you have called, x will be a random number
    
    func setHorizontal( z: Int, ship: Ship) {
        var repeatThisCheck = true
        repeat {
            let x = Int(arc4random_uniform(100))
            let range1 = x..<(x + z)
            let range2 = (x - z)..<x
            var rangeToUse = range1
            if rangeToUse ~= 100{
                rangeToUse = range2
            }
            if checkBoardHorizontally(range: rangeToUse) && board[rangeToUse.lowerBound].1 == board[rangeToUse.upperBound].1 {
                repeatThisCheck = false
                for q in rangeToUse  {
                    board[q].2 = ship
                }
            }
        } while repeatThisCheck == true
    }
    
    func setVerticle(z: Int, ship: Ship){
        var repeatThisCheck = true
        repeat {
            let x = Int(arc4random_uniform(100))
            if x + ((z - 1) * 10) < 100 && checkBoardVerticallyUp(x: x, z: z){
                repeatThisCheck = false
                for i in 0..<z {
                    board[x + (i * 10)].2 = ship
                }
            } else if x - ((z - 1) * 10) >= 0 && checkBoardVerticallyDown(x: x, z: z){
                repeatThisCheck = false
                for i in 0..<z {
                    board[x - (i * 10)].2 = ship
                }
            }
            
        }while repeatThisCheck == true
        
    }
    
    //this creates a board and then fills it with your ships randomly. the nested loop will append the number value as the column and a letter as the row.
    
    private func setUpGame() {
        
        for x in 0...9 {
            for i in 1...10 {
                board.append((i, alphabet[x], .openWater))
            }
        }
        setShip(ship: .cruiserOrSubmarineWeNeedBetterRadarToConfirm, y: vertOrHor())
        setShip(ship: .cruiserOrSubmarineWeNeedBetterRadarToConfirm, y: vertOrHor())
        setShip(ship: .battleship, y: vertOrHor())
        setShip(ship: .carrier, y: vertOrHor())
        setShip(ship: .destroyer, y: vertOrHor())
    }
    
    //this checks to see if your shot has resulted in hitting a target or not. it will let you know what target (for debugging and proof) or if you missed the target entirely.
    
    func checkYourShot (boardPosition: Int) -> (String, Bool) {
        switch board[boardPosition].2 {
        case .battleship:
            return ("You hit a battleship!", true)
        case .carrier:
            return ("You hit a carrier!", true)
        case .destroyer:
            return ("You hit a destroyer!", true)
        case .cruiserOrSubmarineWeNeedBetterRadarToConfirm:
            return ("You hit something! We dont know if its a cruiser or a submarine though.", true)
        case .openWater:
            return ("You completelty missed. Luckily the military budget can handle this easily.", false)
        }
    }

    //have to init the game!
    init() {
        setUpGame()
    }
}

