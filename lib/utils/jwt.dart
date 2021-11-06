class Jwt {
  static String accessToken = "";
  
  static void updateToken(String token) {
    accessToken = token;
  }
  static void resetToken() {
    accessToken = "";
  }
}
