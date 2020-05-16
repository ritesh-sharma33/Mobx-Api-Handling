import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:mobx_api_handling/user.dart';
import 'package:mobx_api_handling/user_store.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final UserStore store = UserStore();

  @override
  void initState() {
    store.getTheUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MobX API Demo"),
      ),
      body: Observer(
        builder: (_) {
          final future = store.userListFuture;
          switch (future.status) {
            case FutureStatus.pending:
              return Center(
                child: CircularProgressIndicator(),
              );
            case FutureStatus.fulfilled:
              final List<User> users = future.result;
              print(users);
              return RefreshIndicator(
                onRefresh: _refresh,
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(user.avatar),
                        radius: 25,
                      ),
                      title: Text(
                        user.name,
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        user.email,
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w400),
                      ),
                      trailing: Text(
                        user.id,
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 20),
                      ),
                    );
                  },
                ),
              );
            case FutureStatus.rejected:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Failed to load items.',
                      style: TextStyle(color: Colors.red),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    RaisedButton(
                      child: const Text('Tap to retry'),
                      onPressed: _refresh,
                    )
                  ],
                ),
              );
              break;
          }
        },
      ),
    );
  }

  Future _refresh() => store.fetchUsers();
}
