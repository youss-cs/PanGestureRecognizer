//
//  ViewController.swift
//  PanGesture
//
//  Created by YouSS on 11/21/18.
//  Copyright © 2018 YouSS. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var docOrigin: CGPoint!
    
    let docView: UIImageView = {
        return UIImageView(image: #imageLiteral(resourceName: "doc"))
    }()
    
    var trashView: UIImageView = {
        return UIImageView(image: #imageLiteral(resourceName: "trash_empty"))
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupLayout()
        setupPanGesture()
    }
    
    override func viewDidLayoutSubviews() {
        docOrigin = docView.frame.origin
    }
    
    func setupView() {
        view.addSubview(docView)
        view.addSubview(trashView)
        view.backgroundColor = UIColor.black
        view.bringSubviewToFront(docView)
    }
    
    func setupLayout() {
        docView.translatesAutoresizingMaskIntoConstraints = false
        docView.isUserInteractionEnabled = true
        trashView.translatesAutoresizingMaskIntoConstraints = false
        
        let docConstraints = [docView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20), docView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20), docView.widthAnchor.constraint(equalToConstant: 60), docView.heightAnchor.constraint(equalToConstant: 60)]
        let trashConstraints = [trashView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20), trashView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20), trashView.widthAnchor.constraint(equalToConstant: 80), trashView.heightAnchor.constraint(equalToConstant: 80)]
        NSLayoutConstraint.activate(docConstraints)
        NSLayoutConstraint.activate(trashConstraints)
    }
    
    func setupPanGesture() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(self.handlePan(sender:)))
        docView.addGestureRecognizer(pan)
    }
    
    @objc func handlePan(sender: UIPanGestureRecognizer) {
        guard let docView = sender.view else { return }
        
        switch sender.state {
        case .began, .changed:
            moveView(view: docView, sender: sender)
        case .ended:
            docView.frame.intersects(trashView.frame) ? deleteDocImage() : backDocImageToOrigin()
        default: break
        }
    }
    
    func moveView(view: UIView, sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        view.frame.origin = CGPoint(x: view.frame.origin.x + translation.x, y: view.frame.origin.y + translation.y)
        sender.setTranslation(CGPoint.zero, in: view)
    }
    
    func backDocImageToOrigin() {
        UIView.animate(withDuration: 0.3) {
            self.docView.frame.origin = self.docOrigin
        }
    }
    
    func deleteDocImage() {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [], animations: {
            self.docView.alpha = 0
        }, completion: { (finished) in
            self.trashView.image = #imageLiteral(resourceName: "trash")
        })
    }

}

