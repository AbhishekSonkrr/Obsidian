
# Square root method
use these condition for finding divisors
1. `N % i`
2. `i ! = N / i` 
3. `i * i <= N`

| No. | Method                             | Basic Idea                                                    | Time Complexity | When to Use                                     |
| --- | ---------------------------------- | ------------------------------------------------------------- | --------------- | ----------------------------------------------- |
| 1   | **Brute Force**                    | Check every number from `1` to `n` and see if it divides `n`  | O(n)            | Simple problems / beginners                     |
| 2   | **Square Root Method**             | Check from `1` to `√n` and add both divisors `i` and `n/i`    | **O(√n)**       | Most common and efficient method                |
| 3   | **Sorted √ Method**                | Same as √ method but store divisors in sorted order           | O(√n) + sorting | When sorted output is required                  |
| 4   | **Prime Factorization Method**     | Find prime factors of `n` and generate all divisors from them | ~O(√n)          | Mathematical / advanced problems                |
| 5   | **Recursion Method**               | Recursively check numbers from `1 → n`                        | O(n)            | Learning recursion concepts                     |
| 6   | **Precomputation / Divisor Sieve** | Precompute divisors for many numbers using sieve technique    | O(n log n)      | Competitive programming when many queries exist |


Here are the **algorithms in code blocks** for the useful methods.

---

# 1. Brute Force Method
```
Algorithm BruteForceDivisors(n)

1. start
2. input n
3. create empty list divisors
4. for i = 1 to n
5.     if n % i == 0
6.         add i to divisors
7. end for
8. return divisors
9. end
```

---

# 2. Square Root Method (Most Important)

```
Algorithm SquareRootDivisors(n)

1. start
2. input n
3. create empty list divisors
4. for i = 1 while i * i <= n
5.     if n % i == 0
6.         add i to divisors
7.         if i != n / i
8.             add n / i to divisors
9. end for
10. return divisors
11. end
```

---

# 3. Prime Factorization Method

```
Algorithm PrimeFactorDivisors(n)

1. start
2. input n
3. find prime factorization of n
4. store prime factors and their powers
5. generate all combinations of powers
6. multiply combinations to get divisors
7. store each divisor
8. return list of divisors
9. end
```

---

# Summary

```
Brute Force        → check 1 to n
Square Root Method → check 1 to √n
Prime Factorization→ use prime factors to generate divisors
```

---

| No. | Method                                      | Use                                                                  | Why This Method Is Used                                                                                           |
| --- | ------------------------------------------- | -------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------- |
| 1   | **Brute Force (1 → n)**                     | Learning divisors, very small numbers                                | Because it is the **simplest approach** and easy to understand                                                    |
| 2   | **Square Root Method (1 → √n)**             | Finding all divisors of a number                                     | Because **divisors occur in pairs `(i, n/i)`**, so we only check up to √n which makes it faster                   |
| 3   | **Sorted √n Method**                        | Printing divisors in sorted order                                    | Because the normal √n method returns **unordered divisors**, so sorting keeps them ordered                        |
| 4   | **Prime Factorization**                     | Counting divisors, sum of divisors, GCD, LCM, number theory problems | Because **prime factors contain full information about the number**, allowing formulas to compute results quickly |
| 5   | **Divisor Sieve (Precomputation)**          | Many divisor queries (1…N)                                           | Because calculating divisors repeatedly is slow, so we **precompute once and reuse**                              |
| 6   | **Recursive generation from prime factors** | Generate divisors after factorization                                | Because divisors can be formed by **combining powers of prime factors**                                           |