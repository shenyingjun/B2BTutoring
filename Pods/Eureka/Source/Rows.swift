//  Rows.swift
//  Eureka ( https://github.com/xmartlabs/Eureka )
//
//  Copyright (c) 2015 Xmartlabs ( http://xmartlabs.com )
//
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit
import MapKit
import Foundation

internal protocol FieldRowConformance : FormatterConformance {
    var textFieldPercentage : CGFloat? { get set }
    var placeholder : String? { get set }
    var placeholderColor : UIColor? { get set }
}

internal protocol TextAreaConformance : FormatterConformance {
    var placeholder : String? { get set }
}

public protocol FormatterConformance: class {
    var formatter: NSFormatter? { get set }
    var useFormatterDuringInput: Bool { get set }
}

public class FieldRow<T: Any, Cell: CellType where Cell: BaseCell, Cell: TextFieldCell, Cell.Value == T>: Row<T, Cell>, FieldRowConformance {
    
    public var textFieldPercentage : CGFloat?
    public var placeholder : String?
    public var placeholderColor : UIColor?
    public var formatter: NSFormatter?
    public var useFormatterDuringInput: Bool
    
    public required init(tag: String?) {
        useFormatterDuringInput = false
        super.init(tag: tag)
        self.displayValueFor = { [unowned self] value in
            guard let v = value else {
                return nil
            }
            if let formatter = self.formatter {
                if self.cell.textField.isFirstResponder() {
                    if self.useFormatterDuringInput {
                        return formatter.editingStringForObjectValue(v as! AnyObject)
                    }
                    else {
                        return String(v)
                    }
                }
                return formatter.stringForObjectValue(v as! AnyObject)
            }
            else{
                return String(v)
            }
        }
    }
}

public protocol _DatePickerRowProtocol {
    var minimumDate : NSDate? { get set }
    var maximumDate : NSDate? { get set }
    var minuteInterval : Int? { get set }
}

public class _DateFieldRow: Row<NSDate, DateCell>, _DatePickerRowProtocol {
    
    public var minimumDate : NSDate?
    public var maximumDate : NSDate?
    public var minuteInterval : Int?
    public var dateFormatter: NSDateFormatter?
    
    required public init(tag: String?) {
        super.init(tag: tag)
        displayValueFor = { [unowned self] value in
            guard let val = value, let formatter = self.dateFormatter else { return nil }
            return formatter.stringFromDate(val)
        }
    }
}

public class _DateInlineFieldRow: Row<NSDate, DateInlineCell>, _DatePickerRowProtocol {
    
    public var minimumDate : NSDate?
    public var maximumDate : NSDate?
    public var minuteInterval : Int?
    public var dateFormatter: NSDateFormatter?
    
    required public init(tag: String?) {
        super.init(tag: tag)
        displayValueFor = { [unowned self] value in
            guard let val = value, let formatter = self.dateFormatter else { return nil }
            return formatter.stringFromDate(val)
        }
    }
}

public class _DateInlineRow: _DateInlineFieldRow {
    
    public typealias InlineRow = DatePickerRow
    public var onPresentInlineRow : (DatePickerRow -> Void)?
    
    public required init(tag: String?) {
        super.init(tag: tag)
        dateFormatter = NSDateFormatter()
        dateFormatter?.timeStyle = .NoStyle
        dateFormatter?.dateStyle = .MediumStyle
        dateFormatter?.locale = .currentLocale()
    }
}

public class _DateTimeInlineRow: _DateInlineFieldRow {

    public typealias InlineRow = DateTimePickerRow
    public var onPresentInlineRow : (DateTimePickerRow -> Void)?
    
    public required init(tag: String?) {
        super.init(tag: tag)
        dateFormatter = NSDateFormatter()
        dateFormatter?.timeStyle = .ShortStyle
        dateFormatter?.dateStyle = .ShortStyle
        dateFormatter?.locale = .currentLocale()
    }
}

public class _TimeInlineRow: _DateInlineFieldRow {
    
    public typealias InlineRow = TimePickerRow
    public var onPresentInlineRow : (TimePickerRow -> Void)?
    
    public required init(tag: String?) {
        super.init(tag: tag)
        dateFormatter = NSDateFormatter()
        dateFormatter?.timeStyle = .ShortStyle
        dateFormatter?.dateStyle = .NoStyle
        dateFormatter?.locale = .currentLocale()
    }
}

public class _CountDownInlineRow: _DateInlineFieldRow {
    
    public typealias InlineRow = CountDownPickerRow
    public var onPresentInlineRow : (CountDownPickerRow -> Void)?
    
    public required init(tag: String?) {
        super.init(tag: tag)
        displayValueFor =  {
            guard let date = $0 else {
                return nil
            }
            let hour = NSCalendar.currentCalendar().component(.Hour, fromDate: date)
            let min = NSCalendar.currentCalendar().component(.Minute, fromDate: date)
            if hour == 1{
                return "\(hour) hour \(min) min"
            }
            return "\(hour) hours \(min) min"
        }
    }
}

public class _TextRow: FieldRow<String, TextCell> {
    public required init(tag: String?) {
        super.init(tag: tag)
    }
}

public class _IntRow: FieldRow<Int, IntCell> {
    public required init(tag: String?) {
        super.init(tag: tag)
        let numberFormatter = NSNumberFormatter()
        numberFormatter.locale = .currentLocale()
        numberFormatter.numberStyle = .DecimalStyle
        numberFormatter.minimumFractionDigits = 0
        formatter = numberFormatter
    }
}

public class _PhoneRow: FieldRow<String, PhoneCell> {
    public required init(tag: String?) {
        super.init(tag: tag)
    }
}

public class _NameRow: FieldRow<String, NameCell> {
    public required init(tag: String?) {
        super.init(tag: tag)
    }
}

public class _EmailRow: FieldRow<String, EmailCell> {
    public required init(tag: String?) {
        super.init(tag: tag)
    }
}

public class _PasswordRow: FieldRow<String, PasswordCell> {
    public required init(tag: String?) {
        super.init(tag: tag)
    }
}

public class _DecimalRow: FieldRow<Float, DecimalCell> {
    public required init(tag: String?) {
        super.init(tag: tag)
        let numberFormatter = NSNumberFormatter()
        numberFormatter.locale = .currentLocale()
        numberFormatter.numberStyle = .DecimalStyle
        numberFormatter.minimumFractionDigits = 2
        formatter = numberFormatter
    }
}

public class _URLRow: FieldRow<NSURL, URLCell> {
    public required init(tag: String?) {
        super.init(tag: tag)
    }
}

public class _TwitterRow: FieldRow<String, TwitterCell> {
    public required init(tag: String?) {
        super.init(tag: tag)
    }
}

public class _AccountRow: FieldRow<String, AccountCell> {
    public required init(tag: String?) {
        super.init(tag: tag)
    }
}

public class _ZipCodeRow: FieldRow<String, ZipCodeCell> {
    public required init(tag: String?) {
        super.init(tag: tag)
    }
}

public class _TimeRow: _DateFieldRow {
    required public init(tag: String?) {
        super.init(tag: tag)
        dateFormatter = NSDateFormatter()
        dateFormatter?.timeStyle = .ShortStyle
        dateFormatter?.dateStyle = .NoStyle
        dateFormatter?.locale = NSLocale.currentLocale()
    }
}

public class _DateRow: _DateFieldRow {
    required public init(tag: String?) {
        super.init(tag: tag)
        dateFormatter = NSDateFormatter()
        dateFormatter?.timeStyle = .NoStyle
        dateFormatter?.dateStyle = .MediumStyle
        dateFormatter?.locale = NSLocale.currentLocale()
    }
}

public class _DateTimeRow: _DateFieldRow {
    required public init(tag: String?) {
        super.init(tag: tag)
        dateFormatter = NSDateFormatter()
        dateFormatter?.timeStyle = .ShortStyle
        dateFormatter?.dateStyle = .ShortStyle
        dateFormatter?.locale = NSLocale.currentLocale()
    }
}

public class _CountDownRow: _DateFieldRow {
    required public init(tag: String?) {
        super.init(tag: tag)
        displayValueFor = { [unowned self] value in
            guard let val = value else {
                return nil
            }
            if let formatter = self.dateFormatter {
                return formatter.stringFromDate(val)
            }
            let components = NSCalendar.currentCalendar().components(NSCalendarUnit.Minute.union(NSCalendarUnit.Hour), fromDate: val)
            var hourString = "hour"
            if components.hour != 1{
                hourString += "s"
            }
            return  "\(components.hour) \(hourString) \(components.minute) min"
        }
    }
}

public class _DatePickerRow : Row<NSDate, DatePickerCell>, _DatePickerRowProtocol {
    
    public var minimumDate : NSDate?
    public var maximumDate : NSDate?
    public var minuteInterval : Int?
    
    required public init(tag: String?) {
        super.init(tag: tag)
        displayValueFor = nil
    }
}

public class _PickerRow<T where T: Equatable> : Row<T, PickerCell<T>>{
    
    public var options = [T]()
    
    required public init(tag: String?) {
        super.init(tag: tag)
    }
}

public class _PickerInlineRow<T where T: Equatable> : Row<T, LabelCellOf<T>>{
    
    public typealias InlineRow = PickerRow<T>
    public var onPresentInlineRow : (PickerRow<T> -> Void)?
    public var options = [T]()

    required public init(tag: String?) {
        super.init(tag: tag)
    }
}

public final class PickerInlineRow<T where T: Equatable> : _PickerInlineRow<T>, RowType, InlineRowType{
    
    required public init(tag: String?) {
        super.init(tag: tag)
        onPresentInlineRow = { [unowned self] inlineRow in
            inlineRow.options = self.options
            inlineRow.displayValueFor = self.displayValueFor
        }
        onExpandInlineRow { cell, row, _ in
            let color = cell.detailTextLabel?.textColor
            row.onCollapseInlineRow { cell, _, _ in
                cell.detailTextLabel?.textColor = color
            }
            cell.detailTextLabel?.textColor = cell.tintColor
        }
    }
    
    public override func customDidSelect() {
        super.customDidSelect()
        if !isDisabled {
            toggleInlineRow()
        }
    }
    
}

public final class PickerRow<T where T: Equatable>: _PickerRow<T>, RowType {
    
    required public init(tag: String?) {
        super.init(tag: tag)
    }
}


public class _TextAreaRow: AreaRow<String, TextAreaCell> {
    required public init(tag: String?) {
        super.init(tag: tag)
    }
}

public class _LabelRow: Row<String, LabelCell> {
    required public init(tag: String?) {
        super.init(tag: tag)
    }
}

public class _CheckRow: Row<Bool, CheckCell> {
    required public init(tag: String?) {
        super.init(tag: tag)
        displayValueFor = nil
    }
}

public class _SwitchRow: Row<Bool, SwitchCell> {
    required public init(tag: String?) {
        super.init(tag: tag)
        displayValueFor = nil
    }
}

public class _PushRow<T: Equatable> : SelectorRow<T, SelectorViewController<T>>, PresenterRowType {
    
    public required init(tag: String?) {
        super.init(tag: tag)
        presentationMode = .Show(controllerProvider: ControllerProvider.Callback { return SelectorViewController<T>(){ _ in } }, completionCallback: { vc in vc.navigationController?.popViewControllerAnimated(true) })
    }
}

public class AreaRow<T: Equatable, Cell: CellType where Cell: BaseCell, Cell: AreaCell, Cell.Value == T>: Row<T, Cell>, TextAreaConformance {
    
    public var placeholder : String?
    public var formatter: NSFormatter?
    public var useFormatterDuringInput: Bool
    
    public required init(tag: String?) {
        useFormatterDuringInput = false
        super.init(tag: tag)
        self.displayValueFor = { [unowned self] value in
            guard let v = value else {
                return nil
            }
            if let formatter = self.formatter {
                if self.cell.textView.isFirstResponder() {
                    if self.useFormatterDuringInput {
                        return formatter.editingStringForObjectValue(v as! AnyObject)
                    }
                    else {
                        return String(v)
                    }
                }
                return formatter.stringForObjectValue(v as! AnyObject)
            }
            else{
                return String(v)
            }
        }
    }

}

public class OptionsRow<T: Equatable, Cell: CellType where Cell: BaseCell, Cell.Value == T> : Row<T, Cell> {
    
    public var options: [T] {
        get { return dataProvider?.arrayData ?? [] }
        set { dataProvider = DataProvider(arrayData: newValue) }
    }
    
    public var selectorTitle: String?
    
    required public init(tag: String?) {
        super.init(tag: tag)
    }
}

public class _ActionSheetRow<T: Equatable>: OptionsRow<T, AlertSelectorCell<T>>, PresenterRowType {
    
    public var onPresentCallback : ((FormViewController, SelectorAlertController<T>)->())?
    lazy public var presentationMode: PresentationMode<SelectorAlertController<T>>? = {
        return .PresentModally(controllerProvider: ControllerProvider.Callback { [unowned self] in
            let vc = SelectorAlertController<T>(title: self.selectorTitle, message: nil, preferredStyle: .ActionSheet)
            vc.row = self
            return vc
            },
            completionCallback: { [unowned self] in
                $0.dismissViewControllerAnimated(true, completion: nil)
                self.cell?.formViewController()?.tableView?.reloadData()
            })
        }()
    
    public required init(tag: String?) {
        super.init(tag: tag)
    }
    
    public override func customDidSelect() {
        super.customDidSelect()
        if let presentationMode = presentationMode where !isDisabled {
            if let controller = presentationMode.createController(){
                controller.row = self
                onPresentCallback?(cell.formViewController()!, controller)
                presentationMode.presentViewController(controller, row: self, presentingViewController: cell.formViewController()!)
            }
            else{
                presentationMode.presentViewController(nil, row: self, presentingViewController: cell.formViewController()!)
            }
        }
    }
}

public class _AlertRow<T: Equatable>: OptionsRow<T, AlertSelectorCell<T>>, PresenterRowType {
    
    public var onPresentCallback : ((FormViewController, SelectorAlertController<T>)->())?
    lazy public var presentationMode: PresentationMode<SelectorAlertController<T>>? = {
        return .PresentModally(controllerProvider: ControllerProvider.Callback { [unowned self] in
            let vc = SelectorAlertController<T>(title: self.selectorTitle, message: nil, preferredStyle: .Alert)
            vc.row = self
            return vc
            }, completionCallback: { [unowned self] in
                $0.dismissViewControllerAnimated(true, completion: nil)
                self.cell?.formViewController()?.tableView?.reloadData()
            }
        )
        
        }()
        
    public required init(tag: String?) {
        super.init(tag: tag)
    }
    
    public override func customDidSelect() {
        super.customDidSelect()
        if let presentationMode = presentationMode where !isDisabled  {
            if let controller = presentationMode.createController(){
                controller.row = self
                onPresentCallback?(cell.formViewController()!, controller)
                presentationMode.presentViewController(controller, row: self, presentingViewController: cell.formViewController()!)
            }
            else{
                presentationMode.presentViewController(nil, row: self, presentingViewController: cell.formViewController()!)
            }
        }
    }
}

public class _ImageRow : SelectorRow<UIImage, ImagePickerController>, PresenterRowType {
    public required init(tag: String?) {
        super.init(tag: tag)
        presentationMode = .PresentModally(controllerProvider: ControllerProvider.Callback { return ImagePickerController() }, completionCallback: { vc in vc.dismissViewControllerAnimated(true, completion: nil) })
        self.displayValueFor = nil
    }
    
    public override func customUpdateCell() {
        super.customUpdateCell()
        cell.accessoryType = .None
        if let image = self.value {
            let imageView = UIImageView(frame: CGRectMake(0, 0, 44, 44))
            imageView.contentMode = .ScaleAspectFill
            imageView.image = image
            imageView.clipsToBounds = true
            cell.accessoryView = imageView
        }
        else{
            cell.accessoryView = nil
        }
    }
}

public class _MultipleSelectorRow<T: Hashable> : GenericMultipleSelectorRow<T, MultipleSelectorViewController<T>>, PresenterRowType {
    public required init(tag: String?) {
        super.init(tag: tag)
        self.displayValueFor = {
            if let t = $0 {
                return t.map({ String($0) }).joinWithSeparator(", ")
            }
            return nil
        }
    }
}

public class _ButtonRowOf<T: Equatable> : Row<T, ButtonCellOf<T>> {
    public var presentationMode: PresentationMode<UIViewController>?
    
    required public init(tag: String?) {
        super.init(tag: tag)
        displayValueFor = nil
        cellStyle = .Default
    }
    
    public override func customDidSelect() {
        super.customDidSelect()
        if !isDisabled {
            if let presentationMode = presentationMode {
                if let controller = presentationMode.createController(){
                    presentationMode.presentViewController(controller, row: self, presentingViewController: self.cell.formViewController()!)
                }
                else{
                    presentationMode.presentViewController(nil, row: self, presentingViewController: self.cell.formViewController()!)
                }
            }
        }
    }
    
    public override func customUpdateCell() {
        super.customUpdateCell()
        let leftAligmnment = presentationMode != nil
        cell.textLabel?.textAlignment = leftAligmnment ? .Left : .Center
        cell.accessoryType = !leftAligmnment || isDisabled ? .None : .DisclosureIndicator
        cell.editingAccessoryType = cell.accessoryType;
        if (!leftAligmnment){
            var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
            cell.tintColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
            cell.textLabel?.textColor  = UIColor(red: red, green: green, blue: blue, alpha:isDisabled ? 0.3 : 1.0)
        }
        else{
            cell.textLabel?.textColor = nil
        }
    }
    
    public override func prepareForSegue(segue: UIStoryboardSegue) {
        super.prepareForSegue(segue)
        let rowVC = segue.destinationViewController as? RowControllerType
        rowVC?.completionCallback = self.presentationMode?.completionHandler
    }
}

public class _ButtonRowWithPresent<T: Equatable, VCType: TypedRowControllerType where VCType: UIViewController, VCType.RowValue == T>: Row<T, ButtonCellOf<T>>, PresenterRowType {
    
    public var presentationMode: PresentationMode<VCType>?
    public var onPresentCallback : ((FormViewController, VCType)->())?
    
    required public init(tag: String?) {
        super.init(tag: tag)
        displayValueFor = nil
        cellStyle = .Default
    }
    
    public override func customUpdateCell() {
        super.customUpdateCell()
        let leftAligmnment = presentationMode != nil
        cell.textLabel?.textAlignment = leftAligmnment ? .Left : .Center
        cell.accessoryType = !leftAligmnment || isDisabled ? .None : .DisclosureIndicator
        cell.editingAccessoryType = cell.accessoryType;
        if (!leftAligmnment){
            var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
            cell.tintColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
            cell.textLabel?.textColor  = UIColor(red: red, green: green, blue: blue, alpha:isDisabled ? 0.3 : 1.0)
        }
        else{
            cell.textLabel?.textColor = nil
        }
    }
    
    public override func customDidSelect() {
        super.customDidSelect()
        if !isDisabled {
            if let presentationMode = presentationMode {
                if let controller = presentationMode.createController(){
                    controller.row = self
                    onPresentCallback?(cell.formViewController()!, controller)
                    presentationMode.presentViewController(controller, row: self, presentingViewController: self.cell.formViewController()!)
                }
                else{
                    presentationMode.presentViewController(nil, row: self, presentingViewController: self.cell.formViewController()!)
                }
            }
        }
    }
    
    public override func prepareForSegue(segue: UIStoryboardSegue) {
        super.prepareForSegue(segue)
        guard let rowVC = segue.destinationViewController as? VCType else {
            return
        }
        if let callback = self.presentationMode?.completionHandler{
            rowVC.completionCallback = callback
        }
        onPresentCallback?(cell.formViewController()!, rowVC)
        rowVC.row = self
    }
    
}


//MARK: Rows

public final class CheckRow: _CheckRow, RowType {
    required public init(tag: String?) {
        super.init(tag: tag)
    }
}

public final class SwitchRow: _SwitchRow, RowType {
    required public init(tag: String?) {
        super.init(tag: tag)
    }
}

public final class LabelRow: _LabelRow, RowType {
    required public init(tag: String?) {
        super.init(tag: tag)
    }
}

public final class DateRow: _DateRow, RowType {
    required public init(tag: String?) {
        super.init(tag: tag)
        onCellHighlight { cell, row in
            let color = cell.detailTextLabel?.textColor
            row.onCellUnHighlight { cell, _ in
                cell.detailTextLabel?.textColor = color
            }
            cell.detailTextLabel?.textColor = cell.tintColor
        }
    }
}

public final class TimeRow: _TimeRow, RowType {
    required public init(tag: String?) {
        super.init(tag: tag)
        onCellHighlight { cell, row in
            let color = cell.detailTextLabel?.textColor
            row.onCellUnHighlight { cell, _ in
                cell.detailTextLabel?.textColor = color
            }
            cell.detailTextLabel?.textColor = cell.tintColor
        }
    }
}

public final class DateTimeRow: _DateTimeRow, RowType {
    required public init(tag: String?) {
        super.init(tag: tag)
        onCellHighlight { cell, row in
            let color = cell.detailTextLabel?.textColor
            row.onCellUnHighlight { cell, _ in
                cell.detailTextLabel?.textColor = color
            }
            cell.detailTextLabel?.textColor = cell.tintColor
        }
    }
}

public final class CountDownRow: _CountDownRow, RowType {
    required public init(tag: String?) {
        super.init(tag: tag)
        onCellHighlight { cell, row in
            let color = cell.detailTextLabel?.textColor
            row.onCellUnHighlight { cell, _ in
                cell.detailTextLabel?.textColor = color
            }
            cell.detailTextLabel?.textColor = cell.tintColor
        }
    }
}

public final class DateInlineRow: _DateInlineRow, RowType, InlineRowType {
    required public init(tag: String?) {
        super.init(tag: tag)
        onExpandInlineRow { cell, row, _ in
            let color = cell.detailTextLabel?.textColor
            row.onCollapseInlineRow { cell, _, _ in
                cell.detailTextLabel?.textColor = color
            }
            cell.detailTextLabel?.textColor = cell.tintColor
        }
    }
    
    public override func customDidSelect() {
        super.customDidSelect()
        if !isDisabled {
            toggleInlineRow()
        }
    }
}

public final class TimeInlineRow: _TimeInlineRow, RowType, InlineRowType {
    required public init(tag: String?) {
        super.init(tag: tag)
        onExpandInlineRow { cell, row, _ in
            let color = cell.detailTextLabel?.textColor
            row.onCollapseInlineRow { cell, _, _ in
                cell.detailTextLabel?.textColor = color
            }
            cell.detailTextLabel?.textColor = cell.tintColor
        }
    }
    
    public override func customDidSelect() {
        super.customDidSelect()
        if !isDisabled {
            toggleInlineRow()
        }
    }
}

public final class DateTimeInlineRow: _DateTimeInlineRow, RowType, InlineRowType {
    required public init(tag: String?) {
        super.init(tag: tag)
        onExpandInlineRow { cell, row, _ in
            let color = cell.detailTextLabel?.textColor
            row.onCollapseInlineRow { cell, _, _ in
                cell.detailTextLabel?.textColor = color
            }
            cell.detailTextLabel?.textColor = cell.tintColor
        }
    }
    
    public override func customDidSelect() {
        super.customDidSelect()
        if !isDisabled {
            toggleInlineRow()
        }
    }
}

public final class CountDownInlineRow: _CountDownInlineRow, RowType, InlineRowType {
    required public init(tag: String?) {
        super.init(tag: tag)
        onExpandInlineRow { cell, row, _ in
            let color = cell.detailTextLabel?.textColor
            row.onCollapseInlineRow { cell, _, _ in
                cell.detailTextLabel?.textColor = color
            }
            cell.detailTextLabel?.textColor = cell.tintColor
        }
    }
    
    public override func customDidSelect() {
        super.customDidSelect()
        if !isDisabled {
            toggleInlineRow()
        }
    }
}

public final class DatePickerRow : _DatePickerRow, RowType {
    public required init(tag: String?) {
        super.init(tag: tag)
    }
}

public final class TimePickerRow : _DatePickerRow, RowType {
    public required init(tag: String?) {
        super.init(tag: tag)
    }
}

public final class DateTimePickerRow : _DatePickerRow, RowType {
    public required init(tag: String?) {
        super.init(tag: tag)
    }
}

public final class CountDownPickerRow : _DatePickerRow, RowType {
    public required init(tag: String?) {
        super.init(tag: tag)
    }
}

public final class TextRow: _TextRow, RowType {
    required public init(tag: String?) {
        super.init(tag: tag)
        onCellHighlight { cell, row  in
            let color = cell.textLabel?.textColor
            row.onCellUnHighlight { cell, _ in
                cell.textLabel?.textColor = color
            }
            cell.textLabel?.textColor = cell.tintColor
        }
    }
}

public final class NameRow: _NameRow, RowType {
    required public init(tag: String?) {
        super.init(tag: tag)
        onCellHighlight { cell, row  in
            let color = cell.textLabel?.textColor
            row.onCellUnHighlight { cell, _ in
                cell.textLabel?.textColor = color
            }
            cell.textLabel?.textColor = cell.tintColor
        }
    }
}

public final class PasswordRow: _PasswordRow, RowType {
    required public init(tag: String?) {
        super.init(tag: tag)
        onCellHighlight { cell, row  in
            let color = cell.textLabel?.textColor
            row.onCellUnHighlight { cell, _ in
                cell.textLabel?.textColor = color
            }
            cell.textLabel?.textColor = cell.tintColor
        }
    }
}

public final class EmailRow: _EmailRow, RowType {
    required public init(tag: String?) {
        super.init(tag: tag)
        onCellHighlight { cell, row  in
            let color = cell.textLabel?.textColor
            row.onCellUnHighlight { cell, _ in
                cell.textLabel?.textColor = color
            }
            cell.textLabel?.textColor = cell.tintColor
        }
    }
}

public final class TwitterRow: _TwitterRow, RowType {
    required public init(tag: String?) {
        super.init(tag: tag)
        onCellHighlight { cell, row  in
            let color = cell.textLabel?.textColor
            row.onCellUnHighlight { cell, _ in
                cell.textLabel?.textColor = color
            }
            cell.textLabel?.textColor = cell.tintColor
        }
    }
}

public final class AccountRow: _AccountRow, RowType {
    required public init(tag: String?) {
        super.init(tag: tag)
        onCellHighlight { cell, row  in
            let color = cell.textLabel?.textColor
            row.onCellUnHighlight { cell, _ in
                cell.textLabel?.textColor = color
            }
            cell.textLabel?.textColor = cell.tintColor
        }
    }
}

public final class ZipCodeRow: _ZipCodeRow, RowType {
    required public init(tag: String?) {
        super.init(tag: tag)
        onCellHighlight { cell, row  in
            let color = cell.textLabel?.textColor
            row.onCellUnHighlight { cell, _ in
                cell.textLabel?.textColor = color
            }
            cell.textLabel?.textColor = cell.tintColor
        }
    }
}

public final class IntRow: _IntRow, RowType {
    required public init(tag: String?) {
        super.init(tag: tag)
        onCellHighlight { cell, row  in
            let color = cell.textLabel?.textColor
            row.onCellUnHighlight { cell, _ in
                cell.textLabel?.textColor = color
            }
            cell.textLabel?.textColor = cell.tintColor
        }
    }
}

public final class DecimalRow: _DecimalRow, RowType {
    required public init(tag: String?) {
        super.init(tag: tag)
        onCellHighlight { cell, row  in
            let color = cell.textLabel?.textColor
            row.onCellUnHighlight { cell, _ in
                cell.textLabel?.textColor = color
            }
            cell.textLabel?.textColor = cell.tintColor
        }
    }
}

public final class URLRow: _URLRow, RowType {
    required public init(tag: String?) {
        super.init(tag: tag)
        onCellHighlight { cell, row  in
            let color = cell.textLabel?.textColor
            row.onCellUnHighlight { cell, _ in
                cell.textLabel?.textColor = color
            }
            cell.textLabel?.textColor = cell.tintColor
        }
    }
}

public final class PhoneRow: _PhoneRow, RowType {
    required public init(tag: String?) {
        super.init(tag: tag)
        onCellHighlight { cell, row  in
            let color = cell.textLabel?.textColor
            row.onCellUnHighlight { cell, _ in
                cell.textLabel?.textColor = color
            }
            cell.textLabel?.textColor = cell.tintColor
        }
    }
}

public final class TextAreaRow: _TextAreaRow, RowType {
    required public init(tag: String?) {
        super.init(tag: tag)
    }
}

public final class SegmentedRow<T: Equatable>: OptionsRow<T, SegmentedCell<T>>, RowType {
    required public init(tag: String?) {
        super.init(tag: tag)
    }
}

public final class ActionSheetRow<T: Equatable>: _ActionSheetRow<T>, RowType {
    required public init(tag: String?) {
        super.init(tag: tag)
    }
}

public final class AlertRow<T: Equatable>: _AlertRow<T>, RowType {
    required public init(tag: String?) {
        super.init(tag: tag)
    }
}

public final class ImageRow : _ImageRow, RowType {
    public required init(tag: String?) {
        super.init(tag: tag)
    }
}

public final class PushRow<T: Equatable> : _PushRow<T>, RowType {
    public required init(tag: String?) {
        super.init(tag: tag)
    }
}

public final class MultipleSelectorRow<T: Hashable> : _MultipleSelectorRow<T>, RowType {
    public required init(tag: String?) {
        super.init(tag: tag)
    }
}

public final class ButtonRowOf<T: Equatable> : _ButtonRowOf<T>, RowType {
    public required init(tag: String?) {
        super.init(tag: tag)
    }
}

public typealias ButtonRow = ButtonRowOf<String>

public final class ButtonRowWithPresent<T: Equatable, VCType: TypedRowControllerType where VCType: UIViewController, VCType.RowValue == T> : _ButtonRowWithPresent<T, VCType>, RowType {
    public required init(tag: String?) {
        super.init(tag: tag)
    }
}

//MARK: LocationRow

public final class LocationRow : SelectorRow<CLLocation, MapViewController>, RowType {
    public required init(tag: String?) {
        super.init(tag: tag)
        presentationMode = .Show(controllerProvider: ControllerProvider.Callback { return MapViewController(){ _ in } }, completionCallback: { vc in vc.navigationController?.popViewControllerAnimated(true) })
        displayValueFor = {
            guard let location = $0 else { return "" }
            let fmt = NSNumberFormatter()
            fmt.maximumFractionDigits = 4
            fmt.minimumFractionDigits = 4
            let latitude = fmt.stringFromNumber(location.coordinate.latitude)!
            let longitude = fmt.stringFromNumber(location.coordinate.longitude)!
            return  "\(latitude), \(longitude)"
        }
    }
}

public class MapViewController : UIViewController, TypedRowControllerType, MKMapViewDelegate {
    
    public var row: RowOf<CLLocation>!
    public var completionCallback : ((UIViewController) -> ())?
    
    lazy var mapView : MKMapView = { [unowned self] in
        let v = MKMapView(frame: self.view.bounds)
        v.autoresizingMask = UIViewAutoresizing.FlexibleWidth.union(UIViewAutoresizing.FlexibleHeight)
        return v
        }()
    
    lazy var pinView: UIImageView = { [unowned self] in
        let v = UIImageView(frame: CGRectMake(0, 0, 50, 50))
        v.image = UIImage(named: "map_pin")
        v.image = v.image?.imageWithRenderingMode(.AlwaysTemplate)
        v.tintColor = UIColor(red: CGFloat(3/255.0), green: CGFloat(201/255.0), blue: CGFloat(169/255.0), alpha: 1.0)
        v.backgroundColor = .clearColor()
        v.clipsToBounds = true
        v.contentMode = .ScaleAspectFit
        v.userInteractionEnabled = false
        return v
        }()
    
    let width: CGFloat = 10.0
    let height: CGFloat = 5.0
    
    lazy var ellipse: UIBezierPath = { [unowned self] in
        let ellipse = UIBezierPath(ovalInRect: CGRectMake(0 , 0, self.width, self.height))
        return ellipse
        }()
    
    
    lazy var ellipsisLayer: CAShapeLayer = { [unowned self] in
        let layer = CAShapeLayer()
        layer.bounds = CGRectMake(0, 0, self.width, self.height)
        layer.path = self.ellipse.CGPath
        layer.fillColor = UIColor.grayColor().CGColor
        layer.fillRule = kCAFillRuleNonZero
        layer.lineCap = kCALineCapButt
        layer.lineDashPattern = nil
        layer.lineDashPhase = 0.0
        layer.lineJoin = kCALineJoinMiter
        layer.lineWidth = 1.0
        layer.miterLimit = 10.0
        layer.strokeColor = UIColor.grayColor().CGColor
        return layer
        }()
    
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience public init(_ callback: (UIViewController) -> ()){
        self.init(nibName: nil, bundle: nil)
        completionCallback = callback
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mapView)
        
        mapView.delegate = self
        mapView.addSubview(pinView)
        mapView.layer.insertSublayer(ellipsisLayer, below: pinView.layer)
        
        let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "tappedDone:")
        button.title = "Done"
        navigationItem.rightBarButtonItem = button
        
        if let value = row.value {
            let region = MKCoordinateRegionMakeWithDistance(value.coordinate, 400, 400)
            mapView.setRegion(region, animated: true)
        }
        else{
            mapView.showsUserLocation = true
        }
        updateTitle()
        
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let center = mapView.convertCoordinate(mapView.centerCoordinate, toPointToView: pinView)
        pinView.center = CGPointMake(center.x, center.y - (CGRectGetHeight(pinView.bounds)/2))
        ellipsisLayer.position = center
    }
    
    
    func tappedDone(sender: UIBarButtonItem){
        let target = mapView.convertPoint(ellipsisLayer.position, toCoordinateFromView: mapView)
        row.value? = CLLocation(latitude: target.latitude, longitude: target.longitude)
        completionCallback?(self)
    }
    
    func updateTitle(){
        let fmt = NSNumberFormatter()
        fmt.maximumFractionDigits = 4
        fmt.minimumFractionDigits = 4
        let latitude = fmt.stringFromNumber(mapView.centerCoordinate.latitude)!
        let longitude = fmt.stringFromNumber(mapView.centerCoordinate.longitude)!
        title = "\(latitude), \(longitude)"
    }
    
    public func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "annotation")
        pinAnnotationView.pinColor = MKPinAnnotationColor.Red
        pinAnnotationView.draggable = false
        pinAnnotationView.animatesDrop = true
        return pinAnnotationView
    }
    
    public func mapView(mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        ellipsisLayer.transform = CATransform3DMakeScale(0.5, 0.5, 1)
        UIView.animateWithDuration(0.2, animations: { [weak self] in
            self?.pinView.center = CGPointMake(self!.pinView.center.x, self!.pinView.center.y - 10)
            })
    }
    
    public func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        ellipsisLayer.transform = CATransform3DIdentity
        UIView.animateWithDuration(0.2, animations: { [weak self] in
            self?.pinView.center = CGPointMake(self!.pinView.center.x, self!.pinView.center.y + 10)
            })
        updateTitle()
    }
}
