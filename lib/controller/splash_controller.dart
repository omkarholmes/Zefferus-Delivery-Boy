import 'package:efood_multivendor_driver/data/api/api_checker.dart';
import 'package:efood_multivendor_driver/data/model/response/config_model.dart';
import 'package:efood_multivendor_driver/data/repository/splash_repo.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SplashController extends GetxController implements GetxService {
  final SplashRepo splashRepo;
  SplashController({required this.splashRepo});

  late ConfigModel _configModel;
  DateTime _currentTime = DateTime.now();
  bool _firstTimeConnectionCheck = true;

  ConfigModel get configModel => _configModel;
  DateTime get currentTime => DateTime.now();
  bool get firstTimeConnectionCheck => _firstTimeConnectionCheck;

  Future<bool> getConfigData() async {
    Response response = await splashRepo.getConfigData();
    bool _isSuccess = false;
    if (response.statusCode == 200) {
      _configModel = ConfigModel.fromJson(response.body);
      _isSuccess = true;
    } else {
      ApiChecker.checkApi(response);
      _isSuccess = false;
    }
    update();
    return _isSuccess;
  }

  Future<bool> initSharedData() {
    return splashRepo.initSharedData();
  }

  Future<bool> removeSharedData() {
    return splashRepo.removeSharedData();
  }

  bool isRestaurantClosed() {
    DateTime _open = DateFormat('hh:mm').parse('');
    DateTime _close = DateFormat('hh:mm').parse('');
    DateTime _openTime = DateTime(_currentTime.year, _currentTime.month,
        _currentTime.day, _open.hour, _open.minute);
    DateTime _closeTime = DateTime(_currentTime.year, _currentTime.month,
        _currentTime.day, _close.hour, _close.minute);
    if (_closeTime.isBefore(_openTime)) {
      _closeTime = _closeTime.add(Duration(days: 1));
    }
    if (_currentTime.isAfter(_openTime) && _currentTime.isBefore(_closeTime)) {
      return false;
    } else {
      return true;
    }
  }

  void setFirstTimeConnectionCheck(bool isChecked) {
    _firstTimeConnectionCheck = isChecked;
  }
}
