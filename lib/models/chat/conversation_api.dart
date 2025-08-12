import 'package:app/models/chat/chat_message.dart';
import 'package:app/models/common/link.dart';

class ConversationApi {
  int? currentPage;
  List<ChatMessage>? messages;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Link>? links;
  String? nextPageUrl;
  String? path;
  int? perPage;
  String? prevPageUrl;
  int? to;
  int? total;

  ConversationApi({
    this.currentPage,
    this.messages,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.links,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  ConversationApi.fromJson(json) {
    currentPage = json['current_page'];
    messages = [];
    if (json['data'] != null) json['data'].forEach((v) => messages?.add(ChatMessage.fromJson(v)));
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    links = [];
    if (json['links'] != null) json['links'].forEach((v) => links?.add(Link.fromJson(v)));
    nextPageUrl = json['next_page_url'];
    path = json['path'];
    perPage = json['per_page'];
    prevPageUrl = json['prev_page_url'];
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['current_page'] = currentPage;
    if (messages != null) map['data'] = messages?.map((v) => v.toJson()).toList();
    map['first_page_url'] = firstPageUrl;
    map['from'] = from;
    map['last_page'] = lastPage;
    map['last_page_url'] = lastPageUrl;
    if (links != null) map['links'] = links?.map((v) => v.toJson()).toList();
    map['next_page_url'] = nextPageUrl;
    map['path'] = path;
    map['per_page'] = perPage;
    map['prev_page_url'] = prevPageUrl;
    map['to'] = to;
    map['total'] = total;
    return map;
  }
}
