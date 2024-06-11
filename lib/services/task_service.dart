import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_mekanix_app/helpers/storage_helper.dart';
import 'package:flutter_mekanix_app/models/custom_task_model.dart';
import 'package:flutter_mekanix_app/services/api_endpoints.dart';
import 'package:http/http.dart' as http;

class TaskService {
  Future<bool> addCustomTask({
    required MyCustomTask task,
  }) async {
    print(task.toMap());
    var headers = {
      'Authorization': 'Bearer ${storage.read('token')}',
      'Content-Type': 'application/json'
    };
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${ApiEndPoints.baseUrl}${ApiEndPoints.createCustomTaskUrl}'),
    );
    // task.toMap(),
    // request.fields.addAll(
    //   {
    //     'is_template': task.isTemplate.toString(),
    //     'is_form': task.isForm.toString(),
    //     'name': task.name,
    //     'customer_name': 'Hassan Ali',
    //     'customer_email': 'hassanaly@progziel.com',
    //     for (int i = 0; i < task.formSections.length; i++) ...{
    //       'formSections[$i][heading]': task.formSections[i].heading,
    //       for (int j = 0; j < task.formSections[i].elements.length; j++) ...{
    //         'formSections[$i][elements][$j][label]':
    //             '${task.formSections[i].elements[j].label}',
    //         'formSections[$i][elements][$j][type]':
    //             '${task.formSections[i].elements[j].type}',
    //         'formSections[$i][elements][$j][options]':
    //             '${task.formSections[i].elements[j].options}',
    //         'formSections[$i][elements][$j][value]':
    //             '${task.formSections[i].elements[j].controller}',
    //       }
    //     }
    //   },
    // );
    // addFilesToRequest(request, attachments);

    request.headers.addAll(headers);
    try {
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 201) {
        debugPrint('${response.reasonPhrase}  ${response.statusCode}');
        return true;
      } else {
        debugPrint('${response.reasonPhrase}  ${response.statusCode} ');
        return false;
      }
    } catch (e) {
      debugPrint('Error adding task: $e');
      return false;
    }
  }

  void addFilesToRequest(
      http.MultipartRequest request, List<Uint8List> attachments) {
    for (int i = 0; i < attachments.length; i++) {
      request.files.add(http.MultipartFile.fromBytes(
        'files',
        attachments[i],
        filename: 'file[$i].png',
      ));
    }
  }
}
