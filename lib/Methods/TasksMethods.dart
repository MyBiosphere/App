import 'package:http/http.dart' as http;

Future<String> createTask(token, data) async {
  var request = http.MultipartRequest(
      'POST', Uri.parse('https://my-biosphere.herokuapp.com/tasks/'));
  request.headers.addAll({
    "Authorization": token
  });

  request.fields['name'] = data['name'];
  request.fields['description'] = data['description'];
  request.fields['done'] = data['done'].toString();
  request.fields['plant_related'] = data['plant_related'].toString();
  request.fields['user'] = data['user'];
  if (data["plant_related"]) {
    request.fields['plant'] = data['plant'];
    request.fields['plant_name'] = data['plant_name'];
    request.fields['plant_id'] = data['plant_id'];
  }
  else{
    request.fields['sensor'] = data['sensor'];
  }
  final response = await request.send();

  if (response.statusCode == 201) {
    return "Sucess";
  } else {
    throw Exception(
        'Task creation failed : ' + response.statusCode.toString() + response.reasonPhrase!);
  }
}


Future<String> updateTask(token, data) async {
  var request = http.MultipartRequest(
      'PATCH', Uri.parse('https://my-biosphere.herokuapp.com/tasks/${data['id']}/'));
  request.headers.addAll({
    "Authorization": token
  });
  request.fields['done'] = data['done'].toString();

  final response = await request.send();

  if (response.statusCode == 200) {
    return "Sucess";
  } else {
    throw Exception(
        'Task creation failed : ' + response.statusCode.toString() + ' : ' + response.reasonPhrase!);
  }
}