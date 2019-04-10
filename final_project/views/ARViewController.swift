//
//  ARViewController.swift
//  final_project
//
//  Created by liblabs-mac on 3/2/19.
//  Copyright © 2019 liblabs-mac. All rights reserved.
//
// Credit to https://github.com/Rageeni/AR-Drawing
// And https://www.appcoda.com/arkit-persistence/
// For helping me create the AR component

import UIKit
import ARKit
import Firebase
import FirebaseDatabase
import RGSColorSlider
import AVFoundation

enum ShapeType {
    case sphere
    case plane
    case ring
    case pyramid
    case box
}

class ARViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet weak var sceneView: ARSCNView!
    
    @IBOutlet weak var sprayPaintCan: UIButton!
    var databaseRef : DatabaseReference!
    var storage: Storage!
    
    var isDraw: Bool = false
    var nodeWidth: CGFloat! = 3
    var nodeColor: UIColor! = UIColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 1)
    
    let strokeTextAttributes: [NSAttributedString.Key : Any] = [
        .strokeColor: UIColor.black,
        .foregroundColor: UIColor.white,
        .strokeWidth: -2.0
    ]
    
    var player: AVAudioPlayer?
    
    var selectedAlpha: CGFloat = 0.7
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        sceneView.delegate = self
        configureLighting()
        
        //set up spray paint can so it's top is midway in the arscene view
        let heightConstraint = NSLayoutConstraint(item: sprayPaintCan, attribute: NSLayoutConstraint.Attribute.height,
                                                  relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil,
                                                  attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1,
                                                  constant: sceneView.bounds.size.height / 2)
        view.addConstraints([heightConstraint])
        
        shapeButtons = [pyramidButton, cubeButton, planeButton, ringButton, sphereButton]
        
        let attrString = NSAttributedString(string: "Go back", attributes: strokeTextAttributes)
        editCancelButton.setAttributedTitle(attrString, for: .normal)
        
        sphereButton.alpha = selectedAlpha
        self.becomeFirstResponder()
        
        databaseRef = Database.database().reference().child("newestARPost")
        storage = Storage.storage()
    }
    
    override var canBecomeFirstResponder: Bool {
        get { return true }
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            playSound(name: "shake")
        }
    }
    
    @IBOutlet weak var colorSlider: RGSColorSlider!
    @IBOutlet weak var lineWidthSlider: UISlider!
    
    @IBAction func undoPressed(_ sender: Any) {
        if mostRecentlyMadeNodes.count >= 1 {
            DispatchQueue.main.async {
                for node in self.mostRecentlyMadeNodes[0] {
                    node.removeFromParentNode()
                }
                self.mostRecentlyMadeNodes.remove(at: 0)
            }
        }
    }
    
    @IBOutlet weak var editCancelButton: UIButton!
    var isInEditMode: Bool = false {
        didSet {
            if isInEditMode == false {
                if let pointer = self.pointerNode {
                    pointer.removeFromParentNode()
                }
            }
        }
    }

    @IBAction func editPressed(_ sender: Any) {
        isInEditMode = true
        
        colorSlider.isHidden = false
        lineWidthSlider.isHidden = false
        editCancelButton.isHidden = false
        sprayPaintCan.isHidden = true
        for btn in shapeButtons {
            btn.isHidden = false
        }
    }
    
    @IBAction func editCancellPressed(_ sender: Any) {
        isInEditMode = false
        
        colorSlider.isHidden = true
        lineWidthSlider.isHidden = true
        editCancelButton.isHidden = true
        sprayPaintCan.isHidden = false
        for btn in shapeButtons {
            btn.isHidden = true
        }
    }
    
    @IBAction func lineWidthSliderChangedValue(_ sender: Any) {
        nodeWidth = CGFloat((sender as? UISlider)!.value)
    }
    
    @IBAction func colorWidthSliderChangedValue(_ sender: Any) {
        let colorSlider = sender as? RGSColorSlider
        nodeColor = colorSlider!.color!
    }
    
    @IBAction func canTouchedDown(_ sender: Any) {
        mostRecentlyMadeNodes.insert([SCNNode](), at: 0)
        isDraw = true
        playSound(name: "spray")
    }
    
    @IBAction func canDoneTouched(_ sender: Any) {
        isDraw = false
        if player?.isPlaying ?? false {
            player!.stop()
        }
    }
    
    func getStartingWorldMapData() {
        databaseRef?.queryOrdered(byChild: "newestARPost")
            .observe(.value, with: { snapshot in
                    let httpsReference = self.storage.reference(forURL: snapshot.value as? String ?? "error")
                    
                    httpsReference.getData(maxSize: 3 * 1024 * 1024) { data, error in
                        if let error = error {
                            print("\n\ncould not get newest world map - instead starting with none\n\n")
                            self.resetTrackingConfiguration(with: nil)
                        } else {
                            print(error.debugDescription)
                            let newMap = self.unarchiveData(worldMapData: data!)
                            self.resetTrackingConfiguration(with: newMap)
                        }
                    }
            })
    }
    
    var mostRecentlyMadeNodes = [[SCNNode]]()
    var pointerNode: SCNNode?
    var chosenShape: ShapeType = .sphere
    
    func clearButtonOpacities() {
        for btn in shapeButtons {
            btn.alpha = 1.0
        }
    }
    
    @IBAction func sphereButtonPressed(_ sender: Any) {
        chosenShape = .sphere
        clearButtonOpacities()
        sphereButton.alpha = selectedAlpha
    }
    
    @IBAction func planeButtonPressed(_ sender: Any) {
        chosenShape = .plane
        clearButtonOpacities()
        planeButton.alpha = selectedAlpha
    }
    
    @IBAction func ringButtonPressed(_ sender: Any) {
        chosenShape = .ring
        clearButtonOpacities()
        ringButton.alpha = selectedAlpha
    }
    
    @IBAction func pyramidButtonPressed(_ sender: Any) {
        chosenShape = .pyramid
        clearButtonOpacities()
        pyramidButton.alpha = selectedAlpha
    }
    
    @IBAction func cubeButtonPressed(_ sender: Any) {
        chosenShape = .box
        clearButtonOpacities()
        cubeButton.alpha = selectedAlpha
    }
    
    @IBOutlet weak var pyramidButton: UIButton!
    @IBOutlet weak var cubeButton: UIButton!
    @IBOutlet weak var planeButton: UIButton!
    @IBOutlet weak var ringButton: UIButton!
    @IBOutlet weak var sphereButton: UIButton!
    var shapeButtons: [UIButton] = []

    func getCurrentNodeType(_ width: CGFloat) -> SCNNode {
        var node: SCNNode
        
        switch chosenShape {
        case .box:
            node = SCNNode(geometry: SCNBox(width: width, height: width, length: width, chamferRadius: 0.0))
        case .pyramid:
            node = SCNNode(geometry: SCNPyramid(width: width, height: width*2, length: width))
        case .ring:
            node = SCNNode(geometry: SCNTorus(ringRadius: width, pipeRadius: width/4))
        case .plane:
            node = SCNNode(geometry: SCNPlane(width: width, height: width))
        default:
            node = SCNNode(geometry: SCNSphere(radius: width))
        }
        
        return node
    }
    
    func displayNode(_ node: SCNNode) {
        //user is drawing
        if isDraw {
            mostRecentlyMadeNodes[0].append(node)
            sceneView.scene.rootNode.addChildNode(node)
            
            if let player = player {
                if !player.isPlaying {
                    player.play()
                } else if player.currentTime >= 1.5 {
                    player.stop()
                    player.currentTime = 0.0
                    player.play()
                }
            }
        }
            
        //user is editing, show them a pointer of what they will paint
        else {
            DispatchQueue.main.async {
                if let pointer = self.pointerNode {
                    pointer.removeFromParentNode()
                }
                self.pointerNode = node
                self.sceneView.scene.rootNode.addChildNode(node)
            }
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
        guard let pointOfView = sceneView.pointOfView else { return }
        //this should not happen but just in case
        if !isDraw || !isInEditMode { return }
        
        let transform = pointOfView.transform
        let orientation = SCNVector3(x: -transform.m31, y: -transform.m32, z: -transform.m33)
        let location = SCNVector3(x: transform.m41, y: transform.m42, z: transform.m43)
        let currentPosition = orientation + location
        
        let width = nodeWidth/200
        
        let node: SCNNode = getCurrentNodeType(width)
    
        node.geometry?.firstMaterial?.diffuse.contents = nodeColor
        node.position = currentPosition
        
        displayNode(node)
    }
    
    func configureLighting() {
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getStartingWorldMapData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    func resetTrackingConfiguration(with worldMap: ARWorldMap?) {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]
        
        let options: ARSession.RunOptions = [.resetTracking, .removeExistingAnchors]
        
        if worldMap != nil {
            print("\n\nsetting world map to be decoded map\n\n")
            configuration.initialWorldMap = worldMap
        }
        
        sceneView.session.run(configuration, options: options)
    }

    @IBAction func saveClicked(_ sender: Any) {
        sceneView.session.getCurrentWorldMap { (worldMap, error) in
            guard let worldMap = worldMap else {
                return
            }
            
            do {
                try self.archiveData(worldMap: worldMap)
            } catch {
                fatalError("Error saving world map: \(error.localizedDescription)")
            }
        }
    }
    
    func unarchiveData(worldMapData data: Data) -> ARWorldMap? {
        guard let unarchievedObject = try? NSKeyedUnarchiver.unarchivedObject(ofClass: ARWorldMap.self, from: data),
            let worldMap = unarchievedObject else { return nil }
        
        return worldMap
    }
    
    func archiveData(worldMap: ARWorldMap) throws {
        let data = try NSKeyedArchiver.archivedData(withRootObject: worldMap, requiringSecureCoding: true)
        let storageRef = storage.reference()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let dateCreated = NSDate()
        let dateCreatedStr = formatter.string(from: dateCreated as Date)
        
        // Create a reference to the file you want to upload
        let arpostRef = storageRef.child(dateCreatedStr)
        
        let uploadTask = arpostRef.putData(data, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                return
            }
            
            // You can also access to download URL after upload.
            arpostRef.downloadURL { (url, error) in
                if let downloadURL = url {
                    self.databaseRef.setValue(downloadURL.absoluteString)
                } else {
                    print(error.debugDescription)
                    return
                }
            }
        }
    }
    
    func playSound(name: String) {
        guard let url = Bundle.main.url(forResource: "audio/" + name, withExtension: "wav") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            //allows player to work on ios11
            self.player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.wav.rawValue)
            
            guard let player = self.player else { return }
            
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
}

func +(left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.x + right.x, left.y + right.y, left.z + right.z)
}

func ==(left: SCNVector3, right: SCNVector3) -> Bool {
    if String(format: "%.1f", left.x) == String(format: "%.1f", right.x) {
        if String(format: "%.1f", left.y) == String(format: "%.1f", right.y) {
            if String(format: "%.1f", left.z) == String(format: "%.1f", right.z) {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    } else {
        return false
    }
}

extension float4x4 {
    var translation: float3 {
        let translation = self.columns.3
        return float3(translation.x, translation.y, translation.z)
    }
}
