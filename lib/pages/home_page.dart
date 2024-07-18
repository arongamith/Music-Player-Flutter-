import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/my_drawer.dart';
import 'package:flutter_application_1/models/playlist_provider.dart';
import 'package:flutter_application_1/models/song.dart';
import 'package:flutter_application_1/pages/song_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // get the playlist provider
  late final dynamic playlistProvider;

  @override
  void initState() {
    super.initState();

    // get playlist provider
    playlistProvider = Provider.of<PlaylistProvider>(context, listen: false);
  }

  // go to a song
  void goToSong(int songIndex) {
    // update current song index
    playlistProvider.currentSongIndex = songIndex;

    // navigate to song page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SongPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(title: const Text("P L A Y L I S T")),
      drawer: const MyDrawer(),
      body: Consumer<PlaylistProvider>(
        builder: (context, value, child) {
          // get the playlist
          final List<Song> playlist = value.playlist;

          //return List View UI
          return ListView.builder(
            itemCount: playlist.length,
            itemBuilder: (context, index) {
              // get individual song
              final Song song = playlist[index];

              // determine play or pause icon to display
              IconData? trailingIcon;
              if (playlistProvider.currentSongIndex == index) {
                trailingIcon = playlistProvider.isPlaying
                    ? Icons.play_circle_outline
                    : Icons.pause_circle_outline;
              }

              // return List Tile UI
              return ListTile(
                title: Text(
                  song.songName,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: Text(song.artistName),
                leading: Image.asset(song.albumArtImagePath),
                trailing: trailingIcon != null ? Icon(trailingIcon) : null,
                onTap: () {
                  if (playlistProvider.currentSongIndex == index &&
                      playlistProvider.currentDuration.inSeconds > 0) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SongPage(),
                      ),
                    );
                  } else {
                    playlistProvider.isPlaying = false;
                    goToSong(index);
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
