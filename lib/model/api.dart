import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bzushadengraduation/model/api_page.dart';
import 'package:bzushadengraduation/model/post.dart';
import 'package:bzushadengraduation/utilities/tools.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'chat_user.dart';

class API extends ChangeNotifier {
  FirebaseStorage storage = FirebaseStorage.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseMessaging fMessaging = FirebaseMessaging.instance;
  ChatUser? me;
  PageUser? pageMe;
  bool state = false;
  bool isHavePage = false;

  // static Future<bool> userExists() async {
  //   return (await firestore.collection('users').doc(user.uid).get()).exists;
  // }

  // static Future<void> getSelfInfo() async {
  //   await firestore.collection('users').doc(user.uid).get().then((user) async {
  //     if (user.exists) {
  //       me = ChatUser.fromJson(user.data()!);
  //       await getFirebaseMessagesToken();
  //     } else {
  //       await createUser().then((value) => getSelfInfo());
  // }
  // });
  // }

  // Future<void> uploadImageToStorage(File file) async {
  //   final ext = file.path.split('.').last;
  //   final ref = storage.ref().child(
  //       'images/${me!.email}.$ext');
  //   await ref.putFile(file, SettableMetadata(contentType: 'image/$ext'));
  //   final imageUrl = await ref.getDownloadURL();
  //   DocumentReference docRef = firestore.collection('users').doc(me!.email);
  //   docRef.update({
  //     "images": FieldValue.arrayUnion([imageUrl])
  //   });
  // }

  Future<void> getFirebaseMessagesToken() async {
    try {
      await fMessaging.requestPermission(

          // alert: true,
          // announcement: false,
          // badge: true,
          // carPlay: false,
          // criticalAlert: false,
          // provisional: false,
          // sound: true,
          );
      await fMessaging.getToken().then((t) {
        if (t != null) {
          me?.pushToken = t;

          firestore
              .collection('users')
              .doc(me?.email)
              .update({'push_token': t});
          printLog("push token : $t");
        }
      });

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        if (message.notification != null) {
          printLog(
              'Message also contained a notification: ${message.notification}');
        }
      });
      notifyListeners();
    } on Exception catch (e) {
      printLog("error: $e");
    }
  }

  Future<void> createUser(
      String name, String pass, String email, File? file) async {
    final time = DateTime.now().millisecondsSinceEpoch;
    try {
      final chatUser = ChatUser(
          id: email.toString(),
          name: name.toString(),
          email: email.toString(),
          about: "I am using BZU",
          image: email.toString(),
          createdAt: time.toString(),
          lastActive: time.toString(),
          isOnline: false,
          pushToken: "",
          password: pass.toString());
      me = chatUser;
      await firestore
          .collection('users')
          .doc(email.toString())
          .set(chatUser.toJson());
      await saveImage(file!);

      await getFirebaseMessagesToken();
      // createMyUsers();
      await createMyPosts();
      notifyListeners();
    } on Exception catch (e) {
      printLog("error: $e");
    }
  }

  Future<void> createPage(String names, File? file) async {
    final time = DateTime.now().millisecondsSinceEpoch;
    try {
      final page = PageUser(
          image: me!.email.toString(),
          name: names.toString().toLowerCase().trim().toString(),
          adminName: me!.name.toString(),
          about: "I am using page to BZU",
          createdAt: time.toString(),
          id: '${me?.email.toString()}_$time',
          lastActive: time.toString(),
          email: me!.email.toString(),
          pushToken: '');

      printLog(page);
      await firestore
          .collection('users/${me!.email.toString()}/pages')
          .doc(names.toLowerCase().trim().toString())
          .set(page.toJson());
      await saveImagePage(file!, time.toString(),
          names.toString().toLowerCase().trim().toString());

      // await getFirebaseMessagesToken();
      // createMyUsers();
      await createMyPostsToPage(names.toLowerCase().trim().toString());
      await check(me!.email.toString());
      notifyListeners();
    } on Exception catch (e) {
      printLog("error: $e");
    }
  }

//
//   static Future<void> createMyUsers() async {
//     await firestore
//         .collection('users')
//         .doc(user.uid)
//         .collection('my_users')
//         .doc()
//         .set({});
//   }
//
//   static Future<void> createPost(String text) async {
//     final time = DateTime.now().millisecondsSinceEpoch;
//     final post = Post(
//         text: text.toString(),
//         email: user.email.toString(),
//         name: user.displayName.toString(),
//         id: user.uid,
//         createAt: time.toString(),
//         images: [],
//         imageUrl: user.photoURL.toString());
//     await firestore
//         .collection('users')
//         .doc(user.uid)
//         .collection('posts')
//         .doc(time.toString())
//         .set(post.toJson());
//   }
//
  Future<void> setPageMe(PageUser? page) async {
    pageMe = page;
    notifyListeners();
  }

  Future<void> createMyPosts() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    try {
      await firestore
          .collection('users')
          .doc(me?.email)
          .collection('posts')
          .doc(time)
          .set({
        "Create_at": time.toString(),
        "images": [],
        "imageUrl": me?.image ?? "",
        "email": me?.email,
        "id": me?.id,
        "name": me?.name,
        "text": "Welcome to BZU🙂"
      });
      notifyListeners();
    } on Exception catch (e) {
      printLog("error: $e");
    }
  }

  Future<void> createMyPostsToPage(String name) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    try {
      await firestore
          .collection('users/${me!.email.toString()}/pages')
          .doc(name)
          .collection('posts')
          .doc(time)
          .set({
        "Create_at": time.toString(),
        "images": [],
        "imageUrl": pageMe?.image ?? "",
        "email": pageMe?.email,
        "id": pageMe?.id,
        "name": pageMe?.name,
        "text": "Welcome to BZU🙂"
      });
      notifyListeners();
    } on Exception catch (e) {
      printLog("error: $e");
    }
  }

  Future<void> sendNotification(ChatUser user) async {
    try {
      var response = await http.post(
        Uri.parse("https://fcm.googleapis.com/fcm/send"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':
              'key=AAAAICXcmTA:APA91bFGVzsbDPHCVi6gLQ2uqY_SCyYcXRIpRxTpr5yrBQtgME7FOxEzb7BQ2gZqAZwgzig6I6UtyD_ONHBbyFGqPLP_pCZch_DSbFl3AfsPW-Y6RT10H6zEVj5nBtzT-le8t-Z4kk0v',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': "${me?.email}",
              'title': "${me?.name}",
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done',
            },
            'to': user.pushToken,
          },
        ),
      );
      response;
      notifyListeners();
    } on Exception catch (e) {
      printLog("error: $e");
    }
  }

  Future<bool> addFriend(String emailFriend) async {
    try {
      final data = await firestore
          .collection('users')
          .where('email', isEqualTo: emailFriend)
          .get();
      if (data.docs.isNotEmpty && data.docs.first.id != me?.email) {
        await firestore
            .collection('users')
            .doc(me?.email)
            .collection('my_users')
            .doc(data.docs.first.id)
            .set({});
        return true;
      } else {
        return false;
      }
    } on Exception catch (e) {
      printLog("error: $e");
      return false;
    }
  }

  Future<bool> isAddedBefore(String email) async {
    try {
      final data = await firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get();
      printLog(data.docs.isEmpty);

      if (data.docs.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } on Exception catch (e) {
      printLog("error: $e");
      return false;
    }
  }

  Future<bool> checkAccount(String email, String pass) async {
    try {
      var data = await firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get();
      var data1 = await firestore
          .collection('users')
          .where('password', isEqualTo: pass)
          .get();

      printLog(data.docs.isEmpty);

      if (data.docs.isNotEmpty && data1.docs.isNotEmpty) {
        var info = await firestore.collection('users').doc(email).get();
        me = (ChatUser.fromJson(info.data() ?? {}));

        var dataPage = await firestore
            .collection('users/${me!.email.toString()}/pages')
            .get();
        printLog(dataPage.docs.isNotEmpty);
        if (dataPage.docs.isNotEmpty) {
          isHavePage = true;
          var info = await firestore
              .collection('users/${me!.email.toString()}/pages')
              .doc(me!.email.toString())
              .get();

          pageMe = (PageUser.fromJson(info.data() ?? {}));
          notifyListeners();
        } else {
          isHavePage = false;
          notifyListeners();
        }
        printLog(me?.name);
        return true;
      } else {
        return false;
      }
    } on Exception catch (e) {
      printLog("error: $e");
      return false;
    }
  }

  Future<bool> check(String email) async {
    try {
      var data = await firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      printLog(data.docs.isEmpty);

      if (data.docs.isNotEmpty) {
        var info = await firestore.collection('users').doc(email).get();
        me = (ChatUser.fromJson(info.data() ?? {}));

        var dataPage = await firestore
            .collection('users/${me!.email.toString()}/pages')
            .get();
        printLog(dataPage.docs.isNotEmpty);
        if (dataPage.docs.isNotEmpty) {
          isHavePage = true;
          var info = await firestore
              .collection('users/${me!.email.toString()}/pages')
              .doc(me!.email.toString())
              .get();

          pageMe = (PageUser.fromJson(info.data() ?? {}));
          notifyListeners();
        } else {
          isHavePage = false;
          notifyListeners();
        }
        printLog(me?.name);
        return true;
      } else {
        return false;
      }
    } on Exception catch (e) {
      printLog("error: $e");
      return false;
    }
  }

  Future<bool> checkPages(String name) async {
    try {
      printLog(name);

      var data = await firestore
          .collection('users/${me!.email.toString()}/pages')
          .where('name', isEqualTo: name.toLowerCase().trim().toString())
          .get();

      if (data.docs.isEmpty) {
        return true;
      } else {
        return false;
      }
    } on Exception catch (e) {
      printLog("error: $e");
      return false;
    }
  }

  String getConversationID(String id) => me!.email.hashCode <= id.hashCode
      ? '${me!.email}_$id'
      : '${id}_${me!.email}';

  Future<void> saveImage(File? file) async {
    try {
      final ext = file?.path.split('.').last;
      final ref = storage.ref().child('images/${me!.image}.$ext');
      await ref.putFile(file!, SettableMetadata(contentType: 'image/$ext'));
      final imageUrl = await ref.getDownloadURL();
      DocumentReference docRef = firestore.collection('users').doc(me!.image);
      docRef.update({"image": imageUrl});
      me?.image = imageUrl;
      notifyListeners();
    } on Exception catch (e) {
      printLog("error: $e");
    }
    // await API.sendMessage(chatUser, imageUrl, Type.image);
  }

  Future<void> saveImagePage(File? file, String time, String name) async {
    try {
      final ext = file?.path.split('.').last;
      final ref = storage.ref().child('imagesPages/${me!.email}.$ext');
      await ref.putFile(file!, SettableMetadata(contentType: 'image/$ext'));
      final imageUrl = await ref.getDownloadURL();
      DocumentReference docRef =
          firestore.collection('users/${me!.email.toString()}/pages').doc(name);
      docRef.update({"image": imageUrl});
      pageMe?.image = imageUrl;
      notifyListeners();
    } on Exception catch (e) {
      printLog("error: $e");
    }
    // await API.sendMessage(chatUser, imageUrl, Type.image);
  }

  Future<void> savedPost(String text) async {
    try {
      final time = DateTime.now().millisecondsSinceEpoch.toString();
      final Post post = Post(
          createAt: time.toString(),
          imageUrl: me!.image.toString(),
          images: [],
          id: me!.email.toString(),
          name: me!.name.toString(),
          email: me!.email.toString(),
          text: text.toString());
      final ref = firestore.collection('users/${me?.email}/posts/');

      await ref.doc(time).set(post.toJson());
      notifyListeners();
    } on Exception catch (e) {
      printLog("error: $e");
    }
  }

  Future<void> savedPostPage(String text) async {
    try {
      final time = DateTime.now().millisecondsSinceEpoch.toString();
      final Post post = Post(
          createAt: time.toString(),
          imageUrl: pageMe!.image.toString(),
          images: [],
          id: pageMe!.email.toString(),
          name: pageMe!.name.toString(),
          email: pageMe!.email.toString(),
          text: text.toString());
      final ref = firestore
          .collection('users/${me?.email}/pages/${pageMe?.name}/posts');

      await ref.doc(time).set(post.toJson());

      notifyListeners();
    } on Exception catch (e) {
      printLog("error: $e");
    }
  }

  Future<void> savedPostWithPicture(String text, List<XFile>? images) async {
    try {
      final time = DateTime.now().millisecondsSinceEpoch.toString();
      final Post post = Post(
          createAt: time.toString(),
          imageUrl: me!.image.toString(),
          images: [],
          id: me!.email.toString(),
          name: me!.name.toString(),
          email: me!.email.toString(),
          text: text.toString());
      final ref = firestore.collection('users/${me!.email}/posts/');
      await ref.doc(time).set(post.toJson());
      for (var i in images!) {
        await saveImagePost(File(i.path), time);
      }
      notifyListeners();
    } on Exception catch (e) {
      printLog("error: $e");
    }
  }

  Future<void> savedPostPageWithPicture(
      String text, List<XFile>? images) async {
    try {
      final time = DateTime.now().millisecondsSinceEpoch.toString();
      final Post post = Post(
          createAt: time.toString(),
          imageUrl: pageMe!.image.toString(),
          images: [],
          id: pageMe!.email.toString(),
          name: pageMe!.name.toString(),
          email: pageMe!.email.toString(),
          text: text.toString());
      final ref = firestore
          .collection('users/${me!.email}/pages/${pageMe?.name}/posts');
      await ref.doc(time).set(post.toJson());
      for (var i in images!) {
        await saveImagePostPage(File(i.path), time);
      }
      notifyListeners();
    } on Exception catch (e) {
      printLog("error: $e");
    }
  }

  Future<void> savedPostWithCamera(String text, XFile? images) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    try {
      final Post post = Post(
          createAt: time.toString(),
          imageUrl: me!.image.toString(),
          images: [],
          id: me!.email.toString(),
          name: me!.name.toString(),
          email: me!.email.toString(),
          text: text.toString());
      final ref = firestore.collection('users/${me!.email}/posts/');
      await ref.doc(time).set(post.toJson());

      await saveImagePost(File(images!.path), time);
      notifyListeners();
    } on Exception catch (e) {
      printLog("error: $e");
    }
  }

  Future<void> savedPostPageWithCamera(String text, XFile? images) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    try {
      final Post post = Post(
          createAt: time.toString(),
          imageUrl: pageMe!.image.toString(),
          images: [],
          id: pageMe!.email.toString(),
          name: pageMe!.name.toString(),
          email: pageMe!.email.toString(),
          text: text.toString());
      final ref =
          firestore.collection('users/${me!.email}/pages/${me!.email}/posts');
      await ref.doc(time).set(post.toJson());

      await saveImagePostPage(File(images!.path), time);
      notifyListeners();
    } on Exception catch (e) {
      printLog("error: $e");
    }
  }

  Future<void> saveImagePost(File file, String time) async {
    try {
      final ext = file.path.split('.').last;
      final ref = storage.ref().child(
          'imagesPosts/${getConversationID(me!.email)}/${DateTime.now().millisecondsSinceEpoch}.$ext');
      await ref.putFile(file, SettableMetadata(contentType: 'image/$ext'));
      final imageUrl = await ref.getDownloadURL();
      DocumentReference docRef = firestore
          .collection('users')
          .doc(me!.email)
          .collection('posts')
          .doc(time);
      docRef.update({
        "images": FieldValue.arrayUnion([imageUrl])
      });
      notifyListeners();
    } on Exception catch (e) {
      printLog("error: $e");
    }
    // await API.sendMessage(chatUser, imageUrl, Type.image);
  }

  Future<void> saveImagePostPage(File file, String time) async {
    try {
      final ext = file.path.split('.').last;
      final ref = storage.ref().child(
          'imagesPages/${getConversationID(me!.email)}/${DateTime.now().millisecondsSinceEpoch}.$ext');
      await ref.putFile(file, SettableMetadata(contentType: 'image/$ext'));
      final imageUrl = await ref.getDownloadURL();
      DocumentReference docRef = firestore
          .collection('users/${me?.email.toString()}/pages')
          .doc(pageMe?.name)
          .collection('posts')
          .doc(time);
      docRef.update({
        "images": FieldValue.arrayUnion([imageUrl])
      });
      notifyListeners();
    } on Exception catch (e) {
      printLog("error: $e");
    }
    // await API.sendMessage(chatUser, imageUrl, Type.image);
  }

  Future<CollectionReference<Object?>> getAllPostsFuture() async {
    CollectionReference userData =
        firestore.collection('users/${me!.email}/posts/');
    return userData;
  }

//
  Stream<QuerySnapshot<Map<String, dynamic>>> getAllMyPosts() {
    printLog(me?.email);
    return firestore
        .collection('users/${me?.email}/posts/')
        .orderBy('Create_at', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllMyPostsPage() {
    printLog(me?.email);
    return firestore
        .collection('users/${me?.email}/pages/${pageMe?.name}/posts')
        .orderBy('Create_at', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllPage() {
    printLog(me?.email);
    return firestore
        .collection('users/${me?.email}/pages')
        .orderBy('created_at', descending: true)
        .snapshots();
  }

//
//   static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMypostsanother() {
//     return firestore
//         .collection('users/rXFU2kT0jXYMyEkjrouhj7xXAgC2/posts/')
//         .orderBy('Create_at', descending: true)
//         .snapshots();
//   }
//
  Future<void> deletePost(Post post) async {
    await firestore
        .collection('users/${me?.email}/posts/')
        .doc(post.createAt)
        .delete();
    // print(post.images.length);
    if (post.images.isNotEmpty) {
      await storage.refFromURL(post.images[0]).delete();
    }
  }

  Future<void> deletePostPage(Post post) async {
    await firestore
        .collection('users/${me?.email}/pages/${pageMe?.name}/posts')
        .doc(post.createAt)
        .delete();
    // print(post.images.length);
    if (post.images.isNotEmpty) {
      await storage.refFromURL(post.images[0]).delete();
    }
  }

  Future<void> exitData() async {
    me = null;
    pageMe = null;
    state = false;
    isHavePage = false;

    notifyListeners();
  }

//
  Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return firestore
        .collection('users')
        .where('email', isNotEqualTo: me?.email.toString())
        .snapshots();
  }

//
  Future<List<Post>> getAllPostUsers() async {
    List<Post> list1 = [];
    List<ChatUser> listUser = [];

    var users = await firestore
        .collection('users')
        .where('email', isNotEqualTo: me?.email.toString())
        .get();

    for (int i = 0; i < users.size; i++) {
      var d = users.docs;
      listUser = d.map((e) => ChatUser.fromJson(e.data())).toList();
      var posts = await firestore
          .collection('users/${listUser[0].id}/posts/')
          .orderBy('Create_at', descending: true)
          .get();
      var list2 = posts.docs.map((e) => Post.fromJson(e.data())).toList();

      list1.addAll(list2);
    }
    // print(list1.length);
    return list1;
  }
}
