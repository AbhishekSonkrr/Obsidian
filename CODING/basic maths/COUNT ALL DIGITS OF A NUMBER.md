>**there are three ways to solve this problem** :
>1. loop
>2. log
>3. string
>4. recursion

# loop 
><mark style="background: #FF5582A6;">best for interview</mark>

step 1: find the quotient of given number n. 
step 2: assign that quotient to n
step 3: repeat this step until n>0

----
# log
step 1: take the log of given number 
step 2: now take floor of that no. 
step 3: and add 1 and return the solution 

---
# string
step 1: convert number to string 
step 2: return the length of string

---
# recursion
step 1: base case
```
if (n>10) return 1;
```

step 2: recursively call the function and pass the n/10 value and add 1 

---

|Method|Idea|Pros ✅|Cons ❌|
|---|---|---|---|
|**Loop (divide by 10)**|Repeatedly do `n = n / 10` until `0`|Simple logic, no extra memory, works for all integers, good for interviews|Slightly slower than constant-time methods|
|**Logarithm (`log10`)**|`floor(log10(n)) + 1`|Very short code, constant time|Uses floating-point math, precision issues for very large numbers, must handle `n = 0` separately|
|**String conversion**|`to_string(n).length()`|Easiest to write and read|Extra memory allocation, slower, not ideal in competitive programming|
|**Recursion**|Call function with `n/10` until base case|Elegant conceptually|Function call overhead, stack usage|


