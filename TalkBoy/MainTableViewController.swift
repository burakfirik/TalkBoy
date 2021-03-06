//
//  MainTableViewController.swift
//  TalkBoy
//
//  Created by Burak Firik on 12/8/17.
//  Copyright © 2017 Code Path. All rights reserved.
//

import UIKit
import AVFoundation

class MainTableViewController: UITableViewController {
  var sounds: [Sound] =  []
  var audioPlayer : AVAudioPlayer?
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  
  func getSound() {
    if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
      if let sound = try? context.fetch(Sound.fetchRequest()) as? [Sound] {
        if let soundData = sound {
          sounds = soundData
          tableView.reloadData()
        }
      }
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    getSound()
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return sounds.count
  }
  
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
    
    // Configure the cell...
    let sound = sounds[indexPath.row]
    if let soundRow = sound.name {
      cell.textLabel?.text = soundRow
    }
    return cell
  }
  
  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
        let sound = sounds[indexPath.row]
        context.delete(sound)
        getSound()
      }
    }
  }
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     let sound = sounds[indexPath.row]
    if let audioData = sound.audioData {
      audioPlayer = try? AVAudioPlayer(data: audioData)
      audioPlayer?.play()
    }
    
  }
  
  
  /*
   // Override to support rearranging the table view.
   override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
   
   }
   */
  
  /*
   // Override to support conditional rearranging of the table view.
   override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
   // Return false if you do not want the item to be re-orderable.
   return true
   }
   */
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
}
