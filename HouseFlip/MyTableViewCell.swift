//
//  MyTableViewCell.swift
//  HouseFlip
//
//  Created by Shawn Ashton on 10/6/20.
//

import UIKit

protocol MyTableViewCellDelegate: AnyObject {
    func didTapCell(with index: Int)
}


class MyTableViewCell: UITableViewCell {
    weak var delegate: MyTableViewCellDelegate?

    static let indentifier = "MyTableViewCell"
    
    static func nib() -> UINib{
        return UINib(nibName: "MyTableViewCell" , bundle: nil)
    }
    
    @IBOutlet var button: UIButton!
    private var title:String = ""
    private var index:Int = 0
    
    @IBAction func didTapCell(){
        delegate?.didTapCell(with: index)
    }
    
    func configure(with title: String, with index: Int)
    {
        self.title = title
        self.index = index
        button.setTitle(title, for: .normal)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        button.setTitleColor(.label, for: .normal)
    }

    
}
