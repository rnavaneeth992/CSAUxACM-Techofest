import 'dart:convert';

class Team {
  final String id;
  final String teamName;
  final String leaderName;
  final String leaderEmail;
  final String leaderPhone;
  final String leaderId;
  final int clueList;
  final DateTime? startTime;
  final DateTime? endTime;
  final List<Map<String, DateTime>>? timings;
  final int hintCount;
  final int wrongClueCount;
  Team({
    required this.id,
    required this.teamName,
    required this.leaderName,
    required this.leaderEmail,
    required this.leaderPhone,
    required this.leaderId,
    required this.clueList,
    this.startTime,
    this.endTime,
    this.timings,
    this.hintCount = 0,
    this.wrongClueCount = 0,
  });

  Team copyWith({
    String? id,
    String? teamName,
    String? leaderName,
    String? leaderEmail,
    String? leaderPhone,
    String? leaderId,
    int? clueList,
    DateTime? startTime,
    DateTime? endTime,
    List<Map<String, DateTime>>? timings,
    int? hintCount,
    int? wrongClueCount,
  }) {
    return Team(
      id: id ?? this.id,
      teamName: teamName ?? this.teamName,
      leaderName: leaderName ?? this.leaderName,
      leaderEmail: leaderEmail ?? this.leaderEmail,
      leaderPhone: leaderPhone ?? this.leaderPhone,
      leaderId: leaderId ?? this.leaderId,
      clueList: clueList ?? this.clueList,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      timings: timings ?? this.timings,
      hintCount: hintCount ?? this.hintCount,
      wrongClueCount: wrongClueCount ?? this.wrongClueCount,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'teamName': teamName,
      'leaderName': leaderName,
      'leaderEmail': leaderEmail,
      'leaderPhone': leaderPhone,
      'leaderId': leaderId,
      'clueList': clueList,
      'startTime': startTime?.millisecondsSinceEpoch,
      'endTime': endTime?.millisecondsSinceEpoch,
      'timings': timings,
      'hintCount': hintCount,
      'wrongClueCount': wrongClueCount,
    };
  }

  factory Team.fromMap(Map<String, dynamic> map) {
    return Team(
      id: map['id'] as String,
      teamName: map['teamName'] as String,
      leaderName: map['leaderName'] as String,
      leaderEmail: map['leaderEmail'] as String,
      leaderPhone: map['leaderPhone'] as String,
      leaderId: map['leaderId'] as String,
      clueList: map['clueList'] as int,
      startTime: map['startTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['startTime'] as int)
          : null,
      endTime: map['endTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['endTime'] as int)
          : null,
      timings: map['timings'] != null
          ? List<Map<String, DateTime>>.from(
              (map['timings'] as List).map<Map<String, DateTime>?>(
                (x) {
                  if (x is Map<String, dynamic>) {
                    final DateTime startTime = x['startTime'].toDate();
                    final DateTime endTime = x['endTime'].toDate();
                    return {'startTime': startTime, 'endTime': endTime};
                  } else {
                    return null;
                  }
                },
              ),
            )
          : null,
      hintCount: map['hintCount'] as int,
      wrongClueCount: map['wrongClueCount'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Team.fromJson(String source) =>
      Team.fromMap(json.decode(source) as Map<String, dynamic>);
}
