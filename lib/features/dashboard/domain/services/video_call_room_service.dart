import '../../../../core/network/api_config.dart';

class VideoCallRoomService {
  const VideoCallRoomService();

  Uri roomUrlFor({
    required String callerName,
    required String friendName,
  }) {
    final String roomName = [
      'linkr',
      callerName,
      friendName,
    ].map(_slug).where((part) => part.isNotEmpty).join('-');

    final Uri baseUrl = Uri.parse(ApiConfig.normalizedVideoCallBaseUrl);
    final String basePath = baseUrl.path.endsWith('/')
        ? baseUrl.path.substring(0, baseUrl.path.length - 1)
        : baseUrl.path;

    return baseUrl.replace(
      path: '$basePath/$roomName',
      queryParameters: <String, String>{
        'config.prejoinPageEnabled': 'false',
        'config.startWithAudioMuted': 'false',
        'config.startWithVideoMuted': 'false',
        'userInfo.displayName': callerName,
      },
    );
  }

  String _slug(String value) {
    return value
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-+|-+$'), '');
  }
}
