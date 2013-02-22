:- module(bencode, [bencode/2]).
:- use_module(library('dcg/basics'), [integer/3]).
:- use_module(library(plunit), [begin_tests/1, end_tests/1]).
:- use_module(library(when), [when/2]).

%%	bencode(?Term, ?Codes) is semidet.
%
%	True if Codes is the bencoding of Term.  In Term, atoms represent
%	byte strings.  Sorted lists of =|Key-Value|= pairs represent
%	dictionaries.  Integers and lists represent themselves.
bencode(Term, Codes) :-
    phrase(bval(Term), Codes).

bval(I) -->
    { freeze(I, integer(I)) },
    "i", integer(I), "e",
    !.
bval(L) -->
    "l", bvals(L), "e",
    !.
bval(Atom) -->
    { freeze(Atom, atom(Atom)) },
    { when(ground(Atom);ground(Bytes), atom_codes(Atom,Bytes)) },
    { when(ground(Bytes);ground(Length), length(Bytes,Length)) },
    integer(Length), ":", Bytes,
    !.
bval(Dict) -->
    { when(ground(Dict), keys_sorted(Dict)) },
    "d",
    bpairs(Dict),
    "e".

bvals([X|Xs]) --> bval(X), bvals(Xs), !.
bvals([]) --> "".

bpairs([K-V|Pairs]) --> bval(K), bval(V), bpairs(Pairs), !.
bpairs([]) --> "".

keys_sorted(L) :-
    is_list(L),
    keysort(L, L).


:- begin_tests(bencode).
test(spam_encode) :-
    bencode(spam, X),
    X = "4:spam".
test(spam_decode) :-
    bencode(X, "4:spam"),
    X = spam.
% TODO test arbitrary byte strings

test(int_encode) :-
    bencode(42, X),
    X = "i42e".
test(int_decode) :-
    bencode(X, "i42e"),
    X = 42.

test(negative_encode) :-
    bencode(-3, X),
    X = "i-3e".
test(negative_decode) :-
    bencode(X, "i-9e"),
    X = -9.

test(list_encode) :-
    bencode([spam, eggs], X),
    X = "l4:spam4:eggse".
test(list_decode) :-
    bencode(X, "l4:spam4:eggse"),
    X = [spam, eggs].

test(dictionary_encode) :-
    bencode([cow-moo, spam-eggs], X),
    X = "d3:cow3:moo4:spam4:eggse".
test(dictionary_decode) :-
    bencode(X, "d3:cow3:moo4:spam4:eggse"),
    X = [cow-moo, spam-eggs].
test(dictionary_list_value) :-
    bencode([spam-[a,b]], "d4:spaml1:a1:bee").
test(dictionary_longer) :-
    bencode([ publisher-bob
            , 'publisher-webpage'-'www.example.com'
            , 'publisher.location'-home
            ],
            "d9:publisher3:bob17:publisher-webpage15:www.example.com18:publisher.location4:homee"
           ).

:- end_tests(bencode).
