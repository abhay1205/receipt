import 'package:recieptStore/models/appState.dart';
import 'package:recieptStore/redux/actions.dart';

AppState appReducer(state, action) {
  return AppState(
      // user: userReducer(state.user, action
      name: nameReducer(state.name,action),
      email: emailReducer(state.email, action)
  );
}

nameReducer(name, action) {
  if (action is GetNameAction) {
    return action.name;
  }
  return name;
}

emailReducer(email, action) {
  if (action is GetEmailAction) {
    return action.email;
  }
  return email;
}


