import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_mekanix_app/controllers/custom_task_controller.dart';
import 'package:flutter_mekanix_app/helpers/storage_helper.dart';
import 'package:flutter_mekanix_app/models/custom_task_model.dart';
import 'package:flutter_mekanix_app/services/api_endpoints.dart';
import 'package:http/http.dart' as http;

class TaskResponse {
  final bool isSuccess;
  final List<String> data;

  TaskResponse({required this.isSuccess, required this.data});
}

class TaskService {
  Future<bool> createCustomTask({
    required Map<String, dynamic> taskData,
  }) async {
    debugPrint('AddingCustomTask');
    var token = storage.read('token');
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.post(
        Uri.parse('${ApiEndPoints.baseUrl}${ApiEndPoints.createCustomTaskUrl}'),
        headers: headers,
        body: jsonEncode(taskData),
      );

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        debugPrint(responseData['message']);
        CustomTaskController().getAllCustomTasks(page: 1);
        CustomTaskController().getAllCustomTasks(page: 1, isTemplate: true);
        return responseData['status'] == 'success';
      } else {
        debugPrint('Failed to add task, status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      debugPrint('Error adding task: $e');
      return false;
    }
  }

  Future<TaskResponse> addCustomTaskFiles({
    required List<Uint8List> attachments,
  }) async {
    debugPrint('AddingCustomTaskFiles');
    var token = storage.read('token');
    var headers = {
      'Authorization': 'Bearer $token',
    };

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${ApiEndPoints.baseUrl}${ApiEndPoints.addCustomTaskFilesUrl}'),
    );

    addFilesToRequest(request, attachments);

    request.headers.addAll(headers);
    try {
      http.StreamedResponse response = await request.send();
      debugPrint('${response.reasonPhrase} ${response.statusCode}');
      if (response.statusCode == 200) {
        var data = await response.stream.bytesToString();
        var jsonData = jsonDecode(data);
        bool isSuccess = jsonData['status'] == 'success';
        List<String> files = List<String>.from(jsonData['data']);
        return TaskResponse(isSuccess: isSuccess, data: files);
      } else {
        debugPrint('Error: ${response.reasonPhrase} ${response.statusCode}');
        return TaskResponse(isSuccess: false, data: []);
      }
    } catch (e) {
      debugPrint('Error adding task: $e');
      return TaskResponse(isSuccess: false, data: []);
    }
  }

  Future<void> addFilesToRequest(
      http.MultipartRequest request, List<Uint8List> attachments) async {
    for (int i = 0; i < attachments.length; i++) {
      request.files.add(http.MultipartFile.fromBytes(
        'files',
        attachments[i],
        filename: 'file_$i.png',
      ));
    }
  }

  Future<List<MyCustomTask>> getAllCustomTasks(
      {String? searchString,
      required String token,
      required int page,
      required bool isTemplate}) async {
    String apiUrl =
        '${ApiEndPoints.baseUrl}${ApiEndPoints.getAllCustomTaskUrl}?page=$page';
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'search': searchString == '' ? null : searchString,
          "is_template": isTemplate,
        }),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['data'] != null) {
          final List tasksList = jsonData['data'];
          List<MyCustomTask> tasks = [];
          for (var task in tasksList) {
            tasks.add(MyCustomTask.fromMap(task));
          }
          return tasks;
        } else {
          debugPrint('No tasks found in the request response');
          return [];
        }
      } else {
        debugPrint('Failed to get tasks: ${response.reasonPhrase}');
        return [];
      }
    } catch (e) {
      debugPrint('Error getting tasks: $e');
      return [];
    }
  }

  Future<bool> deleteTaskById({
    required String taskId,
    required String token,
  }) async {
    bool isSuccess = false;
    print(taskId);
    final Uri apiUrl = Uri.parse(
      '${ApiEndPoints.baseUrl}${ApiEndPoints.deleteCustomTaskUrl}?id=$taskId',
    );

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      final http.Response response = await http.delete(
        apiUrl,
        headers: headers,
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final String message = responseData['message'];
        final Map<String, dynamic> data = responseData['data'];
        debugPrint('Task deletion message: $message');
        debugPrint('Deleted Task details: $data');
        isSuccess = true;
      } else {
        debugPrint(
            'Failed to delete task. Status Code: ${response.statusCode} ${response.reasonPhrase}');
        debugPrint('Response Body: ${response.body}');
      }
    } catch (error) {
      debugPrint('Error deleting task: $error');
    }

    return isSuccess;
  }

  Future<bool> updateCustomTask({
    required Map<String, dynamic> taskData,
    required String taskId,
  }) async {
    debugPrint('AddingCustomTask');
    var token = storage.read('token');
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    debugPrint('Updating task with id: $taskId');
    try {
      final response = await http.put(
        Uri.parse(
            '${ApiEndPoints.baseUrl}${ApiEndPoints.updateCustomTaskUrl}?id=$taskId'),
        headers: headers,
        body: jsonEncode(taskData),
      );

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        debugPrint(responseData['message']);
        return responseData['status'] == 'success';
      } else {
        debugPrint(
            'Failed to update task, status code: ${response.statusCode} ${response.reasonPhrase}');
        return false;
      }
    } catch (e) {
      debugPrint('Error updating task: $e');
      return false;
    }
  }
}
