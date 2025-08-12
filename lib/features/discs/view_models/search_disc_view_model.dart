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

  void initViewModel() {
    clearStates();
    notifyListeners();
    // _fetchPdgaDiscs(isLoader: true);
    // _paginationCheck();
  }

  void clearStates() {
    loader = false;
    isSearched = false;
    _searchCounter = 0;
    pdgaDiscs.clear();
    searchedDisc.clear();
    paginate = Paginate();
  }

  /*Future<void> _paginationCheck() async {
    scrollControl.addListener(() {
      var maxPosition = scrollControl.position.pixels == scrollControl.position.maxScrollExtent;
      if (maxPosition && paginate.length == COMMON_LENGTH_20) _fetchPdgaDiscs(isPaginate: true);
    });
  }*/

  /*Future<void> _fetchPdgaDiscs({bool isLoader = false, bool isPaginate = false}) async {
    if (paginate.pageLoader) return;
    loader = isLoader;
    paginate.pageLoader = isPaginate;
    notifyListeners();
    var response = await sl<DiscRepository>().fetchParentDiscs(page: paginate.page);
    paginate.length = response.length;
    if (paginate.page == 0) pdgaDiscs.clear();
    if (paginate.length >= COMMON_LENGTH_20) paginate.page++;
    if (response.isNotEmpty) pdgaDiscs.addAll(response);
    paginate.pageLoader = false;
    loader = false;
    notifyListeners();
  }*/

  Future<void> fetchSearchDisc(String pattern) async {
    if (pattern.isEmpty) return _onEmptyKey();
    final currentRequest = ++_searchCounter;
    var body = {'query': pattern};
    if (kDebugMode) print(body);
    var response = await sl<DiscRepository>().searchDiscByName(body: body);
    if (currentRequest != _searchCounter) return;
    isSearched = true;
    searchedDisc.clear();
    if (response.isNotEmpty) searchedDisc = response;
    notifyListeners();
  }

  void _onEmptyKey() {
    searchedDisc.clear();
    isSearched = false;
    notifyListeners();
  }
}
