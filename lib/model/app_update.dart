import 'dart:convert';

class AppUpdateModel {
  /// 最新版本号
  String? latestVersion;
  /// 操作系统
  int? operatingSystem;
  /// 下载地址
  String? downloadUrl;
  /// 是否强制更新(0 不强制, 1强制)
  int? forcedUpdate;
  /// 标题
  String? title;
  /// 更新内容
  String? desc;

  AppUpdateModel({
    this.latestVersion,
    this.operatingSystem,
    this.downloadUrl,
    this.forcedUpdate,
    this.title,
    this.desc,
  });

  AppUpdateModel copyWith({
    String? latestVersion,
    int? operatingSystem,
    String? downloadUrl,
    int? forcedUpdate,
    String? title,
    String? desc,
  }) => 
    AppUpdateModel(
      latestVersion: latestVersion ?? this.latestVersion,
      operatingSystem: operatingSystem ?? this.operatingSystem,
      downloadUrl: downloadUrl ?? this.downloadUrl,
      forcedUpdate: forcedUpdate ?? this.forcedUpdate,
      title: title ?? this.title,
      desc: desc ?? this.desc,
    );

  factory AppUpdateModel.fromRawJson(String str) => AppUpdateModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AppUpdateModel.fromJson(Map<String, dynamic> json) => AppUpdateModel(
    latestVersion: json["latest_version"],
    operatingSystem: json["operating_system"],
    downloadUrl: json["download_url"],
    forcedUpdate: json["forced_update"],
    title: json["title"],
    desc: json["desc"],
  );

  Map<String, dynamic> toJson() => {
    "latest_version": latestVersion,
    "operating_system": operatingSystem,
    "download_url": downloadUrl,
    "forced_update": forcedUpdate,
    "title": title,
    "desc": desc,
  };
}
