import Foundation

public extension Date {

    /// Get string from `Date` object.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// let date = Date()
    /// date.toString(withFormat: "yyyy-MM-dd HH:mm:ss.SSS")
    /// ```
    ///
    /// - Parameters:
    ///   - format: Date format string.
    /// - Returns: `String`
    ///

    func toString(withFormat format: String = "yyyy-MM-dd HH:mm:ss.SSS") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = .current
        return formatter.string(from: self)
    }

    /// Add `Calendar.Component` to `Date` object.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// let date = Date()
    /// date.add(.day, value: 1)
    /// ```
    ///
    /// - Parameters:
    ///   - unit: `Calendar.Component`
    ///   - value: Value to add
    /// - Returns: `Date`
    ///

    func add(_ unit: Calendar.Component, value: Int) -> Date {
        guard let date = Calendar.current.date(byAdding: unit, value: value, to: self) else {
            AssertFail(message: "no date from string")
            return Date()
        }
        return date
    }
    
    /// Hour
    var hour: Int {
        let component = Calendar.current.dateComponents([.hour], from: self)
        guard let hour = component.hour else {
            AssertFail(message: "Failed to get hour")
            return -1
        }
        return hour
    }

    /// Value of week day
    var weekday: Int {
        let component = Calendar.current.dateComponents([.weekday], from: self)
        guard let weekday = component.weekday else {
            AssertFail(message: "Failed to get weekday")
            return -1
        }
        return weekday
    }

    /// Value of day of month
    var day: Int {
        let component = Calendar.current.dateComponents([.day], from: self)
        guard let day = component.day else {
            AssertFail(message: "Failed to get day")
            return -1
        }
        return day
    }

    /// Value of Month
    var month: Int {
        let component = Calendar.current.dateComponents([.month], from: self)
        guard let month = component.month else {
            AssertFail(message: "Failed to get month")
            return -1
        }
        return month
    }

    /// Value of Year
    var year: Int {
        let component = Calendar.current.dateComponents([.year], from: self)
        guard let year = component.year else {
            AssertFail(message: "Failed to get year")
            return -1
        }
        return year
    }

    /// System Date
    var toSystemTime: Date {
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }

    /// Strip time from `Date` object.
    func stripTime() -> Date {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: self)
        guard let date = Calendar.current.date(from: components) else {
            AssertFail(message: "Failed to convert date")
            return Date()
        }
        return date
    }
}

public extension String {

    /// Convert one date format to another date format.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// let fromFormat = "yyyy-MM-dd HH:mm:ss.SSS"
    /// let toFormat = "yyyy-MM-dd"
    /// let strDate = "2020-01-01 11:11:11.111"
    /// strDate.convertDate(fromFormat: fromFormat, toFormat: toFormat)
    /// ```
    ///
    /// - Parameters:
    ///   - format1: Date format string.
    ///   - format2: Date format string.
    /// - Returns: `String`
    ///

    func convertDate(fromFormat format1: String, toFormat format2: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format1
        formatter.timeZone = .current

        guard let date = formatter.date(from: self) else {
            AssertFail(message: "Failed to convert date")
            return ""
        }
        formatter.dateFormat = format2
        return formatter.string(from: date)
    }

    /// Convert String date to `Date` object.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// let format = "yyyy-MM-dd HH:mm:ss.SSS"
    /// let strDate = "2020-01-01 11:11:11.111"
    /// strDate.toDate(dateFormat: fromFormat)
    /// ```
    ///
    /// - Parameters:
    ///   - format: Date format string.
    /// - Returns: `Date`
    ///

    func toDate(withFormat format: String = "yyyy-MM-dd HH:mm:ss.SSS") -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = .current

        guard let date = formatter.date(from: self) else {
            AssertFail(message: "No date from string")
            return Date()
        }
        return date
    }
}

// Day
public extension Date {

    /// Get number of days in the month of date.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// let date = Date()
    /// date.numberOfDaysInMonth()
    /// ```
    ///

    func numberOfDaysInMonth() -> Int {
        guard let range = Calendar.current.range(of: Calendar.Component.day, in: Calendar.Component.month, for: self) else {
            AssertFail(message: "Failed")
            return -1
        }
        return range.upperBound - range.lowerBound
    }

    /// Get the last day
    ///
    /// **Example:**
    ///
    /// ```swift
    /// let date = Date()
    /// date.lastDay(ofMonth: 12, year: 2020)
    /// ```
    /// - Parameters:
    ///   - month: Month value
    ///   - year: Year value
    /// - Returns: `Int`
    ///

    func lastDay(ofMonth month: Int, year: Int) -> Int {
        let cal = Calendar.current
        var comps = DateComponents(calendar: cal, year: year, month: month)
        comps.setValue(month + 1, for: .month)
        comps.setValue(0, for: .day)
        guard let date = cal.date(from: comps) else {
            AssertFail(message: "Failed")
            return -1
        }
        return cal.component(.day, from: date)
    }

    /// Add days to `Date` object.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// let date = Date()
    /// date.addDays(numberOfDays: 1)
    /// ```
    ///
    /// - Parameters:
    ///   - numberOfDays: Number Of Days
    /// - Returns: `Date`
    ///

    func addDays(numberOfDays: Int) -> Date {
        guard let date = Calendar.current.date(byAdding: .day, value: numberOfDays, to: self) else {
            AssertFail(message: "Failed")
            return Date()
        }
        return date
    }

    /// Get earlier `Date`.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// let date = Date()
    /// date.daysAgo(numberOfDays: -1)
    /// ```
    ///
    /// - Parameters:
    ///   - numberOfDays: Number Of Days
    /// - Returns: `Date`
    ///

    func daysAgo(numberOfDays: Int) -> Date {
        return addDays(numberOfDays: -numberOfDays)
    }
}

// Month
public extension Date {

    /// Get first date of month.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// let date = Date()
    /// date.startOfMonth()
    /// ```
    ///

    func startOfMonth() -> Date {
        let components = Calendar.current.dateComponents([.year, .month], from: self)
        guard let date = Calendar.current.date(from: components) else {
            AssertFail(message: "Failed")
            return Date()
        }
        return date
    }

    /// Get last date of month.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// let date = Date()
    /// date.endOfMonth()
    /// ```
    ///

    func endOfMonth() -> Date {
        let startOfMonth = self.startOfMonth()
        guard let date = Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth) else {
            AssertFail(message: "Failed")
            return Date()
        }
        return date
    }

    /// Add month to `Date` object.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// let date = Date()
    /// date.addMonths(numberOfMonths: 1)
    /// ```
    ///
    /// - Parameters:
    ///   - numberOfMonths: Number Of Months
    /// - Returns: `Date`
    ///

    func addMonths(numberOfMonths: Int) -> Date {
        guard let date = Calendar.current.date(byAdding: .month, value: numberOfMonths, to: self) else {
            AssertFail(message: "Failed")
            return Date()
        }
        return date
    }

    /// Get month ago `Date` object.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// let date = Date()
    /// date.monthsAgo(numberOfMonths: -1)
    /// ```
    ///
    /// - Parameters:
    ///   - numberOfMonths: Number Of Months
    /// - Returns: `Date`
    ///

    func monthsAgo(numberOfMonths: Int) -> Date {
        return addMonths(numberOfMonths: -numberOfMonths)
    }
}

// Week
public extension Date {

    /// Get first day of week.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// let date = Date()
    /// date.firstDayOfWeek()
    /// ```
    ///

    func firstDayOfWeek() -> Date {
        var beginningOfWeek = Date().toSystemTime
        var interval = TimeInterval()

        _ = Calendar.current.dateInterval(of: .weekOfYear, start: &beginningOfWeek, interval: &interval, for: self)

        let components = Calendar.current.dateComponents([.year, .month, .day], from: beginningOfWeek)
        guard let date = Calendar.current.date(from: components) else {
            AssertFail(message: "Failed")
            return Date()
        }

        return date
    }

    /// Get last date of week.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// let date = Date()
    /// date.lastDayOfWeek()
    /// ```
    ///

    func lastDayOfWeek() -> Date {
        let firstDayOfWeek = self.firstDayOfWeek()
        guard let date = Calendar.current.date(byAdding: DateComponents(weekday: 6), to: firstDayOfWeek) else {
            AssertFail(message: "Failed")
            return Date()
        }
        return date
    }

    /// Add weeks to `Date` object.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// let date = Date()
    /// date.addMonths(numberOfWeeks: 1)
    /// ```
    ///
    /// - Parameters:
    ///   - numberOfWeeks: Number Of Weeks
    /// - Returns: `Date`
    ///

    func addWeeks(numberOfWeeks: Int) -> Date {
        guard let date = Calendar.current.date(byAdding: .weekOfYear, value: numberOfWeeks, to: self) else {
            AssertFail(message: "Failed")
            return Date()
        }
        return date
    }

    /// Get week ago `Date` object.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// let date = Date()
    /// date.weeksAgo(numberOfMonths: -1)
    /// ```
    ///
    /// - Parameters:
    ///   - numberOfWeeks: Number Of Weeks
    /// - Returns: `Date`
    ///

    func weeksAgo(numberOfWeeks: Int) -> Date {
        return addWeeks(numberOfWeeks: -numberOfWeeks)
    }

    /// Get week day.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// let date = Date()
    /// date.weekDay()
    /// ```
    ///

    func weekDay() -> Int {
        let component = Calendar.current.dateComponents([.weekday], from: self)
        return component.weekday ?? -1
    }

    private func getDateComponent(component: Set<Calendar.Component>, date: Date) -> DateComponents {
        return Calendar.current.dateComponents(component, from: date)
    }

    func differenceInSec(to endTime: Date = Date()) -> Int {
        let difference = Calendar.current.dateComponents([.second], from: self, to: endTime)
        if let duration = difference.second {
            return duration * 1000
        }
        return 0
    }
}

public extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the amount of nanoseconds from another date
    func nanoseconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.nanosecond], from: date, to: self).nanosecond ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        var result: String = ""
                if years(from: date)   > 0 { return "\(years(from: date))y"   }
                if months(from: date)  > 0 { return "\(months(from: date))M"  }
                if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if seconds(from: date) > 0 { return "\(seconds(from: date))" }
                if days(from: date)    > 0 { result = result + " " + "\(days(from: date)) D" }
                if hours(from: date)   > 0 { result = result + " " + "\(hours(from: date)) H" }
                if minutes(from: date) > 0 { result = result + " " + "\(minutes(from: date)) M" }
               if seconds(from: date) > 0 { return "\(seconds(from: date))" }
        return ""
     }
}

public enum Weekday: String {
    case monday, tuesday, wednesday, thursday, friday, saturday, sunday
}

public extension Date {
    
    func getWeekDaysInEnglish() -> [String] {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "en_US_POSIX")
        return calendar.weekdaySymbols
    }

    enum SearchDirection {
        case next
        case previous

        var calendarSearchDirection: Calendar.SearchDirection {
          switch self {
          case .next:
            return .forward
          case .previous:
            return .backward
          }
        }
    }
    
    func next(_ weekday: Weekday, considerToday: Bool = false) -> Date {
        return get(.next,
               weekday,
               considerToday: considerToday)
    }

    func previous(_ weekday: Weekday, considerToday: Bool = false) -> Date {
        return get(.previous,
               weekday,
               considerToday: considerToday)
    }
    
    func get(_ direction: SearchDirection,
             _ weekDay: Weekday,
             considerToday consider: Bool = false) -> Date {

        let dayName = weekDay.rawValue

        let weekdaysName = getWeekDaysInEnglish().map { $0.lowercased() }

        assert(weekdaysName.contains(dayName), "weekday symbol should be in form \(weekdaysName)")

        let searchWeekdayIndex = weekdaysName.firstIndex(of: dayName)! + 1

        let calendar = Calendar(identifier: .gregorian)

        if consider && calendar.component(.weekday, from: self) == searchWeekdayIndex {
            return self
        }

        var nextDateComponent = calendar.dateComponents([.hour, .minute, .second], from: self)
        nextDateComponent.weekday = searchWeekdayIndex

        let date = calendar.nextDate(after: self,
                             matching: nextDateComponent,
                             matchingPolicy: .nextTime,
                             direction: direction.calendarSearchDirection)

        return date!
    }
}
