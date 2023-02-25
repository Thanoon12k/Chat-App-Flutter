import 'package:chatapp/bindings/register.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

import '../main.dart';
import '../screens/friends_list.dart';
import '../screens/friends_requests.dart';
import '../screens/get1.dart';
import '../screens/get2.dart';
import '../screens/notification.dart';
import '../screens/rooms.dart';
import '../screens/user_register.dart';
import '../screens/user_setting.dart';
import '../screens/user_view.dart';

app_routes() {
  return [
    GetPage(name: '/splash', page: () => SplashScreen()),
    GetPage(name: '/userregister', page: () => UserRegister()),
    GetPage(name: '/usersetting', page: () => UserSetting()),
    GetPage(name: '/userview', page: () => UserView()),
    GetPage(name: '/rooms', page: () => RoomsList()),
    GetPage(name: '/notification', page: () => NotifyList()),
    GetPage(name: '/frindlist', page: () => FriendsList()),
    GetPage(name: '/friendrequests', page: () => FriendsRequests()),
    GetPage(name: '/get1', page: () => GETX1()),
    GetPage(name: '/get2', page: () => GETX2()),
  ];
}