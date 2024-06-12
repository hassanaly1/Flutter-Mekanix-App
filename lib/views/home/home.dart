import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_mekanix_app/helpers/custom_text.dart';
import 'package:flutter_mekanix_app/helpers/reusable_container.dart';
import 'package:flutter_mekanix_app/views/home/barchart.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late PageController _pageController;
  final CarouselController _carouselController = CarouselController();
  int _currentIndex = 0;
  bool _pageChanging = false;
  bool _carouselChanging = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _pageController = PageController();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    if (!_pageChanging && _currentIndex != index) {
      setState(() {
        _carouselChanging = true;
        _currentIndex = index;
      });
      _carouselController.animateToPage(index);
      _tabController.animateTo(index);
    }
  }

  void _onCarouselPageChanged(int index, CarouselPageChangedReason reason) {
    if (!_carouselChanging && _currentIndex != index) {
      setState(() {
        _pageChanging = true;
        _currentIndex = index;
      });
      _pageController.animateToPage(index,
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
      _tabController.animateTo(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32.0),
            topRight: Radius.circular(32.0),
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: Column(
            children: [
              CarouselSlider(
                items: [
                  NewWidget(
                    onTap: () => _pageController.animateToPage(0,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut),
                    title: 'Submitted Tasks',
                    value: '34',
                  ),
                  NewWidget(
                    onTap: () => _pageController.animateToPage(1,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut),
                    title: 'Total Templates',
                    value: '12',
                  ),
                  NewWidget(
                    onTap: () => _pageController.animateToPage(2,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut),
                    title: 'Total Engines',
                    value: '8',
                  ),
                ],
                options: CarouselOptions(
                  height: 140,
                  enlargeCenterPage: true,
                  autoPlay: false,
                  enableInfiniteScroll: true,
                  viewportFraction: 0.6,
                  onPageChanged: (index, reason) {
                    if (reason == CarouselPageChangedReason.manual) {
                      _onCarouselPageChanged(index, reason);
                    }
                  },
                ),
                carouselController: _carouselController,
              ),
              const Divider(),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: _onPageChanged,
                  children: [
                    TabView1(pageController: _pageController),
                    TabView1(pageController: _pageController),
                    TabView1(pageController: _pageController),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NewWidget extends StatelessWidget {
  final String title;
  final String value;
  final VoidCallback onTap;

  const NewWidget(
      {super.key,
      required this.onTap,
      required this.title,
      required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onTap,
        child: ReUsableContainer(
          height: 100,
          width: 220,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextWidget(text: title, fontSize: 18.0),
              CustomTextWidget(
                text: value,
                fontSize: 26,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TabView1 extends StatelessWidget {
  final PageController pageController;

  const TabView1({super.key, required this.pageController});

  @override
  Widget build(BuildContext context) {
    return const MyBarChart();
  }
}
