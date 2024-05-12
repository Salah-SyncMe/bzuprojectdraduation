import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../controller/home_controller.dart';
import '../controller/login_controller.dart';
import '../controller/page_controller.dart';
import '../controller/provider_file.dart';
import '../controller/registeration_controller.dart';
import '../model/api.dart';

List<SingleChildWidget> providers = [
  ChangeNotifierProvider(create: (context) => HomeController()),
  ChangeNotifierProvider(create: (context) => LoginController()),
  ChangeNotifierProvider(create: (context) => RegisterController()),
  ChangeNotifierProvider(create: (context) => CustomFileImage()),
  ChangeNotifierProvider(create: (context) => API()),
  ChangeNotifierProvider(create: (context) => PageControllers()),
];
