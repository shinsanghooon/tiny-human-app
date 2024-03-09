import 'package:intl/intl.dart';

class DateConvertor {
  static DateTime? stringToDateTime(String? value) {
    print('in convertor');
    print(value);
    if (value == null) {
      return null;
    }
    return DateTime.parse(value);
  }

  static String dateTimeToKoreanDateString(DateTime date) {
    return '${date.year}년 ${date.month}월 ${date.day}일';
  }

  static DateTime? exifDateToDateTime(String? dateString) {
    // from: '2023:09:24 11:18:53'
    // to: 'yyyy:MM:dd HH:mm:ss'
    if (dateString == null) {
      return null;
    }

    // 변환할 날짜 형식을 지정합니다.
    DateFormat inputFormat = DateFormat('yyyy:MM:dd HH:mm:ss');
    // 입력된 문자열을 DateTime 객체로 변환합니다.
    DateTime dateTime = inputFormat.parse(dateString);

    return DateTime.parse(DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime));
  }

  static String convertoToRelativeTime(DateTime date) {
    DateTime now = DateTime.now();
    Duration difference = now.difference(date);

    if (difference.inDays >= 7) {
      int week = (difference.inDays / 7).floor();
      return '$week주 전';
    } else if (difference.inDays >= 1) {
      return '${difference.inDays}일 전';
    } else if (difference.inHours >= 1) {
      return '${difference.inHours}시간 전';
    } else if (difference.inMinutes >= 1) {
      return '${difference.inMinutes}분 전';
    } else {
      return '방금 전';
    }
  }

  static int calculateDaysAfterBaseDate(String baseDate, DateTime selectedDate) {
    final birthday = DateConvertor.stringToDateTime(baseDate);
    return selectedDate.difference(birthday!).inDays + 1;
  }
}
