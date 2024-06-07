import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//tells the system to run the app
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
// this second section describes the build off the app
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(

      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Twitchio',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 43, 43, 64)),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  var favourites = <WordPair>[];

  void toggleFavourites(){
    if (favourites.contains(current)){
      favourites.remove(current);
    }else{
      favourites.add(current);

    }
    notifyListeners();
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair= appState.current;

    return Scaffold(
      body: Center(
        child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BigCard(pair: pair),
            SizedBox(height: 20),
            Text("I am God's child"),
             CardButton(appState: appState),
          ],
        ),
      ),
    );
  }
}

class CardButton extends StatelessWidget {
  const CardButton({
    super.key,
    required this.appState,
  });

  final MyAppState appState;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardstyle = theme.textTheme.bodySmall!.copyWith(color: theme.colorScheme.onSecondary);
    final isFavorite = appState.favourites.contains(appState.current);
    final labelText = isFavorite ? 'Unlike' : 'Like';
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(onPressed: (){
          appState.toggleFavourites();
        },  icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: Colors.red,),),
            Text(labelText, style: TextStyle(color: theme.colorScheme.secondary),),
            SizedBox(width: 20,),
        ElevatedButton(
         style: ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(255, 0, 0, 0)),
         onPressed: () {
           appState.getNext(); 
         },
         child: Text('next', style: cardstyle,),
         ),
      ],
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style =theme.textTheme.displayLarge!.copyWith(color: theme.colorScheme.onPrimary);
    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(pair.asPascalCase, style: style, semanticsLabel: "${pair.first} ${pair.second}",), 
      ),
    );
  }
}