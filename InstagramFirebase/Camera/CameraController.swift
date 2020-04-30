//
//  CameraController.swift
//  InstagramFirebase
//
//  Created by Oleg Kudimov on 4/28/20.
//  Copyright © 2020 Oleg Kudimov. All rights reserved.
//

import UIKit


//Audio/video foundation
import AVFoundation


class CameraController: UIViewController {
    
    let dismissButton: UIButton = {
        let button  = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "right_arrow_shadow").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    
    let capturePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "capture_photo").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleCapturePhoto), for: .touchUpInside)
        return button
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCaptureSession()
        setupHUD()
    }
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    

    @objc func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleCapturePhoto() {
        print("Capturing photo...")
    }
    
    
    //work with camera
    fileprivate func setupCaptureSession() {
        
        let captureSession = AVCaptureSession()
        //1. setup inputs
        if let captureDevice = AVCaptureDevice.default(for: .video) {
            do {
                let input = try AVCaptureDeviceInput(device: captureDevice)
                if captureSession.canAddInput(input) {
                    captureSession.addInput(input)
                }
            } catch let err {
                print("Could not setup camera input: ", err)
            }
        }
        //2. setup outputs
        let output = AVCapturePhotoOutput()
        if captureSession.canAddOutput(output) {
            captureSession.addOutput(output)
        }
        //3. setup output preview
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.frame
        view.layer.addSublayer(previewLayer)
        captureSession.startRunning()
    }
    
    
    fileprivate func setupHUD() {
           view.addSubview(capturePhotoButton)
           view.addSubview(dismissButton)
           
           capturePhotoButton.anchor(top: nil, left: nil, bottom: view.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddongBottom: 82, paddingRight: 0, width: 80, height: 80)
           capturePhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
           
           dismissButton.anchor(top: view.topAnchor, left: nil, bottom:nil, right: view.rightAnchor, paddingTop: 12, paddingLeft: 0, paddongBottom: 0, paddingRight: 12, width: 50, height: 50)
       }





}
