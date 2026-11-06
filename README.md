# Mímica Party Game (Android)

Jogo de Mímica estilo **Party Game** desenvolvido em **Flutter** exclusivamente para a plataforma **Android**, projetado para ser offline, rápido, com visual tátil 3D e APK superleve (com R8/ProGuard ativado).

---

## 1. Sobre o Jogo e Regras da Partida

- **Equipes:** Suporta de **2 a 6 equipes** (com 2 a 6 jogadores por equipe).
- **Pontuação Alvo:** Configurável antes da partida entre **20 e 60 pontos**.
- **Sorteio de Categorias:** A cada turno, o aplicativo sorteia **4 opções** dentre as **12 categorias disponíveis** (*Ações, Objetos, Lugares, Animais, Verbos, Filmes, Heróis, Profissões, Esportes, Comidas, CEP [Cidade, Estado, País] e Difícil/Aleatório*). A equipe da vez escolhe **1 categoria**.
- **Níveis de Risco e Pontuação:**
  - **Fácil (+1 Ponto):** 1 palavra simples (ex: *"Faca"*). Erro: 0 pts.
  - **Normal (+2 Pontos):** 1 palavra mais específica (ex: *"Copo de plástico"*). Erro: 0 pts.
  - **Difícil (+3 Pontos):** 2 palavras fáceis combinadas para fazer mímica junto (ex: *"Pano de chão e Celular"*). Erro: 0 pts.
  - **Bônus (+4 Pontos / Penalidade de -2 Pontos):** 1 palavra Normal acompanhada de uma restrição física obrigatória (ex: *"Sem usar as mãos"*, *"De costas para a equipe"*). **Regra Especial:** Se errar o Bônus, a equipe **perde 2 pontos**.
- **Sem Repetição de Palavras:** Nenhuma palavra sorteada na partida se repete para outra equipe.
- **Temporizador Duplo:** **5 segundos** de preparação (palavra já visível na tela) seguidos automaticamente por **70 segundos** de mímica (com opção de pausar/retomar e encerrar antes).
- **Vitória Imediata:** Sem equilíbrio de turnos. A primeira equipe que atingir ou ultrapassar a pontuação máxima estipulada vence na hora!

---

## 2. Stack Tecnológica e Arquitetura

- **Framework:** Flutter & Dart (Null Safety estrito)
- **Arquitetura:** Feature-First Clean Architecture (`domain`, `data`, `presentation`)
- **Gerenciamento de Estado:** `flutter_riverpod` (`Notifier`)
- **Imutabilidade e Serialização:** `freezed` + `json_serializable`
- **Banco de Dados Offline:** JSON estruturado nos assets (`assets/data/words_db.json`) com cache em memória RAM
- **Feedbacks e Tipografia:** `audioplayers`, `vibration` e `google_fonts` (*Fredoka* + *Nunito*)

---

## 3. Pré-requisitos para Rodar o Projeto

Antes de começar, certifique-se de ter instalado na sua máquina:
1. **Git** ([git-scm.com](https://git-scm.com/))
2. **Flutter SDK** (versão `3.5.0` ou superior — [docs.flutter.dev](https://docs.flutter.dev/get-started/install))
3. **Android Studio** (com Android SDK e um Emulador Android configurado) ou um **Celular Android físico** com a *Depuração USB* ativada.

---

## 4. Passo a Passo: Como Baixar e Executar o Projeto

Siga os comandos abaixo no seu terminal:

### Passo 1: Clonar o repositório do GitHub
```bash
git clone https://github.com/caioeduardoml/MimicaPartyGame.git
```

### Passo 2: Entrar na pasta do projeto
```bash
cd MimicaPartyGame
```

### Passo 3: Instalar todas as dependências do Flutter
```bash
flutter pub get
```

### Passo 4: Gerar os arquivos de código (Freezed / JsonSerializable)
*(Os arquivos já vão pré-gerados no repositório, mas caso você faça alguma alteração nos models, basta rodar):*
```bash
dart run build_runner build --delete-conflicting-outputs
```

### Passo 5: Executar o aplicativo no Emulador ou Celular Android
Com o emulador Android aberto (ou seu celular conectado via cabo USB):
```bash
# Verifique se o dispositivo foi reconhecido
flutter devices

# Inicie o aplicativo
flutter run
```

---

## 5. Como Gerar o APK Instalável para Celular (Versão de Produção)

Se você quiser gerar o arquivo `.apk` otimizado e superleve para enviar e instalar diretamente em qualquer celular Android:

```bash
flutter build apk --release --split-per-abi
```

Após concluir o comando, o arquivo pronto para instalação estará no caminho:
```text
build/app/outputs/flutter-apk/app-arm64-v8a-release.apk
```
Basta enviar esse arquivo para o seu celular Android e tocar nele para instalar!

---

## 6. Estrutura de Pastas do Projeto

```text
├── android/                  # Configurações Android e regras R8/ProGuard
├── assets/
│   ├── audio/                # Efeitos sonoros (.mp3)
│   ├── data/
│   │   └── words_db.json     # Banco de dados com centenas de palavras e penalidades
│   └── icon/
│       └── app_icon.png      # Ícone oficial do aplicativo
├── lib/
│   ├── core/
│   │   ├── services/         # Serviço de vibração (Haptics) e sons (feedback_service.dart)
│   │   └── theme/            # Tema Party Game 3D, cores e fontes (app_theme.dart)
│   ├── features/
│   │   └── mimica/
│   │       ├── domain/       # Entidades (TeamEntity, MimicCardEntity), Enums e Contratos
│   │       ├── data/         # Leitura do JSON e sorteador sem repetição (WordRepositoryImpl)
│   │       └── presentation/ # Estado (GameNotifier/GameState), Botões 3D e as 7 Telas do jogo
│   └── main.dart             # Ponto de entrada do aplicativo
└── pubspec.yaml              # Dependências e declaração de assets
```

---

## 7. Como Personalizar ou Adicionar Novas Palavras

Não é necessário alterar nenhum código Dart para adicionar novas palavras ou penalidades:
1. Abra o arquivo `assets/data/words_db.json`.
2. Adicione novas restrições físicas na lista `"penalties"`.
3. Adicione novas palavras nas listas `"easy"` (Fácil) ou `"normal"` (Normal/Bônus) dentro de qualquer uma das 12 categorias.
4. Salve o arquivo e reinicie o app!
