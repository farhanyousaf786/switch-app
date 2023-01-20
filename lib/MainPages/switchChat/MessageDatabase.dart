//
// import 'package:switchtofuture/Models/Constans.dart';
//
// class MessageDataBase {
//   Map<String, dynamic> toMap(
//       String receiverName,
//       String receiverId,
//       String receiverAvatar,
//       String receiverEmail,
//       String content,
//       String groupChatId,
//       String imageUrl,
//       String type,
//       String messageId,
//       ) {
//     if (imageUrl == "") {
//       List<String> users = [Constants.myEmail, receiverEmail];
//
//       return {
//         'text': content,
//         'senderName': Constants.myName,
//         'senderAvatar': Constants.myPhotoUrl,
//         'senderId': Constants.myId,
//         'idFrom': Constants.myId,
//         'groupChatId': groupChatId,
//         'users': users,
//         'timeStamp': DateTime.now().millisecondsSinceEpoch.toString(),
//         'receiverId': receiverId,
//         'receiverName': receiverName,
//         'receiverAvatar': receiverAvatar,
//         'receiverEmail': receiverEmail,
//         'senderEmail': Constants.myEmail,
//         'token': Constants.token,
//         'type': type,
//         'messageId': messageId,
//
//
//       };
//     } else {
//       return {
//         'imageUrl': imageUrl,
//         'senderName': Constants.myName,
//         'senderAvatar': Constants.myPhotoUrl,
//         'senderId': Constants.myId,
//         'idFrom': Constants.myId,
//         'groupChatId': groupChatId,
//         'timeStamp': DateTime.now().millisecondsSinceEpoch.toString(),
//         'receiverId': receiverId,
//         'receiverName': receiverName,
//         'receiverAvatar': receiverAvatar,
//         'receiverEmail': receiverEmail,
//         'senderEmail': Constants.myEmail,
//         'token': Constants.token,
//         'type': type,
//         'messageId': messageId,
//
//
//
//       };
//     }
//   }
//
//   /// Map For Chat List
//
//   Map<String, dynamic> toMapForChatList(
//       String receiverName,
//       String receiverId,
//       String receiverAvatar,
//       String receiverEmail,
//       String content,
//       String groupChatId,
//       String imageUrl,
//       String type,
//
//       ) {
//     String tileName = getTileName(Constants.myName, receiverName);
//     if (imageUrl == "") {
//       List<String> users = [Constants.myEmail, receiverEmail];
//
//       return {
//         'content': content,
//         'senderName': Constants.myName,
//         'senderAvatar': Constants.myPhotoUrl,
//         'senderId': Constants.myId,
//         'groupChatId': groupChatId,
//         'users': users,
//         'type': type,
//
//         'tileName': tileName,
//         'timestamp': DateTime.now().millisecondsSinceEpoch,
//         'receiverId': receiverId,
//         'receiverName': receiverName,
//         'receiverAvatar': receiverAvatar,
//         'receiverEmail': receiverEmail,
//         'senderEmail': Constants.myEmail,
//         'isRead': false,
//         'token': Constants.token,
//
//       };
//     } else {
//       List<String> users = [Constants.myEmail, receiverEmail];
//       String tileName = getTileName(Constants.myName, receiverName);
//
//       return {
//         'content': imageUrl,
//         'senderName': Constants.myName,
//         'senderAvatar': Constants.myPhotoUrl,
//         'senderId': Constants.myId,
//         'groupChatId': groupChatId,
//         'users': users,
//         'type': type,
//
//         'tileName': tileName,
//         'timestamp': DateTime.now().millisecondsSinceEpoch,
//         'receiverId': receiverId,
//         'receiverName': receiverName,
//         'receiverAvatar': receiverAvatar,
//         'receiverEmail': receiverEmail,
//         'senderEmail': Constants.myEmail,
//         'isRead': false,
//         'token': Constants.token,
//
//
//       };
//     }
//   }
//
//   Map<String, dynamic> toMapForReceiverForChatList(
//       String receiverName,
//       String receiverId,
//       String receiverAvatar,
//       String receiverEmail,
//       String content,
//       String groupChatId,
//       String imageUrl,
//       String type
//
//       ) {
//     String tileName = getTileName(Constants.myName, receiverName);
//     if (imageUrl == "") {
//       List<String> users = [Constants.myEmail, receiverEmail];
//
//       return {
//         'content': content,
//         'senderName': Constants.myName,
//         'senderAvatar': Constants.myPhotoUrl,
//         'senderId': Constants.myId,
//         'type': type,
//
//         'groupChatId': groupChatId,
//         'users': users,
//         'tileName': tileName,
//         'timestamp': DateTime.now().millisecondsSinceEpoch,
//         'receiverId': Constants.myId,
//         'receiverName': Constants.myName,
//         'receiverAvatar': Constants.myPhotoUrl,
//         'receiverEmail': Constants.myEmail,
//         'senderEmail': Constants.myEmail,
//         'token': Constants.token,
//
//       };
//     } else {
//       List<String> users = [Constants.myEmail, receiverEmail];
//       String tileName = getTileName(Constants.myName, receiverName);
//
//       return {
//         'content': imageUrl,
//         'type': type,
//
//         'senderName': Constants.myName,
//         'senderAvatar': Constants.myPhotoUrl,
//         'senderId': Constants.myId,
//         'groupChatId': groupChatId,
//         'users': users,
//         'tileName': tileName,
//         'timestamp': DateTime.now().millisecondsSinceEpoch,
//         'receiverId': Constants.myId,
//         'receiverName': Constants.myName,
//         'receiverAvatar': Constants.myPhotoUrl,
//         'receiverEmail': Constants.myEmail,
//         'senderEmail': Constants.myEmail,
//         'token': Constants.token,
//
//
//       };
//     }
//   }
//
//   /// Compare Data Base
//
//   Map<String, dynamic> toMapForCompareChatList(
//       String receiverName,
//       String receiverId,
//       String receiverAvatar,
//       String receiverEmail,
//       String content,
//       String groupChatId,
//       String type,
//
//       String imageUrl,
//       ) {
//     String tileName = getTileName(Constants.myName, receiverName);
//     if (imageUrl == "") {
//       List<String> users = [Constants.myEmail, receiverEmail];
//
//       return {
//         'content': content,
//         'timestamp': DateTime.now().millisecondsSinceEpoch,
//         'receiverId': receiverId,
//         'receiverName': receiverName,
//         'receiverAvatar': receiverAvatar,
//         'receiverEmail': receiverEmail,
//         'token': Constants.token,
//         'type': type,
//
//
//       };
//     } else {
//       return {
//         'content': imageUrl,
//         'timestamp': DateTime.now().millisecondsSinceEpoch,
//         'receiverId': receiverId,
//         'receiverName': receiverName,
//         'receiverAvatar': receiverAvatar,
//         'receiverEmail': receiverEmail,
//         'token': Constants.token,
//         'type': type,
//
//
//       };
//     }
//   }
//
//   Map<String, dynamic> toMapForCompareChatListForReceiver(
//       String receiverName,
//       String receiverId,
//       String receiverAvatar,
//       String receiverEmail,
//       String content,
//       String groupChatId,
//       String imageUrl,
//       String type
//
//
//       ) {
//     String tileName = getTileName(Constants.myName, receiverName);
//     if (imageUrl == "") {
//       List<String> users = [Constants.myEmail, receiverEmail];
//
//       return {
//         'content': content,
//         'timestamp': DateTime.now().millisecondsSinceEpoch,
//         'receiverId': Constants.myId,
//         'receiverName': Constants.myName,
//         'receiverAvatar': Constants.myPhotoUrl,
//         'receiverEmail': Constants.myEmail,
//         'token': Constants.token,
//         'lastMessage': content,
//
//       };
//     } else {
//       return {
//         'content': imageUrl,
//         'timestamp': DateTime.now().millisecondsSinceEpoch,
//         'receiverId': Constants.myId,
//         'receiverName': Constants.myName,
//         'receiverAvatar': Constants.myPhotoUrl,
//         'receiverEmail': Constants.myEmail,
//         'token': Constants.token,
//         'lastMessage': "",
//
//       };
//     }
//   }
//
//
//
//
// }
//
// getTileName(String a, String b) {
//   if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
//     return "$b\_$a";
//   } else {
//     return "$a\_$b";
//   }
// }

import 'package:switchapp/Universal/Constans.dart';

class MessageDataBase {


  Map<String, dynamic> toMap(String receiverName,
      String receiverId,
      String receiverAvatar,
      String receiverEmail,
      String content,
      String groupChatId,
      String type,
      String messageId,
      String isReplyMessage,
      ) {
    List<String> users = [Constants.myEmail, receiverEmail];

    return {
      'content': content,
      'senderName': Constants.myName,
      'senderAvatar': Constants.myPhotoUrl,
      'senderId': Constants.myId,
      'idFrom': Constants.myId,
      'groupChatId': groupChatId,
      'users': users,
      'timeStamp': DateTime
          .now()
          .millisecondsSinceEpoch
          .toString(),
      'receiverId': receiverId,
      'receiverName': receiverName,
      'receiverAvatar': receiverAvatar,
      'receiverEmail': receiverEmail,
      'senderEmail': Constants.myEmail,
      'token': Constants.token,
      'type': type,
      'messageId': messageId,
      "read": false,
      'isReplyMessage': isReplyMessage,
    };
  }

  /// Map For Chat List

  Map<String, dynamic> toMapForChatList(String receiverName,
      String receiverId,
      String receiverAvatar,
      String receiverEmail,
      String content,
      String groupChatId,
      String type,
      bool isRead,) {
    String tileName = getTileName(Constants.myName, receiverName);

    List<String> users = [Constants.myEmail, receiverEmail];

    return {
      'content': content,
      'senderName': Constants.myName,
      'senderAvatar': Constants.myPhotoUrl,
      'senderId': Constants.myId,
      'groupChatId': groupChatId,
      'users': users,
      'type': type,
      'tileName': tileName,
      'timestamp': DateTime
          .now()
          .millisecondsSinceEpoch,
      'receiverId': receiverId,
      'receiverName': receiverName,
      'receiverAvatar': receiverAvatar,
      'receiverEmail': receiverEmail,
      'senderEmail': Constants.myEmail,
      'isRead': isRead,
      'token': Constants.token,
    };
  }
}

getTileName(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}
