class User {
  final String first_name;
  final String email;
  final String last_name;
  final String country;
  final String gender;
  final String phone;
  final String degree;
  final String linkedin;
  final String institution;
  final String profile_image;
  final String created_at;
  final String updated_at;
  final String category;
  final String industry;
  final String bio_interest;
  final String fav_quote;
  final String isAdmin;
  final String current_job;
  final String company;
  final String position;
  final String state_of_origin;
  int id = 0;

  User(
      this.first_name,
      this.email,
      this.last_name,
      this.country,
      this.gender,
      this.phone,
      this.degree,
      this.institution,
      this.profile_image,
      this.created_at,
      this.updated_at,
      this.company,
      this.isAdmin,
      this.linkedin,
      this.category,
      this.industry,
      this.bio_interest,
      this.fav_quote,
      this.position,
      this.current_job,
      this.state_of_origin,
      this.id);

  Map<String, dynamic> toJson() => {
    'first_name': first_name,
    'email': email,
    'last_name': last_name,
    'country': country,
    'gender': gender,
    'phone': phone,
    'isAdmin': isAdmin,
    'company': company,
    'linkedin': linkedin,
    'position': position,
    'degree': degree,
    'institution': institution,
    'profile_image': profile_image,
    'created_at': created_at,
    'updated_at': updated_at,
    'category': category,
    'industry': industry,
    'bio_interest': bio_interest,
    'fav_quote': fav_quote,
    'current_job': current_job,
    'state_of_origin': state_of_origin,
    'id': id,
  };

  User.fromJson(Map<String, dynamic> json)
      : first_name = json['first_name'],
        email = json['email'],
        last_name = json['last_name'],
        country = json['country'],
        gender = json['gender'],
        phone = json['phone'],
        degree = getFromList(json['education'], 'degree'),
        linkedin = getFromList(json['employment'], 'linkedin'),
        institution = getFromList(json['education'], 'institution'),
        position = getFromList(json['employment'], 'position'),
        isAdmin = json['isAdmin'],
        profile_image = json['profile_image'],
        created_at = json['created_at'],
        updated_at = json['updated_at'],
        category = json['category'],
        industry = json['industry'],
        company = getFromList(json['employment'], 'company'),
        bio_interest = json['bio_interest'],
        fav_quote = json['fav_quote'],
        current_job = json['current_job'],
        state_of_origin = json['state_of_origin'],
        id = json['id'];
}

String getFromList(Map<String, dynamic> json, String key) {
  return json != null ? json[key] : "";
}
