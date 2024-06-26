import 'dart:ui';

// Packages
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Widgets
// Models
import '../controllers/main_page_data_controllers.dart';
import '../models/main_page_data.dart';
import '../models/search_category.dart';
import '../models/movie.dart';
import '../widgets/movie_tile_widget.dart';

// Controllers

final mainPageDataControllerProvider =
    StateNotifierProvider<MainPageDataController, MainPageData>((ref) {
  return MainPageDataController();
});

final selectedMoviePosterURLProvider = StateProvider<String?>((ref) {
  final movies = ref.watch(mainPageDataControllerProvider).movies!;
  return movies.isNotEmpty ? movies[0].posterURL() : null;
});

class MainPage extends ConsumerWidget {
  double? _deviceHeight;
  double? _deviceWidth;

  late var _selectedMoviePosterURL;

  late MainPageDataController _mainPageDataController;
  late MainPageData _mainPageData;

  TextEditingController? _searchTextFieldController;

  MainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;

    _mainPageDataController = ref.watch(mainPageDataControllerProvider.notifier);
    _mainPageData = ref.watch(mainPageDataControllerProvider);
    _selectedMoviePosterURL = ref.watch(selectedMoviePosterURLProvider);

    _searchTextFieldController = TextEditingController();
    _searchTextFieldController!.text = _mainPageData.searchText!;

    return _buildUI(ref);
  }

  Widget _buildUI(WidgetRef ref) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: SizedBox(
        height: _deviceHeight,
        width: _deviceWidth,
        child: Stack(
          alignment: Alignment.center,
          children: [
            _backgroundWidget(),
            _foregroundWidgets(ref),
          ],
        ),
      ),
    );
  }

  Widget _backgroundWidget() {
    if (_selectedMoviePosterURL != null) {
      return Container(
        height: _deviceHeight,
        width: _deviceWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          image: DecorationImage(
            image: NetworkImage(_selectedMoviePosterURL),
            fit: BoxFit.cover,
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.2),
            ),
          ),
        ),
      );
    } else {
      return Container(
        height: _deviceHeight,
        width: _deviceWidth,
        color: Colors.black,
      );
    }
  }

  Widget _foregroundWidgets(WidgetRef ref) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, _deviceHeight! * 0.02, 0, 0),
      width: _deviceWidth! * 0.90,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _topBarWidget(),
          Container(
            height: _deviceHeight! * 0.83,
            padding: EdgeInsets.symmetric(vertical: _deviceHeight! * 0.01),
            child: _moviesListViewWidget(ref),
          )
        ],
      ),
    );
  }

  Widget _topBarWidget() {
    return Container(
      height: _deviceHeight! * 0.08,
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _searchFieldWidget(),
          _categorySelectionWidget(),
        ],
      ),
    );
  }

  Widget _searchFieldWidget() {
    const border = InputBorder.none;
    return SizedBox(
      width: _deviceWidth! * 0.50,
      height: _deviceHeight! * 0.05,
      child: TextField(
        controller: _searchTextFieldController,
        onSubmitted: (input) =>
            _mainPageDataController.updateTextSearch(input),
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(
            focusedBorder: border,
            border: border,
            prefixIcon: Icon(Icons.search, color: Colors.white24),
            hintStyle: TextStyle(color: Colors.white54),
            filled: false,
            fillColor: Colors.white24,
            hintText: 'Search....'),
      ),
    );
  }

  Widget _categorySelectionWidget() {
    return DropdownButton(
      dropdownColor: Colors.black38,
      value: _mainPageData.searchCategory,
      icon: const Icon(
        Icons.menu,
        color: Colors.white24,
      ),
      underline: Container(
        height: 1,
        color: Colors.white24,
      ),
      onChanged: (dynamic value) => value.toString().isNotEmpty
          ? _mainPageDataController.updateSearchCategory(value)
          : null,
      items: const [
        DropdownMenuItem(
          value: SearchCategory.popular,
          child: Text(
            SearchCategory.popular,
            style: TextStyle(color: Colors.white),
          ),
        ),
        DropdownMenuItem(
          value: SearchCategory.upcoming,
          child: Text(
            SearchCategory.upcoming,
            style: TextStyle(color: Colors.white),
          ),
        ),
         DropdownMenuItem(
          value: SearchCategory.topRated,
          child: Text(
            SearchCategory.topRated,
            style: TextStyle(color: Colors.white),
          ),
        ),
        DropdownMenuItem(
          value: SearchCategory.none,
          child: Text(
            SearchCategory.none,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _moviesListViewWidget(WidgetRef ref) {
    final List<Movie> movies = _mainPageData.movies!;

    if (movies.isNotEmpty) {
      return NotificationListener(
        onNotification: (dynamic onScrollNotification) {
          if (onScrollNotification is ScrollEndNotification) {
            final before = onScrollNotification.metrics.extentBefore;
            final max = onScrollNotification.metrics.maxScrollExtent;
            if (before == max) {
              _mainPageDataController.getMovies();
              return true;
            }
            return false;
          }
          return false;
        },
        child: ListView.builder(
          itemCount: movies.length,
          itemBuilder: (BuildContext context, int count) {
            return Padding(
              padding: EdgeInsets.symmetric(
                  vertical: _deviceHeight! * 0.01, horizontal: 0),
              child: GestureDetector(
                onTap: () {
                  ref.read(selectedMoviePosterURLProvider.notifier).state = movies[count].posterURL();
                },
                child: MovieTile(
                  movie: movies[count],
                  height: _deviceHeight! * 0.20,
                  width: _deviceWidth! * 0.85,
                ),
              ),
            );
          },
        ),
      );
    } else {
      return const Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.white,
        ),
      );
    }
  }
}
