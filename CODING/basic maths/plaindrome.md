
1. check :
	1. number is -ve ?
	2. number gives remainder 0 when divided by 10 and also check if number is not equal to 0 ?
	3. only check half of the number : `while(n>rev)`
2. while checking the number is palindrome or not check
	1. even : x\== rev
	2. odd : x \== rev /10

|Method|Idea|Time Complexity|Space Complexity|Notes|
|---|---|---|---|---|
|String method|Convert number to string and compare characters|O(log n)|O(log n)|Extra memory for string|
|Reverse full number|Reverse the integer and compare|O(log n)|O(1)|Risk of overflow|
|Reverse half (optimal)|Reverse only half the digits|O(log n)|O(1)|⭐ Best interview solution|
|Digit comparison|Compare first and last digits repeatedly|O(log n)|O(1)|Pure mathematical approach|
|Recursion|Compare digits recursively|O(log n)|O(log n)|Uses call stack|
