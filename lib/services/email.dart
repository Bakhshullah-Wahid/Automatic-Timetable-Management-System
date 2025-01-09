import 'package:http/http.dart' as http;

import '../widget/base_api.dart';

class EmailSystem{
   Future<void> sendEmail(context, coord , email , userName , password) async {  API api = API();
    // const String baseUrl = 'http://127.0.0.1:8000/';
    final url = Uri.parse('${api.baseUrl}send-email/');
    await http.post(
      url,
      body: {
        'email': email,
        'name': userName,
        'message': coord == 'email'
            ? 'your login as co-ordinator :email:{$email} pswd:$password'
            : coord == 'class'
                ? 'check your Class request List your class is being requested by $email'
                : ''
      },
    );
  }
}