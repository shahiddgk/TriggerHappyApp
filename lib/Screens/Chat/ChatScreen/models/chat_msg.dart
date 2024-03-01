class Messages {
  Messages({
    required this.msg,
    required this.toId,
    required this.read,
    required this.type,
    required this.send,
    required this.fromId,
  });
  late final String msg;
  late final String toId;
  late final String read;
  late final Type type;
  late final String send;
  late final String fromId;
  
  Messages.fromJson(Map<String, dynamic> json){
    msg = json['msg'].toString();
    toId = json['toId'].toString();
    read = json['read'].toString();
    type = json['type'].toString()==Type.image.name?Type.image:Type.text;
    send = json['send'].toString();
    fromId = json['fromId'].toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['msg'] = msg;
    data['toId'] = toId;
    data['read'] = read;
    data['type'] = type.name;
    data['send'] = send;
    data['fromId'] = fromId;
    return data;
  }
}
enum Type{text,image}