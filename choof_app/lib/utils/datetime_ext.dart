extension dateTimeExtension on DateTime {
  String getTimeAgo() {
    final currentTime = DateTime.now();
    final difference = currentTime.difference(this);

    if ((difference.inDays / 7).floor() == 1) {
      return "${(difference.inDays / 7).floor()} week ago";
    } else if ((difference.inDays / 7).floor() > 1) {
      return "${(difference.inDays / 7).floor()} weeks ago";
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays >= 2) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours == 1) {
      return '${difference.inHours} hour ago';
    } else if (difference.inHours > 1) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes == 1) {
      return '${difference.inMinutes} minute ago';
    } else if (difference.inMinutes > 1) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inSeconds == 1) {
      return "${difference.inSeconds} seconds ago";
    } else if (difference.inSeconds > 1) {
      return "${difference.inSeconds} seconds ago";
    } else {
      return 'Just now';
    }
  }
}
