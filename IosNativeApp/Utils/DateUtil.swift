//
//  DateUtil.swift
//  IosNativeApp
//
//  Created by 신동규 on 2020/12/13.
//

import Foundation


class DateUtil {
    static let shared = DateUtil()
    let calendar = Calendar.current
    
    func convertJsonDateToSwiftDate(jsonDate:String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .init(identifier: "ko")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let date = dateFormatter.date(from: jsonDate) {
            return date
        }
        return Date()
    }
    
    func currentYear(date:Date) -> Int {
        
        return calendar.component(Calendar.Component.year, from: date)
    }
    
    func currentMonth(date:Date) -> Int {
        return calendar.component(Calendar.Component.month, from: date)
    }
    
    func currentDay(date:Date) -> Int {
        return calendar.component(Calendar.Component.day, from: date)
    }
    
    func currentHour(date:Date) -> Int {
        return calendar.component(Calendar.Component.hour, from: date)
    }
    
    func currentMinute(date:Date) -> Int {
        return calendar.component(Calendar.Component.minute, from: date)
    }
    
    func compareTwoDate(date1:Date, date2:Date) -> Bool {
        let date1String = "\(currentYear(date: date1))\(currentMonth(date: date1))\(currentDay(date: date1)))"
        let date2String = "\(currentYear(date: date2))\(currentMonth(date: date2))\(currentDay(date: date2)))"
        
        return date1String == date2String
    }
    
    func naturalTimeString(date:Date) -> String {
        let hours = currentHour(date: date)
        let minutes = currentMinute(date: date)
        
        var hoursString = ""
        if hours < 10 {
            hoursString = "0\(hours)"
        }else {
            hoursString = "\(hours)"
        }
        
        var minutesString = ""
        if minutes < 10 {
            minutesString = "0\(minutes)"
        }else {
            minutesString = "\(minutes)"
        }
        
        return "\(hoursString):\(minutesString)"
        
    }
    
    func naturalDateString(date:Date) -> String {
        let now = Date()
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.year, .month, .day]
        formatter.unitsStyle = .full
        if var dayString = formatter.string(from: date, to: now) {
            dayString = dayString.replacingOccurrences(of: "days", with: "일")
            dayString = dayString.replacingOccurrences(of: "day", with: "일")
            dayString = dayString.replacingOccurrences(of: "weeks", with: "주")
            dayString = dayString.replacingOccurrences(of: "week", with: "주")
            dayString = dayString.replacingOccurrences(of: "months", with: "달")
            dayString = dayString.replacingOccurrences(of: "month", with: "달")
            if (dayString == "0 일") {
                return "오늘"
            }
            return dayString
        }
        return "알 수 없음"
    }
    
    func naturalDateStringTypeTwo(date:Date) -> String {
        return "\(currentYear(date: date))년 \(currentMonth(date: date))월 \(currentDay(date: date))일"
    }
}
