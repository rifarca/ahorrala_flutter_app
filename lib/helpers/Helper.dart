// ignore_for_file: unused_local_variable, file_names, avoid_print, use_rethrow_when_possible, non_constant_identifier_names

import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:in_app_review/in_app_review.dart';
import '../models/Categories.dart';
import '../models/Items.dart';
import '../models/Brands.dart';
import 'data.dart';

class Helper {
  static bool isDebug = false;
  static bool isDevice = true;
  static int limit = 16;
  static String getCategoryNameById(int cat) {
    String res = '';

    res = cats.where((c) => c.id == cat).first.name;

    return res;
  }

  static String getLogoById(int bid) {
    String res = '';

    res = logos.where((c) => c.id == bid).first.image;

    return res;
  }

  static String getCategoryImageById(int cid) {
    String res = '';
    res = cats.where((c) => c.id == cid).first.image;
    return res;
  }

  static Color getColorByCategoryId(int cid) {
    switch (cid) {
      case 1:
        return const Color.fromARGB(255, 97, 96, 96);

      case 2:
        return const Color.fromARGB(255, 18, 65, 21);
        break;
      case 7:
        return const Color.fromARGB(255, 183, 58, 121);
        break;
      case 4:
        return const Color.fromARGB(255, 5, 14, 65);
        break;
      case 5:
        return const Color.fromARGB(255, 201, 92, 3);
        break;
      case 6:
        return const Color.fromARGB(255, 34, 163, 196);

        break;
      case 10:
        return Colors.orange;

        break;
    }
    return Colors.black;
  }

  /*
  static String getImagenByFraseId(int fid) {
    String res = '';
    res = frases.where((f) => f.ID == fid).first.Imagen;
    return res;
  } ()

  static fileFromImageUrl(String url, String userName) async {
    final response = await http.get(
      Uri.parse(url),
    );

    final documentDirectory = await getApplicationDocumentsDirectory();

    var randomNumber = Random();
    var filename = "${documentDirectory.path}/$userName.png";
    print(filename);
    final file = File(
      filename,
    );

    file.writeAsBytesSync(response.bodyBytes);

    return XFile(file.path);
  }

  static List<Frases> getFrasesByCategoryID(int cid) {
    final res = frases.where((f) => f.CategoriaID == cid).toList();
    return res;
  }
*/
  static Future<List<Items>> getItemsRelativesByCategory(String sku) async {
    String url = "";
    if (Platform.isAndroid) {
      if (isDebug) {
        if (isDevice) {
          url =
              "http://192.168.0.3/ahorrala/public/api/items/relacionados/$sku";
        } else {
          url = "https://app.ahorrala.com/public/api/items/relacionados/$sku";
        }
      } else {
        url = "https://app.ahorrala.com/public/api/items/relacionados/$sku";
      }
    } else if (Platform.isIOS) {
      if (isDebug) {
        if (isDevice) {
          url =
              "http://192.168.0.3/ahorrala/public/api/items/relacionados/$sku";
        } else {
          url = "http://app.ahorrala.com/public/api/items/relacionados/$sku";
        }
      } else {
        url = "https://app.ahorrala.com/public/api/items/relacionados/$sku";
      }
    }
    //"https://app.ahorrala.com/public/api/items/buscar?q=$query&c=$cat&l=$limit";
    print(url);

    final dio = Dio();

    try {
      var response = await dio.get(url);
      var data = response.data;

      //data = jsonDecode(data);
      //response.data;
      //var jsonobj = jsonDecode(getFrasesRecientes);
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;

        // 2. Parsear el JSON a una lista de objetos Items
        List<Items> remoteItems = data
            .map((json) => Items.fromJson(json))
            .toList();

        // 3. Actualizar la caché local de Hive en segundo plano
        await ItemsBox.saveAllAndClear(remoteItems);
        return ItemsFromJsonList(data);
      } else {
        throw Exception("Error del servidor");
      }
    } finally {
      dio.close(force: true);
    }
  }

  /* 
  static Future<List> getFrasesNews(int total) async {
    try {
      var response = await Dio()
          .get('https://rifarca.serv00.net/public/api/frases/recientes');
      var json = response.data;
      if (response.statusCode == 200) {
        print(json);
        return Frases.fromJson(response.data) as List;
      } else {
        throw Exception("Error");
      }
    } catch (e) {
      throw (e);
    }
  }

  static List<Frases> FrasesFromJsonList(List<dynamic> jsonlList) {
    return jsonlList
        .map((e) => Frases.fromJson(e as Map<String, dynamic>))
        .toList();
  }

*/
  //metodo apra buscasr las
  static List<Categories> CatsFromJsonList(List<dynamic> jsonlList) {
    return jsonlList
        .map((e) => Categories.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /*
  // A function that converts a response body into a List<Frases>.
  static List<Frases> parseFrases(String responseBody) {
    final parsed =
        (jsonDecode(responseBody) as List).cast<Map<String, dynamic>>();

    return parsed.map<Frases>((json) => Frases.fromJson(json)).toList();
  }

  static Future<List<Frases>> getFrasesRecientes() async {
    String url = "https://rifarca.serv00.net/public/api/frases/recientes";
    var response = await Dio().get(url);
    //var jsonobj = jsonDecode(getFrasesRecientes);
    return FrasesFromJsonList(response.data);
  }

  static Future<List<Frases>> getFrasesRelacionados(int fid) async {
    String url = "https://rifarca.serv00.net/public/api/frases/relacionados/$fid";
    var response = await Dio().get(url);
    //var jsonobj = jsonDecode(getFrasesRecientes);
    return FrasesFromJsonList(response.data);
  }

  static Future<List<Frases>> getFrasesByCategory(int cat) async {
    String url = "https://rifarca.serv00.net/public/api/frases/categoria/$cat";
    var response = await Dio().get(url);
    //var jsonobj = jsonDecode(getFrasesRecientes);
    return FrasesFromJsonList(response.data);
  }

  static Future<List<Categorias>> getCategories() async {
    String url = "https://rifarca.serv00.net/public/api/categorias";
    var response = await Dio().get(url);
    //var jsonobj = jsonDecode(getFrasesRecientes);
    return CatsFromJsonList(response.data);
  }
*/
  //methodo para buscasr las frases
  static Future<List<Items>> getItemsBuscar({
    required String query,
    required int cat,
    required int limit,
    required String field,
    required String order,
  }) async {
    String url =
        "http://192.168.0.3/ahorrala/public/api/items/buscar?q=$query&c=$cat&l=$limit&f=$field&o=$order";
    if (Platform.isAndroid) {
      if (isDebug) {
        if (isDevice) {
          url =
              "http://192.168.0.3/ahorrala/public/api/items/buscar?q=$query&c=$cat&l=$limit&f=$field&o=$order";
        } else {
          url =
              "https://app.ahorrala.com/public/api/items/buscar?q=$query&c=$cat&l=$limit&f=$field&o=$order";
        }
      } else {
        url =
            "https://app.ahorrala.com/public/api/items/buscar?q=$query&c=$cat&l=$limit&f=$field&o=$order";
      }
    } else if (Platform.isIOS) {
      if (isDebug) {
        if (isDevice) {
          url =
              "httpds://192.168.0.3/ahorrala/public/api/items/buscar?q=$query&c=$cat&l=$limit&f=$field&o=$order";
        } else {
          url =
              "https://app.ahorrala.com/public/api/items/buscar?q=$query&c=$cat&l=$limit&f=$field&o=$order";
        }
      } else {
        url =
            "https://app.ahorrala.com/public/api/items/buscar?q=$query&c=$cat&l=$limit&f=$field&o=$order";
      }
    }
    //  "https://app.ahorrala.com/public/api/items/buscar?q=$query&c=$cat&l=$limit";
    print(url);

    final dio = Dio();
    try {
      final response = await dio.get(url);
      final data = response.data;
      //data = jsonDecode(data);
      //var jsonobj = jsonDecode(getFrasesRecientes);
      return ItemsFromJsonList(data);
    } finally {
      dio.close(force: true);
    }
  }

  static Future<List<Items>> getItemsList() async {
    String url = "http://192.168.0.3/ahorrala/public/api/items/listar";
    //"https://app.ahorrala.com/public/api/items/listar";
    if (Platform.isAndroid) {
      if (isDebug) {
        if (isDevice) {
          url = "http://192.168.0.3/ahorrala/public/api/itemslistar";
        } else {
          url = "http://10.10.0.2/ahorrala/public/api/items/listar ";
        }
      } else {
        url = "https://app.ahorrala.com/public/api/items/listar";
      }
    } else if (Platform.isIOS) {
      if (isDebug) {
        if (isDevice) {
          url = "http://192.168.0.3/ahorrala/public/api/items/listar";
        } else {
          url = "https://app.ahorrala.com/public/api/items/listar";
        }
      } else {
        url = "https://app.ahorrala.com/public/api/items/listar";
      }
    }
    final dio = Dio();
    try {
      final res = await dio.get(url);
      final data = res.data;
      return ItemsFromJsonList(data);
    } finally {
      dio.close(force: true);
    }
  }

  static Future<List<Items>> getItemsListByCategory({
    required int cat,
    int sub = 1,
    int limit = 16,
  }) async {
    String url =
        "http://192.168.0.3/ahorrala/public/api/items/$cat/1/$limit/listar";
    if (Platform.isAndroid) {
      if (isDebug) {
        if (isDevice) {
          url =
              "http://192.168.0.3/ahorrala/public/api/items/$cat/1/$limit/listar";
        } else {
          url =
              "http://10.10.0.2/ahorrala/public/api/items/$cat/1/$limit/listar";
        }
      } else {
        url = "https://app.ahorrala.com/public/api/items/$cat/1/$limit/listar";
      }
    } else if (Platform.isIOS) {
      if (isDebug) {
        if (isDevice) {
          url =
              "http://192.168.0.3/ahorrala/public/api/items/$cat/1/$limit/listar";
        } else {
          url = "http://app.ahorrala.com/public/api/items/$cat/1/$limit/listar";
        }
      } else {
        url = "https://app.ahorrala.com/public/api/items/$cat/1/$limit/listar";
      }
    }
    //"https://app.ahorrala.com/public/api/items/" +
    //"$cat/$sub/$limit/listar";
    final dio = Dio();
    try {
      final res = await dio.get(url);
      final data = res.data;
      //rdata = jsonDecode(data);

      return ItemsFromJsonList(data);
    } finally {
      dio.close(force: true);
    }
  }

  static Future<List<Items>> getItemsCompare(String sku) async {
    String url = "http://192.168.0.3/ahorrala/public/api/items/ver/$sku";
    if (Platform.isAndroid) {
      if (isDebug) {
        if (isDevice) {
          url = "http://192.168.0.3/ahorrala/public/api/items/ver/$sku";
        } else {
          url = "http://10.10.0.2/ahorrala/public/api/items/ver/$sku";
        }
      } else {
        url = "https://app.ahorrala.com/public/api/items/ver/$sku";
      }
    } else if (Platform.isIOS) {
      if (isDebug) {
        if (isDevice) {
          url = "http://192.168.0.3/ahorrala/public/api/items/ver/$sku";
        } else {
          url = "https://app.ahorrala.com/public/api/items/ver/$sku";
        }
      } else {
        url = "https://app.ahorrala.com/public/api/items/ver/$sku";
      }
    }

    final dio = Dio();
    try {
      final res = await dio.get(url);

      final data = res.data;

      // data = jsonDecode(data);
      return ItemsFromJsonList(data);
    } finally {
      dio.close(force: true);
    }
  }

  static Future<List<Items>> getItemsDetails(String sku) async {
    String url = "http://192.168.0.3/ahorrala/public/api/items/ver/$sku";

    if (Platform.isAndroid) {
      if (isDebug) {
        if (isDevice) {
          url = "http://192.168.0.3/ahorrala/public/api/items/ver/$sku";
        } else {
          url = "http://10.10.0.2/ahorrala/public/api/items/ver/$sku";
        }
      } else {
        url = "https://app.ahorrala.com/public/api/items/ver/$sku";
      }
    } else if (Platform.isIOS) {
      if (isDebug) {
        if (isDevice) {
          url = "http://192.168.4/ahorrala/public/api/items/ver/$sku";
        } else {
          url = "https://app.ahorrala.com/public/api/items/ver/$sku";
        }
      } else {
        url = "https://app.ahorrala.com/public/api/items/ver/$sku";
      }
    }
    // "https://app.ahorrala.com/public/api/items/ver/$sku";
    final dio = Dio();
    try {
      final res = await dio.get(url);
      final data = res.data;
      // data = jsonDecode(data);
      return ItemsFromJsonList(data);
    } finally {
      dio.close(force: true);
    }
  }

  static Future<List<Categories>> getCategoriesList() async {
    String url = "http://192.168.0.3/ahorrala/public/api/categorias/listar";

    if (Platform.isAndroid) {
      if (isDebug) {
        if (isDevice) {
          url = "http://192.168.0.3/ahorrala/public/api/categorias/listar";
        } else {
          url = "http://10.10.0.2/ahorrala/public/api/categorias/listar";
        }
      } else {
        url = "https://app.ahorrala.com/public/api/categorias/listar";
      }
    } else if (Platform.isIOS) {
      if (isDebug) {
        if (isDevice) {
          url = "http://192.168.0.3/ahorrala/public/api/categorias/listar";
        } else {
          url = "http://app.ahorrala.com/public/api/categorias/listar";
        }
      } else {
        url = "https://app.ahorrala.com/public/api/categorias/listar";
      }
    }
    final dio = Dio();
    try {
      final res = await dio.get(url);
      final data = res.data;
      // data = jsonDecode(data);
      return CatsFromJsonList(data);
    } finally {
      dio.close(force: true);
    }
  }

  static Categories getCategoryByID(int cid) {
    final res = cats.where((c) => c.id == cid).first;

    return res;
  }

  static List<Items> ItemsFromJsonList(List<dynamic> jsonlList) {
    return jsonlList
        .map((e) => Items.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static String sanitizeToFriendlyUrl(String input) {
    // Convertir a minúsculas
    String sanitized = input.toLowerCase();

    // Reemplazar caracteres acentuados o especiales por sus equivalentes simples
    sanitized = sanitized
        .replaceAll(RegExp(r'[áàäâã]'), 'a')
        .replaceAll(RegExp(r'[éèëê]'), 'e')
        .replaceAll(RegExp(r'[íìïî]'), 'i')
        .replaceAll(RegExp(r'[óòöôõ]'), 'o')
        .replaceAll(RegExp(r'[úùüû]'), 'u')
        .replaceAll(RegExp(r'ñ'), 'n')
        .replaceAll(RegExp(r'ç'), 'c');

    // Reemplazar cualquier carácter no alfanumérico o espacios con un guion
    sanitized = sanitized.replaceAll(RegExp(r'[^a-z0-9]+'), '-');

    // Eliminar guiones adicionales al inicio o final
    sanitized = sanitized.replaceAll(RegExp(r'^-+|-+$'), '');

    return sanitized;
  }

  static Future<List<Brands>> getBrandsList() async {
    String url = "http://192.168.0.3/ahorrala/public/api/marcas/listar";

    if (Platform.isAndroid) {
      if (isDebug) {
        if (isDevice) {
          url = "http://192.168.0.3/ahorrala/public/api/marcas/listar";
        } else {
          url = "http://10.10.0.2/ahorrala/public/api/marcas/listar";
        }
      } else {
        url = "https://app.ahorrala.com/public/api/marcas/listar";
      }
    } else if (Platform.isIOS) {
      if (isDebug) {
        if (isDevice) {
          url = "http://192.168.0.3/ahorrala/public/api/marcas/listar";
        } else {
          url = "http://app.ahorrala.com/public/api/marcas/listar";
        }
      } else {
        url = "https://app.ahorrala.com/public/api/marcas/listar";
      }
    }
    // "https://app.ahorrala.com/public/api/marcas/listar";
    final dio = Dio();
    try {
      final res = await dio.get(url);
      final data = res.data;
      // data = jsonDecode(data);
      return BrandsFromJsonList(data);
    } finally {
      dio.close(force: true);
    }
  }

  static List<Brands> BrandsFromJsonList(List<dynamic> jsonlList) {
    return jsonlList
        .map((e) => Brands.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  //get hive pen bonx static method
  static Future<Box> getBoxCache(String name) async {
    Box box = await Hive.openBox(name);

    box.put('show_items_grids_total', 3);
    box.put('user_online', 0);
    box.put('user_name', 'Usuario');
    box.put('user_email', 'usuario@gmail.com');
    box.put('user_avatar_image', 'usuario@gmail.com');
    box.put('user_provider_drive', 'Google');
    box.put('user_provider_token', 'Asdsadsdjsdj');

    return box;
  }

  /*
  static Future<String?> getDeviceUniqueIdentifier() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      // Returns the hardware-based build ID string unique to the device configuration
      return androidInfo.id;
    } else if (Platform.isIOS) {
      final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      // Returns the vendor-specific unique device token
      return iosInfo.identifierForVendor;
    }

    return null;
  }
*/
  static Future<Map<String, String>> obtenerDatosControl() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String idUnico = '';
    String plataforma = '';

    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        idUnico = androidInfo.id; // ID único del hardware en Android
        plataforma = 'android';
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        // ID único para tu app en iOS (cambia si el usuario desinstala todas tus apps)
        idUnico = iosInfo.identifierForVendor ?? '';
        plataforma = 'ios';
      }
    } catch (e) {
      idUnico = e.toString();
    }
    var device = {'deviceId': idUnico, 'plataforma': plataforma};
    var deviceAll = await deviceInfo.deviceInfo;
    print("------------------------");
    print('device: $device');
    print('device full: ${deviceAll.data}');
    print("------------------------");
    return device;
  }

  Future<void> initPlatformState() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    Map<String, dynamic> deviceData0 = <String, dynamic>{};
    var deviceData = <String, dynamic>{};

    try {
      if (kIsWeb) {
        deviceData = _readWebBrowserInfo(await deviceInfoPlugin.webBrowserInfo);
      } else {
        deviceData = switch (defaultTargetPlatform) {
          TargetPlatform.android => _readAndroidBuildData(
            await deviceInfoPlugin.androidInfo,
          ),
          TargetPlatform.iOS => _readIosDeviceInfo(
            await deviceInfoPlugin.iosInfo,
          ),
          TargetPlatform.linux => _readLinuxDeviceInfo(
            await deviceInfoPlugin.linuxInfo,
          ),
          TargetPlatform.windows => _readWindowsDeviceInfo(
            await deviceInfoPlugin.windowsInfo,
          ),
          TargetPlatform.macOS => _readMacOsDeviceInfo(
            await deviceInfoPlugin.macOsInfo,
          ),
          TargetPlatform.fuchsia => <String, dynamic>{
            'Error:': 'Fuchsia platform isn\'t supported',
          },
        };
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.',
      };
    }
  }

  static Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'name': build.name,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'freeDiskSize': build.freeDiskSize,
      'totalDiskSize': build.totalDiskSize,
      'systemFeatures': build.systemFeatures,
      'isLowRamDevice': build.isLowRamDevice,
      'physicalRamSize': build.physicalRamSize,
      'availableRamSize': build.availableRamSize,
    };
  }

  static Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'modelName': data.modelName,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'isiOSAppOnMac': data.isiOSAppOnMac,
      'isiOSAppOnVision': data.isiOSAppOnVision,
      'freeDiskSize': data.freeDiskSize,
      'totalDiskSize': data.totalDiskSize,
      'physicalRamSize': data.physicalRamSize,
      'availableRamSize': data.availableRamSize,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }

  Map<String, dynamic> _readLinuxDeviceInfo(LinuxDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'version': data.version,
      'id': data.id,
      'idLike': data.idLike,
      'versionCodename': data.versionCodename,
      'versionId': data.versionId,
      'prettyName': data.prettyName,
      'buildId': data.buildId,
      'variant': data.variant,
      'variantId': data.variantId,
      'machineId': data.machineId,
    };
  }

  Map<String, dynamic> _readWebBrowserInfo(WebBrowserInfo data) {
    return <String, dynamic>{
      'browserName': data.browserName.name,
      'appCodeName': data.appCodeName,
      'appName': data.appName,
      'appVersion': data.appVersion,
      'deviceMemory': data.deviceMemory,
      'language': data.language,
      'languages': data.languages,
      'platform': data.platform,
      'product': data.product,
      'productSub': data.productSub,
      'userAgent': data.userAgent,
      'vendor': data.vendor,
      'vendorSub': data.vendorSub,
      'hardwareConcurrency': data.hardwareConcurrency,
      'maxTouchPoints': data.maxTouchPoints,
    };
  }

  Map<String, dynamic> _readMacOsDeviceInfo(MacOsDeviceInfo data) {
    return <String, dynamic>{
      'computerName': data.computerName,
      'hostName': data.hostName,
      'arch': data.arch,
      'model': data.model,
      'modelName': data.modelName,
      'kernelVersion': data.kernelVersion,
      'majorVersion': data.majorVersion,
      'minorVersion': data.minorVersion,
      'patchVersion': data.patchVersion,
      'osRelease': data.osRelease,
      'activeCPUs': data.activeCPUs,
      'memorySize': data.memorySize,
      'cpuFrequency': data.cpuFrequency,
      'systemGUID': data.systemGUID,
    };
  }

  Map<String, dynamic> _readWindowsDeviceInfo(WindowsDeviceInfo data) {
    return <String, dynamic>{
      'numberOfCores': data.numberOfCores,
      'computerName': data.computerName,
      'systemMemoryInMegabytes': data.systemMemoryInMegabytes,
      'userName': data.userName,
      'majorVersion': data.majorVersion,
      'minorVersion': data.minorVersion,
      'buildNumber': data.buildNumber,
      'platformId': data.platformId,
      'csdVersion': data.csdVersion,
      'servicePackMajor': data.servicePackMajor,
      'servicePackMinor': data.servicePackMinor,
      'suitMask': data.suitMask,
      'productType': data.productType,
      'reserved': data.reserved,
      'buildLab': data.buildLab,
      'buildLabEx': data.buildLabEx,
      'digitalProductId': data.digitalProductId,
      'displayVersion': data.displayVersion,
      'editionId': data.editionId,
      'installDate': data.installDate,
      'productId': data.productId,
      'productName': data.productName,
      'registeredOwner': data.registeredOwner,
      'releaseId': data.releaseId,
      'deviceId': data.deviceId,
    };
  }

  //app review reques modal show
  static Future<void> requestRating() async {
    final review = InAppReview.instance;

    if (await review.isAvailable()) {
      await review.requestReview();
    } else {
      await review.openStoreListing();
    }
  }
}
