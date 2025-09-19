/*class Responsive extends StatelessWidget {
  final Widget mobile;
  const Responsive({required this.mobile});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final screenSize = constraints.maxWidth;
      if (screenSize <= 375) {
        return mobile;
      } else if (screenSize > 375 && screenSize < 601) {
        return mobile;
      } else if (screenSize >= 601 && screenSize < 1024) {
        return NoSupportView();
      } else if (screenSize >= 1024) {
        return NoSupportView();
      } else {
        return NoSupportView();
      }
    });
  }
}*/
