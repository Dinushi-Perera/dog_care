import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:cached_network_image/cached_network_image.dart';

class EducationScreen extends StatefulWidget {
  const EducationScreen({Key? key}) : super(key: key);

  @override
  _EducationScreenState createState() => _EducationScreenState();
}

class _EducationScreenState extends State<EducationScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  final List<Map<String, dynamic>> articles = const [
    {
      'title': 'Puppy Nutrition Guide',
      'summary': 'Complete guide to feeding your puppy during their first year',
      'readTime': '5 min read',
      'category': 'Nutrition',
      'icon': Icons.pets,
      'color': Colors.orange,
      'content':
          'Puppies need nutrient-rich food for proper growth and development. Feed them 3-4 times daily with high-quality puppy food.',
    },
    {
      'title': 'Senior Dog Care',
      'summary': 'Essential tips for caring for aging dogs and their special needs',
      'readTime': '7 min read',
      'category': 'Health',
      'icon': Icons.favorite,
      'color': Colors.red,
      'content':
          'Senior dogs require special attention to their diet, exercise, and health monitoring. Regular vet checkups are crucial.',
    },
    {
      'title': 'Understanding Food Labels',
      'summary':
          'Learn to read and understand dog food ingredients and nutritional information',
      'readTime': '4 min read',
      'category': 'Nutrition',
      'icon': Icons.label,
      'color': Colors.blue,
      'content':
          'Always check the first 5 ingredients. Look for real meat as the first ingredient and avoid artificial preservatives.',
    },
    {
      'title': 'Toxic Foods for Dogs',
      'summary': 'Complete list of foods that are dangerous for your dog',
      'readTime': '3 min read',
      'category': 'Safety',
      'icon': Icons.warning,
      'color': Colors.deepOrange,
      'content':
          'Chocolate, grapes, onions, garlic, and xylitol are extremely toxic to dogs. Keep these away from your pet.',
    },
  ];

  final List<Map<String, dynamic>> videos = const [
    {
      'title': 'Proper Feeding Techniques',
      'duration': '8:30',
      'videoId': 'Hf760ks2yCE',
      'thumbnail': 'https://img.youtube.com/vi/Hf760ks2yCE/hqdefault.jpg',
      'description': 'Learn the best practices for feeding your dog',
      'views': '124K views',
    },
    {
      'title': 'Dog Breed Nutrition Differences',
      'duration': '12:15',
      'videoId': 'bgAkBugi4k0',
      'thumbnail': 'https://img.youtube.com/vi/bgAkBugi4k0/hqdefault.jpg',
      'description': 'How different breeds have different nutritional needs',
      'views': '89K views',
    },
    {
      'title': 'Making Homemade Dog Treats',
      'duration': '6:45',
      'videoId': 'vEh_Z2cpCME',
      'thumbnail': 'https://img.youtube.com/vi/vEh_Z2cpCME/hqdefault.jpg',
      'description': 'Simple and healthy homemade treat recipes',
      'views': '256K views',
    },
  ];

  final List<Map<String, dynamic>> breeds = const [
    {
      'name': 'Golden Retriever',
      'size': 'Large',
      'energy': 'High',
      'nutritionTip': 'Needs high-protein diet for active lifestyle',
      'image': 'https://via.placeholder.com/150x150/FFD700/000000?text=Golden',
    },
    {
      'name': 'Bulldog',
      'size': 'Medium',
      'energy': 'Low',
      'nutritionTip': 'Prone to weight gain, monitor calorie intake',
      'image': 'https://via.placeholder.com/150x150/8B4513/FFFFFF?text=Bulldog',
    },
    {
      'name': 'Chihuahua',
      'size': 'Small',
      'energy': 'Medium',
      'nutritionTip': 'Small frequent meals prevent hypoglycemia',
      'image': 'https://via.placeholder.com/150x150/FF69B4/FFFFFF?text=Chihuahua',
    },
    {
      'name': 'German Shepherd',
      'size': 'Large',
      'energy': 'High',
      'nutritionTip': 'Joint support supplements recommended',
      'image': 'https://via.placeholder.com/150x150/654321/FFFFFF?text=GSD',
    },
  ];

  final List<Map<String, dynamic>> healthTips = const [
    {
      'title': 'Daily Exercise Requirements',
      'tip': 'Most dogs need 30 minutes to 2 hours of exercise daily',
      'icon': Icons.directions_run,
      'color': Colors.green,
    },
    {
      'title': 'Hydration is Key',
      'tip':
          'Always provide fresh, clean water. Dogs need 1 ounce per pound of body weight daily',
      'icon': Icons.water_drop,
      'color': Colors.blue,
    },
    {
      'title': 'Regular Vet Checkups',
      'tip': 'Annual checkups for adult dogs, twice yearly for seniors',
      'icon': Icons.medical_services,
      'color': Colors.red,
    },
    {
      'title': 'Dental Care',
      'tip': 'Brush your dog\'s teeth 2-3 times weekly to prevent dental disease',
      'icon': Icons.medical_information,
      'color': Colors.purple,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 200.0,
              floating: false,
              pinned: true,
              backgroundColor: Colors.teal,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.teal.shade300, Colors.teal.shade600],
                    ),
                  ),
                  child: Center(
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.school, size: 60, color: Colors.white),
                          SizedBox(height: 8),
                          Text(
                            'Learn • Grow • Care',
                            style: TextStyle(color: Colors.white70, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              bottom: TabBar(
                controller: _tabController,
                indicatorColor: Colors.white,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                tabs: const [
                  Tab(icon: Icon(Icons.article), text: 'Articles'),
                  Tab(icon: Icon(Icons.play_circle), text: 'Videos'),
                  Tab(icon: Icon(Icons.pets), text: 'Breeds'),
                  Tab(icon: Icon(Icons.health_and_safety), text: 'Health'),
                ],
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildArticlesTab(),
            _buildVideosTab(),
            _buildBreedsTab(),
            _buildHealthTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildArticlesTab() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: articles.length,
        itemBuilder: (context, index) {
          final article = articles[index];
          return AnimatedContainer(
            duration: Duration(milliseconds: 300 + (index * 100)),
            margin: const EdgeInsets.only(bottom: 16),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => _showArticleDetail(article),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      colors: [
                        (article['color'] as Color).withOpacity(0.1),
                        Colors.white,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: article['color'],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(article['icon'], color: Colors.white, size: 24),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              article['title'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              article['summary'],
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: article['color'],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    article['category'],
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  article['readTime'],
                                  style: TextStyle(
                                      color: Colors.grey[500], fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios, color: Colors.grey[400]),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildVideosTab() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: videos.length,
        itemBuilder: (context, index) {
          final video = videos[index];
          return AnimatedContainer(
            duration: Duration(milliseconds: 300 + (index * 100)),
            margin: const EdgeInsets.only(bottom: 16),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => _showVideoPlayer(video),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius:
                              const BorderRadius.vertical(top: Radius.circular(16)),
                          child: CachedNetworkImage(
                            imageUrl: video['thumbnail'],
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              height: 200,
                              color: Colors.grey[300],
                              child: const Center(
                                child: CircularProgressIndicator(
                                  valueColor:
                                      AlwaysStoppedAnimation<Color>(Colors.teal),
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) {
                              debugPrint(
                                  'Thumbnail failed for ${video['videoId']}: $error');
                              return CachedNetworkImage(
                                imageUrl:
                                    'https://img.youtube.com/vi/${video['videoId']}/hqdefault.jpg',
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  height: 200,
                                  color: Colors.grey[300],
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                      valueColor:
                                          AlwaysStoppedAnimation<Color>(Colors.teal),
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) {
                                  debugPrint(
                                      'Fallback thumbnail failed for ${video['videoId']}: $error');
                                  return Container(
                                    height: 200,
                                    color: Colors.grey[300],
                                    child: const Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.video_library,
                                              size: 50, color: Colors.grey),
                                          SizedBox(height: 8),
                                          Text(
                                            'Thumbnail not available',
                                            style: TextStyle(
                                                color: Colors.grey, fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        Positioned(
                          bottom: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.black87,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              video['duration'],
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            video['title'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            video['description'],
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            video['views'],
                            style: TextStyle(color: Colors.grey[500], fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBreedsTab() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: breeds.length,
        itemBuilder: (context, index) {
          final breed = breeds[index];
          return AnimatedContainer(
            duration: Duration(milliseconds: 300 + (index * 100)),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => _showBreedDetail(breed),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.vertical(top: Radius.circular(16)),
                        child: CachedNetworkImage(
                          imageUrl: breed['image'],
                          width: double.infinity,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: Colors.grey[300],
                            child: const Center(
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.teal),
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) {
                            return Container(
                              color: Colors.grey[300],
                              child: const Center(
                                child: Icon(Icons.pets, size: 40, color: Colors.grey),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              breed['name'],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                _buildInfoChip(breed['size'], Colors.blue),
                                const SizedBox(width: 4),
                                _buildInfoChip(breed['energy'], Colors.orange),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Expanded(
                              child: Text(
                                breed['nutritionTip'],
                                style: TextStyle(
                                    color: Colors.grey[600], fontSize: 12),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHealthTab() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: healthTips.length,
        itemBuilder: (context, index) {
          final tip = healthTips[index];
          return AnimatedContainer(
            duration: Duration(milliseconds: 300 + (index * 100)),
            margin: const EdgeInsets.only(bottom: 16),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [
                      (tip['color'] as Color).withOpacity(0.1),
                      Colors.white,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: tip['color'],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(tip['icon'], color: Colors.white, size: 28),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tip['title'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            tip['tip'],
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }

  void _showArticleDetail(Map<String, dynamic> article) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: article['color'],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(article['icon'], color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        article['title'],
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  article['content'],
                  style: const TextStyle(fontSize: 16, height: 1.5),
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Close'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showVideoPlayer(Map<String, dynamic> video) {
    final YoutubePlayerController controller = YoutubePlayerController.fromVideoId(
      videoId: video['videoId'],
      autoPlay: false,
      params: const YoutubePlayerParams(
        showControls: true,
        mute: false,
        showFullscreenButton: true,
        loop: true,
      ),
    );

    bool isShort = false;
    try {
      final durationParts = video['duration'].split(':');
      final seconds = int.parse(durationParts[0]) * 60 + int.parse(durationParts[1]);
      isShort = seconds <= 60; // Consider videos <= 60 seconds as Shorts
    } catch (e) {
      debugPrint('Error parsing duration for ${video['title']}: $e');
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        video['title'],
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        controller.close();
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  height: 200,
                  child: YoutubePlayer(
                    controller: controller,
                    aspectRatio: isShort ? 9 / 16 : 16 / 9,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  video['description'],
                  style: TextStyle(color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  '${video['views']} • Duration: ${video['duration']}',
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    controller.close();
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Close'),
                ),
              ],
            ),
          ),
        );
      },
    ).then((_) {
      controller.close();
    });
  }

  void _showBreedDetail(Map<String, dynamic> breed) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: breed['image'],
                    height: 120,
                    width: 120,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      height: 120,
                      width: 120,
                      color: Colors.grey[300],
                      child: const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) {
                      return Container(
                        height: 120,
                        width: 120,
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(Icons.pets, size: 40, color: Colors.grey),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  breed['name'],
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildInfoChip(breed['size'], Colors.blue),
                    const SizedBox(width: 8),
                    _buildInfoChip('${breed['energy']} Energy', Colors.orange),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Nutrition Tip:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  breed['nutritionTip'],
                  style: const TextStyle(fontSize: 14, height: 1.4),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Close'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}