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
    let rotateDuration: TimeInterval = 5
    let waitDuration: TimeInterval = 0.5

    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLighting()
        sceneView.delegate = self
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

    lazy var eeveeNode: SCNNode = {
        guard let pokemonScene = SCNScene(named: "art.scnassets/eevee.scn") else { return SCNNode() }
        let pokemonNode = SCNNode()
        let pokemonSceneChildNodes = pokemonScene.rootNode.childNodes
        for childNode in pokemonSceneChildNodes {
            pokemonNode.addChildNode(childNode)
        }
        return pokemonNode
    }()

    lazy var mewtwoNode: SCNNode = {
        guard let pokemonScene = SCNScene(named: "art.scnassets/mewtwo.scn") else { return SCNNode() }
        let pokemonNode = SCNNode()
        let pokemonSceneChildNodes = pokemonScene.rootNode.childNodes
        for childNode in pokemonSceneChildNodes {
            pokemonNode.addChildNode(childNode)
        }
        return pokemonNode
    }()

    lazy var bulbasaurNode: SCNNode = {
        guard let pokemonScene = SCNScene(named: "art.scnassets/bulbasaur.scn") else { return SCNNode()}
        let pokemonNode = SCNNode()
        let pokemonSceneChildNodes = pokemonScene.rootNode.childNodes
        for childNode in pokemonSceneChildNodes {
            pokemonNode.addChildNode(childNode)
        }
        return pokemonNode
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
        DispatchQueue.main.async {
            guard let imageAnchor = anchor as? ARImageAnchor,
                let imageName = imageAnchor.referenceImage.name else { return }

            // TODO: Overlay 3D Object
            let overlayNode = self.getNode(withImageName: imageName)
            overlayNode.runAction(self.fadeAndSpinAction)
            node.addChildNode(overlayNode)
            self.label.text = "Image detected: \"\(imageName)\""
        }
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
        case "eevee":
            node = eeveeNode
        case "mewtwo":
            node = mewtwoNode
        case "bulbasaur":
            node = bulbasaurNode
        default:
            break
        }
        return node
    }
}

//    func addEevee(x: Float = 0, y: Float = 0.2, z: Float = -0.5) {
//        guard let pokemonScene = SCNScene(named: "art.scnassets/eevee.scn") else { return }
//        let pokemonNode = SCNNode()
//        let pokemonSceneChildNodes = pokemonScene.rootNode.childNodes
//        for childNode in pokemonSceneChildNodes {
//            pokemonNode.addChildNode(childNode)
//        }
//        pokemonNode.position = SCNVector3(x, y, z)
//        pokemonNode.runAction(.fadeIn(duration: 1))
//        sceneView.scene.rootNode.addChildNode(pokemonNode)
//    }
//
//    func addMewtwo(x: Float = 0, y: Float = 0.2, z: Float = -0.5) {
//        guard let pokemonScene = SCNScene(named: "art.scnassets/mewtwo.scn") else { return }
//        let pokemonNode = SCNNode()
//        let pokemonSceneChildNodes = pokemonScene.rootNode.childNodes
//        for childNode in pokemonSceneChildNodes {
//            pokemonNode.addChildNode(childNode)
//        }
//        pokemonNode.position = SCNVector3(x, y, z)
//        pokemonNode.runAction(.fadeIn(duration: 1))
//        sceneView.scene.rootNode.addChildNode(pokemonNode)
//    }
//
//    func addBulbassaur(x: Float = 0, y: Float = 0.2, z: Float = -0.5) {
//        guard let pokemonScene = SCNScene(named: "art.scnassets/bulbasaur.scn") else { return }
//        let pokemonNode = SCNNode()
//        let pokemonSceneChildNodes = pokemonScene.rootNode.childNodes
//        for childNode in pokemonSceneChildNodes {
//            pokemonNode.addChildNode(childNode)
//        }
//        pokemonNode.position = SCNVector3(x, y, z)
//        pokemonNode.runAction(.fadeIn(duration: 1))
//        sceneView.scene.rootNode.addChildNode(pokemonNode)
//    }

