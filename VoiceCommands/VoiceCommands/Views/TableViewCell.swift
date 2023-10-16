//
//  TableViewCell.swift
//  VoiceCommands
//
//  Created by Ankush 29/09/23.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var speechLabel: UILabel!
    @IBOutlet weak var currentStatusLabel: UILabel!
    @IBOutlet weak var outputLabel: UILabel!
    @IBOutlet weak var allCommandHistoryLabel: UILabel!

    var viewModel: TableCellViewModel? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }
            speechLabel.text = viewModel.speechText
            currentStatusLabel.text = viewModel.currentStatus
            outputLabel.text = viewModel.outPutText
            allCommandHistoryLabel.text = viewModel.allCommandHisory
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        speechLabel.backgroundColor = UIColor(red: 1.00, green: 0.79, blue: 0.58, alpha: 0.3)
        currentStatusLabel.backgroundColor = UIColor(red: 0.75, green: 0.02, blue: 0.95, alpha: 0.3)
        outputLabel.backgroundColor = UIColor(red: 0.73, green: 0.60, blue: 0.97, alpha: 0.3)
        allCommandHistoryLabel.backgroundColor = UIColor(red: 1.00, green: 0.95, blue: 0.74, alpha: 0.5)
    }
    
    static var identifier: String {
        "TableViewCell"
    }
  
    static var nibName: String {
        "TableViewCell"
    }
}
