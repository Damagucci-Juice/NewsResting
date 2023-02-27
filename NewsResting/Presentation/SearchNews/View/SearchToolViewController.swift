//
//  SearchToolViewController.swift
//  NewsResting
//
//  Created by YEONGJIN JANG on 2023/02/24.
//

import UIKit
import SnapKit

final class SearchToolViewController: UIViewController {
    private var onTappedDoneButton: (DetailSearchRequestValue) -> Void = { _ in }
    private var detailSearchRequestValue: DetailSearchRequestValue
    
    private var selectedDays: [DateComponents] = [] {
        didSet {
            selectedDays = selectedDays.sorted { ($0.date ?? Date()) < ($1.date ?? Date()) }
        }
    }
    
    private var includeTerm: UILabel = {
        let label = UILabel()
        label.text = "include searchTerm".localized()
        label.textColor = .secondaryLabel
        return label
    }()
    
    private var includeArea: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .center
        view.distribution = .fill
        view.spacing = 4
        view.backgroundColor = .systemGray6
        return view
    }()
    
    private let calendarView: UICalendarView = {
        let calendarView = UICalendarView()
        let gregorianCalendar = Calendar(identifier: .gregorian)
        calendarView.calendar = gregorianCalendar
        calendarView.locale = Locale.autoupdatingCurrent
        calendarView.fontDesign = .rounded
        return calendarView
    }()
    
    private var excludeArea: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .center
        view.distribution = .fillProportionally
        view.backgroundColor = .systemGray6
        return view
    }()
    
    private var plusButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        button.setTitleColor(UIColor.tintColor, for: .normal)
        return button
    }()
    
    private var minusButton: UIButton = {
        let button = UIButton()
        button.tintColor = .red
        button.setImage(UIImage(systemName: "minus.circle.fill"), for: .normal)
        return button
    }()
    
    private var excludeTerm: UILabel = {
        let label = UILabel()
        label.text = "exclude searchTerm".localized()
        label.textColor = .secondaryLabel
        return label
    }()
    
    private var periodLabel: UILabel = {
        let label = UILabel()
        label.text = "period".localized()
        label.textColor = .secondaryLabel
        return label
    }()
    
    init(detailSearchRequestValue: DetailSearchRequestValue? = nil) {
        if let detailSearchRequestValue {
            self.detailSearchRequestValue = detailSearchRequestValue
        } else {
            self.detailSearchRequestValue = DetailSearchRequestValue()
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Controller's life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .brown
        setupNavigation()
        setupCalendar()
        setupLayout()
        setupAttribute()
    }
    
    @objc func injectToolViewModel() {
        fillDetailRequestValue()
        onTappedDoneButton(detailSearchRequestValue)
        Task {
            self.dismiss(animated: true)
        }
    }
}

//MARK: - Private
extension SearchToolViewController {
    private func addSearchTermButton(_ text: String) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.frame = .zero
        button.setTitle(text, for: .normal)
        button.layer.cornerRadius = 10
        return button
    }
    
    private func fillDetailRequestValue() {
        switch selectedDays.count {
        case 0:
            detailSearchRequestValue.fromDateCompo = nil
        case 1:
            if let first = selectedDays.first {
                detailSearchRequestValue.fromDateCompo = first
            }
        default: // 2
            if let first = selectedDays.first, let last = selectedDays.last {
                detailSearchRequestValue.fromDateCompo = first
                detailSearchRequestValue.toDateCompo = last
            }
        }
    }
    
    private func setupNavigation() {
        navigationItem.setRightBarButton(UIBarButtonItem(title: "Done",
                                                         style: .done,
                                                         target: self,
                                                         action: #selector(injectToolViewModel)),
                                         animated: false)
        self.title = "검색 상세 조건"
    }
    
    private func setupLayout() {
        let constraintFromWall: CGFloat = 15
        let areaSpace: CGFloat = 50
        
        [
            includeTerm, plusButton, includeArea,
            excludeTerm, minusButton, excludeArea,
            periodLabel, calendarView
        ].forEach { view in
            self.view.addSubview(view)
        }
        
        includeTerm.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(constraintFromWall)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(constraintFromWall)
        }
        
        plusButton.snp.makeConstraints { make in
            make.top.equalTo(includeTerm)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(constraintFromWall)
            make.bottom.equalTo(includeTerm)
            make.width.equalTo(plusButton.snp.height)
        }
        
        includeArea.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(constraintFromWall)
            make.top.equalTo(includeTerm.snp.bottom).offset(constraintFromWall)
            make.height.equalTo(areaSpace)
        }
        
        excludeTerm.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(constraintFromWall)
            make.top.equalTo(includeArea.snp.bottom).offset(constraintFromWall)
        }
        
        minusButton.snp.makeConstraints { make in
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(constraintFromWall)
            make.top.equalTo(excludeTerm)
            make.bottom.equalTo(excludeTerm)
            make.width.equalTo(minusButton.snp.height)
        }
        
        excludeArea.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(constraintFromWall)
            make.top.equalTo(excludeTerm.snp.bottom).offset(constraintFromWall)
            make.height.equalTo(areaSpace)
        }
        
        periodLabel.snp.makeConstraints { make in
            make.top.equalTo(excludeArea.snp.bottom).offset(constraintFromWall)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(constraintFromWall)
        }
        
        calendarView.snp.makeConstraints { make in
            make.top.equalTo(periodLabel.snp.bottom).offset(constraintFromWall)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(constraintFromWall)
        }
    }
    
    private func setupAttribute() {
        [includeArea, excludeArea].forEach { stackView in
            stackView.subviews.forEach { view in
                stackView.removeArrangedSubview(view)
            }
        }
        
        detailSearchRequestValue.includeSearchTerms.forEach { includeText in
            let button = addSearchTermButton(includeText)
            button.backgroundColor = .blue
            self.includeArea.addArrangedSubview(button)
        }
        
        detailSearchRequestValue.excludeSearchTerms.forEach { excludeText in
            let button = addSearchTermButton(excludeText)
            button.backgroundColor = .red
            self.excludeArea.addArrangedSubview(button)
        }
        
        //TODO: - refactor plus, minus overlap
        plusButton.addAction(UIAction(handler: { _ in
            let alert = UIAlertController(title: "alert", message: "textField", preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "OK", style: .default) {[unowned self] _ in
                guard let includeText = alert.textFields?[0].text else { return }
                let button = addSearchTermButton(includeText)
                button.backgroundColor = .blue
                self.includeArea.addArrangedSubview(button)
                self.detailSearchRequestValue.includeSearchTerms.append(includeText)
            }
            
            let cancel = UIAlertAction(title: "cancel", style: .cancel)
            alert.addTextField { textField in
                textField.placeholder = "검색어를 입력하세요."
            }
            
            alert.addAction(cancel)
            
            alert.addAction(ok)
            
            self.present(alert, animated: true, completion: nil)
        }), for: .touchUpInside)
        
        minusButton.addAction(UIAction(handler: { _ in
            let alert = UIAlertController(title: "alert", message: "textField", preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "OK", style: .default) {[unowned self] _ in
                guard let excludeText = alert.textFields?[0].text else { return }
                let button = addSearchTermButton(excludeText)
                button.addAction(UIAction(handler: { [unowned self] _ in
                    button.removeFromSuperview()
                    self.detailSearchRequestValue.excludeSearchTerms.removeAll { $0 == excludeText }
                }), for: .touchUpInside)
                button.backgroundColor = .red
                self.excludeArea.addArrangedSubview(button)
                self.detailSearchRequestValue.excludeSearchTerms.append(excludeText)
            }
            
            let cancel = UIAlertAction(title: "cancel", style: .cancel)
            alert.addTextField { textField in
                textField.placeholder = "검색어를 입력하세요."
            }
            
            alert.addAction(cancel)
            
            alert.addAction(ok)
            
            self.present(alert, animated: true, completion: nil)
        }), for: .touchUpInside)
        
        [includeArea, excludeArea].forEach { area in
            area.layer.cornerRadius = 10
        }
        
    }
    
    private func setupCalendar() {
        // if has values, draw at calendar
        if let start = detailSearchRequestValue.fromDateCompo, let end = detailSearchRequestValue.toDateCompo {
            self.selectedDays = [start, end]
        } else if let start = detailSearchRequestValue.fromDateCompo {
            self.selectedDays = [start]
        }
        /// delegate
        let dateSelection = UICalendarSelectionMultiDate(delegate: self)
        dateSelection.selectedDates = self.selectedDays
        calendarView.selectionBehavior = dateSelection
        
        /// available range
        let calendarViewDateRange = DateInterval(start: .distantPast, end: .now)
        calendarView.availableDateRange = calendarViewDateRange
    }
    
    private func filterInvalidComponents(_ newCompos: [DateComponents]) -> [DateComponents] {
        var newCompos = newCompos.sorted { ($0.date ?? Date()) < ($1.date ?? Date()) }
        let removeIndex = isInRange(newComponents: newCompos) ? 2 : 1
        _ = newCompos.remove(at: removeIndex)
        return newCompos
    }
    
    private func isInRange(newComponents: [DateComponents]) -> Bool {
        let selectedDates = self.selectedDays.compactMap { $0.date }
        let startDate = selectedDates.first ?? Date()
        let lastDate = selectedDates.last ?? Date()
        let dates = newComponents.compactMap { $0.date }
        
        for date in dates {
            if !(startDate...lastDate ~= date) {
                return false
            }
        }
        return true
    }
}


//MARK: - Public
extension SearchToolViewController {
    func bidnig(completion: @escaping (DetailSearchRequestValue) -> Void) {
        onTappedDoneButton = completion
    }
}

extension SearchToolViewController: UICalendarSelectionMultiDateDelegate {
    func multiDateSelection(_ selection: UICalendarSelectionMultiDate, didSelectDate dateComponents: DateComponents) {
        if selection.selectedDates.count == 2 {
            self.selectedDays = selection.selectedDates.sorted { ($0.date ?? Date()) < ($1.date ?? Date()) }
        }
        if selection.selectedDates.count == 3 {
            let twoDates = filterInvalidComponents(selection.selectedDates)
            selection.setSelectedDates(twoDates, animated: true)
            self.selectedDays = twoDates
        }
    }
    
    func multiDateSelection(_ selection: UICalendarSelectionMultiDate, didDeselectDate dateComponents: DateComponents) { }
}
