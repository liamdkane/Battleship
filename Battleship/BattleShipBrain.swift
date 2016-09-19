//
//  File.swift
//  Battleship
//
//  Created by C4Q on 9/17/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import Foundation

class BattleShipBrain {
    
    func vertOrHor() -> State {
        let randomNum = Int(arc4random_uniform(2))
        if randomNum == 0 {
            return .verticle
        } else {
            return .horizontal
        }
    }
    
    enum State {
        case verticle
        case horizontal
    }
    
    enum Ship: Int {
        case destroyer = 2
        case cruiserOrSubmarineWeNeedBetterRadarToConfirm = 3
        case battleship = 4
        case carrier = 5
        case openWater = 0
    }
    
    private let alphabet = ["A","B","C","D","E","F","G","H","I","J"]
    
    var board = [(Int, String, Ship)]()
    
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
    
    private func setShip(ship: Ship, a: Int, y: State) {
        let z = ship.rawValue
        
        switch y {
        case .horizontal:
            setHorizontal(z: z, ship: ship)
        case .verticle :
            setVerticle(z: z, ship: ship)
        }
    }
    
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
    
    private func setUpGame() {
        
        for x in 0...9 {
            for i in 1...10 {
                board.append((i, alphabet[x], .openWater))
            }
        }
        setShip(ship: .cruiserOrSubmarineWeNeedBetterRadarToConfirm, a: 1, y: vertOrHor())
        setShip(ship: .cruiserOrSubmarineWeNeedBetterRadarToConfirm, a: 2, y: vertOrHor())
        setShip(ship: .battleship, a: 3, y: vertOrHor())
        setShip(ship: .carrier, a: 4, y: vertOrHor())
        setShip(ship: .destroyer, a: 5, y: vertOrHor())
    }
    
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

    init() {
        setUpGame()
    }
}

