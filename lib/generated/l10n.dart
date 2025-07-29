import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class S {
  static const S instance = S._();
  const S._();

  static S of(BuildContext context) => S.instance;

  String get playlists => 'Playlists';
  String get create_playlist => 'Create Playlist';
  String get delete => 'Delete';
  String get cancel => 'Cancel';
  String get confirm => 'Confirm';
  String get empty_playlists => 'No playlists yet';
  String get create_first_playlist => 'Create your first playlist';
  String get edit => 'Edit';
  String get save => 'Save';
  String get playlist_name => 'Playlist Name';
  String get add_media => 'Add Media';
  String get remove => 'Remove';
  String get no_media => 'No media files in this playlist';
}
