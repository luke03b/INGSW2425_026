abstract class DTO{
  Map<String, dynamic> toJson();
  DTO fromJson(Map<String, dynamic> json);
}