enum UpdateDeleteMenu {
  UPDATE('update', '일기 수정'), DELETE('delete', '일기 삭제');

  final String name;
  final String displayName;

  const UpdateDeleteMenu(this.name, this.displayName);
}