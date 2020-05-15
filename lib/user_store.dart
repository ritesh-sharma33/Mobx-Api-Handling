
import 'package:mobx/mobx.dart';
import 'package:mobx_api_handling/network_service.dart';
import 'package:mobx_api_handling/user.dart';

part 'user_store.g.dart';


class UserStore = _UserStore with _$UserStore;

abstract class _UserStore with Store {
  
  final NetworkService httpClient = NetworkService();
  List<User> users = List();

  @observable
  ObservableFuture<List<User>> userListFuture;

  @action
  Future fetchUsers() => userListFuture = ObservableFuture(httpClient.getData('https://reqres.in/api/users?page=1').then((json) {
    users = (json['data'] as List).map((data) {
      return User.fromJSON(data);
    });

    print(users);

    return users;
  }));

  void getTheUsers() {
    fetchUsers();
  }
}