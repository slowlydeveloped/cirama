import 'dart:ui';

import '/widgets/movie_tile_widget.dart';

import '../models/movie.dart';
import '../models/search_category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainPage extends ConsumerWidget {

  double? _height;
  double? _width;
  TextEditingController? _searchController;

  MainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _searchController = TextEditingController();
    return _buildUI();
  }

  Widget _buildUI() {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: SizedBox(
        height: _height,
        width: _width,
        child: Stack(
          alignment: Alignment.center,
          children: [
            _backgroundWidget(),
            _foregroundWidgets(),
          ],
        ),
      ),
    );
  }

  Widget _backgroundWidget() {
    return Container(
      height: _height,
      width: _width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        image: const DecorationImage(
            image: NetworkImage(
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRNTBDvydTf8LjU_YSFRqGYkVZwpMCxnIXOWQ&s'),
            fit: BoxFit.cover),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
        child: Container(
          decoration: BoxDecoration(color: Colors.black.withOpacity(0.2)),
        ),
      ),
    );
  }

  Widget _foregroundWidgets() {
    return Container(
      padding: EdgeInsets.fromLTRB(0, _height! * 0.02, 0, 0),
      width: _width! * 0.88,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _topBarWidget(),
          Container(
            height: _height! * 0.83,
            padding: EdgeInsets.symmetric(vertical: _height! * 0.01),
            child: _movieListViewWidget(),
          )
        ],
      ),
    );
  }

  Widget _topBarWidget() {
    return Container(
        height: _height! * 0.08,
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _searchFieldWidget(),
            _categorySelectionWidget(),
          ],
        ));
  }

  Widget _searchFieldWidget() {
    const border = InputBorder.none;
    return SizedBox(
      width: _width! * 0.50,
      height: _height! * 0.50,
      child: TextField(
        controller: _searchController,
        onSubmitted: (_input) {},
        style: const TextStyle(
          color: Colors.white,
        ),
        decoration: const InputDecoration(
            focusedBorder: border,
            border: border,
            prefixIcon: Icon(
              Icons.search,
              color: Colors.white24,
            ),
            hintStyle: TextStyle(color: Colors.white54),
            filled: false,
            fillColor: Colors.white24,
            hintText: "Search..."),
      ),
    );
  }

  Widget _categorySelectionWidget() {
    return DropdownButton(
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
          value: SearchCategory.none,
          child: Text(
            SearchCategory.none,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
      onChanged: (_value) {},
      dropdownColor: Colors.black38,
      value: SearchCategory.popular,
      icon: const Icon(
        Icons.menu,
        color: Colors.white24,
      ),
      underline: Container(
        height: 1,
        color: Colors.white24,
      ),
    );
  }

  Widget _movieListViewWidget() {
    final List<MovieModel> movies = [];
    if (movies.isNotEmpty) {
      return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.symmetric(
                vertical: _height! * 0.01,
                horizontal: 0,
              ),
              child: GestureDetector(
                onTap: () {},
                child: MovieTile(
                  movieModel: movies[index],
                  height: _height! * 0.20,
                  width: _width! * 0.85,
                ),
              ),
            );
          });
    } else {
      return const Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.white,
        ),
      );
    }
  }
}
