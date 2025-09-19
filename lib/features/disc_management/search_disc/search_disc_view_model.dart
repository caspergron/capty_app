import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import 'package:app/di.dart';
import 'package:app/models/disc/parent_disc.dart';
import 'package:app/models/system/paginate.dart';
import 'package:app/repository/disc_repo.dart';

class SearchDiscViewModel with ChangeNotifier {
  var loader = false;
  var isSearched = false;
  var paginate = Paginate();
  var pdgaDiscs = <ParentDisc>[];
  var searchedDisc = <ParentDisc>[];
  var scrollControl = ScrollController();
  var _searchCounter = 0;
  var _lastQuery = '';
  Timer? _debounceTimer;

  void initViewModel() {
    clearStates();
    notifyListeners();
    // _fetchPdgaDiscs(isLoader: true);
    // _paginationCheck();
  }

  void clearStates() {
    loader = false;
    isSearched = false;

    pdgaDiscs.clear();
    searchedDisc.clear();
    paginate = Paginate();
    _searchCounter = 0;
    _lastQuery = '';
    _debounceTimer?.cancel();
  }

  void onDebounceSearch(String query) {
    _debounceTimer?.cancel();
    if (query.trim().isEmpty || query.length < 2) return _onEmptyKey();
    if (query == _lastQuery) return;
    _lastQuery = query;
    _debounceTimer = Timer(const Duration(milliseconds: 300), () => _fetchSearchDisc(query));
  }

  Future<void> _fetchSearchDisc(String pattern) async {
    final currentRequest = ++_searchCounter;
    final body = {'query': pattern};
    try {
      final response = await sl<DiscRepository>().searchDiscByName(body: body);
      if (currentRequest != _searchCounter) return;
      isSearched = true;
      searchedDisc.clear();
      if (response.isNotEmpty) searchedDisc.addAll(response);
      notifyListeners();
    } catch (e) {
      if (kDebugMode) print('Search error: $e');
    }
  }

  void _onEmptyKey() {
    searchedDisc.clear();
    isSearched = false;
    _lastQuery = '';
    notifyListeners();
  }
}
