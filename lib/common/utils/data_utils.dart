class DataUtils {

  static DateTime? stringToDateTime(String? value) {
    if (value == null) {
      return null;
    }
    return DateTime.parse(value);
  }

  static String dateTimeToKoreanDateString(DateTime date) {
    return '${date.year}년 ${date.month}월 ${date.day}일';
  }
}
