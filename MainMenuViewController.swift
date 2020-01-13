//
//  MainMenuViewController.swift
//  ShurikenShooter
//
//  Created by il17aag on 12/01/2020.
//  Copyright © 2020 il17aag. All rights reserved.
//

import UIKit
import AVFoundation

class MainMenuViewController: UIViewController
{
    var musicEffect: AVAudioPlayer = AVAudioPlayer()
    let A = UIScreen.main.bounds.width
    let B = UIScreen.main.bounds.height

    func createBackgroundImage()
    {
        let backImages = UIImageView(image: nil)
        backImages.image = UIImage(named: "StartUpImage.jpg")
        backImages.frame = CGRect(x: self.A*0.0, y: self.B*0.0, width: self.A, height: self.B)
        self.view.addSubview(backImages)
    }
    @IBOutlet weak var musicBtnImage: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        createBackgroundImage()
        self.view.bringSubviewToFront(musicBtn)
        self.view.bringSubviewToFront(playBtn)
        let musicFile = Bundle.main.path(forResource: "MainMenuMusic", ofType: ".mp3")
        do{
            try musicEffect = AVAudioPlayer(contentsOf: URL (fileURLWithPath: musicFile!))
            
        }
        catch{
            print(error)
        }
        musicEffect.play()
        
    }

    @IBAction func musicButton(_ sender: Any)
    {
        if musicBtnImage.currentBackgroundImage == UIImage(named: "musicON"){
            musicBtnImage.setBackgroundImage(UIImage(named:"musicOFF"), for: .normal)
            musicEffect.stop()
        }
        else{
            musicBtnImage.setBackgroundImage(UIImage(named:"musicON"), for: .normal)
            musicEffect.play()
        }
        
    }
    
    @IBAction func playGame(_ sender: Any)
    {
        musicEffect.stop()
    }
    
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var musicBtn: UIButton!
    
}
