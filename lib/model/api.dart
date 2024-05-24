import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bzushadengraduation/model/api_page.dart';
import 'package:bzushadengraduation/model/post.dart';
import 'package:bzushadengraduation/utilities/tools.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:rxdart/rxdart.dart';
import 'chat_user.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/services.dart' show rootBundle;

class API extends ChangeNotifier {
  FirebaseStorage storage = FirebaseStorage.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseMessaging fMessaging = FirebaseMessaging.instance;
  ChatUser? me;
  PageUser? pageMe;
  bool state = false;
  bool isHavePage = false;

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
          password: pass.toString(),
          subImage: email.toString());
      me = chatUser;
      await firestore
          .collection('users')
          .doc(email.toString())
          .set(chatUser.toJson());
      await saveImage(file!);
      await saveSubImage();
      await getFirebaseMessagesToken();
      await createMyPosts();
      await createPageFriends();

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
          id: '${names.toLowerCase().trim().toString()}_${me?.email.substring(0, me!.email.indexOf('@'))}'
              .toString()
              .toLowerCase()
              .trim(),
          lastActive: time.toString(),
          email: me!.email.toString(),
          pushToken: '');

      printLog(page);
      await firestore
          .collection('users/${me!.email.toString()}/pages')
          .doc(names.toLowerCase().trim().toString())
          .set(page.toJson());
      pageMe = page;
      await setPageMe(page);
      await firestore
          .collection('pages')
          .doc(
              '${names.toLowerCase().trim().toString()}_${me?.email.substring(0, me!.email.indexOf('@'))}'
                  .toLowerCase()
                  .trim()
                  .toString())
          .set(page.toJson());
      await saveImagePage(file!, time.toString(),
          names.toString().toLowerCase().trim().toString());
      //
      // await getFirebaseMessagesToken();
      await createMyPostsToPage(names.toLowerCase().trim().toString());
      await check(me!.email.toString());

      notifyListeners();
    } on Exception catch (e) {
      printLog("error: $e");
    }
  }

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
          .doc('${time}_${me?.email.substring(0, me!.email.indexOf('@'))}')
          .set({
        "created_at": time.toString(),
        "admin_name": me?.name.toString() ?? "",
        "images": [],
        "imageUrl": me?.image ?? "",
        "email": me?.email,
        "id": me?.id,
        "name": me?.name,
        "type": PostType.user.name,
        "text": "Welcome to BZU🙂"
      });

      await firestore
          .collection('postsUsers')
          .doc('${time}_${me?.email.substring(0, me!.email.indexOf('@'))}')
          .set({
        "created_at": time.toString(),
        "admin_name": me?.name.toString() ?? "",
        "images": [],
        "imageUrl": me?.image ?? "",
        "email": me?.email,
        "id": me?.id,
        "name": me?.name,
        "type": PostType.user.name,
        "text": "Welcome to BZU🙂"
      });
      notifyListeners();
    } on Exception catch (e) {
      printLog("error: $e");
    }
  }

  Future<void> createPageFriends() async {
    try {
      final page = PageUser(
          image: me!.email.toString(),
          name: me!.name,
          adminName: me!.name.toString(),
          about: "I am using page to BZU",
          createdAt: '',
          id: '',
          lastActive: '',
          email: me!.email.toString(),
          pushToken: '');

      await firestore
          .collection('users')
          .doc(me?.email)
          .collection('pageAdded')
          .doc('${me?.email}')
          .set(page.toJson());

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
          .doc('${time}_${me?.email.substring(0, me!.email.indexOf('@'))}')
          .set({
        "created_at": time.toString(),
        "images": [],
        "imageUrl": pageMe?.image ?? "",
        "email": pageMe?.email,
        "id": pageMe?.id,
        "admin_name": me?.name.toString() ?? "",
        "name": pageMe?.name,
        "type": PostType.page.name,
        "text": "Welcome to BZU🙂"
      });

      await firestore
          .collection('postsPages')
          .doc('${time}_${me?.email.substring(0, me!.email.indexOf('@'))}')
          .set({
        "created_at": time.toString(),
        "images": [],
        "imageUrl": pageMe?.image ?? "",
        "email": pageMe?.email,
        "admin_name": me?.name.toString() ?? "",
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

  Future<void> sendNotificationPage(PageUser user) async {
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

  Future<void> updateSubMyPicture(File file) async {
    final ext = file.path.split('.').last;
    final ref = storage.ref().child('subImages/${me!.email}.$ext');
    await ref.putFile(file, SettableMetadata(contentType: 'image/$ext'));
    me?.subImage = await ref.getDownloadURL();
    DocumentReference docRef = firestore.collection('users').doc(me!.email);
    await docRef.update({"sub_image": me?.subImage});
    notifyListeners();
  }

  Future<void> updateMyPicture(File file) async {
    final ext = file.path.split('.').last;
    final ref = storage.ref().child('images/${me!.email}.$ext');
    await ref.putFile(file, SettableMetadata(contentType: 'image/$ext'));
    me?.image = await ref.getDownloadURL();
    DocumentReference docRef = firestore.collection('users').doc(me!.email);
    await docRef.update({"image": me?.image});
    notifyListeners();
  }

  Future<void> updateName(String name) async {
    DocumentReference docRef = firestore.collection('users').doc(me!.email);
    await docRef.update({"name": name});
    me?.name = name;
    notifyListeners();
  }

  Future<void> updatePassAndName(String name, String pass) async {
    DocumentReference docRef = firestore.collection('users').doc(me!.email);
    await docRef.update({"name": name, "password": pass});
    me?.name = name;
    notifyListeners();
  }

  Future<void> saveImage(File? file) async {
    try {
      final ext = file?.path.split('.').last;
      final ref = storage.ref().child('images/${me!.email}.$ext');
      await ref.putFile(file!, SettableMetadata(contentType: 'image/$ext'));
      final imageUrl = await ref.getDownloadURL();
      DocumentReference docRef = firestore.collection('users').doc(me!.email);
      docRef.update({"image": imageUrl});
      me?.image = imageUrl;
      notifyListeners();
    } on Exception catch (e) {
      printLog("error: $e");
    }
    // await API.sendMessage(chatUser, imageUrl, Type.image);
  }

  Future<File?> getImageFileFromAssets(String assetPath) async {
    final byteData = await rootBundle.load(assetPath);
    final tempDir = Directory.systemTemp;
    final file = File(path.join(tempDir.path, path.basename(assetPath)));
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    printLog(file);
    return file;
  }

  Future<void> saveSubImage() async {
    try {
      String imagePath = "images/pic.jpg";
      File? file = await getImageFileFromAssets(imagePath);
      final ext = file?.path.split('.').last;
      final ref = storage.ref().child('subImages/${me!.email}.$ext');
      await ref.putFile(file!);
      final imageUrl = await ref.getDownloadURL();

      printLog(imageUrl);

      DocumentReference docRef =
          firestore.collection('users').doc(me!.subImage);
      docRef.update({"sub_image": imageUrl});
      me?.subImage = imageUrl;
      notifyListeners();
    } on Exception catch (e) {
      printLog("error: $e");
    }
  }

  // Future<void> uploadImageFileToFirebase(File imageFile, String storagePath) async {
  //   FirebaseStorage storage = FirebaseStorage.instance;
  //   try {
  //     Reference ref = storage.ref().child(storagePath);
  //     await ref.putFile(imageFile);
  //     String url = await ref.getDownloadURL();
  //     print("Uploaded successfully! URL: $url");
  //   } catch (e) {
  //     print("Failed to upload image: $e");
  //   }
  // }

  Future<void> saveImagePage(File? file, String time, String name) async {
    try {
      final ext = file?.path.split('.').last;
      final ref = storage.ref().child('imagesPages/${me!.email}.$ext');
      await ref.putFile(file!, SettableMetadata(contentType: 'image/$ext'));
      final imageUrl = await ref.getDownloadURL();
      DocumentReference docRef =
          firestore.collection('users/${me!.email.toString()}/pages').doc(name);
      await docRef.update({"image": imageUrl});

      DocumentReference docRef1 = firestore.collection('pages').doc(
          '${name.toLowerCase().trim().toString()}_${me?.email.substring(0, me!.email.indexOf('@'))}');
      await docRef1.update({"image": imageUrl});
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
        text: text.toString(),
        type: PostType.user.name,
        adminName: me!.name.toString(),
      );
      final ref = firestore.collection('users/${me?.email}/posts/');
      final ref1 = firestore.collection('postsUsers');

      await ref
          .doc('${time}_${me?.email.substring(0, me!.email.indexOf('@'))}')
          .set(post.toJson());
      await ref1
          .doc('${time}_${me?.email.substring(0, me!.email.indexOf('@'))}')
          .set(post.toJson());

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
          text: text.toString(),
          type: PostType.page.name,
          adminName: pageMe!.adminName.toString());
      final ref = firestore
          .collection('users/${me?.email}/pages/${pageMe?.name}/posts');
      final ref1 = firestore.collection('postsPages');

      await ref
          .doc('${time}_${me?.email.substring(0, me!.email.indexOf('@'))}')
          .set(post.toJson());
      await ref1
          .doc('${time}_${me?.email.substring(0, me!.email.indexOf('@'))}')
          .set(post.toJson());

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
          text: text.toString(),
          type: PostType.user.name,
          adminName: me!.name.toString());
      final ref = firestore.collection('users/${me!.email}/posts/');
      final ref1 = firestore.collection('postsUsers');
      await ref
          .doc('${time}_${me?.email.substring(0, me!.email.indexOf('@'))}')
          .set(post.toJson());
      await ref1
          .doc('${time}_${me?.email.substring(0, me!.email.indexOf('@'))}')
          .set(post.toJson());
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
          type: PostType.page.name,
          text: text.toString(),
          adminName: pageMe!.adminName.toString());
      final ref = firestore
          .collection('users/${me!.email}/pages/${pageMe?.name}/posts');
      final ref1 = firestore.collection('postsPages');
      await ref
          .doc('${time}_${me?.email.substring(0, me!.email.indexOf('@'))}')
          .set(post.toJson());
      await ref1
          .doc('${time}_${me?.email.substring(0, me!.email.indexOf('@'))}')
          .set(post.toJson());
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
          type: PostType.user.name,
          id: me!.email.toString(),
          name: me!.name.toString(),
          email: me!.email.toString(),
          text: text.toString(),
          adminName: me!.name.toString());
      final ref = firestore.collection('users/${me!.email}/posts/');
      final ref1 = firestore.collection('postsUsers');
      await ref
          .doc('${time}_${me?.email.substring(0, me!.email.indexOf('@'))}')
          .set(post.toJson());
      await ref1
          .doc('${time}_${me?.email.substring(0, me!.email.indexOf('@'))}')
          .set(post.toJson());

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
          text: text.toString(),
          type: PostType.page.name,
          adminName: pageMe!.adminName.toString());
      final ref = firestore
          .collection('users/${me!.email}/pages/${pageMe?.name}/posts');
      final ref1 = firestore.collection('postsPages');
      await ref
          .doc('${time}_${me?.email.substring(0, me!.email.indexOf('@'))}')
          .set(post.toJson());
      await ref1
          .doc('${time}_${me?.email.substring(0, me!.email.indexOf('@'))}')
          .set(post.toJson());
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
          .doc('${time}_${me?.email.substring(0, me!.email.indexOf('@'))}');
      await docRef.update({
        "images": FieldValue.arrayUnion([imageUrl])
      });

      DocumentReference docRef1 = firestore
          .collection('postsUsers')
          .doc('${time}_${me?.email.substring(0, me!.email.indexOf('@'))}');
      await docRef1.update({
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
          .doc('${time}_${me?.email.substring(0, me!.email.indexOf('@'))}');
      await docRef.update({
        "images": FieldValue.arrayUnion([imageUrl])
      });

      DocumentReference docRef1 = firestore
          .collection('postsPages')
          .doc('${time}_${me?.email.substring(0, me!.email.indexOf('@'))}');
      await docRef1.update({
        "images": FieldValue.arrayUnion([imageUrl])
      });

      notifyListeners();
    } on Exception catch (e) {
      printLog("error: $e");
    }
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
        .orderBy('created_at', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllMyPostsPage() {
    printLog(me?.email);
    return firestore
        .collection('users/${me?.email}/pages/${pageMe?.name}/posts')
        .orderBy('created_at', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllCertainPostsPage(
      PageUser page) {
    return firestore
        .collection('users/${page.email}/pages/${page.name}/posts')
        .orderBy('created_at', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllPage() {
    printLog(me?.email);
    return firestore
        .collection('users/${me?.email}/pages')
        .orderBy('created_at', descending: true)
        .snapshots();
  }

  Future<void> deletePost(Post post) async {
    await firestore
        .collection('users/${me?.email}/posts/')
        .doc(
            '${post.createAt}_${me?.email.substring(0, me!.email.indexOf('@'))}')
        .delete();

    await firestore
        .collection('postsUsers')
        .doc(
            '${post.createAt}_${me?.email.substring(0, me!.email.indexOf('@'))}')
        .delete();

    if (post.images.isNotEmpty) {
      await storage.refFromURL(post.images[0]).delete();
      await storage
          .refFromURL(
              '${post.images[0]}_${me?.email.substring(0, me!.email.indexOf('@'))}')
          .delete();
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllPostMyPages() {
    return firestore
        .collection('postsPages')
        .where('email', isEqualTo: me?.email)
        .snapshots();
  }

  Stream<List<PageUser>> getFilteredPostPages() {
    // Stream of pages not added by the user
    var allPages = getAllPostMyPages().map((snapshot) =>
        snapshot.docs.map((doc) => PageUser.fromJson(doc.data())).toList());

    // Get user's added pages' IDs as a set
    var addedPagesIds = firestore
        .collection('users/${me?.email}/pageAdded')
        .where('email', isNotEqualTo: me?.email)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => doc.id.toString().trim().toLowerCase())
            .toSet());

    // Combine and filter the lists
    return Rx.combineLatest2(allPages, addedPagesIds,
        (List<PageUser> pages, Set<String> addedIds) {
      return pages
          .where((page) => !addedIds.contains(page.id.toLowerCase()))
          .toList();
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllPagesWithoutMe() {
    return firestore
        .collection('pages')
        .where('email', isNotEqualTo: me?.email)
        .snapshots();
  }

  Stream<List<PageUser>> getFilteredPages() {
    // Stream of pages not added by the user
    var allPages = getAllPagesWithoutMe().map((snapshot) =>
        snapshot.docs.map((doc) => PageUser.fromJson(doc.data())).toList());

    // Get user's added pages' IDs as a set
    var addedPagesIds = firestore
        .collection('users/${me?.email}/pageAdded')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => doc.id.toString().trim().toLowerCase())
            .toSet());

    // Combine and filter the lists
    return Rx.combineLatest2(allPages, addedPagesIds,
        (List<PageUser> pages, Set<String> addedIds) {
      return pages
          .where((page) => !addedIds.contains(page.id.toLowerCase()))
          .toList();
    });
  }

  Future<void> deletePostPage(Post post) async {
    await firestore
        .collection('users/${me?.email}/pages/${pageMe?.name}/posts')
        .doc(post.createAt)
        .delete();
    await firestore
        .collection('postsPages')
        .doc(
            '${post.createAt}_${me?.email.substring(0, me!.email.indexOf('@'))}')
        .delete();
    // print(post.images.length);

    if (post.images.isNotEmpty) {
      await storage.refFromURL(post.images[0]).delete();
      await storage
          .refFromURL(
              '${post.images[0]}_${me?.email.substring(0, me!.email.indexOf('@'))}')
          .delete();
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

  Future<List<PageUser>> getAllPages() async {
    List<PageUser> list1 = [];

    var allData = await firestore
        .collection('pages')
        .where('email', isNotEqualTo: me?.email)
        .get();
    var d = allData.docs;
    var listUser1 = d.map((e) => PageUser.fromJson(e.data())).toList();
    var isEmpty =
        await firestore.collection('users/${me?.email}/pageAdded').get();

    if (isEmpty.size == 0) {
      var listUser1 = d.map((e) => PageUser.fromJson(e.data())).toList();

      list1.addAll(listUser1);
      return list1;
    } else {
      for (int i = 0; i < allData.size; i++) {
        var data = await firestore
            .collection('users/${me?.email}/pageAdded')
            .where('id',
                isNotEqualTo: d.elementAt(i).id.toString().trim().toLowerCase())
            .get();

        if (data.docs.isNotEmpty == true && data.size == isEmpty.size) {
          list1.add(listUser1[i]);
        }
      }
      list1 = list1.toSet().toList();
      return list1;
    }
  }

  Future<bool> addPage(String namePage) async {
    try {
      var data = await firestore
          .collection('users/${me?.email}/pageAdded')
          .where('id', isEqualTo: namePage.toString().toLowerCase().trim())
          .get();
      printLog(data.size);

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

  Stream<List<Map<String, dynamic>>> getPagesAllMeAndPostsPagesAndPostUser() {
    // Stream of posts directly associated with the user's email from 'postsPages'
    Stream<List<Map<String, dynamic>>> myPostsStream = firestore
        .collection('postsPages')
        .where('email', isEqualTo: me?.email)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList())
        .doOnData((data) {
      printLog('My Posts: ${data.length}'); // Log the count of my posts
    });

    Stream<List<Map<String, dynamic>>> userSpecificPostsStream = firestore
        .collection('users/${me?.email}/posts')
        .orderBy('created_at', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList())
        .doOnData((data) {
      printLog(
          'User Specific Posts: ${data.length}'); // Log the count of user-specific posts
    });

    // Stream of IDs from pages added by the user
    Stream<List<String>> addedPageIdsStream = firestore
        .collection('users/${me?.email}/pageAdded')
        .where('email', isNotEqualTo: me?.email)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.id).toList());

    return addedPageIdsStream.flatMap((List<String> pageIds) {
      if (pageIds.isEmpty) {
        // If no added pages, return combined streams of the user's posts and user-specific posts
        return Rx.combineLatestList([myPostsStream, userSpecificPostsStream])
            .map((List<List<Map<String, dynamic>>> allLists) {
          var combinedList = allLists.expand((element) => element).toList();
          return combinedList;
        });
      } else {
        // Create streams for each added page's posts
        List<Stream<List<Map<String, dynamic>>>> postsFromAddedPagesStreams =
            pageIds.map((id) {
          return firestore
              .collection('postsPages')
              .where('id', isEqualTo: id)
              .snapshots()
              .map(
                  (snapshot) => snapshot.docs.map((doc) => doc.data()).toList())
              .doOnData((data) {
            printLog(
                'Posts from Page ID $id: ${data.length}'); // Log the count of posts from each page
          });
        }).toList();

        // Merge all streams: myPostsStream, userSpecificPostsStream, and posts from added pages
        return Rx.combineLatestList([
          myPostsStream,
          userSpecificPostsStream,
          ...postsFromAddedPagesStreams
        ]).map((List<List<Map<String, dynamic>>> allLists) {
          // Flatten all lists into a single list
          var combinedList = allLists.expand((element) => element).toList();
          // Sort the combined list by createdAt in descending order
          // combinedList.sort((a, b) => DateTime.parse(b['created_at'])
          //     .compareTo(DateTime.parse(a['created_at'])));
          printLog(
              'Total Posts after merge: ${combinedList.length}'); // Log total number of posts after merging
          return combinedList;
        });
      }
    });
  }

  Stream<List<Map<String, dynamic>>> getPagesAllMeAndPostsPages() {
    // Stream of posts directly associated with the user's email
    Stream<List<Map<String, dynamic>>> myPostsStream = firestore
        .collection('postsPages')
        .where('email', isEqualTo: me?.email)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList())
        .doOnData((data) {
      printLog('My Posts: ${data.length}'); // Log the count of my posts
    });

    // Stream of IDs from pages added by the user
    Stream<List<String>> addedPageIdsStream = firestore
        .collection('users/${me?.email}/pageAdded')
        .where('email', isNotEqualTo: me?.email)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.id).toList());

    return addedPageIdsStream.flatMap((List<String> pageIds) {
      if (pageIds.isEmpty) {
        return myPostsStream; // If no added pages, just return the user's posts
      } else {
        // Create streams for each added page's posts
        List<Stream<List<Map<String, dynamic>>>> postsFromAddedPagesStreams =
            pageIds.map((id) {
          return firestore
              .collection('postsPages')
              .where('id', isEqualTo: id)
              .snapshots()
              .map(
                  (snapshot) => snapshot.docs.map((doc) => doc.data()).toList())
              .doOnData((data) {
            printLog(
                'Posts from Page ID $id: ${data.length}'); // Log the count of posts from each page
          });
        }).toList();

        // Merge myPostsStream with all stream
        //s from added pages and combine them into a single list
        return Rx.combineLatestList(
                [myPostsStream, ...postsFromAddedPagesStreams])
            .map((List<List<Map<String, dynamic>>> allLists) {
          // Flatten all lists into a single list
          var combinedList = allLists.expand((element) => element).toList();
          combinedList
              .sort((a, b) => b['created_at'].compareTo(a['created_at']));

          printLog(
              'Total Posts after merge: ${combinedList.length}'); // Log total number of posts after merging
          return combinedList;
        });
      }
    });
  }

  Future<void> addPageFriends(PageUser page) async {
    try {
      printLog(page.id);
      await firestore
          .collection('users/${me?.email}/pageAdded')
          .doc(page.id)
          .set(page.toJson());

      await isAddedPageBefore(page.id);
      notifyListeners();
    } on Exception catch (e) {
      printLog("error: $e");
    }
  }

  Future<bool> isAddedPageBefore(String id) async {
    try {
      final data = await firestore
          .collection('users/${me?.email}/pages')
          .where('id', isEqualTo: id)
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

  Future<void> unfollowPageFriend(PageUser page) async {
    await firestore
        .collection('users/${me?.email}/pageAdded')
        .doc(page.id)
        .delete();
    await isAddedPageBefore(page.id);
    notifyListeners();
  }
}
