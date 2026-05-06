class NewsModel {
  final int id;
  final String title;
  final String summary;
  final String category;
  final String date;
  final String source;
  final bool isFeatured;
  final String imageEmoji;
  final String? firestoreId; // معرّف Firestore

  const NewsModel({
    required this.id,
    required this.title,
    required this.summary,
    required this.category,
    required this.date,
    required this.source,
    this.isFeatured = false,
    this.imageEmoji = '📰',
    this.firestoreId,
  });

  // ── تحويل إلى Map لحفظه في Firestore ────────────────────────────────────────
  Map<String, dynamic> toJson() => {
    'id':          id,
    'title':       title,
    'summary':     summary,
    'category':    category,
    'date':        date,
    'source':      source,
    'isFeatured':  isFeatured,
    'imageEmoji':  imageEmoji,
  };

  // ── تحويل من Firestore إلى NewsModel ────────────────────────────────────────
  factory NewsModel.fromJson(Map<String, dynamic> json, {String? firestoreId}) {
    return NewsModel(
      id:          json['id']         ?? 0,
      title:       json['title']      ?? '',
      summary:     json['summary']    ?? '',
      category:    json['category']   ?? 'إعلانات',
      date:        json['date']       ?? '',
      source:      json['source']     ?? 'نقابة دمشق',
      isFeatured:  json['isFeatured'] ?? false,
      imageEmoji:  json['imageEmoji'] ?? '📰',
      firestoreId: firestoreId,
    );
  }

  // ── copyWith ────────────────────────────────────────────────────────────────
  NewsModel copyWith({
    int? id,
    String? title,
    String? summary,
    String? category,
    String? date,
    String? source,
    bool? isFeatured,
    String? imageEmoji,
    String? firestoreId,
  }) {
    return NewsModel(
      id:          id          ?? this.id,
      title:       title       ?? this.title,
      summary:     summary     ?? this.summary,
      category:    category    ?? this.category,
      date:        date        ?? this.date,
      source:      source      ?? this.source,
      isFeatured:  isFeatured  ?? this.isFeatured,
      imageEmoji:  imageEmoji  ?? this.imageEmoji,
      firestoreId: firestoreId ?? this.firestoreId,
    );
  }
}
