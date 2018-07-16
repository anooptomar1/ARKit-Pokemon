//
//  ViewController.swift
//  CardARKit
//
//  Created by Larissa Ganaha on 14/07/18.
//  Copyright © 2018 Larissa Ganaha. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController {

    let fadeDuration: TimeInterval = 0.3
    let rotateDuration: TimeInterval = 3
    let waitDuration: TimeInterval = 0.5

    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLighting()
        addPokemon()
        sceneView.delegate = self
    }

    func addPokemon(x: Float = 0, y: Float = 0, z: Float = -0.5) {
        guard let pokemonScene = SCNScene(named: "art.scnassets/eevee.scn") else { return }
        let pokemonNode = SCNNode()
        let pokemonSceneChildNodes = pokemonScene.rootNode.childNodes
        for childNode in pokemonSceneChildNodes {
            pokemonNode.addChildNode(childNode)
        }
        pokemonNode.position = SCNVector3(x, y, z)
        sceneView.scene.rootNode.addChildNode(pokemonNode)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        resetTrackingConfiguration()
        sceneView.session.run(configuration)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }


    func configureLighting() {
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
    }

    lazy var fadeAndSpinAction: SCNAction = {
        return .sequence([
            .fadeIn(duration: fadeDuration),
            .rotateBy(x: 0, y: 0, z: CGFloat.pi * 360 / 180, duration: rotateDuration),
            .wait(duration: waitDuration),
            .fadeOut(duration: fadeDuration)
            ])
    }()

    lazy var fadeAction: SCNAction = {
        return .sequence([
            .fadeOpacity(by: 0.8, duration: fadeDuration),
            .wait(duration: waitDuration),
            .fadeOut(duration: fadeDuration)
            ])
    }()

    lazy var treeNode: SCNNode = {
        guard let scene = SCNScene(named: "tree.scn"),
            let node = scene.rootNode.childNode(withName: "tree", recursively: false) else { return SCNNode() }
        let scaleFactor = 0.005
        node.scale = SCNVector3(scaleFactor, scaleFactor, scaleFactor)
        node.eulerAngles.x = -.pi / 2
        return node
    }()

    lazy var bookNode: SCNNode = {
        guard let scene = SCNScene(named: "book.scn"),
            let node = scene.rootNode.childNode(withName: "book", recursively: false) else { return SCNNode() }
        let scaleFactor  = 0.1
        node.scale = SCNVector3(scaleFactor, scaleFactor, scaleFactor)
        return node
    }()

    lazy var mountainNode: SCNNode = {
        guard let scene = SCNScene(named: "mountain.scn"),
            let node = scene.rootNode.childNode(withName: "mountain", recursively: false) else { return SCNNode() }
        let scaleFactor  = 0.25
        node.scale = SCNVector3(scaleFactor, scaleFactor, scaleFactor)
        node.eulerAngles.x += -.pi / 2
        return node
    }()

    @IBAction func resetButtonDidTouch(_ sender: UIBarButtonItem) {
        resetTrackingConfiguration()

    }
    func resetTrackingConfiguration() {
        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else { return }
        let configuration = ARWorldTrackingConfiguration()
        configuration.detectionImages = referenceImages
        let options: ARSession.RunOptions = [.resetTracking, .removeExistingAnchors]
        sceneView.session.run(configuration, options: options)
        label.text = "Move camera around to detect images"
    }

}

extension ViewController: ARSCNViewDelegate {

    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {

    }

    func getPlaneNode(withReferenceImage image: ARReferenceImage) -> SCNNode {
        let plane = SCNPlane(width: image.physicalSize.width,
                             height: image.physicalSize.height)
        let node = SCNNode(geometry: plane)
        return node
    }

    func getNode(withImageName name: String) -> SCNNode {
        var node = SCNNode()
        switch name {
        case "Eevee":
            node = bookNode
        case "Snow Mountain":
            node = mountainNode
        case "Trees In the Dark":
            node = treeNode
        default:
            break
        }
        return node
    }

}
