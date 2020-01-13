//
//  SecondStageViewController.swift
//  ShurikenShooter
//
//  Created by il17aag on 12/01/2020.
//  Copyright © 2020 il17aag. All rights reserved.
//

import UIKit
import AVFoundation

class SecondStageViewController: UIViewController, subViewDelegate
{
    var dynamicA: UIDynamicAnimator!
    var dynamicB: UIDynamicItemBehavior!
    var collusionB: UICollisionBehavior!
    var ninjaCollusion: UICollisionBehavior!
    var obCollusion: UICollisionBehavior!
    var shurikenImageArray: [UIImageView] = []
    var villanViewArray: [UIImageView] = []
    
    var musicEffect: AVAudioPlayer = AVAudioPlayer()
    var sound: AVAudioPlayer = AVAudioPlayer()
    var chargeSound: AVAudioPlayer = AVAudioPlayer()
    var woodImage: UIImageView?
    let wooImage = UIImage(named: "woodSub")
    var imgSize: CGSize?
    var imgPoint: CGPoint?
    
    var score = 0
    var countdown = 20
    var timer = Timer()
    
    let A = UIScreen.main.bounds.width
    let B = UIScreen.main.bounds.height
    
    var sideX: CGFloat? = 0
    var sideY: CGFloat? = 0
    
    var imageArray = [UIImage(named: "frame32.gif")!,
                      UIImage(named: "frame33.gif")!,
                      UIImage(named: "frame34.gif")!,
                      UIImage(named: "frame35.gif")!,
                      UIImage(named: "frame36.gif")!,
                      UIImage(named: "frame37.gif")!,
                      UIImage(named: "frame38.gif")!,
                      UIImage(named: "frame39.gif")!,
                      UIImage(named: "frame40.gif")!,
                      UIImage(named: "frame41.gif")!,
                      UIImage(named: "frame42.gif")!,
                      UIImage(named: "frame43.gif")!,
                      UIImage(named: "frame44.gif")!,
                      UIImage(named: "frame45.gif")!,
                      UIImage(named: "frame46.gif")!,
                      UIImage(named: "frame47.gif")!]
    
    let villanImageArray = [UIImage(named: "villan1.png")!,
        UIImage(named:"villan2.png")!,
        UIImage(named:"villan3.png")!,
        UIImage(named:"villan4.png")!,
        UIImage(named:"villan5.png")!
    ]
    
    func updatethrow()
    {
        targetSling.image = UIImage(named: "launch")
    }
    func changethrow()
    {
        targetSling.image = UIImage(named: "throw")
    }
    
    func chargethrow()
    {
        targetSling.image = UIImage(named: "charge")
    }
    
    func updateShuriken(currentPosition: CGPoint)
    {
        sideX = currentPosition.x
        sideY = currentPosition.y
    }
    
    func generateShuriken()
    {
        let shurikenImage = UIImageView(image: UIImage(named: "shuriken"))
        shurikenImage.frame = CGRect(x: A*0.08, y: B*0.47, width: A*0.10, height: B*0.17)
        self.view.addSubview(shurikenImage)
        
        let angleX = sideX! - self.targetSling.bounds.midX
        let angleY = sideY! - B*0.5
        
        shurikenImageArray.append(shurikenImage)
        dynamicB.addItem(shurikenImage)
        dynamicB.addLinearVelocity(CGPoint(x: angleX*5, y:angleY*5), for:shurikenImage)
        collusionB.addItem(shurikenImage)
        
        let vanish = DispatchTime.now() + 3
        DispatchQueue.main.asyncAfter(deadline: vanish){
            shurikenImage.removeFromSuperview()
        }
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        start()
        playBGMusic()
        //Background Animation
        createBackgroundImage()
        self.view.bringSubviewToFront(targetSling)
        self.view.bringSubviewToFront(points)
        self.view.bringSubviewToFront(timeBox)
        self.view.bringSubviewToFront(timelimit)
        self.view.bringSubviewToFront(info)

        woodImage = UIImageView(image: wooImage)
        self.createObstacle()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.counter), userInfo: nil, repeats: true)
        
        self.targetSling.center.x = self.A * 0.10
        self.targetSling.center.y = self.B * 0.50
               
        targetSling.myDelegate = self
               
        dynamicA = UIDynamicAnimator(referenceView: self.view)
        dynamicB = UIDynamicItemBehavior(items: shurikenImageArray)
        dynamicA.addBehavior(dynamicB)
        dynamicA.addBehavior(ninjaCollusion)
               
        collusionB = UICollisionBehavior(items: [])
               
               
        collusionB = UICollisionBehavior(items: shurikenImageArray)
        //collisionBehavior.translatesReferenceBoundsIntoBoundary = true
               
        collusionB.addBoundary(withIdentifier: "LEFTScreen" as NSCopying, from: CGPoint(x: self.A*0.0, y: self.B*0.0), to: CGPoint(x: self.A*0.0, y: self.B*1.0))
               
        collusionB.addBoundary(withIdentifier: "TOPScreen" as NSCopying, from: CGPoint(x: self.A*0.0, y: self.B*0.0), to: CGPoint(x: self.A*1.0, y: self.B*0.0))
              
        collusionB.addBoundary(withIdentifier: "BOTTOMScreen" as NSCopying, from: CGPoint(x: self.A*0.0, y: self.B*1.0), to: CGPoint(x: self.A*1.0, y: self.B*1.0))
         collusionB.addBoundary(withIdentifier: "ObstacleBoundary" as NSCopying, from: CGPoint(x: self.A*0.60, y: self.B*0.3), to: CGPoint(x: self.A*0.65, y: self.B*0.6))
        
        dynamicA.addBehavior(collusionB)
    }
    
    override func didReceiveMemoryWarning()
    {
                   super.didReceiveMemoryWarning()
    }
    
    func createVillanImage()
    {
    let enemy = 5
    let villanSize = Int(self.B)/enemy-2
    
    for index in 0...1000
    {
        let when = DispatchTime.now() + (Double(index)/2)
        DispatchQueue.main.asyncAfter(deadline: when)
        {
            while true
            {
                let randomHeight = Int(self.B)/enemy * Int.random(in: 0...enemy)
                let villanView = UIImageView(image: nil)
                villanView.image = self.villanImageArray.randomElement()
                villanView.frame = CGRect(x: self.A-CGFloat(villanSize), y:  CGFloat(randomHeight), width: CGFloat(villanSize),
                               height: CGFloat(villanSize))
                self.view.addSubview(villanView)
                self.view.bringSubviewToFront(villanView)
                               
                for anyVillanView in self.villanViewArray
                {
                    if villanView.frame.intersects(anyVillanView.frame)
                    {
                        villanView.removeFromSuperview()
                        continue
                    }
                }
                               
                self.villanViewArray.append(villanView)
                break;
            }
        }
                       
        }
    }
    
    func start()
    {
        self.createVillanImage()
        dynamicA = UIDynamicAnimator(referenceView: self.view)
        targetSling.frame = CGRect(x:A*0.02, y: B*0.4, width: A*0.2, height: B*0.2)
        targetSling.myDelegate = self
        ninjaCollusion = UICollisionBehavior(items: villanViewArray)
        self.ninjaCollusion.action =
        {
            for shurikenView in self.shurikenImageArray
            {
                for villanView in self.villanViewArray
                {
                    let index = self.villanViewArray.firstIndex(of: villanView)
                    if shurikenView.frame.intersects(villanView.frame)
                    {
                        self.targetSling.myDelegate?.playChargeSound()
                        self.chargeSound.stop()
                        self.playCollisionSound()
                        let scoreCount = self.view.subviews.count
                        villanView.removeFromSuperview()
                        self.villanViewArray.remove(at:index!)
                        let countEnd = self.view.subviews.count
                        if(scoreCount != countEnd)
                        {
                            self.score += 1
                            self.updateScore()
                        }
                    }
                }
            }
        }
        dynamicA.addBehavior(ninjaCollusion)
    }
    
    func updateScore()
    {
        points.text = "Score: " + "\(score)"
    }
    
    @objc func counter()
    {
        countdown -= 1
        timelimit.text = String(countdown)
        if (countdown == 0) {
            if (score >= 15)
            {
                timelimitreached()
                musicEffect.stop()
            }
            else
            {
               
                gameover()
                musicEffect.stop()
            }
        }
    }
    
    func gameover()
    {
        //performSegue(withIdentifier: "score", sender: self)
        let main = UIStoryboard(name: "Main", bundle: nil)
        let finito = main.instantiateViewController(identifier: "gameOverVC")
        self.present(finito, animated: true, completion: nil)
    }
    
    func timelimitreached()
    {
        let main = UIStoryboard(name: "Main", bundle: nil)
        let complete = main.instantiateViewController(identifier: "thirdstageVC")
        self.present(complete, animated: true, completion: nil)
    }
    
    func createObstacle()
    {
        imgPoint = CGPoint(x: self.A*0.50, y: self.B*0.25)
        imgSize = CGSize(width: self.A*0.30, height: self.B*0.35)
        woodImage!.frame = CGRect(origin: self.imgPoint!, size: self.imgSize!)
        self.view.addSubview(woodImage!)
        //collusionB.addBoundary(withIdentifier: "woodCollusion" as NSCopying, for: UIBezierPath(rect: woodImage!.frame))
    }
    func playCollisionSound()
    {
        let musicFile = Bundle.main.path(forResource: "CollideSound", ofType: ".mp3")
        do{
            try sound = AVAudioPlayer(contentsOf: URL (fileURLWithPath: musicFile!))
            
        }
        catch{
            print(error)
        }
        sound.play()
    }
    
    func playBGMusic()
    {
        let musicFile = Bundle.main.path(forResource: "SecondStageSound", ofType: ".mp3")
        do{
            try musicEffect = AVAudioPlayer(contentsOf: URL (fileURLWithPath: musicFile!))
            
        }
        catch{
            print(error)
        }
        musicEffect.play()
    }
    
    func playChargeSound()
    {
        let musicFile = Bundle.main.path(forResource: "ChargeSound", ofType: ".mp3")
        do{
            try chargeSound = AVAudioPlayer(contentsOf: URL (fileURLWithPath: musicFile!))
            
        }
        catch{
            print(error)
        }
        chargeSound.play()
    }
    func createBackgroundImage()
    {
        let backImages = UIImageView(image: nil)
        backImages.image = UIImage.animatedImage(with: imageArray, duration: 2.5)
        backImages.frame = CGRect(x: self.A*0.0, y: self.B*0.0, width: self.A, height: self.B)
        self.view.addSubview(backImages)
    }

    @IBOutlet weak var info: UILabel!
    @IBOutlet weak var timelimit: UILabel!
    @IBOutlet weak var points: UILabel!
    @IBOutlet weak var targetSling: SlingShooter!
    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var timeBox: UIImageView!
    
}
