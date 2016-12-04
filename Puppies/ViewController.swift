//
//  ViewController.swift
//  Puppies
//
//  Created by Richard Su on 12/3/16.
//  Copyright © 2016 Richard Su. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var puppyView: UIImageView!
    var puppyURLs:[String] = []
    var previousPuppyIndex:Int = -1
    var player: AVAudioPlayer?
    let barkSound = Bundle.main.url(forResource: "puppyBark", withExtension: "wav")!
    let meowSound = Bundle.main.url(forResource: "kittyMeow", withExtension: "wav")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadURLs()
        showCutePuppy()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.incomingPuppy(_:)))
        puppyView.addGestureRecognizer(tapGesture)
        puppyView.isUserInteractionEnabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func incomingPuppy(_ sender: UITapGestureRecognizer) {
        showCutePuppy()
        bark()
    }
    
    func showCutePuppy() {
        var puppyIndex = Int(arc4random_uniform(UInt32(puppyURLs.count)))
        if puppyIndex == previousPuppyIndex {
            puppyIndex = Int(arc4random_uniform(UInt32(puppyURLs.count)))
        }
        previousPuppyIndex = puppyIndex
        let THEpuppyURL = URL(string: puppyURLs[puppyIndex])
        
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: THEpuppyURL!)
            DispatchQueue.main.async {
                self.puppyView.image = UIImage(data: data!)
            }
        }
    }
    
    func bark() {
        do {
            if previousPuppyIndex == puppyURLs.count - 1 {
                player = try AVAudioPlayer(contentsOf: meowSound)
            } else {
                player = try AVAudioPlayer(contentsOf: barkSound)
            }
            guard let player = player else { return }
            
            player.prepareToPlay()
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func loadURLs() {
        if let path = Bundle.main.path(forResource: "puppyURLs", ofType: "txt") {
            do {
                let data = try String(contentsOfFile: path, encoding: .utf8)
                puppyURLs = data.components(separatedBy: .newlines)
                puppyURLs = puppyURLs.filter { $0.characters.count > 4 }
            } catch {
                print("no puppies :(")
            }
        }
    }

}

