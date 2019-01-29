//
//  ListTableViewCell.swift
//  GitList
//
//  Created by Gabriel vieira on 1/28/19.
//  Copyright © 2019 Gabriel Vieira Figueiredo Tomaz. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage

class ListTableViewCell: UITableViewCell {

    static let labelTextColor: UIColor = UIColor(red:0.27, green:0.27, blue:0.27, alpha:1.0)
    static let reuseIdentifier: String = "ListTableViewCell"
    
    //subviews
    let authorImageView: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill // image will never be strecthed vertially or horizontally
        img.translatesAutoresizingMaskIntoConstraints = false // enable autolayout
        img.layer.cornerRadius = 25
        img.backgroundColor = .clear
        img.clipsToBounds = true
        return img
    }()
    
    let authorNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = ListTableViewCell.labelTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let starImageView: UIImageView = {
        
        let img = UIImageView()
        img.contentMode = .scaleAspectFill // image will never be strecthed vertially or horizontally
        img.translatesAutoresizingMaskIntoConstraints = false // enable autolayout
        img.clipsToBounds = true
        return img
    }()
    
    let repoNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = ListTableViewCell.labelTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let starLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = ListTableViewCell.labelTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configUI() {
        
        self.contentView.addSubview(self.starImageView)
        self.starImageView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(10)
            make.right.equalTo(-10)
            make.width.height.equalTo(20)
        }
        
        self.contentView.addSubview(self.starLabel)
        self.starLabel.snp.makeConstraints { (make) -> Void in

            make.right.equalTo(self.starImageView.snp.left).offset(-10)
            make.top.equalTo(10)
            make.height.equalTo(18)
            make.width.equalTo(70)
        }
        
        self.contentView.addSubview(self.authorImageView)
        self.authorImageView.snp.makeConstraints { (make) -> Void in
            make.left.top.equalTo(10)
            make.width.height.equalTo(50)
        }
        
        self.contentView.addSubview(self.authorNameLabel)
        self.authorNameLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(self.authorImageView.snp.right).offset(10)
            make.top.equalTo(10)
            make.height.equalTo(18)
            make.right.greaterThanOrEqualTo(self.starLabel.snp.left).offset(-10)
        }
        
        self.contentView.addSubview(self.repoNameLabel)
        self.repoNameLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(self.authorImageView.snp.right).offset(10)
            make.bottom.equalTo(-10)
            make.height.equalTo(18)
            make.right.equalTo(-10)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    public func setup(_ item: RepositoryViewModelItem) {
        
        self.repoNameLabel.text = item.repositoryName
        self.starLabel.text = "\(item.starCount)"
        self.authorNameLabel.text = item.authorName
        self.starImageView.image = UIImage(named: "star_icon")
        self.authorImageView.sd_setImage(with: URL(string: item.authorImageUrl), placeholderImage: UIImage(named: "placeholder_icon"))
    }
}
