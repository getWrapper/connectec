class Usuario {
  String role;
  bool active;
  String id;
  String email;
  String nickname;
  String name;
  bool ok;
  String message;
  String token;
  

  Usuario({
    this.role,
    this.active,
    this.id,
    this.email,
    this.nickname,
    this.name,
    this.ok,
    this.message,
    this.token
  });

  Usuario.fromJson(Map<String, dynamic> json){
    name = json['name'];
    email = json['email'];
    nickname = json['nickname'];
    role = json['role'];
    active = json['active'];
  }
}
