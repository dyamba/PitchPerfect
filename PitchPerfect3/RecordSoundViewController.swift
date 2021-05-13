//
//  RecordSoundViewController.swift
//  PitchPerfect3
//
//  Created by Unsal Aslan on 11.05.2021.
//

import UIKit
import AVFoundation

class RecordSoundViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var recordingLabel2: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!

    var audioRecorder:AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        stopRecordingButton.isEnabled=false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear called")
        
        
    }

    @IBAction func recordAudio(_ sender: Any) {
        recordingLabel2.text="Recording in Progress"
        stopRecordingButton.isEnabled=true
        recordButton.isEnabled=false
        
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        print(filePath!)

        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)


        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate=self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    
    
    @IBAction func stopRecoring(_ sender: Any) {
        
        recordingLabel2.text="Tab to Record"
        stopRecordingButton.isEnabled=false
        recordButton.isEnabled=true
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        print("finish recording")
        if(flag){
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }
        else{
            print("record was not successful")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="stopRecording"{
            let playSoundVC=segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            
            playSoundVC.recordedAudioURL=recordedAudioURL
        }
    }
}

