const functions = require("firebase-functions");
const admin = require("firebase-admin");
const { Message } = require("firebase-functions/lib/providers/pubsub");
admin.initializeApp();

//ddwdw
exports.onCreatMessage = functions.database.ref('/switchChatMessages-786/{chatRoomId}/{messageId}')
    .onCreate( async (snapshot, context) => {
const CreatedActivityFeedItem = snapshot.val()
const message = CreatedActivityFeedItem.content
const userId  = CreatedActivityFeedItem.receiverId

const androidNotificationToken =  CreatedActivityFeedItem.token;

console.log('Token', androidNotificationToken);
console.log('Message', message);
console.log('user Id', userId);


if(androidNotificationToken){

  sendNotification(androidNotificationToken, CreatedActivityFeedItem);

  }else{

  console.log("no Tokken For User, can not send notification");

  }

function sendNotification(androidNotificationToken,activityFeedItem ){

  let body;

if(activityFeedItem.type === "image"){

body = `${activityFeedItem.senderName}: ${"Image 🖼️"}`;

}else if(activityFeedItem.type === "audio"){
body = `${activityFeedItem.senderName}: ${"Audio Note 🔊"}`;



}else{

body = `${activityFeedItem.senderName}: ${activityFeedItem.content}`;


}


  const message =  {
     notification : {

       title: "New Message",

     //  Click_action: 'FLUTTER_NOTIFICATION_CLICK',

        body,

           },


token: androidNotificationToken,

data:  {recipient: userId,
screen: "chatList",}

  };


  admin
  .messaging()
  .send(message)
  .then(response => {
    // Response is a message ID string
 return   console.log("Successfully sent message", response);
  })
  .catch(error => {
    console.log("Error sending message", error);
  });


}
    });

