// import 'dart:convert';
// import 'dart:io';
//
// import 'package:getonnet_project/model/CategoryResponseDto.dart';
//
// import '../utils/strings.dart';
// import 'package:http/http.dart' as http;
//
// class CategoryRepository{
//   final String _baseUrl = CustomStrings.baseUrl;
//
//   Future<List<CategoryResponseDto>> getMovieCategory() async {
//     final response = await http.get(Uri.parse(_baseUrl + "api/v1/issue_reporting/issuable_farms"), headers: {
//       'Authorization': 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxNzc4ZjdiNzY5ZmY1YjkyN2U0MjRlMGFmYjk5ZGFjZSIsInN1YiI6IjU2ZjliNDlmOTI1MTQxNGRmMTAwMDI2MiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.4murMPfAupna-hycPVRT5KSPeQSP888rWkacpZCxhgQ',
//     },);
//     print(jsonDecode(response.body));
//     if(response.statusCode == HttpStatus.ok){
//       List<CategoryResponseDto> list = (json.decode(response.body) as List).map((e) => CategoryResponseDto.fromJson(e)).toList();
//       return list;
//     }
//
//   }
// }