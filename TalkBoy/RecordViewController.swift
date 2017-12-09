//
//  RecordViewController.swift
//  TalkBoy
//
//  Created by Burak Firik on 12/8/17.
//  Copyright © 2017 Code Path. All rights reserved.
//

import UIKit
import AVFoundation

class RecordViewController: UIViewController {
  
  @IBOutlet weak var recordButton: UIButton!
  @IBOutlet weak var playButton: UIButton!
  @IBOutlet weak var soundNameTextField: UITextField!
  @IBOutlet weak var addButton: UIButton!
  var audioRecorder : AVAudioRecorder?
  var audioPlayer : AVAudioPlayer?
  var audioURL: URL?
  
  @IBAction func recordBtn(_ sender: Any) {
    if let audioRecorder = self.audioRecorder {
      if (audioRecorder.isRecording) {
        audioRecorder.stop()
        recordButton.setTitle("Record", for: .normal)
        playButton.isEnabled = true
        soundNameTextField.isEnabled = true
        addButton.isEnabled = true
      } else {
        audioRecorder.record()
        recordButton.setTitle("Stop", for: .normal)
        playButton.isEnabled = false
        soundNameTextField.isEnabled = false
        addButton.isEnabled = false
      }
    }
  }
  
  @IBAction func playBtn(_ sender: Any) {
    if let audioURL = self.audioURL {
      audioPlayer = try? AVAudioPlayer(contentsOf: audioURL)
      audioPlayer?.play()
    }
    
  }
  
  
  @IBAction func addBtn(_ sender: Any) {
    if let context =  (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
      let sound = Sound(entity: Sound.entity(), insertInto: context)
      sound.name  = soundNameTextField.text
      if let audioURL = self.audioURL {
        sound.audioData = try? Data(contentsOf: audioURL)
        try? context.save()
      }
      navigationController?.popViewController(animated: true)
    }
    
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let session = AVAudioSession.sharedInstance()
    try? session.setCategory(AVAudioSessionCategoryPlayAndRecord)
    try? session.overrideOutputAudioPort(.speaker)
    try? session.setActive(true)
    
    if let basePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
      let baseComponents = [basePath,"audio.m4a"]
      if let audioURL = NSURL.fileURL(withPathComponents: baseComponents) {
        var settings: [String: Any] = [:]
        self.audioURL = audioURL
        settings[AVFormatIDKey] = Int(kAudioFormatMPEG4AAC)
        settings[AVSampleRateKey] = 44100.0
        settings[AVNumberOfChannelsKey] = 2
        audioRecorder = try? AVAudioRecorder(url: audioURL, settings: settings)
        audioRecorder?.prepareToRecord()
      }
    }
    playButton.isEnabled = false
    soundNameTextField.isEnabled = false
    addButton.isEnabled = false
    
    
    
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}
