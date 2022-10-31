% arvore de conhecimento
:- dynamic tree/1.
tree(
[
  "Eh mamifero?",
  [
    [
      "Tem listras?",
      [
        "zebra",
        "leao"
      ]
    ],
    [
      "Passaro?",
      [
        [
          "Ele voa?",
          [
            "aguia",
            "pinguim"
          ]
        ],
        "lagarto"
      ]
    ]
  ]
]
).

% algoritmo de substituicao
subs(_, _, [], []).
subs(X, Y, [X|T1], [Y|T2]) :- subs(X, Y, T1, T2), !.
subs(X, Y, [H|T1], [H|T2]) :- \+ is_list(H), subs(X, Y, T1, T2), !.
subs(X, Y, [H1|T1], [H2|T2]) :- subs(X, Y, H1, H2), subs(X, Y, T1, T2).

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
  (
    % se eh o fim ou nao
    T = [P, Rs] ->
      % ainda tem perguntas
        write(P), write(" (responda s. ou n.)"), nl,
        read(RESP), nl,
        (
          RESP = s ->
            % respondeu sim
            sim(Re, Rs)
          ;
            % respondeu nao
            nao(Re, Rs)
        )
      ;
      % resposta final eh T
        T = Re,
        atom_concat("Eu chuto ", Re, CHUTO),
        atom_concat(CHUTO, "!", CHUTEFINAL),
        write(CHUTEFINAL), write(" (responda s. ou n.)"), nl,
        read(RESP), nl,
        (
          RESP = s ->
            % respondeu sim
            acertou(),
            play_again(Re)
          ;
            % respondeu nao
            errou(),
            aprende(Re),
            play_again(Re)
        )
  ).

% aprendizado por rodada
aprende(T):-
  write("Em qual animal voce estava pensando? "), nl,
  read(CORRECT), nl,

  atom_concat("Que pergunta seria verdadeira para ", CORRECT, QUEPERG1),
  atom_concat(QUEPERG1, " e falsa para ", QUEPERG2),
  atom_concat(QUEPERG2, T, QUEPERG3),
  atom_concat(QUEPERG3, "?", PERGUNTA),
  write(PERGUNTA), nl,
  read(NEWQUEST), nl,

  NewNode = [NEWQUEST , [CORRECT, T]],
  tree(FullTree),

  subs(T, NewNode, FullTree, NewTree),

  retract(tree(FullTree)),
  assert(tree(NewTree)),
  write("Entendido!"), nl, nl.

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

