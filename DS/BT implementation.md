# Algo

<mark style="background: #FFB8EBA6;">step1</mark> 
start

<mark style="background: #FFB8EBA6;">step2</mark> 
allocate memory for new node,
newNode=(struct node * )malloc(sizeof(struct node))

<mark style="background: #FFB8EBA6;">step3</mark>
promt the user,
"enter the value for node OR -1 to stop"

<mark style="background: #FFB8EBA6;">step4</mark>
read value from user

<mark style="background: #FFB8EBA6;">step5</mark>
if x\==-1
return NULL

<mark style="background: #FFB8EBA6;">step6</mark>
assign data to new node
newNode->data=x

<mark style="background: #FFB8EBA6;">step7</mark>
recursively create left node
newNode->left=create();

<mark style="background: #FFB8EBA6;">step8</mark>
recursively create right node
newNode->right=create();

<mark style="background: #FFB8EBA6;">step9</mark>
return newNode

<mark style="background: #FFB8EBA6;">step8</mark>
stop

---

algo for main()
<mark style="background: #FFB8EBA6;">step1</mark>
start

<mark style="background: #FFB8EBA6;">step2</mark>
declare pointer 
start=NULL

<mark style="background: #FFB8EBA6;">step3</mark>
call tree creation function
start=create();

<mark style="background: #FFB8EBA6;">step4</mark>
stop