/// Representa um jogador cadastrado na sessao do "Nem a Pato".
class NemAPatoPlayerEntity {
  final String id;
  final String name;
  final int roundsWon;
  final int punishmentsTaken;

  const NemAPatoPlayerEntity({
    required this.id,
    required this.name,
    this.roundsWon = 0,
    this.punishmentsTaken = 0,
  });

  NemAPatoPlayerEntity copyWith({
    String? id,
    String? name,
    int? roundsWon,
    int? punishmentsTaken,
  }) {
    return NemAPatoPlayerEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      roundsWon: roundsWon ?? this.roundsWon,
      punishmentsTaken: punishmentsTaken ?? this.punishmentsTaken,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is NemAPatoPlayerEntity &&
            other.id == id &&
            other.name == name &&
            other.roundsWon == roundsWon &&
            other.punishmentsTaken == punishmentsTaken);
  }

  @override
  int get hashCode => Object.hash(id, name, roundsWon, punishmentsTaken);
}

