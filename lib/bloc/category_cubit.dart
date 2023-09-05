// import 'dart:io';
//
// import 'package:bloc/bloc.dart';
// import 'package:getonnet_project/repositories/CategoryRepository.dart';
// import 'package:meta/meta.dart';
//
//
// class CategoryCubit extends Cubit<ReportProblemState> {
//
//   final CategoryRepository _repository;
//
//   CategoryCubit(this._repository) : super(CategoryInitial());
//
//   Future<void> fetchFarmsForReportProblem () async{
//     final response = await _repository.getFarmsForReportProblem();
//     emit(GetFarmForReportProblem(response));
//   }
//
//   Future<void> fetchProblemTypes () async{
//     final response = await _repository.getProblemTypes();
//     emit(GetProblemTypes(response));
//   }
//
//   Future<void> sendProblem (List<File>files, Map<String, dynamic> map, OnUploadProgressCallback onUploadProgressCallback) async{
//     final response = await _repository.fileUploadMultipart(files: files, onUploadProgress: onUploadProgressCallback, map: map);
//     if(response is SubmitProblemReportResponseDto){
//       emit(SubmitProblemReportSuccessfully(response));
//     }else if(response is String){
//       emit(SubmitProblemReportError(response));
//     }
//     print(response);
//   }
//
//   Future<void> getReportedProblemList(int page) async{
//     final response = await _repository.getReportedProblemList(page);
//     if(response is ReportedProblemListResponseDto){
//       emit(ReportedProblemList(response));
//     }
//   }
//
//   Future<void> giveFeedback(double rating, String feedback, int issueId) async{
//     final response = await _repository.giveFeedback(rating, feedback, issueId);
//     if(response is GiveFeedbackResponseDto){
//       emit(GiveFeedback(response));
//     }
//   }
// }
