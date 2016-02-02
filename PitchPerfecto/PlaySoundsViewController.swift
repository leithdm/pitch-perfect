//
//  PlaySoundsViewController.swift
//  PitchPerfecto
//
//  Created by Darren Leith on 01/02/2016.
//  Copyright © 2016 Darren Leith. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
  
  //MARK: - outlets
  var audioPlayer = AVAudioPlayer()
  var recordedAudio: RecordedAudio?
  var audioEngine: AVAudioEngine!
  var audioFile: AVAudioFile!
  
  //MARK: - viewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()
    
    audioEngine = AVAudioEngine()
    audioFile = try! AVAudioFile(forReading: (recordedAudio?.filePathUrl)!)
    
    if let recordedAudio = recordedAudio {
      audioPlayer = try! AVAudioPlayer(contentsOfURL: recordedAudio.filePathUrl)
      audioPlayer.enableRate = true
    }

  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  
  //MARK: - playSound
  func playSound(rate: Float, currentTime: Double) {
    audioPlayer.rate = rate
    audioPlayer.currentTime = currentTime
    audioPlayer.play()
    
  }
  
  //MARK: - playSlowly
  @IBAction func playSlowly(sender: UIButton) {
    audioEngine.stop()
    audioEngine.reset()
    playSound(0.5, currentTime: 0.0)
  }
  
  //MARK: - playFast
  @IBAction func playFast(sender: UIButton) {
    audioEngine.stop()
    audioEngine.reset()
    playSound(1.5, currentTime: 0.0)
  }
  
  //MARK: - playVariablePitch
  func playAudioWithVariablePitch(pitch: Float) {
    audioPlayer.stop()
    audioEngine.stop()
    audioEngine.reset()
    
    let audioPlayerNode = AVAudioPlayerNode()
    audioEngine.attachNode(audioPlayerNode)
    
    let timePitch = AVAudioUnitTimePitch()
    timePitch.pitch = pitch
    audioEngine.attachNode(timePitch)
    
    audioEngine.connect(audioPlayerNode, to: timePitch, format: nil)
    audioEngine.connect(timePitch, to: audioEngine.outputNode, format: nil)
    
    audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
    try! audioEngine.start()
    audioPlayerNode.play()
  }
  
  //MARK: - playChipmunk
  @IBAction func playChipMunk(sender: UIButton) {
    playAudioWithVariablePitch(1000)
      }

  //MARK: - playDarthVader
  @IBAction func playDarthVader(sender: UIButton) {
    playAudioWithVariablePitch(-800)
  }
  
  //MARK: - stop
  @IBAction func stop(sender: UIButton) {
    audioPlayer.stop()
  }
  
}
