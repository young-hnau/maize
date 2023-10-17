part of '../mealie_repository.dart';

class Settings extends Equatable {
  Settings({
    this.public,
    this.showNutrition,
    this.showAssets,
    this.landscapeView,
    this.disableComments,
    this.disableAmount,
    this.locked,
  });

  final bool? public;
  final bool? showNutrition;
  final bool? showAssets;
  final bool? landscapeView;
  final bool? disableComments;
  final bool? disableAmount;
  final bool? locked;

  static Settings? fromData({Map<String, dynamic>? data}) {
    if (data == null) return null;
    return Settings(
        public: data['public'],
        showNutrition: data['showNutrition'],
        showAssets: data['showAssets'],
        landscapeView: data['landscapeView'],
        disableComments: data['disableComments'],
        disableAmount: data['disbaleAmount'],
        locked: data['locked']);
  }

  Settings copyWith({
    bool? public,
    bool? showNutrition,
    bool? showAssets,
    bool? landscapeView,
    bool? disableComments,
    bool? disableAmount,
    bool? locked,
  }) {
    return Settings(
      public: public ?? this.public,
      showNutrition: showNutrition ?? this.showNutrition,
      showAssets: showAssets ?? this.showAssets,
      landscapeView: landscapeView ?? this.landscapeView,
      disableComments: disableComments ?? this.disableComments,
      disableAmount: disableAmount ?? this.disableAmount,
      locked: locked ?? this.locked,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (this.public != null) json['public'] = this.public;
    if (this.showNutrition != null) json['showNutrition'] = this.showNutrition;
    if (this.showAssets != null) json['showAssets'] = this.showAssets;
    if (this.landscapeView != null) json['landscapeView'] = this.landscapeView;
    if (this.disableComments != null)
      json['disableComments'] = this.disableComments;
    if (this.disableAmount != null) json['disableAmount'] = this.disableAmount;
    if (this.locked != null) json['locked'] = this.locked;
    return json;
  }

  @override
  List<Object?> get props => [
        public,
        showNutrition,
        showAssets,
        landscapeView,
        disableComments,
        disableAmount,
        locked,
      ];
}
