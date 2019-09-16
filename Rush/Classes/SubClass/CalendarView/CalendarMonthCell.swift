//
//  CalendarMonthCell.swift
//  digicrony_ios
//
//  Created by kamal on 23/07/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

protocol CalendarMonthCellDelegate: class {
    func selectedDate(date: Date)
    func isEventExist(date: Date) -> Bool
}

class CalendarMonthCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var monthCollectionView: UICollectionView!
    weak var delegate: CalendarMonthCellDelegate!
    var isWeekStartFromMonday = false

    var dateList = [AnyObject]()
    var selectedDate: Date?
    var dateColor: UIColor = UIColor.white
    var dotColor: UIColor = UIColor.brown24
    var outerViewSelectedColor: UIColor = UIColor.brown24
    var dateSelectedColor: UIColor = UIColor.white

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        monthCollectionView.register(UINib(nibName: String(describing: CalendarDayCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: CalendarDayCell.self))
        monthCollectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    // MARK: - Collection View Delegate and DataSource
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let count = self.dateList.count
        if count > 0 {
            return count
        }
        
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CalendarDayCell.self), for: indexPath) as? CalendarDayCell {
            cell.outerView.isHidden = true
            cell.setup(dateColor: dateColor)
            cell.setup(dotColor: dotColor)
            cell.setup(outerViewBgSelectedColor: outerViewSelectedColor)
            cell.setup(dateSelectedColor: dateSelectedColor)
            if self.dateList.count > indexPath.row {
                guard let date = self.dateList[indexPath.row] as? Date else { return cell }
                cell.outerView.isHidden = false
                cell.setup(date: date)
                cell.setup(isSelected: selectedDate == date)
                cell.setup(isEventExist: delegate?.isEventExist(date: date) ?? false)
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let date = self.dateList[indexPath.row] as? Date {
            self.delegate?.selectedDate(date: date)
            selectedDate = date
            collectionView.reloadData()
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = self.monthCollectionView.frame.size.width/7.0
        return CGSize(width: floor(width), height: width)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    // MARK: - Other Functions
    func reloadMonthCalendar(date: Date, selectedDate: Date?) {
        self.selectedDate = selectedDate
        self.getMonthDateList(date: date)
        self.monthCollectionView.reloadData()
    }
    
    func getMonthDateList(date: Date) {
        self.dateList.removeAll()
        var weekday = date.weekday
        /// Default Sunday is 1 and Saturday is 7 and Calendar week start from Sunday
        /// But if Week start from Monday, we need to move 1 day before. So Monday is 1 and Sunday = 7
        if isWeekStartFromMonday {
           weekday -= 1
           if weekday == 0 {
              weekday = 7
           }
        }
        
        for _ in (1..<weekday).reversed() {
            self.dateList.append(NSNull())
        }
        
        let numberofDaysInMonth = date.daysInMonth
        for index in 0..<numberofDaysInMonth {
            let day = date.plus(days: index)
            self.dateList.append(day as AnyObject)
        }
    }
    
    func setup(dateColor: UIColor) {
        self.dateColor = dateColor
        monthCollectionView.reloadData()
    }
    
    func setup(dotColor: UIColor) {
        self.dotColor = dotColor
        monthCollectionView.reloadData()
    }

    func setup(outerViewBgSelectedColor: UIColor) {
        self.outerViewSelectedColor = outerViewBgSelectedColor
        monthCollectionView.reloadData()
    }
    
    func setup(dateSelectedColor: UIColor) {
        self.dateSelectedColor = dateSelectedColor
        monthCollectionView.reloadData()
    }

}
