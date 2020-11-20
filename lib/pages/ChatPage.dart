import 'package:duyvo/models/Address.dart';
import 'package:flutter/material.dart';

import 'api.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  bool isLoading = false;
  List<Address> provices = List();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() => isLoading = true);
      await Api().getAllProvincesOfVietNam(onSuccess: (values) {
        setState(() {
          isLoading = false;
          provices = values;
        });
      }, onError: (msg) {
        setState(() => isLoading = false);
        print(msg);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "PROVINCES OF VIET NAM",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        elevation: 0,
        actionsIconTheme: IconThemeData(color: Colors.black),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: isLoading
          ? Center(
              child: Text("loading..."),
            )
          : provices.isEmpty
              ? Center(
                  child: Text("empty"),
                )
              : ListView(
                  children: provices.map((province) {
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                      color: Colors.blueGrey[200],
                      child: Text(province.name),
                    );
                  }).toList(),
                ),
    );
  }
  // List<bool> numberTruthList = [true, true, true, true, true, true];
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       centerTitle: true,
  //       title: Text(
  //         "DuyVo",
  //         style: TextStyle(color: Colors.black),
  //       ),
  //       backgroundColor: Colors.white,
  //       brightness: Brightness.light,
  //       elevation: 0,
  //       actionsIconTheme: IconThemeData(color: Colors.black),
  //       iconTheme: IconThemeData(color: Colors.black),
  //       actions: <Widget>[
  //         IconButton(icon: Icon(Icons.more_vert_outlined), onPressed: () {})
  //       ],
  //     ),
  //     body: Stack(
  //       children: <Widget>[
  //         ListView.builder(
  //           itemCount: 5,
  //           itemBuilder: (context, i) {
  //             return numberTruthList[i]
  //                 ? ListTile(title: Text(numberTruthList[i].toString()))
  //                 : Container();
  //           },
  //           shrinkWrap: true,
  //           padding: EdgeInsets.only(top: 10, bottom: 10),
  //           physics: NeverScrollableScrollPhysics(),
  //         ),
  //         Align(
  //           alignment: Alignment.bottomLeft,
  //           child: Container(
  //             padding: EdgeInsets.only(left: 16, bottom: 10),
  //             height: 80,
  //             width: double.infinity,
  //             color: Colors.white,
  //             child: Row(
  //               children: <Widget>[
  //                 GestureDetector(
  //                   onTap: () {},
  //                   child: Container(
  //                     height: 40,
  //                     width: 40,
  //                     decoration: BoxDecoration(
  //                       color: Colors.blueGrey,
  //                       borderRadius: BorderRadius.circular(30),
  //                     ),
  //                     child: Icon(
  //                       Icons.add,
  //                       color: Colors.white,
  //                       size: 21,
  //                     ),
  //                   ),
  //                 ),
  //                 SizedBox(
  //                   width: 16,
  //                 ),
  //                 Expanded(
  //                   child: TextField(
  //                     decoration: InputDecoration(
  //                       hintText: "Type message ...",
  //                       hintStyle: TextStyle(color: Colors.grey.shade500),
  //                       border: InputBorder.none,
  //                     ),
  //                   ),
  //                 ),
  //                 Align(
  //                   alignment: Alignment.bottomRight,
  //                   child: Container(
  //                     height: 54,
  //                     padding: EdgeInsets.only(right: 20, bottom: 15),
  //                     child: FloatingActionButton(
  //                       onPressed: () {},
  //                       child: Icon(
  //                         Icons.send,
  //                         color: Colors.white,
  //                         size: 21,
  //                       ),
  //                       backgroundColor: Colors.black,
  //                       elevation: 0,
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }
}

//       body: FlatPageWrapper(
//         scrollType: ScrollType.floatingHeader,
//         reverseBodyList: true,
//         header: FlatPageHeader(
//           prefixWidget: FlatActionButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//           ),
//           title: 'Duy Vo',
//           suffixWidget: FlatProfileImage(
//             size: 35.0,
//             onlineIndicator: true,
//             imageUrl: 'assets/nancy.jpg',
//             onPressed: () {
//               print("Click Profile Image");
//             },
//           ),
//         ),
//         children: [
//           FlatChatMessage(
//             message: "Hello World!, This is the first message.",
//             messageType: MessageType.sent,
//             showTime: true,
//             time: "2 mins ago",
//           ),
//           FlatChatMessage(
//             message: "Typing another message from the input box.",
//             messageType: MessageType.sent,
//             showTime: true,
//             time: "2 mins ago",
//           ),
//           FlatChatMessage(
//             message: "Message Length Small.",
//             showTime: true,
//             time: "2 mins ago",
//           ),
//           FlatChatMessage(
//             message:
//                 "Message Length Large. This message has more text to configure the size of the message box.",
//             showTime: true,
//             time: "2 mins ago",
//           ),
//           FlatChatMessage(
//             message: "Meet me tomorrow at the coffee shop.",
//             showTime: true,
//             time: "2 mins ago",
//           ),
//           FlatChatMessage(
//             message: "Around 11 o'clock.",
//             showTime: true,
//             time: "2 mins ago",
//           ),
//           FlatChatMessage(
//             message:
//                 "Flat Social UI kit is going really well. Hope this finishes soon.",
//             showTime: true,
//             time: "2 mins ago",
//           ),
//           FlatChatMessage(
//             message: "Final Message in the list.",
//             showTime: true,
//             time: "2 mins ago",
//           ),
//         ],
//         footer: FlatMessageInputBox(
//           prefix: FlatActionButton(
//             iconData: Icons.add,
//             iconSize: 24.0,
//           ),
//           roundedCorners: true,
//           suffix: FlatActionButton(
//             iconData: Icons.image,
//             iconSize: 24.0,
//           ),
//         ),
//       ),
//     );
//   }
// }
