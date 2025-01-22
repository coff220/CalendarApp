//
//  EventsTableViewCell.swift
//  BroshchersCalendar
//
//  Created by Viacheslav on 26/12/2024.
//

import UIKit

class EventsTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var eventImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        titleLabel.textColor = .mainDigit
        titleLabel.font = UIFont(name: "VarelaRound-Regular", size: 17)
        dateLabel.textColor = .cellDate
        dateLabel.font = UIFont(name: "VarelaRound-Regular", size: 15)
        
        eventImage.setImageColor(color: .mainPurple)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
