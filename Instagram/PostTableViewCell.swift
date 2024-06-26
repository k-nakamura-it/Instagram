//
//  PostTableViewCell.swift
//  Instagram
//
//  Created by 中村 行汰 on 2024/05/13.
//

import UIKit
import FirebaseStorageUI

protocol PostTableViewCellDelegate: AnyObject {
    func handlecommentArea(_ sender: UILabel)
}

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var commentDate: UILabel!
    @IBOutlet weak var commenterName: UILabel!
    @IBOutlet weak var commentResent: UILabel!
    @IBOutlet weak var commentCountLabel: UILabel!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var commentStatus: UILabel!
    
    weak var delegate: PostTableViewCellDelegate?
    
    // PostDataの内容をセルに表示
    func setPostData(_ postData: PostData) {
        // 画像の表示
        postImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        let imageRef = Storage.storage().reference().child(Const.ImagePath).child(postData.id + ".jpg")
        postImageView.sd_setImage(with: imageRef)

        // キャプションの表示
        self.captionLabel.text = "\(postData.name) : \(postData.caption)"

        // 日時の表示
        self.dateLabel.text = postData.date

        // いいね数の表示
        let likeNumber = postData.likes.count
        likeLabel.text = "\(likeNumber)"
        
        let commentNumber = postData.comments.count
        commentCountLabel.text = "\(commentNumber)"
        if commentNumber == 0 {
            commentDate.text = ""
            commenterName.text = ""
            commentResent.text = ""
            commentStatus.text = "コメントはありません"
        } else {
            //最新のコメントを表示
            commentDate.text = postData.comments.last?.commentDate
            commenterName.text = "\(postData.comments.last?.commenterName ?? "") : "
            commentResent.text = postData.comments.last?.comment
            commentStatus.text = ""
        }
        // いいねボタンの表示
        if postData.isLiked {
            let buttonImage = UIImage(named: "like_exist")
            self.likeButton.setImage(buttonImage, for: .normal)
        } else {
            let buttonImage = UIImage(named: "like_none")
            self.likeButton.setImage(buttonImage, for: .normal)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
//         Initialization code
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handlecommentArea))
        commentResent.addGestureRecognizer(tapGesture)
        commentResent.isUserInteractionEnabled = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func handlecommentArea(){
        delegate?.handlecommentArea(self.commentResent)
    }
    
}
