enum BannerType {
  position1,
  position2,
  position3,
  position4,
  position5,
}

//扩展
extension BannerPosition on BannerType {
  int get position {
    switch(this) {
      case BannerType.position1: return 1;
      case BannerType.position2: return 2;
      case BannerType.position3: return 3;
      case BannerType.position4: return 4;
      case BannerType.position5: return 5;
    }
  }
}
