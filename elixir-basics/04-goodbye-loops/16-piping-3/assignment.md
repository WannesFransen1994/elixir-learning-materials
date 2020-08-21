# Assignment

## Task

Write a function `Bank.largest_expense_index(balance_history)` that returns the index of the most negative transaction.
`balance_history` is a list of numbers representing your bank account balance. A transaction is defined as
the difference between two successive balances.

For example, say the balance history is

```text
1000
1200
1150
1000
1200
500
2500
```

If we compute the differences, we get

```text
1000
        +200
1200
        -50
1150
        -150
1000
        +200
1200
        -700
500
        +2000
2500
```

Looking for the most negative transaction yields the fifth transaction, i.e., `-700`. It has index `4`, which
is therefore the value that should be returned by `largest_expense_index`.
