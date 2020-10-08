class LvlSettings {
  final int numberOfTiles;
  final Duration roundDuration;

  const LvlSettings(this.numberOfTiles, {this.roundDuration});

  bool get isStress {
    return roundDuration != null;
  }
}
