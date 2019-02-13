//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Sarah on 10/24/18.
//  Copyright © 2018 Sarah. All rights reserved.
//


import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController , AVAudioRecorderDelegate {
    
    var audioRecorder : AVAudioRecorder!

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recoedingLable: UILabel!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        theContentMode()
        stopRecordingButton.isEnabled = false
        print("viewDidLoad called ")
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear called ")
    }

    func theContentMode(){
         recordButton.imageView?.contentMode = .scaleAspectFit
        stopRecordingButton.imageView?.contentMode = .scaleAspectFit
    }
    
    
    
    func configureUI(lable: String , record : Bool , stopRecord: Bool  ){
        recoedingLable.text = lable
        recordButton.isEnabled = record
        stopRecordingButton.isEnabled = stopRecord
        
    }
    
    
    @IBAction func recordAudio(_ sender: Any) {
        
        configureUI(lable: "Recorfing in Progress",record : false , stopRecord: true )

        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(.playAndRecord, mode: .default, options: .defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        configureUI(lable: "Tap to Record",record : true , stopRecord: false )
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        do{
            try audioSession.setActive(false)
        }catch{
            print("Could not deactivate audio session.")
        }
    }
    
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        
        if flag {
        performSegue(withIdentifier: "stopRecording", sender:audioRecorder.url )
        }else {
       print("Recording was not succeessful ")
        
    }
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
            
        }
    }
    
    
    
    
}
