class Noti {
  int id;
  int userId;
  Message message;
  String createdAt;
  String updatedAt;

  Noti({this.id, this.userId, this.message, this.createdAt, this.updatedAt});

  Noti.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    message = json['message'] != null ? new Message.fromJson(json['message']) : null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    if (this.message != null) {
      data['message'] = this.message.toJson();
    }
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Message {
  String body;
  String title;

  Message({this.body, this.title});

  Message.fromJson(Map<String, dynamic> json) {
    body = json['body'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['body'] = this.body;
    data['title'] = this.title;
    return data;
  }
}