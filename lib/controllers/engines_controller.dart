import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_mekanix_app/controllers/universal_controller.dart';
import 'package:flutter_mekanix_app/helpers/storage_helper.dart';
import 'package:flutter_mekanix_app/helpers/toast.dart';
import 'package:flutter_mekanix_app/models/engine_model.dart';
import 'package:flutter_mekanix_app/services/engine_service.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EnginesController extends GetxController {
  var isLoading = false.obs;
  var isEnginesAreLoading = false.obs;
  RxBool isQrCodeGenerated = false.obs;
  XFile? engineImage;
  late Uint8List engineImageInBytes;
  RxString engineImageUrl = ''.obs;
  TextEditingController engineName = TextEditingController();
  TextEditingController engineSubtitle = TextEditingController();
  RxString engineType = 'Generator'.obs;
  GlobalKey engineFormKey = GlobalKey<FormState>();
  RxString qrCodeData = ''.obs;

  var fetchedEngines = <EngineModel>[].obs;

  final ImagePicker picker = ImagePicker();
  final PageController pageController = PageController();
  final UniversalController universalController = Get.find();
  EngineService engineService = EngineService();

  //For Pagination
  ScrollController scrollController = ScrollController();
  final RxInt _currentPage = 1.obs;

  //For Searching
  TextEditingController searchController = TextEditingController();

  @override
  onInit() {
    // getAllEngines();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (!isLoading.value) {
          _loadNextPage();
        }
      }
    });
    super.onInit();
  }

  @override
  void dispose() {
    searchController.dispose();
    scrollController.dispose();
    pageController.dispose();
    universalController.dispose();
    super.dispose();
  }

  void _loadNextPage() async {
    debugPrint('Loading Next Page ${_currentPage.value} Engines');
    isLoading.value = true;
    List<EngineModel> nextPageEngines = await engineService.getAllEngines(
      page: _currentPage.value + 1,
      token: storage.read('token'),
    );

    fetchedEngines.addAll(nextPageEngines);
    _currentPage.value++;
    isLoading.value = false;
  }

  Future<void> getAllEngines({String? searchName}) async {
    try {
      isEnginesAreLoading.value = true;
      _currentPage.value = 1;
      // Call the service method to fetch the engines
      fetchedEngines.value = await engineService.getAllEngines(
        searchString: searchName ?? '',
        token: storage.read('token'),
        page: _currentPage.value,
      );
      universalController.engines = fetchedEngines;
      debugPrint('EnginesCount: ${universalController.engines.length}');
      isEnginesAreLoading.value = false;
    } catch (e) {
      debugPrint('Error fetching engines: $e');
    } finally {
      isEnginesAreLoading.value = false;
    }
  }

  // Function to pick an image
  Future<void> pickImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      engineImage = image;
      engineImageUrl.value = image.path;
      engineImageInBytes = (await engineImage?.readAsBytes())!;

      update();
    }
  }

  // Function to update an image
  Future<void> updateImage(EngineModel model) async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      engineImage = image;
      engineImageUrl.value = image.path;
      engineImageInBytes = (await engineImage?.readAsBytes())!;
      engineService.updateEngineImage(
          engineImageInBytes: engineImageInBytes,
          engineId: model.id ?? '',
          token: storage.read('token'));
    }
  }

  void addEngine() async {
    if (engineImageUrl.value == '') {
      ToastMessage.showToastMessage(
          message: 'Please Select an Engine Image',
          backgroundColor: Colors.red);
    } else {
      isLoading.value = true;
      try {
        var newEngine = EngineModel(
          userId: storage.read('user_info')['_id'],
          name: engineName.text.trim(),
          imageUrl: engineImageUrl.value,
          subname: engineSubtitle.text.trim(),
          isGenerator: engineType.value == 'Generator',
          isCompressor: engineType.value == 'Compressor',
        );
        bool success = await engineService.addEngine(
            engineModel: newEngine, engineImageInBytes: engineImageInBytes);

        if (success) {
          ToastMessage.showToastMessage(
              message: 'Engine Added Successfully',
              backgroundColor: Colors.green);
          isLoading.value = false;
          pageController.nextPage(
              duration: const Duration(milliseconds: 300), curve: Curves.ease);
          await getAllEngines();
          isQrCodeGenerated.value = true;
          engineType.value = 'Generator';
        } else {
          ToastMessage.showToastMessage(
              message: 'Something went wrong, please try again',
              backgroundColor: Colors.red);
          isLoading.value = false;
        }
      } catch (e) {
        ToastMessage.showToastMessage(
            message: 'Something went wrong, please try again',
            backgroundColor: Colors.red);
        isLoading.value = false;
      }
    }
  }

  Future<void> updateEngine({required String id}) async {
    isLoading.value = true;
    try {
      var updatedEngineData = EngineModel(
        id: id,
        userId: storage.read('user_info')['_id'],
        name: engineName.text.trim(),
        subname: engineSubtitle.text.trim(),
        isGenerator: engineType.value == 'Generator',
        isCompressor: engineType.value == 'Compressor',
      );
      bool success = await engineService.updateEngine(
          engineModel: updatedEngineData, token: storage.read('token'));
      isLoading.value = false;
      if (success) {
        ToastMessage.showToastMessage(
            message: 'Engine Updated Successfully',
            backgroundColor: Colors.green);
        getAllEngines();
        Get.back();
      } else {
        ToastMessage.showToastMessage(
            message: 'Failed to update engine, please try again',
            backgroundColor: Colors.red);
      }
    } catch (e) {
      debugPrint('Error updating engine: $e');
    } finally {
      // isLoading.value = false;
    }
  }

  Future<void> deleteEngine({required EngineModel engineModel}) async {
    debugPrint('DeleteEngineFunctionCalled');
    isLoading.value = true;
    try {
      var deletedEngineData = EngineModel(
        id: engineModel.id,
        userId: storage.read('user_info')['_id'],
        name: engineModel.name,
        subname: engineModel.subname,
        isGenerator: engineModel.isGenerator,
        isCompressor: engineModel.isCompressor,
      );
      bool success = await engineService.deleteEngine(
        engineModel: deletedEngineData,
        token: storage.read('token'),
      );
      getAllEngines();
      isLoading.value = false;
      if (success) {
        ToastMessage.showToastMessage(
          message: 'Engine Deleted Successfully',
          backgroundColor: Colors.green,
        );
        Get.back();
      } else {
        ToastMessage.showToastMessage(
          message: 'Failed to delete engine, please try again',
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      isLoading.value = false;
      ToastMessage.showToastMessage(
        message: 'Something went wrong, please try again',
        backgroundColor: Colors.red,
      );
      debugPrint('Error deleting engine: $e');
    } finally {
      // isLoading.value = false;
    }
  }

  @override
  void onClose() {
    engineName.clear();
    engineSubtitle.clear();
    engineImageUrl.value = '';
    engineImageInBytes = Uint8List(0);
    isQrCodeGenerated.value = false;
    pageController.dispose();
    super.onClose();
  }
}
