import 'package:get/get_navigation/src/routes/get_route.dart';

import '../screens/friends_list.dart';
import '../screens/friends_requests.dart';

import '../screens/notification.dart';
import '../screens/rooms.dart';
import '../screens/splashscreen.dart';
import '../screens/user_register.dart';
import '../screens/user_setting.dart';
import '../screens/user_view.dart';

get_initial_route() {
  return '/splash';
}

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
  ];
}
