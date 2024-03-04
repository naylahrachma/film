import 'package:flutter/material.dart';
import 'package:film/screens/detail_screen.dart';
import 'package:film/services/api_service.dart';
import 'package:flutter/cupertino.dart';

import '../models/movie.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();

  List<Movie> _allMovies = [];
  List<Movie> _trendingMovies = [];
  List<Movie> _popularMovies = [];

  @override
  void intState () {
    super.initState();
  }

  Future<void> _loadMovies() async {
    final List<Map<String, dynamic>> _allMoviesData = await _apiService.getAllMovies();
    final List<Map<String, dynamic>> _trendingMoviesData = await _apiService.getTrendingMovies();
    final List<Map<String, dynamic>> _popularMoviesData = await _apiService.getPopularMovies();

    setState(() {
      _allMovies = _allMoviesData.map((e) => Movie.fromJson(e)).toList();
      _trendingMovies = _trendingMoviesData.map((e) => Movie.fromJson(e)).toList();
      _popularMovies = _popularMoviesData.map((e) => Movie.fromJson(e)).toList();

      print('_allMovies: $_allMovies');
      print('_trendingMovies: $_trendingMovies');
      print('_popularMovies: $_popularMovies');
    });
  }

  Widget _buildMovieList(String title, List<Movie> movies) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: movies.length,
              itemBuilder: (BuildContext context, int index) {
                final Movie movie = movies[index];
                GestureDetector(
                    onTap: () =>
                        Navigator.push(
                          context, MaterialPageRoute(
                          builder: (context) => DetailScreen(movie: movie),),),
                    child: Column(
                      children: [
                        Image.network(
                          'https://image.tmdb.org/t/p/w/500${movie.posterPath}',
                          height: 150,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(height: 5),
                        Text(movie.title.length > 14 ?
                        '${movie.title.substring(0, 10)}...' : movie.title,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    )
                );
              }
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Film'),
      ),
      body: SingleChildScrollView(
        child:Column(
          children: [
            _buildMovieList('All Movies', _allMovies),
            _buildMovieList('Trending Movies', _trendingMovies),
            _buildMovieList('Popular Movies', _popularMovies),
          ],
        ),
      ),
    );
  }
}