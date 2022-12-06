part of 'rooms_cubit.dart';

import 'package:chat_app/core/models/profile.dart';

@immutable
abstract class RoomState {}

class RoomsLoading extends RoomState {}

class RoomsLoaded extends RoomState {
  final List<Profile> newUsers;
  final List<Room> rooms;

  RoomsLoaded({
    required this.rooms,
    required this.newUsers
  });
}

class RoomsEmpty extends RoomState {
  final List<Profile> newUsers;

  RoomsEmpty({required this.newUsers});
}

class RoomError extends RoomState {
  final String message;

  RoomError(this.message);
}