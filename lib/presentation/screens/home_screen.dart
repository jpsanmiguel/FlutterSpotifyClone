import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_clone/logic/cubit/tracks_cubit.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.title, this.color}) : super(key: key);

  final String title;
  final Color color;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var clientId = '407d613826f145328e1d271f7efc7ac5';
  var redirectUrl = 'http://example.com/callback/';

  @override
  Widget build(BuildContext homeScreenContext) {
    BlocProvider.of<TracksCubit>(context).fetchUserTopTracks();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.color,
        title: Text('Test!'),
        actions: [
          IconButton(
              icon: Icon(Icons.settings),
              onPressed: () => Navigator.pushNamed(context, '/settings')),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // BlocBuilder<InternetCubit, InternetState>(
            //   builder: (internetCubitBuilderContext, state) {
            //     if (state is InternetConnected &&
            //         state.connectionType == ConnectionType.Wifi) {
            //       return Text(
            //         'Wi-Fi',
            //         style: Theme.of(internetCubitBuilderContext)
            //             .textTheme
            //             .headline3
            //             .copyWith(
            //               color: Colors.green,
            //             ),
            //       );
            //     } else if (state is InternetConnected &&
            //         state.connectionType == ConnectionType.Mobile) {
            //       return Text(
            //         'Mobile',
            //         style: Theme.of(internetCubitBuilderContext)
            //             .textTheme
            //             .headline3
            //             .copyWith(
            //               color: Colors.red,
            //             ),
            //       );
            //     } else if (state is InternetDisconnected) {
            //       return Text(
            //         'Disconnected',
            //         style: Theme.of(internetCubitBuilderContext)
            //             .textTheme
            //             .headline3
            //             .copyWith(
            //               color: Colors.grey,
            //             ),
            //       );
            //     }
            //     return CircularProgressIndicator();
            //   },
            // ),
            Divider(
              height: 5,
            ),
            // BlocConsumer<CounterCubit, CounterState>(
            //   listener: (counterCubitListenerContext, state) {
            //     if (state.wasIncremented == true) {
            //       Scaffold.of(counterCubitListenerContext).showSnackBar(
            //         SnackBar(
            //           content: Text('Incremented!'),
            //           duration: Duration(milliseconds: 300),
            //         ),
            //       );
            //     } else if (state.wasIncremented == false) {
            //       Scaffold.of(counterCubitListenerContext).showSnackBar(
            //         SnackBar(
            //           content: Text('Decremented!'),
            //           duration: Duration(milliseconds: 300),
            //         ),
            //       );
            //     }
            //   },
            //   builder: (counterCubiBuilderContext, state) {
            //     if (state.counterValue < 0) {
            //       return Text(
            //         'BRR, NEGATIVE ' + state.counterValue.toString(),
            //         style:
            //             Theme.of(counterCubiBuilderContext).textTheme.headline4,
            //       );
            //     } else if (state.counterValue % 2 == 0) {
            //       return Text(
            //         'YAAAY ' + state.counterValue.toString(),
            //         style:
            //             Theme.of(counterCubiBuilderContext).textTheme.headline4,
            //       );
            //     } else if (state.counterValue == 5) {
            //       return Text(
            //         'HMM, NUMBER 5',
            //         style:
            //             Theme.of(counterCubiBuilderContext).textTheme.headline4,
            //       );
            //     } else
            //       return Text(
            //         state.counterValue.toString(),
            //         style:
            //             Theme.of(counterCubiBuilderContext).textTheme.headline4,
            //       );
            //   },
            // ),
            SizedBox(
              height: 24,
            ),
            // Builder(
            //   builder: (context) {
            //     final counterState = context.watch<CounterCubit>().state;
            //     final internetState = context.watch<InternetCubit>().state;

            //     if (internetState is InternetConnected &&
            //         internetState.connectionType == ConnectionType.Mobile) {
            //       return Text(
            //         'Counter: ' +
            //             counterState.counterValue.toString() +
            //             ' Internet: Mobile',
            //         style: Theme.of(context).textTheme.headline6,
            //       );
            //     } else if (internetState is InternetConnected &&
            //         internetState.connectionType == ConnectionType.Wifi) {
            //       return Text(
            //         'Counter: ' +
            //             counterState.counterValue.toString() +
            //             ' Internet: Wifi',
            //         style: Theme.of(context).textTheme.headline6,
            //       );
            //     } else {
            //       return Text(
            //         'Counter: ' +
            //             counterState.counterValue.toString() +
            //             ' Internet: Disconnected',
            //         style: Theme.of(context).textTheme.headline6,
            //       );
            //     }
            //   },
            // ),
            SizedBox(
              height: 24,
            ),
            // Builder(
            //   builder: (context) {
            //     final counterValue = context
            //         .select((CounterCubit cubit) => cubit.state.counterValue);
            //     return Text(
            //       'Counter: ' + counterValue.toString(),
            //       style: Theme.of(context).textTheme.headline6,
            //     );
            //   },
            // ),
            SizedBox(
              height: 24,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton(
                  heroTag: Text('${widget.title}'),
                  onPressed: () {
                    print("Pressed decrement");
                    // BlocProvider.of<CounterCubit>(context).decrement();
                    // context.bloc<CounterCubit>().decrement();
                  },
                  tooltip: 'Decrement',
                  child: Icon(Icons.remove),
                ),
                FloatingActionButton(
                  heroTag: Text('${widget.title} 2nd'),
                  onPressed: () {
                    print("Pressed increment");
                    // BlocProvider.of<CounterCubit>(context).increment();
                    // context.read<CounterCubit>().increment();
                  },
                  tooltip: 'Increment',
                  child: Icon(Icons.add),
                ),
              ],
            ),
            SizedBox(
              height: 24,
            ),
            Builder(
              builder: (materialButtonContext) => MaterialButton(
                color: Colors.redAccent,
                child: Text(
                  'Connect to Spotify!',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  var connected = await SpotifySdk.connectToSpotifyRemote(
                      clientId: clientId, redirectUrl: redirectUrl);

                  print('connected? $connected');
                },
              ),
            ),
            // SizedBox(
            //   height: 24,
            // ),
            MaterialButton(
              color: Colors.greenAccent,
              child: Text(
                'Get auth token!',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                var authenticationToken = await SpotifySdk.getAuthenticationToken(
                    clientId: clientId,
                    redirectUrl: redirectUrl,
                    scope: 'app-remote-control, '
                        'user-modify-playback-state, '
                        'user-library-read, '
                        'playlist-read-private, '
                        'user-top-read, '
                        'playlist-modify-public,user-read-currently-playing');

                print('authenticationToken? $authenticationToken');
              },
            ),
          ],
        ),
      ),
    );
  }
}
