/// Modos de jogo disponiveis no "Nem a Pato".
enum NemAPatoGameMode {
  /// Fluxo continuo sem turnos individuais; os jogadores chutam em voz alta na mesa.
  classic('Modo Clássico', 'Aberto e rápido na mesa'),

  /// Fluxo Pass-and-Play em turnos com input numerico secreto, votacao e trava dos 80%.
  secret('Modo Secreto', 'Pass-and-Play com chutes secretos');

  final String label;
  final String subtitle;
  const NemAPatoGameMode(this.label, this.subtitle);
}

/// Modo de escolha da punicao (aplicavel ao Modo Secreto).
enum PunishmentSelectionMode {
  /// Os proprios jogadores votam em qual punicao desejam aplicar na rodada.
  voting('Votação da Mesa'),

  /// O aplicativo sorteia automaticamente uma das 4 punicoes a cada pergunta.
  random('Sorteio Aleatório');

  final String label;
  const PunishmentSelectionMode(this.label);
}

/// As 4 punicoes oficiais do jogo "Nem a Pato".
enum PunishmentType {
  onlyWorstDrinks(
    label: 'Só o pior bebe',
    shortLabel: 'Só o Pior',
    description: 'Apenas o último colocado (maior erro absoluto) sofre a punição.',
  ),
  oneThirdDrinks(
    label: '1/3 bebe',
    shortLabel: '1/3 Bebe',
    description: 'O um terço (1/3) com os piores palpites da rodada sofre a punição.',
  ),
  halfDrinks(
    label: 'Metade bebe',
    shortLabel: 'Metade Bebe',
    description: 'A metade inferior do ranking da rodada sofre a punição.',
  ),
  onlyBestSpared(
    label: 'Só o melhor não bebe',
    shortLabel: 'Todos menos 1º',
    description: 'Apenas o grande vencedor da rodada escapa; todos os outros bebem!',
  );

  final String label;
  final String shortLabel;
  final String description;

  const PunishmentType({
    required this.label,
    required this.shortLabel,
    required this.description,
  });
}

/// Multiplicadores de grandeza numerica para o Input Customizado.
enum NumberMagnitude {
  unit(
    label: 'Unidade',
    shortChip: 'x1',
    multiplier: 1.0,
    suffix: '',
  ),
  thousand(
    label: 'Mil',
    shortChip: 'Mil (x1K)',
    multiplier: 1e3,
    suffix: 'mil',
  ),
  million(
    label: 'Milhão',
    shortChip: 'Milhão (x1M)',
    multiplier: 1e6,
    suffix: 'milhões',
  ),
  billion(
    label: 'Bilhão',
    shortChip: 'Bilhão (x1B)',
    multiplier: 1e9,
    suffix: 'bilhões',
  ),
  trillion(
    label: 'Trilhão',
    shortChip: 'Trilhão (x1T)',
    multiplier: 1e12,
    suffix: 'trilhões',
  );

  final String label;
  final String shortChip;
  final double multiplier;
  final String suffix;

  const NumberMagnitude({
    required this.label,
    required this.shortChip,
    required this.multiplier,
    required this.suffix,
  });
}

/// Fases da maquina de estados que controla o fluxo de telas do "Nem a Pato".
enum NemAPatoPhase {
  home,
  setup,
  classicQuestion,
  classicReveal,
  secretPassDevice,
  secretPlayerTurn,
  secretEightyPercentAlert,
  secretRoundResult,
}

