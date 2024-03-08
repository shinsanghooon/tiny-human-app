enum ChatRequestType {
  KEYWORD('KEYWORD', '관심사 기반', '관심사가 비슷한 사용자에게 채팅을 요청합니다.'),
  LOCATION('LOCATION', '지역 기반', '내 위치 주변의 사용자에게 채팅을 요청합니다.');

  final String name;
  final String displayName;
  final String description;

  const ChatRequestType(this.name, this.displayName, this.description);
}
