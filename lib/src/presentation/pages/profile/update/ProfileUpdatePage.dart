import 'package:ecommerce_flutter/src/domain/models/User.dart';
import 'package:ecommerce_flutter/src/domain/utils/Resource.dart';
import 'package:ecommerce_flutter/src/presentation/pages/profile/info/bloc/ProfileInfoBloc.dart';
import 'package:ecommerce_flutter/src/presentation/pages/profile/info/bloc/ProfileInfoEvent.dart';
import 'package:ecommerce_flutter/src/presentation/pages/profile/update/ProfileUpdateContent.dart';
import 'package:ecommerce_flutter/src/presentation/pages/profile/update/bloc/ProfileUpdateBloc.dart';
import 'package:ecommerce_flutter/src/presentation/pages/profile/update/bloc/ProfileUpdateEvent.dart';
import 'package:ecommerce_flutter/src/presentation/pages/profile/update/bloc/ProfileUpdateState.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProfileUpdatePage extends StatefulWidget {
  const ProfileUpdatePage({super.key});

  @override
  State<ProfileUpdatePage> createState() => _ProfileUpdatePageState();
}

class _ProfileUpdatePageState extends State<ProfileUpdatePage> {
  ProfileUpdateBloc? _bloc;
  User? user;

  @override
  void initState() { // UNA VEZ 
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) { // PANTALLA CARGADA
      _bloc?.add(ProfileUpdateInitEvent(user: user));  
    });
    
  }

  @override
  Widget build(BuildContext context) { // DESPUES DEL INIT // VARIAS VECES
    _bloc = BlocProvider.of<ProfileUpdateBloc>(context);
    user = ModalRoute.of(context)?.settings.arguments as User;
    return Scaffold(
      body: BlocListener<ProfileUpdateBloc, ProfileUpdateState>(
        listener: (context, state) {
          final responseState = state.response;
          if (responseState is Error) {
            _showToast(context, responseState.message);
          }
          else if (responseState is Success) {
            User user = responseState.data as User;
            _bloc?.add(ProfileUpdateUpdateUserSession(user: user));
            Future.delayed(Duration(seconds: 1), () {
              context.read<ProfileInfoBloc>().add(ProfileInfoGetUser()); 
            });
            _showToast(context, 'Actualizacion exitosa');
          }
        },
        child: BlocBuilder<ProfileUpdateBloc, ProfileUpdateState>(
          builder: (context, state) {
            final responseState = state.response;
              if (responseState is Loading) {
                return Stack(
                  children: [
                    ProfileUpdateContent(_bloc, state, user),
                    Center(child: CircularProgressIndicator())
                  ],
                );
              }
            return ProfileUpdateContent(_bloc, state, user);
          },
        ),
      )
    );
  }

  Future<void> _showToast(BuildContext context, String message) async {
    try {
      await Fluttertoast.showToast(msg: message, toastLength: Toast.LENGTH_LONG);
    } on MissingPluginException {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    }
  }
}
