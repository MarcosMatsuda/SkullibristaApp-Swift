//
//  ViewController.swift
//  SkullibristaApp
//
//  Created by Marcos V. S. Matsuda on 07/12/18.
//  Copyright © 2018 Marcos V. S. Matsuda. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    
    @IBOutlet weak var streets: UIImageView!
    @IBOutlet weak var player: UIImageView!
    @IBOutlet weak var viewGameOver: UIView!
    @IBOutlet weak var lbTimePlayed: UILabel!
    @IBOutlet weak var lbInstructions: UILabel!
    
    var isMoving = false
    lazy var motionManager = CMMotionManager()
    var gameTimer: Timer!
    var startDate: Date!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewGameOver.isHidden = true
        lbInstructions.isHidden = false
        
        streets.frame.size.width = view.frame.size.width * 2
        streets.frame.size.height = streets.frame.size.width * 2
        streets.center = view.center
        player.center = view.center
        player.animationImages = []
        
        for i in 0...7{
            let image = UIImage(named: "player\(i)")!
            player.animationImages?.append(image)
        }
        player.animationDuration = 0.5
        player.startAnimating()
        
        Timer.scheduledTimer(withTimeInterval: 6.0, repeats: false) { (timer) in
            self.start()
        }
    }
    
    @IBAction func playAgain(_ sender: UIButton) {
        start()
    }
    
    func start(){
        lbInstructions.isHidden = true
        viewGameOver.isHidden = true
        isMoving = false
        startDate = Date()
        self.player.transform = CGAffineTransform(rotationAngle: 0)
        self.streets.transform = CGAffineTransform(rotationAngle: 0)

        if motionManager.isDeviceMotionAvailable {
            motionManager.startDeviceMotionUpdates(to: OperationQueue.main) { (data, error) in
                if error == nil {
                    if let data = data{

                        let angle = atan2(data.gravity.x, data.gravity.y) - .pi
                        self.player.transform = CGAffineTransform(rotationAngle: CGFloat(angle))

                        if !self.isMoving {
                            self.checkGameOver()
                        }
                    }

                }
            }
        }

        gameTimer = Timer.scheduledTimer(withTimeInterval: 4.0, repeats: true, block: { (timer) in
            self.rotateWorld()
        })
    }
    
    func checkGameOver(){
        let worldAngle = atan2(Double(streets.transform.a), Double(streets.transform.b))
        let playerAngle = atan2(Double(player.transform.a), Double(player.transform.b))
        let difference = abs(worldAngle - playerAngle)
        if difference > 0.25 {
            gameTimer.invalidate()
            viewGameOver.isHidden = false
            motionManager.stopDeviceMotionUpdates()
            
            let secondsPlayed = round(Date().timeIntervalSince(startDate))
            lbTimePlayed.text = "Você jogou durante \(secondsPlayed) segundos"
        }
    }
    
    func rotateWorld(){
        let randomAngle = Double(arc4random_uniform(120))/100 - 0.6
        isMoving = true
        UIView.animate(withDuration: 0.75, animations: {
            self.streets.transform = CGAffineTransform(rotationAngle: CGFloat(randomAngle))
        }){(success) in
            self.isMoving = false
        }
        
        
    }
    
    

}

