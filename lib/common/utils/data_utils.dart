class DataUtils {

  static DateTime? stringToDateTime(String? value) {
    if (value == null) {
      return null;
    }
    return DateTime.parse(value);
  }
}
