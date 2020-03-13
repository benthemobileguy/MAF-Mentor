class MentorIndex {
  final int id;
  final String mentor_id;
  final String mentee_id;
  final String status;
  final int session_count;
  final String current_job;
  final String email;
  final String phone_call;
  final String video_call;
  final String face_to_face;
  final String created_at;
  final String updated_at;

  MentorIndex(this.id, this.mentor_id, this.mentee_id, this.status, this.session_count, this.current_job,
      this.email, this.phone_call, this.video_call, this.face_to_face, this.created_at, this.updated_at);

  Map<String, dynamic> toJson() => {
    'id': id,
    'mentor_id': mentor_id,
    'mentee_id': mentee_id,
    'status': status,
    'session_count': session_count,
    'current_job': current_job,
    'email':email,
    'phone_call': phone_call,
    'video_call': video_call,
    'face_to_face': face_to_face,
    'created_at': created_at,
    'updated_at': updated_at,
  };

  MentorIndex.fromJson(Map<String, dynamic> json):
        id = json['id'],
        mentor_id = json['mentor_id'],
        mentee_id = json['mentee_id'],
        status = json['status'],
        session_count = json['session_count'],
        current_job = json['current_job'],
        email = json['email'],
        phone_call = json['phone_call'],
        video_call = json['video_call'],
        face_to_face = json['face_to_face'],
        created_at = json['created_at'],
        updated_at = json['updated_at'];
}
