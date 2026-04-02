import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/video_player_widget.dart';
import '../../services/youtube_service.dart';
import 'dart:ui';
import '../auth/login_page.dart';
import '../../widgets/login_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey _homeKey = GlobalKey();
  final GlobalKey _tutorialKey = GlobalKey();
  final GlobalKey _aboutKey = GlobalKey();

  bool _isLoggedIn = false;
  String _userEmail = "";

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
      _userEmail = prefs.getString('userEmail') ?? "";
    });
    if (_isLoggedIn) {
      print("👤 [HOME] User is logged in: $_userEmail");
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await prefs.remove('userEmail');
    setState(() {
      _isLoggedIn = false;
      _userEmail = "";
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Logged out successfully")),
    );
  }

  void _scrollTo(GlobalKey key) {
    Scrollable.ensureVisible(
      key.currentContext!,
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0B1220), Color(0xFF111C2E), Color(0xFF16263F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          automaticallyImplyLeading: false, // 👈 Ensures no back button appears
          backgroundColor: Colors.black.withOpacity(0.2),
          elevation: 0,
          toolbarHeight: 100,
          titleSpacing: 40,
          title: SizedBox(
            height: 90,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Blurred glow layer
                ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  child: Image.asset(
                    'assets/images/ytt.png',
                    height: 90,
                    color: const Color(0xFF3B82F6).withOpacity(0.7),
                    colorBlendMode: BlendMode.srcATop,
                  ),
                ),
                // Original sharp logo
                Image.asset('assets/images/ytt.png', height: 90),
              ],
            ),
          ),
          actions: [
            NavItem("Home", onTap: () => _scrollTo(_homeKey)),
            NavItem("Tutorials", onTap: () => _scrollTo(_tutorialKey)),
            NavItem("About", onTap: () => _scrollTo(_aboutKey)),
            
            /// Conditional Auth Widget
            if (!_isLoggedIn)
              NavItem("Login", onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                ).then((_) => _checkLoginStatus()); // Refresh on return
              })
            else
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: PopupMenuButton<String>(
                  offset: const Offset(0, 60),
                  onSelected: (value) {
                    if (value == 'logout') _logout();
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      enabled: false,
                      child: Text(
                        _userEmail,
                        style: const TextStyle(color: Colors.white38, fontSize: 13),
                      ),
                    ),
                    const PopupMenuDivider(),
                    const PopupMenuItem(
                      value: 'logout',
                      child: Row(
                        children: [
                          Icon(Icons.logout, color: Colors.redAccent, size: 20),
                          SizedBox(width: 12),
                          Text("Logout", style: TextStyle(color: Colors.redAccent)),
                        ],
                      ),
                    ),
                  ],
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF3B82F6), width: 2),
                      boxShadow: [
                        BoxShadow(color: const Color(0xFF3B82F6).withOpacity(0.3), blurRadius: 10),
                      ],
                    ),
                    child: const CircleAvatar(
                      backgroundColor: Color(0xFF1E293B),
                      radius: 20,
                      child: Icon(Icons.person, color: Color(0xFF3B82F6), size: 24),
                    ),
                  ),
                ),
              ),
            const SizedBox(width: 40),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              /////////////////////////////////////////////////////////////
              /// HERO SECTION
              /////////////////////////////////////////////////////////////
              Container(
                key: _homeKey,
                padding: const EdgeInsets.symmetric(
                  horizontal: 120,
                  vertical: 140,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Your Technical Tutorial",
                            style: Theme.of(context).textTheme.headlineLarge
                                ?.copyWith(
                                  fontSize: 56,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: -1,
                                  shadows: [
                                    Shadow(
                                      color: const Color(
                                        0xFF3B82F6,
                                      ).withOpacity(0.25),
                                      blurRadius: 25,
                                    ),
                                  ],
                                ),
                          ),
                          const SizedBox(height: 30),
                          Text(
                            "Where Ideas Become Code.",
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(fontSize: 20, color: Colors.white70),
                          ),
                          const SizedBox(height: 60),
                          HoverButton(
                            text: "Explore Tutorials",
                            onPressed: () => _scrollTo(_tutorialKey),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 80),
                    Expanded(child: Center(child: _HoverVideoCard())),
                  ],
                ),
              ),

              const SizedBox(height: 150),

              /////////////////////////////////////////////////////////////
              /// YOUTUBE TUTORIAL SECTION
              /////////////////////////////////////////////////////////////
              Container(
                color: const Color(0xFF0F1B2D),
                padding: const EdgeInsets.symmetric(
                  horizontal: 120,
                  vertical: 100,
                ),
                child: const YouTubeGridSection(),
              ),

              const SizedBox(height: 150),

              /////////////////////////////////////////////////////////////
              /// ABOUT SECTION
              /////////////////////////////////////////////////////////////
              Container(
                key: _aboutKey,
                padding: const EdgeInsets.symmetric(horizontal: 120),
                child: const AboutSection(),
              ),

              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }
}

//////////////////////////////////////////////////////////////
// NAV ITEM
//////////////////////////////////////////////////////////////

class NavItem extends StatefulWidget {
  final String title;
  final VoidCallback onTap;

  const NavItem(this.title, {required this.onTap, super.key});

  @override
  State<NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<NavItem> {
  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: GestureDetector(
        onTap: widget.onTap,
        child: MouseRegion(
          onEnter: (_) => setState(() => isHovering = true),
          onExit: (_) => setState(() => isHovering = false),
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: isHovering ? const Color(0xFF93C5FD) : Colors.white70,
            ),
            child: Text(widget.title),
          ),
        ),
      ),
    );
  }
}

//////////////////////////////////////////////////////////////
// YOUTUBE GRID SECTION
//////////////////////////////////////////////////////////////

class YouTubeGridSection extends StatefulWidget {
  const YouTubeGridSection({super.key});

  @override
  State<YouTubeGridSection> createState() => _YouTubeGridSectionState();
}

class _YouTubeGridSectionState extends State<YouTubeGridSection> {
  List<dynamic> videos = [];
  bool isLoading = true;

  int currentPage = 0;
  final int videosPerPage = 4;

  @override
  void initState() {
    super.initState();
    loadVideos();
  }

  Future<void> loadVideos() async {
    setState(() => isLoading = true);

    /// Fetch more videos to compensate filtering
    final data = await YouTubeService.fetchVideos(maxResults: 15);

    setState(() {
      videos = data['items'];
      isLoading = false;
      currentPage = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 80),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    /// Manual Pagination Logic
    final startIndex = currentPage * videosPerPage;
    final endIndex = (startIndex + videosPerPage > videos.length)
        ? videos.length
        : startIndex + videosPerPage;

    final currentVideos = videos.sublist(startIndex, endIndex);

    return Column(
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            int crossAxisCount = 2;

            if (constraints.maxWidth < 900) {
              crossAxisCount = 1;
            }

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: currentVideos.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 28,
                mainAxisSpacing: 28,
                childAspectRatio: 16 / 12,
              ),
              itemBuilder: (context, index) {
                final video = currentVideos[index];
                final title = video['snippet']['title'];
                final thumbnail =
                    video['snippet']['thumbnails']['maxres']?['url'] ??
                    video['snippet']['thumbnails']['high']['url'];
                final videoId = video['id']?['videoId'] ?? '';

                return YouTubeCard(
                  title: title,
                  thumbnail: thumbnail,
                  videoId: videoId,
                );
              },
            );
          },
        ),

        const SizedBox(height: 60),

        /// Clean Manual Pagination Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (currentPage > 0)
              _PaginationButton(
                text: "Previous",
                onTap: () {
                  setState(() => currentPage--);
                },
              ),

            const SizedBox(width: 20),

            if ((currentPage + 1) * videosPerPage < videos.length)
              _PaginationButton(
                text: "Next",
                onTap: () {
                  setState(() => currentPage++);
                },
              ),
          ],
        ),
      ],
    );
  }
}
//////////////////////////////////////////////////////////////
// YOUTUBE CARD
//////////////////////////////////////////////////////////////

class YouTubeCard extends StatefulWidget {
  final String title;
  final String thumbnail;
  final String videoId;

  const YouTubeCard({
    super.key,
    required this.title,
    required this.thumbnail,
    required this.videoId,
  });

  @override
  State<YouTubeCard> createState() => _YouTubeCardState();
}

class _YouTubeCardState extends State<YouTubeCard> {
  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovering = true),
      onExit: (_) => setState(() => isHovering = false),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  VideoDetailPage(videoId: widget.videoId, title: widget.title),
            ),
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          transform: Matrix4.translationValues(0, isHovering ? -6 : 0, 0),
          decoration: BoxDecoration(
            color: const Color(0xFF1B2A41),
            borderRadius: BorderRadius.circular(18),
            boxShadow: isHovering
                ? [
                    BoxShadow(
                      color: Colors.blueAccent.withOpacity(0.25),
                      blurRadius: 20,
                      offset: const Offset(0, 12),
                    ),
                  ]
                : [],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Thumbnail
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Stack(
                    children: [
                      AnimatedScale(
                        scale: isHovering ? 1.05 : 1,
                        duration: const Duration(milliseconds: 300),
                        child: Image.network(
                          widget.thumbnail,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          filterQuality: FilterQuality.high,
                        ),
                      ),

                      /// Play icon overlay
                      Center(
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 200),
                          opacity: isHovering ? 1 : 0,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                /// Title
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Text(
                    widget.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//////////////////////////////////////////////////////////////
// PAGINATION BUTTON
//////////////////////////////////////////////////////////////

class _PaginationButton extends StatefulWidget {
  final String text;
  final VoidCallback onTap;

  const _PaginationButton({required this.text, required this.onTap});

  @override
  State<_PaginationButton> createState() => _PaginationButtonState();
}

class _PaginationButtonState extends State<_PaginationButton> {
  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovering = true),
      onExit: (_) => setState(() => isHovering = false),
      child: AnimatedScale(
        scale: isHovering ? 1.05 : 1,
        duration: const Duration(milliseconds: 200),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isHovering
                ? const Color(0xFF3B82F6)
                : const Color(0xFF2563EB),
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          onPressed: widget.onTap,
          child: Text(
            widget.text,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}

//////////////////////////////////////////////////////////////
// VIDEO DETAIL PAGE
//////////////////////////////////////////////////////////////

class VideoDetailPage extends StatelessWidget {
  final String videoId;
  final String title;

  const VideoDetailPage({
    super.key,
    required this.videoId,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0B1220), Color(0xFF111C2E), Color(0xFF16263F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 60),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// VIDEO CONTAINER
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.6),
                          blurRadius: 40,
                          offset: const Offset(0, 25),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: VideoPlayerWidget(videoId: videoId),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  /// TITLE
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// OPTIONAL DESCRIPTION TEXT
                  const Text(
                    "Watch this tutorial and improve your development skills. "
                    "Make sure to subscribe for more content.",
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

//////////////////////////////////////////////////////////////
// ABOUT SECTION
//////////////////////////////////////////////////////////////

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Heading with Brand Highlight
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                children: [
                  TextSpan(text: "About "),
                  TextSpan(
                    text: "Your Technical Tutorial",
                    style: TextStyle(
                      color: Color(0xFF3B82F6), // Brand Blue
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 1),

            /// Brand Accent Line
            Container(
              height: 4,
              width: 85,
              decoration: BoxDecoration(
                color: const Color(0xFF3B82F6),
                borderRadius: BorderRadius.circular(3),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF3B82F6).withOpacity(0.45),
                    blurRadius: 18,
                    spreadRadius: 2,
                    offset: const Offset(0, 6), // 👈 pushes glow upward
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 30),

        /// Description
        const Text(
          "We create high quality programming tutorials to help developers grow. "
          "Our mission is to simplify coding concepts and make learning enjoyable.",
          style: TextStyle(fontSize: 18, color: Colors.white60, height: 1.7),
        ),
      ],
    );
  }
}
//////////////////////////////////////////////////////////////
// PREMIUM HOVER BUTTON
//////////////////////////////////////////////////////////////

class HoverButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;

  const HoverButton({super.key, required this.text, required this.onPressed});

  @override
  State<HoverButton> createState() => _HoverButtonState();
}

class _HoverButtonState extends State<HoverButton> {
  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovering = true),
      onExit: (_) => setState(() => isHovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: isHovering
              ? [
                  BoxShadow(
                    color: const Color(0xFF3B82F6).withOpacity(0.45),
                    blurRadius: 35,
                    offset: const Offset(0, 18),
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ]
              : [],
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 42, vertical: 32),
            backgroundColor: const Color(0xFF2563EB),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: isHovering
                    ? Colors.white.withOpacity(0.6)
                    : Colors.transparent,
                width: 1,
              ),
            ),
            elevation: 0,
          ),
          onPressed: widget.onPressed,
          child: Text(
            widget.text,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}


//////////////////////////////////////////////////////////////
// HOVER Video CARD
//////////////////////////////////////////////////////////////


class _HoverVideoCard extends StatefulWidget {
  const _HoverVideoCard({super.key});

  @override
  State<_HoverVideoCard> createState() => _HoverVideoCardState();
}

class _HoverVideoCardState extends State<_HoverVideoCard> {
  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovering = true),
      onExit: (_) => setState(() => isHovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        transform: Matrix4.translationValues(
          0,
          isHovering ? -6 : 0, // slight lift
          0,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            // Depth shadow
            BoxShadow(
              color: Colors.black.withOpacity(0.55),
              blurRadius: 40,
              offset: const Offset(0, 25),
            ),

            // Blue glow ONLY when hovering
            if (isHovering)
              BoxShadow(
                color: const Color(0xFF3B82F6).withOpacity(0.35),
                blurRadius: 35,
                offset: const Offset(0, 20),
              ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: const SizedBox(
            width: 650,
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: VideoPlayerWidget(videoId: "RVGAENB9sFg"),
            ),
          ),
        ),
      ),
    );
  }
}
