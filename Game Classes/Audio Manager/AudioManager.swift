//
//  AudioManager.swift
//  Jack the Giant
//
//  Created by Quan Lieu on 5/18/18.
//  Copyright © 2018 Quan Lieu. All rights reserved.
//

import AVFoundation

class AudioManager {
    static let instance = AudioManager()
    private init() {}
    
    private var audioPlayer: AVAudioPlayer?
    
    func playBGMusic() {
        let url = Bundle.main.url(forResource: "Background music", withExtension: "mp3")
        var err: NSError?
        do {
            try audioPlayer = AVAudioPlayer(contentsOf: url!)
            audioPlayer?.numberOfLoops = -1
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch let err1 as NSError {
            err = err1
        }
        
        if err != nil {
            print("We have a problem \(String(describing: err))")
        }
    }
    
    func stopBGMusic() {
        if (audioPlayer?.isPlaying)! {
            audioPlayer?.stop()
        }
    }
    
    func isAudioPlayerInitialized() -> Bool {
        return audioPlayer != nil;
    }
}
