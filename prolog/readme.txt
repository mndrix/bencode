---+ Name

=bencode= - Bencoding per BEP 0003

---+ Synopsis

==
:- use_module(library(bencode)).
main :-
    bencode([amount-3, food-spam], Bencoded),
    format('~s~n', [Bencoded]),

    bencode(Term, "l5:hello6:worlde"),
    format('~w~n', [Term]).
% Outputs:
% d6:amounti3e4:food4:spame
% [hello, world]
==

---+ Description

library(bencode) implements Bencoding as used in the
[[BitTorrent protocol][http://www.bittorrent.org/beps/bep_0003.html]].
bencode/2 supports encoding, decoding and validation.  See the
predicate's documentation for full details.

---+ Installation

Using SWI-Prolog 6.3 or later:

==
    $ swipl
    1 ?- pack_install(bencode).
==

Source code available and pull requests accepted on GitHub:
https://github.com/mndrix/bencode


@author Michael Hendricks <michael@ndrix.org>
@license BSD
