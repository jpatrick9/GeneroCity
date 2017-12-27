//
//  SplashScreen.swift
//  Generocity
//
//  Created by Dante  Lacey-Thompson on 11/22/17.
//  Copyright © 2017 Dante  Lacey-Thompson. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class SplashScreen: UIViewController {
    @IBOutlet weak var videoHolder: UIStackView!
    
    var player: AVPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadVideo()
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
    
    
    //Mark: Private functions
    private func loadVideo() {
        
        //this line is important to prevent background music stop
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
        } catch { }
        
        guard let path = Bundle.main.path(forResource: "Comp1", ofType:"mp4")else{
            debugPrint("Video not found")
            return
        }
        
        let item = AVPlayerItem(url: URL(fileURLWithPath: path))
        
        NotificationCenter.default.addObserver(self, selector: #selector(SplashScreen.finishedPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: item)
        
        player = AVPlayer(playerItem: item)
        let playerLayer = AVPlayerLayer(player: player)
        
        playerLayer.frame = self.view.frame
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        playerLayer.zPosition = -1
        
        
        self.videoHolder.layer.addSublayer(playerLayer)
        
        player?.play()
    }
    
    func finishedPlaying(note: NSNotification){
        performSegue(withIdentifier: "splashToSignIn", sender: self)
    }
}
