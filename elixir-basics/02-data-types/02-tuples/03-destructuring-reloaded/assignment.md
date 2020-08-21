# Assignment

## Task

Write a function `Cards.higher?(card1, card2, trump_suit)` that determines
whether `card1` has a higher value than `card2`, according to rules
common to many card games involving trump cards.
`card1` and `card2` are both tuples with structure `{value, suit}`.

For those unfamiliar with card games:
first you look at the suits.

* If both cards have the same suit, it is the cards' values
  that determine the outcome. In increasing order: `2`, `3`, ..., `10`, `jack`, `queen`, `king`, `ace`.
* If the first card is not a trump card (i.e., its suit is
  not equal to `trump_suit`) but the second card is, the
  second card is always higher.
* In all other cases, the first card is higher.

For example,

* 10&hearts; is higher than 5&hearts;.
* 2&hearts; is higher than 5&clubs;, as long as &clubs; is not the trump suit.
* K&spades; is lower than 2&hearts; if &hearts; is trump.
