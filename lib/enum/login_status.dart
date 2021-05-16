import 'package:json_annotation/json_annotation.dart';

enum LOGIN_STATUS{
  @JsonValue("logged_in")
  LoggedIn,
  @JsonValue("logged_out")
  LoggedOut,
}