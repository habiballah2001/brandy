/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Test extends StatefulWidget {
  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  final db = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Collection Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: db.collection('Users').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var doc = snapshot.data.documents;
              return new ListView.builder(
                  itemCount: doc.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: Column(
                          children: <Widget>[
                            Text(doc[index].data['email']),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(doc[index].data['phone']),
                          ],
                        ),
                      ),
                    );
                  });
            } else {
              return LinearProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}*/
/*To retrieve document data from a subcollection in Firebase and display it on the screen using Flutter, you can follow the steps below:

1. Set up Firebase:
   - Create a Firebase project and enable Firestore.
   - Add the necessary dependencies to your Flutter project by including the firebase_core and cloud_firestore packages in your pubspec.yaml file.
   - Download the google-services.json file from your Firebase project settings and place it in the android/app directory for Android or ios/Runner directory for iOS.

2. Initialize Firebase in your Flutter code:
   - Import the necessary packages:
     dart
     import 'package:firebase_core/firebase_core.dart';
     import 'package:cloud_firestore/cloud_firestore.dart';

   - Initialize Firebase in your main function:
     dart
     void main() async {
       WidgetsFlutterBinding.ensureInitialized();
       await Firebase.initializeApp();
       runApp(MyApp());
     }


3. Retrieve data from the subcollection and display it on the screen:
   - Create a StreamBuilder widget to listen for changes in the subcollection:
     dart
     StreamBuilder<QuerySnapshot>(
       stream: FirebaseFirestore.instance
           .collection('users')
           .doc('USER_ID')
           .collection('documents')
           .snapshots(),
       builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
         if (snapshot.hasError) {
           return Text('Error: ${snapshot.error}');
         }

         if (snapshot.connectionState == ConnectionState.waiting) {
           return Text('Loading...');
         }

         if (snapshot.hasData) {
           return ListView(
             children: snapshot.data!.docs.map((doc) {
               var documentData = doc.data();
               return ListTile(
                 title: Text(documentData['name']),
                 // Display other properties as desired
               );
             }).toList(),
           );
         }

         return Text('No data available');
       },
     )


In the code snippet above, replace 'USER_ID' with the actual ID of the user you want to retrieve documents for. Modify the structure and properties of your documents as needed.

The StreamBuilder listens for changes in the subcollection and rebuilds the widget tree whenever there are updates. It displays a loading indicator while the data is being fetched and then renders a ListView with ListTile widgets for each document retrieved. Customize the UI according to your requirements by adding or modifying the widgets within the ListView.

Make sure to properly configure Firebase and include the necessary dependencies in your Flutter project.*/
/*Apologies for the confusion. To retrieve document data from a subcollection in Firebase and use the Stream function in Flutter, you can follow these steps:

1. Set up Firebase:
   - Create a Firebase project and enable Firestore.
   - Add the necessary dependencies to your Flutter project by including the firebase_core and cloud_firestore packages in your pubspec.yaml file.
   - Download the google-services.json file from your Firebase project settings and place it in the android/app directory for Android or the ios/Runner directory for iOS.

2. Initialize Firebase in your Flutter code:
   - Import the necessary packages:
     dart
     import 'package:firebase_core/firebase_core.dart';
     import 'package:cloud_firestore/cloud_firestore.dart';

   - Initialize Firebase in an initFirebase() function:
     dart
     Future<void> initFirebase() async {
       WidgetsFlutterBinding.ensureInitialized();
       await Firebase.initializeApp();
     }


3. Retrieve data from the subcollection using a Stream:
   - Create a method to fetch the subcollection documents as a Stream:
     dart
     Stream<QuerySnapshot> getDocumentsStream() {
       return FirebaseFirestore.instance
           .collection('users')
           .doc('USER_ID')
           .collection('documents')
           .snapshots();
     }


4. Display the data using the StreamBuilder widget:
   - Wrap your view with the StreamBuilder widget, providing the getDocumentsStream() method as the stream parameter:
     dart
     StreamBuilder<QuerySnapshot>(
       stream: getDocumentsStream(),
       builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
         if (snapshot.hasError) {
           return Text('Error: ${snapshot.error}');
         }

         if (snapshot.connectionState == ConnectionState.waiting) {
           return Text('Loading...');
         }

         if (snapshot.hasData) {
           final documents = snapshot.data!.docs;

           return ListView.builder(
             itemCount: documents.length,
             itemBuilder: (context, index) {
               final documentData = documents[index].data();
               return ListTile(
                 title: Text(documentData['name']),
                 // Display other properties as desired
               );
             },
           );
         }

         return Text('No data available');
       },
     )


In the code snippet above, replace 'USER_ID' with the actual ID of the user you want to retrieve documents for. Modify the structure and properties of your documents as needed.

The StreamBuilder widget listens for changes in the subcollection and rebuilds the widget tree whenever there are updates. It displays a loading indicator while the data is being fetched and then renders a ListView.builder widget with ListTile widgets for each document retrieved. Customize the UI according to your requirements by adding or modifying the widgets within the ListView.builder.

Make sure to properly configure Firebase and include the necessary dependencies in your Flutter project. Additionally, call the initFirebase() function to initialize Firebase before running the app.*/
/*
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:manager/data/models/comment_model.dart';
import 'package:manager/data/models/task_model.dart';
import 'package:manager/data/models/userModel.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

import '../../res/constants.dart';
import 'app_states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(InitialAppStates());

  static AppCubit get(context) => BlocProvider.of(context);

  //user

  List<UserModel> users = [];
  Future<List<UserModel>> getUsers() async {
    try {
      emit(GetUsersLoadingState());

      await FirebaseFirestore.instance.collection('users').get().then(
        (snap) {
          users.clear();
          users = snap.docs.map((e) {
            return UserModel.fromFirestore(e.data());
          }).toList();
          emit(GetUsersSuccessState());
        },
      );
    } catch (e) {
      emit(GetUsersErrorState(e.toString()));
      log('ERROR IN GET TASKS ${e.toString()}');
      rethrow;
    }
    return users;
  }

  //
  UserModel? userData;
  Future<void> getUserData({String? uId}) async {
    emit(GetUserDataLoadingState());
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .get()
        .then((value) {
      userData = UserModel.fromFirestore(value.data()!);
      emit(GetUserDataSuccessState(userData!));
    }).catchError((e) {
      emit(GetUserDataErrorState(e.toString()));
      printFull(e.toString());
      log('ERROR IS ${e.toString()}');
    });
  }

  Future<void> openWhatsapp() async {
    final Uri url = Uri.parse('https://wa.me/${userData!.phone}?text=Hello');
    try {
      if (await canLaunchUrl(url)) {
        launchUrl(url);
      } else {
        throw Exception('Could not launch $url');
      }
    } catch (e) {
      log('ERROR ==== ${e.toString()}');
    }
  }

  Future<void> openGmail() async {
    final Uri url = Uri.parse('mailto:${userData!.email}');

    try {
      if (await canLaunchUrl(url)) {
        launchUrl(url);
      } else {
        throw Exception('Could not launch $url');
      }
    } catch (e) {
      log('ERROR ==== ${e.toString()}');
    }
  }

  Future<void> openCall() async {
    final Uri phoneUrl = Uri.parse('tel://${userData!.phone}');

    try {
      if (await canLaunchUrl(phoneUrl)) {
        launchUrl(phoneUrl);
      } else {
        throw Exception('Could not launch $phoneUrl');
      }
    } catch (e) {
      log('ERROR ==== ${e.toString()}');
    }
  }

  //add task
  Future<void> addTask({
    required String? taskId,
    //required String? uploadedBy,
    required String? uploadedFor,
    required String? taskCategory,
    required String? taskTitle,
    required String? taskDesc,
    //required Timestamp? createdAt,
    required String? taskDeadline,
    required Timestamp? taskDeadlineTimeStamp,
    required bool? isDone,
  }) async {
    TaskModel task = TaskModel(
      taskId: taskId,
      uploadedBy: currentUser!.uid,
      uploadedFor: uploadedFor,
      taskCategory: taskCategory,
      taskTitle: taskTitle,
      taskDesc: taskDesc,
      createdAt: Timestamp.now(),
      taskDeadline: taskDeadline,
      taskDeadlineTimeStamp: taskDeadlineTimeStamp,
      isDone: isDone,
    );
    emit(AddTaskLoadingState());
    await FirebaseFirestore.instance
        .collection('tasks')
        .doc(taskId)
        .set(task.toMap())
        .then((value) async {
      await getTasks();
      emit(AddTaskSuccessState());
      log('task uploaded successfully');
    }).catchError((e) {
      emit(AddTaskErrorState(e.toString()));
      log('ERROR IS ${e.toString()}');
    });
  }

  //getTasks
  List<TaskModel> tasks = [];
  String? taskCategory;
  TaskModel? taskModel;
  Future<List<TaskModel>> getTasks({String? taskCategory}) async {
    try {
      emit(GetTaskLoadingState());

      await FirebaseFirestore.instance
          .collection('tasks')
          //.where('taskCategory', isEqualTo: taskCategory)
          .orderBy('createdAt', descending: true)
          .get()
          .then(
        (snap) {
          tasks.clear();
          tasks = snap.docs.map((e) {
            return TaskModel.fromFirestore(e.data());
          }).toList();
          emit(GetTaskSuccessState(taskModel));
        },
      );
    } catch (e) {
      emit(GetTaskErrorState(e.toString()));
      log('ERROR IN GET TASKS ${e.toString()}');
      rethrow;
    }
    return tasks;
  }

  Stream<List<TaskModel>> getTasksStream({String? taskCategory}) {
    emit(GetTaskLoadingState());
    try {
      return FirebaseFirestore.instance
          .collection('tasks')
          .where('taskCategory', isEqualTo: taskCategory)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map(
        (snap) {
          tasks.clear();
          tasks = snap.docs.map((e) {
            return TaskModel.fromFirestore(e.data());
          }).toList();
          emit(GetTaskSuccessState(taskModel));
          return tasks;
        },
      );
    } catch (e) {
      emit(GetTaskErrorState(e.toString()));
      log('ERROR IN GET TASKS ${e.toString()}');
      rethrow;
    }
  }

  //task comment
  Future<void> comment({
    required String? taskId,
    required String? commenterId,
    required String? commentBody,
    required String? commenterName,
    required String? commenterPic,
    Timestamp? time,
  }) async {
    emit(CommentingLoadingState());
    final commentId = const Uuid().v4();
    CommentModel comment = CommentModel(
      commenterId: commenterId,
      commentBody: commentBody,
      commenterName: commenterName,
      commentId: commentId,
      commenterPic: commenterPic,
      time: Timestamp.now(),
    );
    FirebaseFirestore.instance
        .collection('tasks')
        .doc(taskId)
        .collection('comments')
        .doc(commentId)
        .set(comment.toMap())
        .then((value) {
      emit(CommentingSuccessState());
    }).catchError((e) {
      emit(CommentingErrorState(e.toString()));
      log('ERROR IS ${e.toString()}');
    });
  }

  //task done state
  Future<void> taskStatus({
    required String? taskId,
    required bool? isDone,
  }) async {
    emit(DoneLoadingState());
    FirebaseFirestore.instance
        .collection('tasks')
        .doc(taskId)
        .update({'isDone': isDone}).then((value) {
      //getTaskDetails(taskId: taskId);
      getTasks();
      emit(DoneSuccessState());
    }).catchError((e) {
      emit(DoneErrorState(e.toString()));
      log('ERROR IS ${e.toString()}');
    });
  }
}
*/
/*import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manager/view_model/app_cubit/app_cubit.dart';
import 'package:manager/res/constants.dart';
import 'package:manager/res/custom_widgets/CustomAppBar.dart';
import '../view_model/app_cubit/app_states.dart';
import '../data/models/task_model.dart';
import '../res/custom_widgets/custom_texts.dart';
import '../res/services/dialogs.dart';
import '../view/widgets/drawer_widget.dart';
import '../view/widgets/task_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    AppCubit cubit = AppCubit.get(context);
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) => Scaffold(
        appBar: CustomAppBar(
          title: const Text('Tasks'),
          actions: [
            IconButton(
              onPressed: () {
                Dialogs.taskCategoryDialog(context);
              },
              icon: const Icon(Icons.filter_list),
            ),
            IconButton(
              onPressed: () {
                log(currentUser!.uid);
              },
              icon: const Icon(Icons.account_tree_outlined),
            ),
          ],
        ),
        drawer: const CustomDrawer(),
        body: cubit.tasks.isNotEmpty
            ? ListView.builder(
                itemCount: cubit.tasks.length,
                itemBuilder: (context, index) {
                  TaskModel item = cubit.tasks[index];
                  return TaskItem(
                    taskModel: item,
                  );
                },
              )
            : const Center(
                child: HeadLargeText('no tasks'),
              ),
      ),
    );
  }
}
*/
/*To retrieve order details and its associated product data from Firebase using a data model in Flutter, you can follow these steps:

1. Set up Firebase in your Flutter project by adding the necessary dependencies and configuration. You can refer to the Firebase documentation for step-by-step instructions on how to do this.

2. Define the data model classes for orders and products. These classes will represent the structure of the data you want to retrieve from Firebase. For example:

dart
class Order {
  final String id;
  final String customerId;
  final List<String> productIds;

  Order({required this.id, required this.customerId, required this.productIds});
}

class Product {
  final String id;
  final String name;
  final double price;

  Product({required this.id, required this.name, required this.price});
}


3. Set up a Firebase Firestore instance in your Flutter code to access the database. Make sure you have the necessary permissions set up in Firebase for read access to the order and product data.

dart
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;


4. Retrieve the order details and associated product data using a query and mapping the data to your data model. Here's an example of how you can do this:

dart
Future<Order> getOrderDetails(String orderId) async {
  DocumentSnapshot orderSnapshot =
      await firestore.collection('orders').doc(orderId).get();

  if (orderSnapshot.exists) {
    final orderData = orderSnapshot.data();

    Order order = Order(
      id: orderSnapshot.id,
      customerId: orderData['customerId'],
      productIds: List<String>.from(orderData['productIds']),
    );

    List<Product> products = [];

    for (String productId in order.productIds) {
      DocumentSnapshot productSnapshot =
          await firestore.collection('products').doc(productId).get();

      if (productSnapshot.exists) {
        final productData = productSnapshot.data();

        Product product = Product(
          id: productSnapshot.id,
          name: productData['name'],
          price: productData['price'].toDouble(),
        );

        products.add(product);
      }
    }

    return order;
  } else {
    throw Exception('Order not found');
  }
}


In this example, we first retrieve the order document using the provided order ID. Then, we extract the relevant data from the snapshot and create an Order object. We iterate through the productIds list in the order and retrieve each associated product document. Finally, we create Product objects and add them to the products list.

5. To use this function and retrieve the order details, you can call it like this:

dart
Order order = await getOrderDetails('your_order_id');


Make sure to replace 'your_order_id' with the actual ID of the order you want to retrieve.

This is a basic example to get you started. You can further enhance it by adding error handling, caching mechanisms, or optimizing the data retrieval process based on your specific requirements.*/
/*To update a button immediately when its title updates in Firebase Firestore using the Provider package with Flutter, you can combine Firebase Firestore's real-time updates with Flutter's state management using Provider.

Here's a step-by-step guide on how to achieve this:

1. Set up Firebase in your Flutter project by following the official Firebase Flutter documentation.

2. Create a Firestore collection and document to store the button title.

3. Add the necessary Firebase, Flutter, and Provider packages to your pubspec.yaml file:
yaml
dependencies:
  flutter:
    sdk: flutter
  firebase_core: ^1.10.0
  cloud_firestore: ^3.1.0
  provider: ^6.0.0


4. Import the required packages in your Dart files:
dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';


5. Initialize Firebase in your Flutter app. This should be done before calling runApp() in your main() function:
dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}


6. Create a ButtonModel class to hold the button's title:
dart
class ButtonModel {
  String title;

  ButtonModel({this.title});
}


7. Create a ButtonProvider class that extends ChangeNotifier from the Provider package. This will provide the button's data and handle updates:
dart
class ButtonProvider extends ChangeNotifier {
  ButtonModel _button;

  ButtonModel get button => _button;

  void updateButton(ButtonModel updatedButton) {
    _button = updatedButton;
    notifyListeners();
  }

  void fetchButtonData() async {
    // Retrieve data from Firestore
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection('buttons').doc('button1').get();
    ButtonModel button = ButtonModel(title: snapshot.data()['title'] ?? '');
    updateButton(button);
  }

  void subscribeToButtonChanges() {
    // Listen to changes in Firestore document
    FirebaseFirestore.instance
        .collection('buttons')
        .doc('button1')
        .snapshots()
        .listen((DocumentSnapshot snapshot) {
      ButtonModel button = ButtonModel(title: snapshot.data()['title'] ?? '');
      updateButton(button);
    });
  }
}


8. Create a MyButton widget that uses the ButtonProvider to update the button's title:
dart
class MyButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ButtonProvider buttonProvider = Provider.of<ButtonProvider>(context);
    ButtonModel button = buttonProvider.button;

    return ElevatedButton(
      onPressed: () {
        // Button logic here
      },
      child: Text(button.title),
    );
  }
}


9. Create a MyApp widget that wraps the MyButton widget with a ChangeNotifierProvider to provide the ButtonProvider:
dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ButtonProvider(),
      builder: (context, _) {
        ButtonProvider buttonProvider = Provider.of<ButtonProvider>(context);
        buttonProvider.fetchButtonData();
        buttonProvider.subscribeToButtonChanges();

        return MaterialApp(
          title: 'Button Example',
          home: Scaffold(
            appBar: AppBar(title: Text('Button Example')),
            body: Center(
              child: MyButton(),
            ),
          ),
        );
      },
    );
  }
}


10. In your main widget, use MyApp as the root widget:
dart
void main() {
  runApp(MyApp());
}


With this setup, the button's title will update immediately whenever the Firestore document's title field changes. The state management provided by the ButtonProvider and ChangeNotifierProvider will ensure that the button's title is updated and reflected correctly in the UI.*/
/*// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

import 'firebase_options.dart';
import 'message.dart';
import 'message_list.dart';
import 'permissions.dart';
import 'token_monitor.dart';

/// Working example of FirebaseMessaging.
/// Please use this in order to verify messages are working in foreground, background & terminated state.
/// Setup your app following this guide:
/// https://firebase.google.com/docs/cloud-messaging/flutter/client#platform-specific_setup_and_requirements):
///
/// Once you've completed platform specific requirements, follow these instructions:
/// 1. Install melos tool by running `flutter pub global activate melos`.
/// 2. Run `melos bootstrap` in FlutterFire project.
/// 3. In your terminal, root to ./packages/firebase_messaging/firebase_messaging/example directory.
/// 4. Run `flutterfire configure` in the example/ directory to setup your app with your Firebase project.
/// 5. Open `token_monitor.dart` and change `vapidKey` to yours.
/// 6. Run the app on an actual device for iOS, android is fine to run on an emulator.
/// 7. Use the following script to send a message to your device: scripts/send-message.js. To run this script,
///    you will need nodejs installed on your computer. Then the following:
///     a. Download a service account key (JSON file) from your Firebase console, rename it to "google-services.json" and add to the example/scripts directory.
///     b. Ensure your device/emulator is running, and run the FirebaseMessaging example app using `flutter run`.
///     c. Copy the token that is printed in the console and paste it here: https://github.com/firebase/flutterfire/blob/01b4d357e1/packages/firebase_messaging/firebase_messaging/example/lib/main.dart#L32
///     c. From your terminal, root to example/scripts directory & run `npm install`.
///     d. Run `npm run send-message` in the example/scripts directory and your app will receive messages in any state; foreground, background, terminated.
///  Note: Flutter API documentation for receiving messages: https://firebase.google.com/docs/cloud-messaging/flutter/receive
///  Note: If you find your messages have stopped arriving, it is extremely likely they are being throttled by the platform. iOS in particular
///  are aggressive with their throttling policy.
///
/// To verify that your messages are being received, you ought to see a notification appearon your device/emulator via the flutter_local_notifications plugin.
/// Define a top-level named handler which background/terminated messages will
/// call. Be sure to annotate the handler with `@pragma('vm:entry-point')` above the function declaration.
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await setupFlutterNotifications();
  showFlutterNotification(message);
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  print('Handling a background message ${message.messageId}');
}

/// Create a [AndroidNotificationChannel] for heads up notifications
late AndroidNotificationChannel channel;

bool isFlutterLocalNotificationsInitialized = false;

Future<void> setupFlutterNotifications() async {
  if (isFlutterLocalNotificationsInitialized) {
    return;
  }
  channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  /// Create an Android Notification Channel.
  ///
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  isFlutterLocalNotificationsInitialized = true;
}

void showFlutterNotification(RemoteMessage message) {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  if (notification != null && android != null && !kIsWeb) {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          // TODO add a proper drawable resource to android, for now using
          //      one that already exists in example app.
          icon: 'launch_background',
        ),
      ),
    );
  }
}

/// Initialize the [FlutterLocalNotificationsPlugin] package.
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  if (!kIsWeb) {
    await setupFlutterNotifications();
  }

  runApp(MessagingExampleApp());
}

/// Entry point for the example application.
class MessagingExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Messaging Example App',
      theme: ThemeData.dark(),
      routes: {
        '/': (context) => Application(),
        '/message': (context) => MessageView(),
      },
    );
  }
}

// Crude counter to make messages unique
int _messageCount = 0;

/// The API endpoint here accepts a raw FCM payload for demonstration purposes.
String constructFCMPayload(String? token) {
  _messageCount++;
  return jsonEncode({
    'token': token,
    'data': {
      'via': 'FlutterFire Cloud Messaging!!!',
      'count': _messageCount.toString(),
    },
    'notification': {
      'title': 'Hello FlutterFire!',
      'body': 'This notification (#$_messageCount) was created via FCM!',
    },
  });
}

/// Renders the example application.
class Application extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Application();
}

class _Application extends State<Application> {
  String? _token;
  String? initialMessage;
  bool _resolved = false;

  @override
  void initState() {
    super.initState();

    FirebaseMessaging.instance.getInitialMessage().then(
          (value) => setState(
            () {
              _resolved = true;
              initialMessage = value?.data.toString();
            },
          ),
        );

    FirebaseMessaging.onMessage.listen(showFlutterNotification);

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      Navigator.pushNamed(
        context,
        '/message',
        arguments: MessageArguments(message, true),
      );
    });
  }

  Future<void> sendPushMessage() async {
    if (_token == null) {
      print('Unable to send FCM message, no token exists.');
      return;
    }

    try {
      await http.post(
        Uri.parse('https://api.rnfirebase.io/messaging/send'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: constructFCMPayload(_token),
      );
      print('FCM request for device sent!');
    } catch (e) {
      print(e);
    }
  }

  Future<void> onActionSelected(String value) async {
    switch (value) {
      case 'subscribe':
        {
          print(
            'FlutterFire Messaging Example: Subscribing to topic "fcm_test".',
          );
          await FirebaseMessaging.instance.subscribeToTopic('fcm_test');
          print(
            'FlutterFire Messaging Example: Subscribing to topic "fcm_test" successful.',
          );
        }
        break;
      case 'unsubscribe':
        {
          print(
            'FlutterFire Messaging Example: Unsubscribing from topic "fcm_test".',
          );
          await FirebaseMessaging.instance.unsubscribeFromTopic('fcm_test');
          print(
            'FlutterFire Messaging Example: Unsubscribing from topic "fcm_test" successful.',
          );
        }
        break;
      case 'get_apns_token':
        {
          if (defaultTargetPlatform == TargetPlatform.iOS ||
              defaultTargetPlatform == TargetPlatform.macOS) {
            print('FlutterFire Messaging Example: Getting APNs token...');
            String? token = await FirebaseMessaging.instance.getAPNSToken();
            print('FlutterFire Messaging Example: Got APNs token: $token');
          } else {
            print(
              'FlutterFire Messaging Example: Getting an APNs token is only supported on iOS and macOS platforms.',
            );
          }
        }
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cloud Messaging'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: onActionSelected,
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  value: 'subscribe',
                  child: Text('Subscribe to topic'),
                ),
                const PopupMenuItem(
                  value: 'unsubscribe',
                  child: Text('Unsubscribe to topic'),
                ),
                const PopupMenuItem(
                  value: 'get_apns_token',
                  child: Text('Get APNs token (Apple only)'),
                ),
              ];
            },
          ),
        ],
      ),
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton(
          onPressed: sendPushMessage,
          backgroundColor: Colors.white,
          child: const Icon(Icons.send),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            MetaCard('Permissions', Permissions()),
            MetaCard(
              'Initial Message',
              Column(
                children: [
                  Text(_resolved ? 'Resolved' : 'Resolving'),
                  Text(initialMessage ?? 'None'),
                ],
              ),
            ),
            MetaCard(
              'FCM Token',
              TokenMonitor((token) {
                _token = token;
                return token == null
                    ? const CircularProgressIndicator()
                    : SelectableText(
                        token,
                        style: const TextStyle(fontSize: 12),
                      );
              }),
            ),
            ElevatedButton(
              onPressed: () {
                FirebaseMessaging.instance
                    .getInitialMessage()
                    .then((RemoteMessage? message) {
                  if (message != null) {
                    Navigator.pushNamed(
                      context,
                      '/message',
                      arguments: MessageArguments(message, true),
                    );
                  }
                });
              },
              child: const Text('getInitialMessage()'),
            ),
            MetaCard('Message Stream', MessageList()),
          ],
        ),
      ),
    );
  }
}

/// UI Widget for displaying metadata.
class MetaCard extends StatelessWidget {
  final String _title;
  final Widget _children;

  // ignore: public_member_api_docs
  MetaCard(this._title, this._children);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(left: 8, right: 8, top: 8),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                child: Text(_title, style: const TextStyle(fontSize: 18)),
              ),
              _children,
            ],
          ),
        ),
      ),
    );
  }
}*/
/*To retrieve a list with specific data from a list of maps stored in Firebase Firestore using Flutter, you can follow these steps:

1. Import the required packages:
dart
import 'package:cloud_firestore/cloud_firestore.dart';


2. Retrieve the Firestore collection reference:
dart
final CollectionReference<Map<String, dynamic>> collectionReference =
    FirebaseFirestore.instance.collection('your_collection_name');


3. Query the Firestore collection and filter the documents based on your criteria:
dart
QuerySnapshot<Map<String, dynamic>> querySnapshot =
    await collectionReference.where('field_name', isEqualTo: 'desired_value').get();

Replace 'field_name' with the name of the field you want to filter on, and 'desired_value' with the specific value you are looking for.

4. Extract the data from the retrieved documents:
dart
List<Map<String, dynamic>> resultList = querySnapshot.docs
    .map((DocumentSnapshot<Map<String, dynamic>> doc) => doc.data())
    .toList();


The resultList will contain a list of maps, where each map represents the data of a document that matches the specified criteria.

Here's the complete example code:
dart
import 'package:cloud_firestore/cloud_firestore.dart';

Future<List<Map<String, dynamic>>> getListFromFirestore() async {
  final CollectionReference<Map<String, dynamic>> collectionReference =
      FirebaseFirestore.instance.collection('your_collection_name');

  QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await collectionReference.where('field_name', isEqualTo: 'desired_value').get();

  List<Map<String, dynamic>> resultList = querySnapshot.docs
      .map((DocumentSnapshot<Map<String, dynamic>> doc) => doc.data())
      .toList();

  return resultList;
}

Remember to replace 'your_collection_name' with the actual name of your collection.

You can then call the getListFromFirestore() function to retrieve the desired list of data.*/
/*To retrieve a list of maps with just two specific fields and their corresponding values from Firebase Firestore using Flutter, you can modify the previous example as follows:

1. Update the query to include only the desired fields:
dart
QuerySnapshot<Map<String, dynamic>> querySnapshot = await collectionReference
    .where('field_name', isEqualTo: 'desired_value')
    .select(['field1', 'field2'])
    .get();

Replace 'field1' and 'field2' with the actual names of the fields you want to retrieve.

2. Modify the mapping function to create a map with only the desired fields:
dart
List<Map<String, dynamic>> resultList = querySnapshot.docs
    .map((DocumentSnapshot<Map<String, dynamic>> doc) => {
          'field1': doc.data()['field1'],
          'field2': doc.data()['field2'],
        })
    .toList();

Replace 'field1' and 'field2' with the actual names of the fields you want to include in the result map.

Here's the updated code:
dart
import 'package:cloud_firestore/cloud_firestore.dart';

Future<List<Map<String, dynamic>>> getListFromFirestore() async {
  final CollectionReference<Map<String, dynamic>> collectionReference =
      FirebaseFirestore.instance.collection('your_collection_name');

  QuerySnapshot<Map<String, dynamic>> querySnapshot = await collectionReference
      .where('field_name', isEqualTo: 'desired_value')
      .select(['field1', 'field2'])
      .get();

  List<Map<String, dynamic>> resultList = querySnapshot.docs
      .map((DocumentSnapshot<Map<String, dynamic>> doc) => {
            'field1': doc.data()['field1'],
            'field2': doc.data()['field2'],
          })
      .toList();

  return resultList;
}

Remember to replace 'your_collection_name', 'field_name', 'field1', and 'field2' with the actual names in your Firestore collection.

You can then call the getListFromFirestore() function to retrieve the desired list of maps with just two fields and their values.*/
/*import 'dart:developer';

import 'package:brandy/view_model/cart_provider.dart';
import 'package:brandy/view_model/cart_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../models/address_model.dart';
import '../models/order_model.dart';
import '../models/user_data_model.dart';
import '../res/constants/constants.dart';
import '../res/services/utils.dart';
import 'home_provider.dart';
import 'user_provider.dart';

class OrderProvider with ChangeNotifier {
  static OrderProvider get(context, {bool listen = true}) =>
      Provider.of<OrderProvider>(context, listen: listen);

  OrderProvider() {
    fetchOrders();
  }

  final User? _user = FirebaseAuth.instance.currentUser;
  final _ordersCollection = FirebaseFirestore.instance.collection("orders");
  final CollectionReference<Map<String, dynamic>> _usersCollection =
      FirebaseFirestore.instance.collection("users");
  //
  static List<OrderModel> _orders = [];
  List<OrderModel> get getOrdersList => _orders;
  Future<List<OrderModel>?> fetchOrders() async {
    if (_user != null) {
      _ordersCollection
          .orderBy('date', descending: true)
          .get()
          .then((orderSnapshot) {
        _orders.clear();
        _orders = orderSnapshot.docs.map((querySnapshot) {
          return OrderModel.fromFirestore(querySnapshot);
        }).toList();
      }).catchError((e) {
        log('err in fetchOrders : ${e.toString()}');
      });
    } else {
      log('no user :$_user');

      return null;
    }
    return _orders;
  }

  Stream<List<OrderModel>>? fetchOrdersStream({String? status}) {
    if (_user != null) {
      try {
        return status != null
            ? _ordersCollection
                .orderBy('date', descending: true)
                .where('status', isEqualTo: status)
                .where('userId', isEqualTo: _user!.uid)
                .snapshots()
                .map((productsSnapshot) {
                _orders.clear();
                _orders = productsSnapshot.docs.map((e) {
                  return OrderModel.fromFirestore(e);
                }).toList();
                return _orders;
              })
            : _ordersCollection
                .orderBy('date', descending: true)
                .where('userId', isEqualTo: _user!.uid)
                .snapshots()
                .map((productsSnapshot) {
                _orders.clear();
                _orders = productsSnapshot.docs.map((e) {
                  return OrderModel.fromFirestore(e);
                }).toList();
                return _orders;
              });
      } catch (e) {
        log('error in fetch orders ${e.toString()}');
        rethrow;
      }
    } else {
      log('no user :$_user');
      return null;
    }
  }

  //make order products list
  List<Map<String, dynamic>> _orderProductsList = [];
  List<Map<String, dynamic>> get getOrderProducts => _orderProductsList;

  Future<List<Map<String, dynamic>>> makeOrderProductsList() async {
    if (Constants.user != null) {
      await _usersCollection
          .doc(Constants.user!.uid)
          .collection('cartList')
          .get()
          .then((value) {
        _orderProductsList.clear();
        _orderProductsList =
            value.docs.map((DocumentSnapshot<Map<String, dynamic>> doc) {
          return {
            'productId': doc.get('productId'),
            'quantity': doc.get('quantity'),
          };
        }).toList();
      }).catchError((e) {
        log('Error fetching cart: $e');
      });
    } else {
      log('no user fetchCart :${Constants.user}');
    }
    notifyListeners();
    return _orderProductsList;
  }

  AddressModel? addressModel;
  Future<void> makeOrder({required BuildContext context}) async {
    String orderId = const Uuid().v4();
    UserProvider userProvider = UserProvider.get(context, listen: false);
    CartProvider cartProvider = CartProvider.get(context, listen: false);
    HomeProvider homeProvider = HomeProvider.get(context, listen: false);
    if (Constants.user != null) {
      UserModel? getUser = userProvider.getUserModel!;
      //
      OrderModel orderModel = OrderModel(
        orderId: orderId,
        userId: getUser.uId,
        userName: getUser.userName,
        userPhone: getUser.phone,
        vat: cartProvider.getVat,
        subTotal: cartProvider.getSubTotal(homeProvider: homeProvider),
        totalDiscount:
            cartProvider.getTotalDiscount(homeProvider: homeProvider),
        cost: cartProvider.getCost(homeProvider: homeProvider),
        paymentMethod: 'Cash',
        date: Timestamp.now(),
        status: 'waiting',
        products: _orderProductsList,
        address: addressModel!,
      );
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId)
          .set(orderModel.toFirestore())
          .then((value) {
        cartProvider.deleteCartData(context);
        CustomMethods.toast(body: 'Order sent');
      }).catchError((e) {
        log('err in makeOrder : $e');
      });
    } else {
      log('no user makeOrder :${Constants.user}');
      return;
    }
    notifyListeners();
  }

  //
  OrderModel? orderModel;
  OrderModel? get getOrderData => orderModel;
  Future<OrderModel?> fetchOrderDetails({required String orderId}) async {
    if (_user != null) {
      _ordersCollection.doc(orderId).get().then((value) {
        orderModel = OrderModel.fromFirestore(value);
      });
    } else {
      log('no user :$_user');
    }
    return orderModel;
  }

  //
  Future<void> orderStatus({
    required String orderId,
    required String status,
  }) async {
    FirebaseFirestore.instance
        .collection('orders')
        .doc(orderId)
        .update({'status': status}).then((value) async {
      await fetchOrderDetails(orderId: orderId);
      await fetchOrders();
    }).catchError((e) {
      log('ERROR IS ${e.toString()}');
    });
    notifyListeners();
  }
}
*/
/*import 'dart:developer';
import 'dart:js_interop_unsafe';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/address_model.dart';
import '../models/cart_model.dart';
import '../models/order_model.dart';
import '../models/product_model.dart';
import '../models/user_data_model.dart';
import '../res/constants/constants.dart';
import '../res/services/dialogs.dart';
import '../res/services/utils.dart';
import 'home_provider.dart';
import 'order_provider.dart';
import 'user_provider.dart';

class CartProvider with ChangeNotifier {
  static CartProvider get(context, {bool listen = true}) =>
      Provider.of<CartProvider>(context, listen: listen);

  CartProvider() {
    fetchCart();
  }

  static final Map<String, CartModel> _cartMap = {};
  Map<String, CartModel> get getCartMap => _cartMap;

  List<Map<String, dynamic>> _cartList = [];
  List<Map<String, dynamic>> get getCartList => _cartList;
/*
  List<Map<String, dynamic>> _orderProductsList = [];
  List<Map<String, dynamic>> get getOrderProducts => _orderProductsList;*/

  final CollectionReference<Map<String, dynamic>> _usersCollection =
      FirebaseFirestore.instance.collection("users");
  // static final User? _user = FirebaseAuth.instance.currentUser;

  //firebase
  Future<void> addToCartFirebase({
    required String productId,
    required int quantity,
    required BuildContext context,
  }) async {
    if (Constants.user != null) {
      CartModel cartModel = CartModel(
        cartId: const Uuid().v4(),
        productId: productId,
        quantity: quantity,
      );
      _usersCollection
          .doc(Constants.user!.uid)
          .collection('cartList')
          .doc(productId)
          .set(cartModel.toFirestore())
          .then((value) async {
        await fetchCart();
        if (!context.mounted) return;
        await OrderProvider.get(context, listen: false).makeOrderProductsList();
        CustomMethods.toast(body: 'Item has been added to cart');
      }).catchError((e) {
        log('ERROR IN ADD TO CART : ${e.toString()}');
      });
    } else {
      Dialogs.warningDialog(content: 'pls, login first', context: context);
      return;
    }
    notifyListeners();
  }

  Future<List<Map<String, dynamic>>> fetchCart() async {
    if (Constants.user != null) {
      await _usersCollection
          .doc(Constants.user!.uid)
          .collection('cartList')
          .get()
          .then((value) {
        _cartList.clear();
        _cartList = value.docs.map((doc) => doc.data()).toList();
        for (var element in _cartList) {
          _cartMap.putIfAbsent(
            element['productId'],
            () {
              return CartModel.fromFirestore(element);
            },
          );
        }
        /* _orderProductsList.clear();
        _orderProductsList =
            value.docs.map((DocumentSnapshot<Map<String, dynamic>> doc) {
          return {

            'productId': doc.get('productId'),
            'quantity': doc.get('quantity'),
          };
        }).toList();*/
        log('fetchCart success : ${_cartMap.values.toString()}');
      }).catchError((e) {
        log('Error fetching cart: $e');
      });
    } else {
      log('no user fetchCart :${Constants.user}');
    }
    notifyListeners();
    return _cartList;
  }

/*  Stream<List<CartModel>>? fetchCartStream() {
    List<CartModel> carts = [];
    if (Constants.user!= null) {
      try {
        return _usersCollection
            .doc(Constants.user!.uid)
            .collection('cartList')
            .snapshots()
            .map((event) {
          carts.clear();
          carts = event.docs.map((e) {
            return CartModel.fromFirestore(e);
          }).toList();
/*
          for (var element in carts) {
            _cartMap.putIfAbsent(
              element['productId'],
              () {
                return CartModel.fromFirestore(element);
              },
            );
          }
*/
          log('fetchCart success : ${_cartMap.values.toString()}');
          return carts;
        });
      } catch (e) {
        log('Error fetching cart: $e');
        rethrow;
      }
    } else {
      log('no user fetchCart :${Constants.user');
      return null;
    }
  }
*/
  Future<void> removeFromCart({
    required String productId,
    required BuildContext context,
  }) async {
    try {
      Dialogs.warningDialog(
        content: 'Sure to delete!',
        accept: () async {
          await _usersCollection
              .doc(Constants.user!.uid)
              .collection('cartList')
              .doc(productId)
              .delete()
              .then((value) async {
            CustomMethods.popNavigate(context);
            CustomMethods.toast(body: 'removed');
            _cartMap.remove(productId);
            await fetchCart();
          }).catchError((e) {
            log('ERROR IN REMOVE ITEM : $e');
          });
          notifyListeners();
        },
        context: context,
      );
    } catch (e) {
      log('err in removeFromCart : $e');
    }
  }

  Future<void> deleteCartData(BuildContext context) async {
    final CollectionReference<Map<String, dynamic>> subCollectionReference =
        _usersCollection.doc(Constants.user!.uid).collection('cartList');
    final QuerySnapshot<Map<String, dynamic>> subCollectionSnapshot =
        await subCollectionReference.get();
    final WriteBatch batch = FirebaseFirestore.instance.batch();

    try {
      for (var doc in subCollectionSnapshot.docs) {
        batch.delete(doc.reference);
      }
    } catch (e) {
      log('err in deleteCartData : $e');
    }

    await batch.commit();
    _cartMap.clear();
    await fetchCart();
    if (!context.mounted) return;
    CustomMethods.popNavigate(context);
  }

/*
  AddressModel? addressModel;
  Future<void> makeOrder({required BuildContext context}) async {
    String orderId = const Uuid().v4();
    UserProvider userProvider = UserProvider.get(context, listen: false);
    HomeProvider homeProvider = HomeProvider.get(context, listen: false);
    if (Constants.user != null) {
      UserModel? getUser = userProvider.getUserModel!;
      //
      OrderModel orderModel = OrderModel(
        orderId: orderId,
        userId: getUser.uId,
        userName: getUser.userName,
        userPhone: getUser.phone,
        vat: _vat,
        subTotal: getSubTotal(homeProvider: homeProvider),
        totalDiscount: getTotalDiscount(homeProvider: homeProvider),
        cost: getCost(homeProvider: homeProvider),
        paymentMethod: 'Cash',
        date: Timestamp.now(),
        status: 'waiting',
        products: _orderProductsList,
        address: addressModel!,
      );
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId)
          .set(orderModel.toFirestore())
          .then((value) {
        deleteCartData(context);
        CustomMethods.toast(body: 'Order sent');
      }).catchError((e) {
        log('err in makeOrder : $e');
      });
    } else {
      log('no user makeOrder :${Constants.user}');
      return;
    }
    notifyListeners();
  }
*/

  Future<int> updateQuantity({
    required int quantity,
    required String productId,
    required String cartId,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(Constants.user!.uid)
          .collection("cartList")
          .doc(productId)
          .update({"quantity": quantity}).then((value) {
        updateLocalQuantity(
          cartId: cartId,
          productId: productId,
          quantity: quantity,
        );
        fetchCart();
      });
    } catch (e) {
      log('err in increase quantity : $e');
    }
    notifyListeners();
    return quantity;
  }

  //local
  bool inCart({required String productId}) {
    return _cartMap.containsKey(productId);
  }

  Future<Map<String, CartModel>> updateLocalQuantity({
    required String cartId,
    required String productId,
    required int quantity,
  }) async {
    try {
      _cartMap.update(
        productId,
        (item) => CartModel(
          cartId: item.cartId,
          productId: productId,
          quantity: quantity,
        ),
      );
      log('quantity updated locally');
    } catch (e) {
      log('err in updateLocalQuantity : $e');
    }
    notifyListeners();
    return _cartMap;
  }

  double getSubTotal({required HomeProvider homeProvider}) {
    double subTotal = 0.0;
    try {
      _cartMap.forEach((key, value) {
        ProductModel? product =
            homeProvider.getProductById(productId: value.productId!);
        product != null
            ? subTotal += product.oldPrice * value.quantity!.toDouble()
            : null;
      });
    } catch (e) {
      log('err in getSubTotal : $e');
    }
    return subTotal;
  }

  int _vat = 0;
  int get getVat => _vat;
  Future<int> getDeliveryFee() async {
    DocumentSnapshot<Map<String, dynamic>> userDoc =
        await FirebaseFirestore.instance.collection('vat').doc('vat').get();
    try {
      _vat = userDoc.get('vat');
    } catch (e) {
      log('err in vat $e');
    }
    notifyListeners();
    return _vat;
  }

  double getTotalDiscount({required HomeProvider homeProvider}) {
    double totalDiscount = 0.0;
    try {
      _cartMap.forEach((key, value) {
        ProductModel? product =
            homeProvider.getProductById(productId: value.productId!);
        product != null
            ? totalDiscount += product.discount *
                (product.oldPrice / 100) *
                value.quantity!.toDouble()
            : null;
      });
    } catch (e) {
      log('err in getTotalDiscount $e');
    }
    return totalDiscount;
  }

  double getCost({required HomeProvider homeProvider}) {
    double total = 0.0;
    try {
      _cartMap.forEach((key, value) {
        ProductModel? product =
            homeProvider.getProductById(productId: value.productId!);
        product != null
            ? total += product.price * value.quantity!.toDouble()
            : null;
      });
    } catch (e) {
      log('err in getCost $e');
    }
    return _cartMap.isNotEmpty ? total + _vat : total;
  }

  int getQuantity() {
    int totalQuantity = 0;
    try {
      _cartMap.forEach((key, value) {
        totalQuantity += value.quantity!;
      });
    } catch (e) {
      log('err in getQuantity $e');
    }
    return totalQuantity;
  }

  Map<String, CartModel> clearLocalCart() {
    try {
      _cartMap.clear();
    } catch (e) {
      log('err un clear local cart $e');
    }
    notifyListeners();
    return _cartMap;
  }
/*
  void removeFromCart({required String productId}) {
    _cartItems.remove(productId);
    CustomMethods.toast(body: 'Deleted');

    notifyListeners();
  }
*/
}
*/
/**/

/*
class _CheckoutPageState extends State<CheckoutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "PayPal Checkout",
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: Center(
        child: TextButton(
          onPressed: () async {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => PaypalCheckout(
                sandboxMode: true,
                clientId: "",
                secretKey: "",
                returnURL: "success.snippetcoder.com",
                cancelURL: "cancel.snippetcoder.com",
                transactions: const [
                  {
                    "amount": {
                      "total": '70',
                      "currency": "USD",
                      "details": {
                        "subtotal": '70',
                        "shipping": '0',
                        "shipping_discount": 0
                      }
                    },
                    "description": "The payment transaction description.",
                    // "payment_options": {
                    //   "allowed_payment_method":
                    //       "INSTANT_FUNDING_SOURCE"
                    // },
                    "item_list": {
                      "items": [
                        {
                          "name": "Apple",
                          "quantity": 4,
                          "price": '5',
                          "currency": "USD"
                        },
                        {
                          "name": "Pineapple",
                          "quantity": 5,
                          "price": '10',
                          "currency": "USD"
                        }
                      ],

                      // shipping address is not required though
                      //   "shipping_address": {
                      //     "recipient_name": "Raman Singh",
                      //     "line1": "Delhi",
                      //     "line2": "",
                      //     "city": "Delhi",
                      //     "country_code": "IN",
                      //     "postal_code": "11001",
                      //     "phone": "+00000000",
                      //     "state": "Texas"
                      //  },
                    }
                  }
                ],
                note: "Contact us for any questions on your order.",
                onSuccess: (Map params) async {
                  print("onSuccess: $params");
                },
                onError: (error) {
                  print("onError: $error");
                  Navigator.pop(context);
                },
                onCancel: () {
                  print('cancelled:');
                },
              ),
            ));
          },
          style: TextButton.styleFrom(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            shape: const BeveledRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(1),
              ),
            ),
          ),
          child: const Text('Checkout'),
        ),
      ),
    );
  }
}
*/
