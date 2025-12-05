// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title HelloWorld
 * @dev 一个简单的智能合约，用于存储和检索 "Hello, World!" 消息，并附带时间戳。
 */
contract HelloWorld {

    // 定义一个私有状态变量 _message，用于存储字符串。
    string private _message;

    /**
     * @dev 合约构造函数，在部署合约时调用。
     * 它将 _message 初始化为 "Hello, World!"。
     */
    constructor() {
        _message = "Hello, World!";
    }

    /**
     * @dev Converts a Unix timestamp to a Gregorian calendar date (year, month, day).
     * Based on validated community implementations.
     * Assumes input timestamp is based on 1970-01-01 00:00:00 UTC.
     */
    function _timestampToDate(uint256 timestamp)
        private
        pure
        returns (
            uint256 year,
            uint256 month,
            uint256 day
        )
    {
        // Number of seconds in a day
        uint256 SECONDS_PER_DAY = 24 * 60 * 60; // 86400
        // Unix time starts at 1970-01-01
        uint256 EPOCH_YEAR = 1970;

        // Total number of days since Unix epoch
        uint256 days_since_epoch = timestamp / SECONDS_PER_DAY;

        // Approximate year calculation (this will be refined)
        uint256 DAYS_PER_YEAR_APPROX = 36525; // 365.25 * 100
        uint256 years_since_epoch_approx = (days_since_epoch * 100) / DAYS_PER_YEAR_APPROX;
        year = EPOCH_YEAR + years_since_epoch_approx;

        // Calculate how many days have passed since the start of the calculated year
        uint256 days_in_previous_years = 0;
        uint256 y = EPOCH_YEAR;
        while (y < year) {
            days_in_previous_years += _isLeapYear(y) ? 366 : 365;
            y++;
        }
        uint256 day_of_year = days_since_epoch - days_in_previous_years;

        // If day_of_year is negative, it means our year estimate was too high
        // This loop adjusts the year downwards until day_of_year is non-negative
        while (int256(day_of_year) < 0) {
            year--;
            day_of_year += _isLeapYear(year) ? 366 : 365;
        }

        // --- 修改点：使用 uint8[12] ---
        // Now determine the month and day within the finalized year
        uint8[12] memory days_in_months = [
            31, // January
            uint8(_isLeapYear(year) ? 29 : 28), // February - Explicitly cast result to uint8
            31, // March
            30, // April
            31, // May
            30, // June
            31, // July
            31, // August
            30, // September
            31, // October
            30, // November
            31  // December
        ];
        // --- 修改结束 ---

        month = 1;
        // --- 循环条件也需要相应调整 ---
        while (day_of_year >= days_in_months[month - 1]) { // uint256 >= uint8 is fine
            day_of_year -= days_in_months[month - 1]; // uint256 -= uint8 is fine
            month++;
        }
        // --- 调整结束 ---
        day = day_of_year + 1; // day_of_year is 0-indexed
    }

    /**
     * @dev Determines if a given year is a leap year.
     * Leap year rules: divisible by 4, but not by 100 unless also by 400.
     */
    function _isLeapYear(uint256 year) private pure returns (bool) {
        return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
    }


    // --- 格式化日期部分 (yyyy-MM-dd) ---
    function _formatDatePart(uint256 timestamp) private pure returns (string memory) {
        (uint256 year, uint256 month, uint256 day) = _timestampToDate(timestamp);

        return string.concat(
            _uintToString(year),
            "-", 
            _padZero(_uintToString(month)),
            "-", 
            _padZero(_uintToString(day))
        );
    }

    // --- 格式化时间部分 (HH:mm:ss) ---
    function _formatTimePart(uint256 timestamp) private pure returns (string memory) {
        uint256 ts = timestamp;
        uint256 totalSeconds = ts;
        uint256 totalMinutes = totalSeconds / 60;
        uint256 totalHours = totalMinutes / 60;

        return string.concat(
            _padZero(_uintToString(totalHours % 24)),
            ":",
            _padZero(_uintToString(totalMinutes % 60)),
            ":",
            _padZero(_uintToString(totalSeconds % 60))
        );
    }

    // --- 主格式化函数 ---
    function _formatTimestamp(uint256 timestamp) private pure returns (string memory) {
        uint256 beijingTimestamp = timestamp + 28800;
        string memory datePart = _formatDatePart(beijingTimestamp);
        string memory timePart = _formatTimePart(beijingTimestamp);
        return string.concat(datePart, " ", timePart);
    }

    // --- 以下辅助函数保持不变 ---

    function _uintToString(uint256 number) private pure returns (string memory) {
        if (number == 0) {
            return "0";
        }
        uint256 temp = number;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (number != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + number % 10));
            number /= 10;
        }
        return string(buffer);
    }

    function _padZero(string memory s) private pure returns (string memory) {
        return bytes(s).length == 1 ? string.concat("0", s) : s;
    }

    function _getMessageWithTimestamp() private view returns (string memory) {
        return string.concat(_message, " (", _formatTimestamp(block.timestamp), ")");
    }

    function getMessage() public view returns (string memory) {
        return _getMessageWithTimestamp();
    }
}