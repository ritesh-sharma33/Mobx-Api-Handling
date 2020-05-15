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
            case FutureStatus.rejected:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Failed to load items.',
                      style: TextStyle(color: Colors.red),
                    ),
                    SizedBox(height: 10,),
                    RaisedButton(
                      child: const Text('Tap to retry'),
                      onPressed: _refresh,
                    )
                  ],
                ),
              );
            case FutureStatus.fulfilled:
              final List<User> users = future.result;
              return RefreshIndicator(
                onRefresh: _refresh,
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return ListTile(
                      leading: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: NetworkImage(user.avatar),
                            fit: BoxFit.cover
                          )
                        ),
                      ),
                      title: Text(
                        user.name,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      subtitle: Text(
                        user.email,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      trailing: Text(
                        user.id,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20
                        ),
                      ),
                    );
                  },
                ),
              );
          }
        },
      ),
    );
  }

  Future _refresh() => store.fetchUsers();
}
