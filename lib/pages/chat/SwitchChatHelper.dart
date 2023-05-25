// import 'package:shared_preferences/shared_preferences.dart';
//
// class ChatHelper {
//   late String groupChatId;
//   late SharedPreferences prefs;
//   late String id;
//   String lastVisit = "";
//   late String groupChatIdd;
//
//   Future<String> readLocal(String receiverId) async {
//
//     prefs = await SharedPreferences.getInstance();
//     id = prefs.getString('ownerId') ?? '';
//
//     print("owneri = = > $receiverId");
//
//     if (id.hashCode <= receiverId.hashCode) {
//       groupChatId = '$id-$receiverId';
//       prefs.setString("groupChatId", groupChatId);
//
//     } else {
//       groupChatId = '$receiverId-$id';
//       prefs.setString("groupChatId", groupChatId);
//
//     }
//
//     return groupChatIdd;
//
//   }
// }
