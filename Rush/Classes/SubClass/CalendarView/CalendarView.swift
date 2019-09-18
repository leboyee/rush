//
//  CalendarView.swift
//  digicrony_ios
//
//  Created by kamal on 23/07/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

protocol CalendarViewDelegate: class {
    func setHeightOfView(height: CGFloat)
    func changeMonth(date: Date)
    func selectedDate( date: Date)
    func isEventExist( date: Date) -> Bool
}

class CalendarView: UIView {

    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var monthNameView: UIView!
    @IBOutlet weak var infoViewHeight: NSLayoutConstraint!
    var isWeekStartFromMonday = true
    var isNeedToHideMonthNameView = true
    let bottomPadding: CGFloat = 10.0
    weak var delegate: CalendarViewDelegate!
    var minDateOfCalendar: Date = Date.parse(dateString: "2017-06-01", format: "yyyy-MM-dd")!
    var maxDateOfCalendar: Date = Date.parse(dateString: "2027-06-01", format: "yyyy-MM-dd")!
    var currentIndex: Int = 0
    var selectedDate: Date?
    var dateColor: UIColor = UIColor.white
    var dotColor: UIColor = UIColor.brown24
    var outerViewSelectedColor: UIColor = UIColor.brown24
    var dateSelectedColor: UIColor = UIColor.white
    var minimumSelectedDate: Date?
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
}

extension CalendarView {
    
    private func commonInit() {
        let nib  = UINib(nibName: String(describing: CalendarView.self), bundle: nil)

        if let view = nib.instantiate(withOwner: self, options: nil).first as? UIView {
            view.clipsToBounds = true
            addSubview(view)
            addViewConstraint(view: view)
            configureCollectionView()
            
            if isNeedToHideMonthNameView {
                infoViewHeight.constant = 48.0
                monthNameView.isHidden = true
            }
            
            DispatchQueue.main.async {
                self.setCurrentMonth()
            }
        }
    }
    
    private func addViewConstraint(view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let top = view.topAnchor.constraint(equalTo: self.topAnchor)
        let bottom = view.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        let leading = view.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        let trailing = view.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        addConstraints([top, bottom, trailing, leading])
    }
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: String(describing: CalendarMonthCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: CalendarMonthCell.self))
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

// MARK: - Actions
extension CalendarView {

    @IBAction func nextButtonAction(sender: UIButton) {
        setNextMonth()
    }
    
    @IBAction func previousButtonAction(sender: UIButton) {
        setPreviousMonth()
    }
    
}

// MARK: - Other Functions
extension CalendarView {
    
    func setupCalendar(animation: Bool) {
        let indexPath = IndexPath(row: self.currentIndex, section: 0)
        collectionView.layoutIfNeeded()
        collectionView.scrollToItem(at: indexPath, at: .left, animated: animation)
        collectionView.reloadData()
    }
    
    func setMonthViewHeight( height: CGFloat) {
        let fullHeight =  height + self.collectionView.frame.origin.y
        self.delegate?.setHeightOfView(height: fullHeight)
        setMonthTitle()
    }
    
    func setCurrentMonth() {
        let month = Date.monthsBetween(date1: minDateOfCalendar, date2: Date())
        self.currentIndex = month
        self.setupCalendar(animation: false)
    }
    
    func setNextMonth() {
        var newIndex = self.currentIndex + 1
        
        let maxMonth = Date.monthsBetween(date1: minDateOfCalendar, date2: maxDateOfCalendar)
        if newIndex > maxMonth - 1 {
            newIndex = maxMonth - 1
        }
        
        let indexPath = IndexPath(row: newIndex, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
    }
    
    func setPreviousMonth() {

        var newIndex = self.currentIndex - 1
        if newIndex < 0 {
            newIndex = 0
        }

        let indexPath = IndexPath(row: newIndex, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
    }
    
    func setMonthTitle() {
        let month = minDateOfCalendar.plus(months: UInt(self.currentIndex)).toString(format: "MMMM yyyy")
        self.monthLabel.text = month
    }
    
    func setSelectedDate(date: Date) {
        selectedDate = date
        reloadMonth()
    }
    
    func reloadMonth() {
        collectionView.reloadData()
    }
    
}

// MARK: - UICollectionViewDelegate
extension CalendarView: UICollectionViewDelegate {
    
}

// MARK: - UICollectionViewDataSource
extension CalendarView: UICollectionViewDataSource {
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Date.monthsBetween(date1: minDateOfCalendar, date2: maxDateOfCalendar)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CalendarMonthCell.self), for: indexPath) as? CalendarMonthCell {
            cell.setup(dateColor: dateColor)
            cell.setup(dotColor: dotColor)
            cell.setup(outerViewBgSelectedColor: outerViewSelectedColor)
            cell.setup(dateSelectedColor: dateSelectedColor)
            cell.setup(minimumDate: minimumSelectedDate)
            cell.isWeekStartFromMonday = isWeekStartFromMonday
            let date = minDateOfCalendar.plus(months: UInt(indexPath.row))
            cell.reloadMonthCalendar(date: date, selectedDate: selectedDate)
            cell.delegate = self
           
            return cell
        }
        return UICollectionViewCell()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CalendarView: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width
        //Calculate Height
        let date = minDateOfCalendar.plus(months: UInt(self.currentIndex))
        
        var weekday = Int(date.weekday - 1)
        if isWeekStartFromMonday {
            weekday -= 1
            if weekday < 0 {
                weekday += 7
            }
        }
        
        let count = (date.daysInMonth + UInt(weekday))
       
        //let count = (date.daysInMonth + (isWeekStartFromMonday ? date.weekday : (date.weekday - 1)))
        
        var numberOfRows = count / 7
        if count % 7 > 0 {
            numberOfRows += 1
        }
        let height =  ceil(width/7.0) * CGFloat(numberOfRows)
        setMonthViewHeight(height: height + bottomPadding)
        return CGSize(width: width, height: height)
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
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let page = Int(collectionView.contentOffset.x / collectionView.frame.size.width)
        if page != currentIndex {
            currentIndex = page
            setMonthTitle()
            let date = minDateOfCalendar.plus(months: UInt(self.currentIndex))
            self.delegate?.changeMonth(date: date)
            DispatchQueue.main.async {
                collectionView.reloadData()
            }
            //print(currentIndex)
        }
    }

}

// MARK: - CalendarMonthCellDelegate
extension CalendarView: CalendarMonthCellDelegate {
    
    func selectedDate(date: Date) {
        self.delegate?.selectedDate(date: date)
    }
    
    func isEventExist(date: Date) -> Bool {
        return delegate?.isEventExist(date: date) ?? false
    }
}
