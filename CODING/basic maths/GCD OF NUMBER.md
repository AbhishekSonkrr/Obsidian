| Method                  | Idea                                    | Time Complexity | Space Complexity | Notes                |
| ----------------------- | --------------------------------------- | --------------- | ---------------- | -------------------- |
| Brute Force             | Check all numbers up to `min(n1,n2)`    | O(min(n1,n2))   | O(1)             | Very slow            |
| Optimized Brute Force   | Check from `min(n1,n2)` downward        | O(min(n1,n2))   | O(1)             | Slightly better      |
| Euclidean (Subtraction) | Repeatedly subtract smaller from larger | O(n) worst      | O(1)             | Old method           |
| Euclidean (Modulo)      | Use remainder repeatedly                | **O(log n)**    | O(1)             | ⭐ Best               |
| Prime Factorization     | Factorize both numbers and compare      | O(√n)           | O(1)             | Rarely used          |
| Recursive Euclidean     | Same as modulo but recursive            | **O(log n)**    | O(log n) stack   | Clean implementation |

> [!abstract]- code
> ```cpp
> class Solution {
>public:
>    int GCD(int n1,int n2) {
>        while(n1>0 && n2>0)
>        {
>            n1>n2 ? n1=n1%n2 : n2=n2%n1;
>        }
>    return max(n1,n2);
>    }
>};
> ```