import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/song.dart';

class PlaylistProvider extends ChangeNotifier {
  // playlist of songs
  final List<Song> _playlist = [
    Song(
      songName: "Swear It Again",
      artistName: "Westlife",
      albumArtImagePath: 'assets/images/cover.jpg',
      audioPath: 'audio/swear.mp3',
    ),
    Song(
      songName: "If I Let You Go",
      artistName: "Westlife",
      albumArtImagePath: 'assets/images/cover.jpg',
      audioPath: 'audio/if.flac',
    ),
    Song(
      songName: "Fool Again",
      artistName: "Westlife",
      albumArtImagePath: 'assets/images/cover.jpg',
      audioPath: 'audio/fool.flac',
    ),
    Song(
      songName: "I Want it That Way",
      artistName: "Backstreet Boys",
      albumArtImagePath: 'assets/images/cover2.jpg',
      audioPath: 'audio/02. I Want It That Way.flac',
    ),
    Song(
      songName: "Show Me the Meaning",
      artistName: "Backstreet Boys",
      albumArtImagePath: 'assets/images/cover2.jpg',
      audioPath: 'audio/03. Show Me the Meaning of Being Lonely.flac',
    ),
    Song(
      songName: "The One",
      artistName: "Backstreet Boys",
      albumArtImagePath: 'assets/images/cover2.jpg',
      audioPath: 'audio/08. The One.flac',
    )
  ];

  // current song playing
  int? _currentSongIndex;

  /* 
  
  A U D I O  P L A Y E R
  

  */

  // audio player
  final AudioPlayer _audioPlayer = AudioPlayer();

  // durations
  Duration _currentDuration = Duration.zero;
  Duration _totalDuration = Duration.zero;

  // constructor
  PlaylistProvider() {
    listenToDuration();
  }

  // initially not playing
  bool _isPlaying = false;

  // play the song
  void play() async {
    final String path = _playlist[_currentSongIndex!].audioPath;
    await _audioPlayer.stop(); // stop current song
    await _audioPlayer.play(AssetSource(path)); // play the new song
    _isPlaying = true;
    notifyListeners();
  }

  // pause current song
  void pause() async {
    await _audioPlayer.pause();
    _isPlaying = false;
    notifyListeners();
  }

  // resume
  void resume() async {
    await _audioPlayer.resume();
    _isPlaying = true;
    notifyListeners();
  }

  // pause or resume
  void pauseOrResume() async {
    if (_isPlaying) {
      pause();
    } else {
      resume();
    }
    notifyListeners();
  }

  // seek to a specific position in the current song
  void seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  // play next song
  void playNextSong() {
    if (_currentSongIndex != null) {
      if (_currentSongIndex! < _playlist.length - 1) {
        // go to the next song if its not the last song
        _currentSongIndex = _currentSongIndex! + 1;
      } else {
        // if its the last song loop back to the first song
        _currentSongIndex = 0;
      }
      play();
    }
  }

  // play previous song
  void playPreviousSong() async {
    // if more than 2 seonds have passed, restart the current song
    if (_currentDuration.inSeconds > 2) {
      play();
    }
    // othervise go the previous song
    else {
      if (currentSongIndex! > 0) {
        currentSongIndex = _currentSongIndex! - 1;
      } else {
        // if its the first song loop back to the last song
        currentSongIndex = _playlist.length - 1;
      }
      play();
    }
  }

  // listen to duration
  void listenToDuration() {
    // listen for the total duration
    _audioPlayer.onDurationChanged.listen((newDuration) {
      _totalDuration = newDuration;
      notifyListeners();
    });

    // listen for the current duration
    _audioPlayer.onPositionChanged.listen((newPosition) {
      _currentDuration = newPosition;
      notifyListeners();
    });

    // listen fo the completion
    _audioPlayer.onPlayerComplete.listen((event) {
      playNextSong();
    });
  }

  // dispose audio player

  /*
  
  G E T T E R S

  */

  List<Song> get playlist => _playlist;
  int? get currentSongIndex => _currentSongIndex;
  bool get isPlaying => _isPlaying;
  Duration get currentDuration => _currentDuration;
  Duration get totalDuration => _totalDuration;

  /*
  
  S E T T E R S

  */

  set currentSongIndex(int? newIndex) {
    // Update current song index
    _currentSongIndex = newIndex;

    if (newIndex != null) {
      play(); // play the song at the new index
    }

    // Update UI
    notifyListeners();
  }

  set isPlaying(bool isPlaying) {
    _isPlaying = isPlaying;
  }
}
