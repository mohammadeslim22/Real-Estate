import 'package:flutter/material.dart';

class Account extends StatefulWidget {
  Account({Key key}) : super(key: key);

  @override
  AccountState createState() => AccountState();
}

class AccountState extends State<Account> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: true, title: Text("مسكن")),
      body: ListView(
        shrinkWrap: true,
        children: [
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("أهلا وسهلا",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              )),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text("عمليات بحث محفوظة", style: TextStyle(fontSize: 24)),
                const SizedBox(width: 24),
                Icon(Icons.star, size: 36)
              ],
            ),
          ),
          Divider(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text("العقارات المفضلة", style: TextStyle(fontSize: 24)),
                const SizedBox(width: 24),
                Icon(Icons.favorite, size: 36)
              ],
            ),
          ),
          Divider(),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("خيارات الحساب",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              )),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text("تغيير كلمة المرور", style: TextStyle(fontSize: 24)),
                const SizedBox(width: 0),
                Icon(Icons.star, size: 36)
              ],
            ),
          ),
          Divider(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text("تسجيل الخروج", style: TextStyle(fontSize: 24)),
                const SizedBox(width: 0),
                Icon(Icons.favorite, size: 36)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
