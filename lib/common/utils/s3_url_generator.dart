import '../constant/data.dart';

class S3UrlGenerator {
  static getThumbnailUrlWith300wh(String originalPath) {
    // 파일 경로를 확장자명 기준으로 분리
    List<String> parts = originalPath.split('.');

    // 마지막 부분(확장자명)을 제외한 나머지 부분에' 추가
    String newPath = '${parts.sublist(0, parts.length - 1).join('.')}_300.${parts.last}';

    return '$S3_BASE_URL$newPath';
  }

  static getThumbnailUrlWith1000wh(String originalPath) {
    // 파일 경로를 확장자명 기준으로 분리
    List<String> parts = originalPath.split('.');

    // 마지막 부분(확장자명)을 제외한 나머지 부분에' 추가
    String newPath = '${parts.sublist(0, parts.length - 1).join('.')}_1000.${parts.last}';

    return '$S3_BASE_URL$newPath';
  }
}
