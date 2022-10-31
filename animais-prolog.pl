% árvore inicial
tree(
[
  "Mamifero?",
  [
    [
      "Tem listras?",
      [
        ["Eu chuto zebra!", []],
        ["Eu chuto leao!", []]
      ]
    ],
    [
      "Passaro?",
      [
        [
          "Ele voa?",
          [
            ["Eu chuto aguia!", []],
            ["Eu chuto pinguim!", []]
          ]
        ],
        "Eu chuto lagarto!"
      ]
    ]
  ]
]
).

% associa a X o que estiver no 'sim' da lista L (posicao 0)
sim(X, L):-
  L = [X|_].

% associa a X o que estiver no 'nao'  da lista L (posicao 1)
nao(X, L):-
  L = [_|[X|_]].

% mensagens de fim de jogo
acertou():- write("Oba! Acertei!"), nl, nl.
errou():- write("Droga! Errei!"), nl, nl.

% faz uma pergunta pro usuário, avança com a resposta
pergunta(T, Re):-
  T = [P, Rs],
  write(P), write(" (responda s. ou n.)"), nl,
  read(RESP), nl,
  (
    % se respondeu sim ou nao
    RESP = s ->
      (
        % checando se o jogo acabou
        Rs = [] ->
          acertou(),
          play_again(Re)
          ;
          sim(Re, Rs)
      )
    ;
      (
        % checando se o jogo acabou
        Rs = [] ->
          errou(),
          play_again(Re)
          ;
          nao(Re, Rs)
      )
  ).

% jogo
jogo(TREE):-
  pergunta(TREE, Re),
  jogo(Re).

% inicio do jogo
start_game():-
  tree(TREE),
  jogo(TREE).

% jogar de novo
play_again(Re):-
  write("Jogar de novo? (responda s. ou n.)"), nl,
  read(RESP), nl,
  (
    RESP = s ->
      write("OK! Vamos!"), nl, nl,
      start_game()
    ;
      write("Ate mais!"), nl, nl,
      Re=0
  ).

