import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class Message extends StatefulWidget {
  const Message({Key? key});

  @override
  State<Message> createState() => _MessageState();
}

class _MessageState extends State<Message> {
  final user = FirebaseAuth.instance.currentUser!;

  Future<QuerySnapshot> fetchMessages() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Messages')
        .where('receiver', isEqualTo: user.uid)
        .get();

    return querySnapshot;
  }

  Future<String> fetchUserNamePAR(String senderId) async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(senderId)
        .get();
    if (snapshot.exists) {
      Map<String, dynamic> userData =
          snapshot.data() as Map<String, dynamic>;
      String userName = userData['firstname'];

      return userName;
    } else {
      return 'Unknown User';
    }
  }

  Future<String> fetchLastMessage(String conversationId) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Messages')
        .doc(conversationId)
        .collection('conversation')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      String lastMessage = snapshot.docs[0]['text'];
      return lastMessage;
    } else {
      return 'No messages';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<QuerySnapshot>(
        future: fetchMessages(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot conversationSnapshot =
                    snapshot.data!.docs[index];
                Map<String, dynamic> conversationData =
                    conversationSnapshot.data() as Map<String, dynamic>;
                String conversationId = conversationSnapshot.id;
                String personName = conversationData['sender'];

                return FutureBuilder<String>(
                  future: fetchUserNamePAR(personName),
                  builder: (context, senderSnapshot) {
                    if (senderSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return ListTile(
                        leading: const CircleAvatar(
                          backgroundImage: NetworkImage(
                              'https://www.shutterstock.com/image-vector/default-avatar-profile-flat-icon-260nw-1742219921.jpg'),
                        ),
                        title: Text('Loading...'),
                      );
                    } else if (senderSnapshot.hasData) {
                      String senderName = senderSnapshot.data!;
                      return FutureBuilder<String>(
                        future: fetchLastMessage(conversationId),
                        builder: (context, messageSnapshot) {
                          if (messageSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return ListTile(
                              leading: const CircleAvatar(
                                backgroundImage: NetworkImage(
                                    'https://www.shutterstock.com/image-vector/default-avatar-profile-flat-icon-260nw-1742219921.jpg'),
                              ),
                              title: Text('Loading...'),
                            );
                          } else if (messageSnapshot.hasData) {
                            String lastMessage = messageSnapshot.data!;
                            return Column(
                              children: [
                                ListTile(
                                  leading: const CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        'https://www.shutterstock.com/image-vector/default-avatar-profile-flat-icon-260nw-1742219921.jpg'),
                                  ),
                                  title: Text(senderName),
                                  subtitle: Text(lastMessage),
                                  
                                  onTap: () {
                                    // Navigate to the chat screen for the selected person
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ChatScreenPartenaire(
                                          sender: personName,
                                        ),
                                      ),
                                    );
                                  },
                                  
                                ),
                               
                              ],
                            );
                          } else {
                            return ListTile(
                              leading: const CircleAvatar(
                                backgroundImage: NetworkImage(
                                    'https://www.shutterstock.com/image-vector/default-avatar-profile-flat-icon-260nw-1742219921.jpg'),
                              ),
                              title: Text(senderName),
                              subtitle: Text('No messages'),
                            );
                          }
                        },
                      );
                    } else {
                      return ListTile(
                        leading: const CircleAvatar(
                          backgroundImage: NetworkImage(
                              'https://www.shutterstock.com/image-vector/default-avatar-profile-flat-icon-260nw-1742219921.jpg'),
                        ),
                        title: Text('Unknown User'),
                      );
                    }
                  },
                );
              },
            );
          } else {
            return Center(
              child: Text('No conversations found.'),
            );
          }
        },
      ),
    );
  }
}


class ChatScreen extends StatefulWidget {
  final String receiver;

  const ChatScreen({required this.receiver, Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final TextEditingController message;
/*
 
  final user = FirebaseAuth.instance.currentUser!;
Future<void> messagedetails(String msg, String userId, String receiver) async {
  CollectionReference messagesCollection =
      FirebaseFirestore.instance.collection('Messages');

  // Check if a conversation document already exists
  QuerySnapshot conversationSnapshot = await messagesCollection
      .where('sender', isEqualTo: userId)
      .where('receiver', isEqualTo: receiver)
      .limit(1)
      .get();

  if (conversationSnapshot.docs.isNotEmpty) {
    // Add the message to the existing conversation
    DocumentReference conversationDocRef =
        conversationSnapshot.docs[0].reference;

    CollectionReference conversationCollection =
        conversationDocRef.collection('conversation');

    await conversationCollection.add({
      'text': msg,
      'sender': userId,
      'receiver': receiver,
      'timestamp': FieldValue.serverTimestamp(),
    });
  } else {
    // Create a new conversation document and add the message
    DocumentReference newConversationDocRef =
        await messagesCollection.add({
      'sender': userId,
      'receiver': receiver,
      'timestamp': FieldValue.serverTimestamp(),
    });

    CollectionReference conversationCollection =
        newConversationDocRef.collection('conversation');

    await conversationCollection.add({
      'text': msg,
      'sender': userId,
      'receiver': receiver,
      'timestamp': FieldValue.serverTimestamp(),
    });
  
  }
 DocumentSnapshot conversationDocSnapshot = await newConversationDocRef.get();
   senderuid = conversationDocSnapshot['sender'];
}

Future<QuerySnapshot> fetchMessages() async {
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('Messages')
      .where('sender', isEqualTo: user.uid)
      .where('receiver', isEqualTo: widget.receiver)
      .limit(1)
      .get();

  if (querySnapshot.docs.isNotEmpty) {
    // Retrieve the first document
    DocumentSnapshot documentSnapshot = querySnapshot.docs[0];

    // Fetch the messages from the conversation document
    QuerySnapshot conversationSnapshot = await documentSnapshot.reference
        .collection('conversation')
        .orderBy('timestamp', descending: false)
        .get();

    return conversationSnapshot;
  } else {
    // Handle the case when no conversation document is found
    return querySnapshot ;
  }}



  Future<String> fetchUserName(String senderId) async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid) // Use senderId instead of userId
        .get();
    if (snapshot.exists) {
      Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;
      String userName = userData['firstname'];
      return userName;
    } else {
      return 'n';
    }
  }
*/
late String senderuid ="";
  final user = FirebaseAuth.instance.currentUser!;
Future<String> messagedetails(String msg, String userId, String sender) async {
  CollectionReference messagesCollection =
      FirebaseFirestore.instance.collection('Messages');

  // Check if a conversation document already exists
  QuerySnapshot conversationSnapshot = await messagesCollection
      .where('sender', isEqualTo: user.uid)
      .where('receiver', isEqualTo: widget.receiver)
      .limit(1)
      .get();

  if (conversationSnapshot.docs.isNotEmpty) {
    // Add the message to the existing conversation
    DocumentReference conversationDocRef =
        conversationSnapshot.docs[0].reference;

    CollectionReference conversationCollection =
        conversationDocRef.collection('conversation');

    await conversationCollection.add({
      'text': msg,
      'sender': user.uid,
      'receiver': widget.receiver,
      'timestamp': FieldValue.serverTimestamp(),
    });
     DocumentSnapshot conversationDocSnapshot = await conversationDocRef.get();
   senderuid = conversationDocSnapshot['sender'];
  } else {
    // Create a new conversation document and add the message
    DocumentReference newConversationDocRef =
        await messagesCollection.add({
      'sender': user.uid,
      'receiver':widget.receiver,
      'timestamp': FieldValue.serverTimestamp(),
    });

    CollectionReference conversationCollection =
        newConversationDocRef.collection('conversation');

    await conversationCollection.add({
      'text': msg,
      'sender': user.uid,
      'receiver':widget.receiver,
      'timestamp': FieldValue.serverTimestamp(),
    });
   DocumentSnapshot conversationDocSnapshot = await newConversationDocRef.get();
   senderuid = conversationDocSnapshot['sender'];

  
  }
  return senderuid;
 
}

Future<QuerySnapshot> fetchMessages() async {
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('Messages')
      .where('sender', isEqualTo: user.uid)
      .where('receiver', isEqualTo: widget.receiver)
      .limit(1)
      .get();

  if (querySnapshot.docs.isNotEmpty) {
    // Retrieve the first document
    DocumentSnapshot documentSnapshot = querySnapshot.docs[0];

    // Fetch the messages from the conversation document
    QuerySnapshot conversationSnapshot = await documentSnapshot.reference
        .collection('conversation')
        .orderBy('timestamp', descending: false)
        .get();

    return conversationSnapshot;
  } else {
    // Handle the case when no conversation document is found
    return querySnapshot ;
  }}



  Future<String> fetchUserName(String senderuid) async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(senderuid) // Use senderId instead of userId
        .get();
    if (snapshot.exists) {
      Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;
      String userName = userData['firstname'];
      return userName;
    } else {
      return 'n';
    }
  }
 String? appBarName;
  Future<void> fetchAppBarName(String senderUid) async {
  DocumentSnapshot snapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(widget.receiver) // Use senderId instead of userId
      .get();
      print(widget.receiver);
  if (snapshot.exists) {
    Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;
    String userName = userData['firstname'];
    setState(() {
      appBarName = userName;
    });
  } else {
    setState(() {
      appBarName = 'n';
    });
  }
}

 
  @override
  void initState() {
    super.initState();
    message = TextEditingController();
    fetchAppBarName(widget.receiver);
  }

  @override
  void dispose() {
    message.dispose();
    super.dispose();
  }
@override
Widget build(BuildContext context) {
  return Scaffold(
    body: SafeArea(
      child: Column(
        children: [
          Container(
            height: 50,
            color: const Color.fromARGB(255, 210, 233, 255),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Color.fromARGB(255, 12, 39, 87),
                  ),
                ),
                const CircleAvatar(
                  backgroundImage: NetworkImage(
                      'https://www.shutterstock.com/image-vector/default-avatar-profile-flat-icon-260nw-1742219921.jpg'),
                  radius: 18,
                ),
                const SizedBox(width: 10),
                Expanded(flex: 2, child: Text(appBarName != null ? appBarName! : '')),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.phone, color: Color.fromARGB(255, 12, 39, 87)),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<QuerySnapshot>(
              future: fetchMessages(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot messageSnapshot = snapshot.data!.docs[index];
                      Map<String, dynamic>? messageData = messageSnapshot.data() as Map<String, dynamic>?;

                      String messageText = messageData!['text'];
                      String senderId = messageData['sender'];

                      return FutureBuilder<String>(
                        future: fetchUserName(senderId),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const SizedBox(); // Return an empty widget while fetching the sender's name
                          } else if (snapshot.hasData) {
                            String senderName = snapshot.data!;
                            return Container(
                              margin: EdgeInsets.symmetric(vertical: 5),
                              child: Column(
                                crossAxisAlignment: senderId == user.uid ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                children: [
                                  if (senderId != user.uid)
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        CircleAvatar(
                                          backgroundImage: NetworkImage(
                                            'https://www.shutterstock.com/image-vector/default-avatar-profile-flat-icon-260nw-1742219921.jpg',
                                          ),
                                          radius: 18,
                                        ),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                senderName,
                                                style: TextStyle(color: Color.fromARGB(255, 12, 39, 87)),
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(17),
                                                  border: Border.all(
                                                    color: Color.fromARGB(96, 122, 122, 122),
                                                    width: 2,
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Text(messageText),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  if (senderId == user.uid)
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                senderName,
                                                style: TextStyle(color: Color.fromARGB(255, 12, 39, 87)),
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  Expanded(
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(17),
                                                        border: Border.all(
                                                          color: Color.fromARGB(96, 122, 122, 122),
                                                          width: 2,
                                                        ),
                                                      ),
                                                      child: Padding(
                                                        padding: EdgeInsets.all(8.0),
                                                        child: Text(messageText),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 7),
                                                  CircleAvatar(
                                                    backgroundImage: NetworkImage(
                                                      'https://www.shutterstock.com/image-vector/default-avatar-profile-flat-icon-260nw-1742219921.jpg',
                                                    ),
                                                    radius: 18,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            );
                          } else {
                            return const SizedBox(); // Handle the case when the sender's name cannot be fetched
                          }
                        },
                      );
                    },
                  );
                } else {
                  return const Center(
                    child: Text('No messages found.'),
                  );
                }
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: message,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                    ),
                    // TODO: Handle text input and sending messages
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    final msg = message.text.trim();
                    messagedetails(msg, user.uid, widget.receiver);
                    message.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
}///////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////
///
 class ChatScreenPartenaire extends StatefulWidget {
  final String sender;
  const ChatScreenPartenaire({required this.sender,super.key});

  @override
  State<ChatScreenPartenaire> createState() => _ChatScreenPartenaireState();
}

class _ChatScreenPartenaireState extends State<ChatScreenPartenaire> {
  late final TextEditingController message;
late String senderuid ="";
  final user = FirebaseAuth.instance.currentUser!;
Future<String> messagedetails(String msg, String userId, String sender) async {
  CollectionReference messagesCollection =
      FirebaseFirestore.instance.collection('Messages');

  // Check if a conversation document already exists
  QuerySnapshot conversationSnapshot = await messagesCollection
      .where('sender', isEqualTo: widget.sender)
      .where('receiver', isEqualTo: user.uid)
      .limit(1)
      .get();

  if (conversationSnapshot.docs.isNotEmpty) {
    // Add the message to the existing conversation
    DocumentReference conversationDocRef =
        conversationSnapshot.docs[0].reference;

    CollectionReference conversationCollection =
        conversationDocRef.collection('conversation');

    await conversationCollection.add({
      'text': msg,
      'sender': user.uid,
      'receiver': widget.sender,
      'timestamp': FieldValue.serverTimestamp(),
    });
     DocumentSnapshot conversationDocSnapshot = await conversationDocRef.get();
   senderuid = conversationDocSnapshot['sender'];
  } else {
    // Create a new conversation document and add the message
    DocumentReference newConversationDocRef =
        await messagesCollection.add({
      'sender': user.uid,
      'receiver':widget.sender,
      'timestamp': FieldValue.serverTimestamp(),
    });

    CollectionReference conversationCollection =
        newConversationDocRef.collection('conversation');

    await conversationCollection.add({
      'text': msg,
      'sender': user.uid,
      'receiver':widget.sender,
      'timestamp': FieldValue.serverTimestamp(),
    });
   DocumentSnapshot conversationDocSnapshot = await newConversationDocRef.get();
   senderuid = conversationDocSnapshot['sender'];

  
  }
  return senderuid;
 
}

Future<QuerySnapshot> fetchMessages() async {
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('Messages')
      .where('sender', isEqualTo: widget.sender)
      .where('receiver', isEqualTo: user.uid)
      .limit(1)
      .get();

  if (querySnapshot.docs.isNotEmpty) {
    // Retrieve the first document
    DocumentSnapshot documentSnapshot = querySnapshot.docs[0];

    // Fetch the messages from the conversation document
    QuerySnapshot conversationSnapshot = await documentSnapshot.reference
        .collection('conversation')
        .orderBy('timestamp', descending: false)
        .get();

    return conversationSnapshot;
  } else {
    // Handle the case when no conversation document is found
    return querySnapshot ;
  }}



  Future<String> fetchUserName(String senderuid) async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(senderuid) // Use senderId instead of userId
        .get();
    if (snapshot.exists) {
      Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;
      String userName = userData['firstname'];
      return userName;
    } else {
      return 'n';
    }
  }

String? appBarName;
  Future<String> fetchUserNamePAR(String senderuid) async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.sender) // Use senderId instead of userId
        .get();
    if (snapshot.exists) {
      Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;
      String userName = userData['firstname'];
       setState(() {
      appBarName = userName;
    });
      return userName;
    } else {
       setState(() {
      appBarName = 'e';
    });
      return 'n';
    }
  }

  @override
  void initState() {
    super.initState();
    message = TextEditingController();
    fetchUserNamePAR(senderuid);
  }

  @override
  void dispose() {
    message.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 50,
              color: const Color.fromARGB(255, 210, 233, 255),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Color.fromARGB(255, 19, 47, 70),
                    ),
                  ),
                  const CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://www.shutterstock.com/image-vector/default-avatar-profile-flat-icon-260nw-1742219921.jpg'),
                    radius: 18,
                  ),
                  const SizedBox(width: 10),
                Expanded(flex: 2, child: Text(appBarName != null ? appBarName! : '')),
                 IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.phone, color: Color.fromARGB(255, 12, 39, 87)),
                ),
                ],
              ),
            ),
             Expanded(
            child: FutureBuilder<QuerySnapshot>(
              future: fetchMessages(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot messageSnapshot = snapshot.data!.docs[index];
                      Map<String, dynamic>? messageData = messageSnapshot.data() as Map<String, dynamic>?;

                      String messageText = messageData!['text'];
                      String senderId = messageData['sender'];

                      return FutureBuilder<String>(
                        future: fetchUserName(senderId),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const SizedBox(); // Return an empty widget while fetching the sender's name
                          } else if (snapshot.hasData) {
                            String senderName = snapshot.data!;
                            return Container(
                              margin: EdgeInsets.symmetric(vertical: 5),
                              child: Column(
                                crossAxisAlignment: senderId == user.uid ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                children: [
                                  if (senderId != user.uid)
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        CircleAvatar(
                                          backgroundImage: NetworkImage(
                                            'https://www.shutterstock.com/image-vector/default-avatar-profile-flat-icon-260nw-1742219921.jpg',
                                          ),
                                          radius: 18,
                                        ),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                senderName,
                                                style: TextStyle(color: Color.fromARGB(255, 12, 39, 87)),
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(17),
                                                  border: Border.all(
                                                    color: Color.fromARGB(96, 122, 122, 122),
                                                    width: 2,
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Text(messageText),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  if (senderId == user.uid)
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                senderName,
                                                style: TextStyle(color: Color.fromARGB(255, 12, 39, 87)),
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  Expanded(
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(17),
                                                        border: Border.all(
                                                          color: Color.fromARGB(96, 122, 122, 122),
                                                          width: 2,
                                                        ),
                                                      ),
                                                      child: Padding(
                                                        padding: EdgeInsets.all(8.0),
                                                        child: Text(messageText),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 7),
                                                  CircleAvatar(
                                                    backgroundImage: NetworkImage(
                                                      'https://www.shutterstock.com/image-vector/default-avatar-profile-flat-icon-260nw-1742219921.jpg',
                                                    ),
                                                    radius: 18,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            );
                          } else {
                            return const SizedBox(); // Handle the case when the sender's name cannot be fetched
                          }
                        },
                      );
                    },
                  );
                } else {
                  return const Center(
                    child: Text('No messages found.'),
                  );
                }
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: message,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                    ),
                    // TODO: Handle text input and sending messages
                  ),
                ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      final msg = message.text.trim();
                      messagedetails(msg, user.uid, widget.sender);
                      message.clear();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}