//
//  AvatarPickerViewController.swift
//  SlackAliker
//
//  Created by Andrii Zakharenkov on 2/7/19.
//  Copyright © 2019 Andrii Zakharenkov. All rights reserved.
//

import UIKit

class AvatarPickerViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet fileprivate weak var collectionView: UICollectionView!
    @IBOutlet fileprivate weak var segmentControl: UISegmentedControl!
    
    var avatarType = AvatarType.dark;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self;
        collectionView.delegate = self;
    }

    @IBAction fileprivate func backBtnClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction fileprivate func segmentChangeClick(_ sender: Any) {
        switch segmentControl.selectedSegmentIndex {
            case 1:
                avatarType = AvatarType.light;
                break;
            default:
                avatarType = AvatarType.dark;
                break;
        }
        
        collectionView.reloadData()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 28;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "avatarCell", for: indexPath) as? AvatarCell else { return AvatarCell() }
        
        cell.configureCell(index: indexPath.item, avatarType: avatarType)
        
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let avatarToSave = avatarType == AvatarType.dark ? "dark\(indexPath.item)" : "light\(indexPath.item)"
       
        UserDataService.instance.changeAvatarName(avatarName: avatarToSave)
        self.dismiss(animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        var numberOfColumns: CGFloat = 3;
        
        if UIScreen.main.bounds.width > 320 {
            numberOfColumns = 4
        }
        
        let spaceBetweenCells: CGFloat = 10;
        let padding: CGFloat = 40; //paddings from left and right
        let cellDimension = ((collectionView.bounds.width - padding) - (numberOfColumns - 1) * spaceBetweenCells) / numberOfColumns
        
        return CGSize(width: cellDimension, height: cellDimension)
    }
}
