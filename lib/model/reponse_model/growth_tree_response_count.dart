class TreeGrowthResponse {
  int? status;
  String? responseCount;
  String? gardenType;
  String? maxCount;
  String? currentLevel;
  int? seedCount;
  String? currentStatus;
  int? nextLevel;
  bool? isPopUpForNewTreeSelection;
  String? mobileImageUrl;
  String? ipadImageUrl;
  String? mobilePreviousImageUrl;
  String? ipadPreviousImageUrl;

  TreeGrowthResponse(
      {this.status,
        this.responseCount,
        this.gardenType,
        this.maxCount,
        this.currentLevel,
        this.seedCount,
        this.currentStatus,
        this.nextLevel,
        this.isPopUpForNewTreeSelection,
        this.mobileImageUrl,
        this.ipadImageUrl,
        this.mobilePreviousImageUrl,
        this.ipadPreviousImageUrl});

  TreeGrowthResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    responseCount =  json['response_count'].toString();
    gardenType = json['garden_type'];
    maxCount = json['max_count'];
    currentLevel = json['current_level'];
    seedCount = json['seed_count'];
    currentStatus = json['level_status '];
    nextLevel = json['next_level'];
    isPopUpForNewTreeSelection = json['is_pop_up_for_new_tree_selection'] ?? false;
    mobileImageUrl = json['mobile_image_url'];
    ipadImageUrl = json['ipad_image_url'];
    mobilePreviousImageUrl = json['mobile_previous_image_url'];
    ipadPreviousImageUrl = json['ipad_previous_image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['response_count'] = responseCount;
    data['garden_type'] = gardenType;
    data['max_count'] = maxCount;
    data['current_level'] = currentLevel;
    data['seed_count'] = seedCount;
    data['level_status '] = currentStatus;
    data['next_level'] = nextLevel;
    data['is_pop_up_for_new_tree_selection'] = isPopUpForNewTreeSelection;
    data['mobile_image_url'] = mobileImageUrl;
    data['ipad_image_url'] = ipadImageUrl;
    data['mobile_previous_image_url'] = mobilePreviousImageUrl;
    data['ipad_previous_image_url'] = ipadPreviousImageUrl;
    return data;
  }
}