enum ChatRequestType {
  random('random', '랜덤 기반', '채팅을 허용한 사용자에게 채팅을 요청합니다.'),
  locationBased('locationBased', '지역 기반', '내 위치 주변의 사용자에게 채팅을 요청합니다.');

  final String name;
  final String displayName;
  final String description;

  const ChatRequestType(this.name, this.displayName, this.description);
}
