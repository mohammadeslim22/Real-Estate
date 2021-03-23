import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_estate/constants/colors.dart';
import 'package:real_estate/providers/auth.dart';


class Account extends StatefulWidget {
  Account({Key key}) : super(key: key);

  @override
  AccountState createState() => AccountState();
}

class AccountState extends State<Account> {
  @override
  Widget build(BuildContext context) {
    final Auth auth = Provider.of<Auth>(context);
    return Scaffold(
      backgroundColor: colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Text("مسكن"),
        backgroundColor: colors.white,
      ),
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
          InkWell(
              child: Padding(
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
              onTap: () {}),
          Divider(),
          InkWell(
            child: Padding(
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
            onTap: () {},
          ),
              Divider(),
          InkWell(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("عقاراتي", style: TextStyle(fontSize: 24)),
                  const SizedBox(width: 24),
                  Icon(Icons.home, size: 36)
                ],
              ),
            ),
            onTap: () {Navigator.pushNamed(context,"/MyProps");},
          ),
          Divider(),
          InkWell(
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("خيارات الحساب",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ))),
          InkWell(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("تغيير كلمة المرور", style: TextStyle(fontSize: 24)),
                  const SizedBox(width: 0),
                  Icon(Icons.change_history_sharp, size: 36)
                ],
              ),
            ),
            onTap: () {},
          ),
          Divider(),
          InkWell(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("تسجيل الخروج", style: TextStyle(fontSize: 24)),
                  const SizedBox(width: 0),
                  Icon(Icons.logout, size: 36)
                ],
              ),
            ),
            onTap: () async {
              await auth.signOut();
            },
          ),
          
        ],
      ),
    );
  }
}
