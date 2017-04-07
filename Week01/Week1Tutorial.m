%Introduction to MATLAB

%This tutorial will serve as a brief orientation to the MATLAB language.
%
%We hope to cover many of the concepts that will be used throughout the
%course. 
%
%----

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%PART 1: Syntax, Operations, and Variables.
%Basic Arithmetic & Logical operators
%
%Numerical operations are important for every programming language, but
%they are central to MATLAB. 
%
%Here is a quick vocab lesson:
%
%operator: A routine that takes two or more values and manipulates them in
%some way.
%   -Binary operator: a routine that takes exactly two values and
%   manipulates them in some way.
%   -Unary operator: A routine that takes exactly one value and manipulates
%   it in some way. 
%
%operand: the values that are manipulated by the operator

%For example, in the addition operation 5+8, 5 and 8 are operands 
%(specifically, 5 the augend and 8 is the addend), and "+" is the
%(binary) operator.
%
%Lets say that you wanted to use MATLAB as a calculator, so your goal is
%to print out the results of arithmetic operations to the screen. Here are
%some examples:

%--------------------------------------DEMO CODE--------------------------------------------------
5+8 %addition of two numbers
3-1 %subtraction of two numbers
4*2 %multiplication of two numbers
7/9 %division of two numbers
2^4 %exponentiation of one number by another number
log(3) %(natural) log of a number. 
exp(2) %exponentiation of the natural number (to the power of two)
-5 %Unary negation operator. negates the number '5'. 

%It is important to remember the order of operations, lest you write code
%with nonsensical outputs. PEMDAS!
(3+2)/9^2+7
%-----------------------------------------------------------------------------------------------------

%Comparison & operations are very important for programming, too. Sometimes it
%is important to test the relative value of two numbers (e.g., whether one
%is bigger, or whether they are equal) before you do some other operation.
%
%Whereas the output of an arithmetic operation is a number, the output of a
%logical operation is a boolean (i.e., 1 or 0 corresponding to true or
%false). 

%--------------------------------------DEMO CODE--------------------------------------------------
%Comparison operators
3==3 %test for equality
2~=5 %test for inequality. In other programming languages, the "not equals" operator is !=. In MATLAB, it is ~=. 
6>4 %greater than
7<9 %less than
4>=4 %greater than or equal to
1<=8 %less than or equal to

true==1 %in matlab, the word "true" and the number "1" are the same.
true==.9 %true is exactly 1. It is not just anything that isn't zero.
true==1.1

false==0 %in matlab, the word "false" and the number "0" are the same.

%Operator precedence is important for comparison operators as well. All
%arithmetic operations take precedence over comparison operators.
3*5>4*16 %If arithmetic is evaluated first, this should simply be false (as 3*5 is not greater than 4*16). If comparison operations are evaluated first, this should be equal to 3*true*16, or 3*1*16. 
(3*5)>(4*16) %this is equivalent to the above, except that the order of operations is made explicit by parnethesis (operations in parenthesis are always evaluated first)
3*(5>4)*16 %this is NOT equivalent to the first statement. 
%-----------------------------------------------------------------------------------------------------
%
%Another type of statement that returns a boolean value is called simply a
%logical operation. These test the relationship between logical statements.

%--------------------------------------DEMO CODE--------------------------------------------------
5>4 && 6==6 %The and operator. This is true when both its left and right operand are true.

2>3 || 1~=7 %The or operator. This is true when one or both of its operands are true.

~(5>7) %The not operator. This is a unary operator that is returns true when its operand is false, and returns false when its operand is true. Essentially, it flips the "truth value" of its operand.
%Unlike other logical operators, the not operator takes precedence over
%multiplication and subtraction
%-----------------------------------------------------------------------------------------------------



%For more on operator precedence in MATLAB, see this page: http://www.mathworks.com/help/matlab/matlab_prog/operator-precedence.html

%Variables
%
%A lot of the power of programming languages rests in the ability to
%operate on data that are stored in the computer's memory. Data, such as
%numbers, are stored in variables. 
%
%--------------------------------------DEMO CODE--------------------------------------------------
x=5 %this declares a variable. 
%Note, this is NOT the equality operator, as it only has one '='. 
%This is called the assignment operator, which changes the value of its
%left operand to the value of the right operand.

x+6 %you can use variables as operands to arithmetic operators
x>4 %and comparison operators.

%Variables can be named however you want, and can even include numerals.
%However, you cannot start a variable name with a numeral. You should also
%be careful not to name the variable something that is already taken (e.g.,
%'log'), lest you introduce unwanted behavior in your code. 
arithmeticResult1 = 5+7/8

y = arithmeticResult1 > x; %the semi-colon will stop the operation from being displayed in the terminal.
y %you can print it later explicitly like this.
%-----------------------------------------------------------------------------------------------------




%Vectors & Matrices
%
%Mathworks developed MATLAB to be a scripting language that can handle
%matrices and matrix arithmetic very efficiently. This is why the language
%is so popular - many problems in scientific computing are ultimately
%solvable using matrix operations.
%--------------------------------------DEMO CODE--------------------------------------------------
firstVector = [5,6,7]; %This is matrix notation. This variable is a 1x3 matrix (vector) that holds all three values, 5,6, and 7.
firstVector

secondVector = [1;2;3]; %whereas the commas separate by columns, the semi-colon denotes a new row. Thus, this is a 3x1 vector.
secondVector

firstVector' %the ' is the unary transpose operator. This turns an nxm matrix into an mxn matrix. 

%All of the arithmetic operators always work with matrices as long as one
%of the operands is a scalar.
firstVector*5 
firstVector+3
firstVector-10
secondVector/2

%Even comparison operators work as long as one of the operands is a scalar.
firstVector==5
firstVector>=6
firstVector<6

%However, if both of the operands to an arithmetic operator are matrices,
%you will perform matrix operations (e.g., * is a dot product). It is often
%important to be aware of the dimensions of your matrices for these
%operations, otherwise they won't work.

firstVector*secondVector %takes the dot (inner) product of the two matrices
secondVector'*firstVector' %this wouldn't work without the transpose operators

firstVector/secondVector %this won't work unless you transpose the secondVector
firstVector/secondVector'

firstVector+secondVector' %dimensions need to match exactly for addition/subtraction, so a transpose is necessary

%Sometimes you want to multiply the corresponding elements of two matrices 
%together, rather than taking the dot product of two matrices. There are
%special operators for this:

firstVector.*secondVector' %the .* operator is the elementwise multiplication operator. This takes two nxm matrices, and multiplies the corresponding elements together and returns an nxm matrix.
firstVector./secondVector' %elementwise division.
%-----------------------------------------------------------------------------------------------------


%We have been working with vectors, but you can also make matrices.
%--------------------------------------DEMO CODE--------------------------------------------------
firstMatrix = [1,2,3;4,5,6;7,8,9]; %This is a 3x3 matrix.
secondMatrix =  [1:3;4:6;7:9]; %The colon operator is a shorthand way to enumerate the integers between its left and right operator (inclusive)
firstMatrix==secondMatrix

%To access a particular element of a matrix, you use the following
%notation:
firstMatrix(2,3) %this accesses the second row, third column of firstMatrix
firstMatrix(3,2) %Different, of course - you're getting the third row, second column here.

%Sometimes you want an entire row or column.
firstMatrix(:,1) %this gets the entire first column. Think of this as specifying "all rows," and column 1.
firstMatrix(2,:) %this gets the entire second row. This is a 1x3 matrix.
firstMatrix(2,1:2) %this gets you the second row, and both the first and second columns. This is a 1x2 matrix.

firstMatrix(:,1).*firstMatrix(:,3) %The above operations will get you vectors/matrices that can be used with matrix operators.

%-----------------------------------------------------------------------------------------------------




%Data types
%
%Not all data is numeric. Likewise, not all variables hold numbers.
%Sometimes, you are interested in storing characters or booleans in a
%variable instead of just numbers.
%--------------------------------------DEMO CODE--------------------------------------------------
greeting = 'hello world'; %a set of characters is called a string. anything between two single quotation marks is treated as a string.
greeting

logicalValue = 5>4;

numericalValue = logicalValue*4 + (1-logicalValue)*5 %recall that true==1 and false==0. This line of code is a handy trick that exploits that fact to condition the value of numericalValue on the value of logicalValue.

greeting*5 %you actually can multiply characters by numbers. This is because each character is associated with a numerical value, that is used behind-the-scenes. Try to avoid doing this.

%-----------------------------------------------------------------------------------------------------
%Other languages require you to explicitly specify the type of data that a
%variable will hold when you first declare the variable, like java or C++.
%Matlab is a dynamically-typed language, so it does not require that you
%specify data types when you declare variables - the same variable that
%once held a number can later hold a string. This can be convenient, but
%can also lead to some confusing or unexpected runtime/logical errors.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%PART 2: Control statmenets
%
%Until now, I've shown you how to use MATLAB like a particularly advanced
%calculator. However, most of the advantage of a programming language lies
%in the fact that you can write a sequence of programming logic that will
%operate on some inputs in a fairly complex way, e.g. data analysis. 
%
%At the heart of programming logic are control statements, which specify
%what to do with a line of code and when to do it.


%If-statements
%
%The simplest of the control statements are the conditional statements,
%which perform one of a set of possible operations based on some logical
%value.
%
%Conditional statements are powerful enough that you can use them alone to
%write some fairly complicated programs.
%--------------------------------------DEMO CODE--------------------------------------------------

%The subsequent 5 lines of code are a simple if...else statement. 
if(5>4) %Its easy to think of 'if' as a unary operator, with its single argument being a statement that returns a logical value. This is the condition.
    'math still works' %this will print if the condition is true. 
else
    'unfortunately, math no longer works' %this will print if the conditional statement is not true.
end %you have to put 'end' at the end of all control statements.


%There are also more complicated conditional control statements:
if(4>5) %First, this statement is checked for truth.
    'uh oh' 
elseif(2>3) %If the first statement is false, this statement is checked for truth.
	'this is bad' 
elseif(6>1) %if the previous statement is false, then this statement is checked for truth.
    'this is great news' 
else %If none of the conditions are met, this will run. 
    'things do not look good'
end

%...But it is not necessary to have any 'else' conditions at all
if(6>3)
    'this will work'
end
%-----------------------------------------------------------------------------------------------------



%Looping statements
%
%Sometimes, you want to repeat a particular action some number of times.
%There are a number of control statements that allow you to do this.
%--------------------------------------DEMO CODE--------------------------------------------------
%The most commonly used looping statement is a for-loop. 
x = 0;
for i=1:10 %here, you set a looping variable to be each of the values between 1 and 10 on each of the n iterations, where n is the number of integers on the interval [1,10].
    x = x+i; %this will accumulate the values of i on each loop
end
x == 1+2+3+4+5+6+7+8+9+10

%you can even combine conditional statements and looping statements
for i=1:10
    if(i==5)
        'this is the fifth iteration'
    end
end


%There is another kind of looping statement called a 'while' loop. The
%while loop will repeatedly execute until some condition is no longer true.

%This while loop is a lot like a foor loop going from 1 to 10.
i = 1;
x2 = 0;
while(i<=10)%the statements in the loop will keep executing until i is greater than 10.
    x2 = x2+i;
    i = i+1; %if you didn't include this statement, you would have an infinite loop that would never terminate. 
end
x2 == 1+2+3+4+5+6+7+8+9+10
%-----------------------------------------------------------------------------------------------------
%There are many cases where for-loops and the like can be replaced with
%matrix operations. The practice of minimizing for-loops in lieu of matrix
%operations is called "vectorizing" your code. Matrix operations are very
%efficient in matlab, so vectorizing should be practiced as often as
%possible.



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%PART 3: Functions

%Named functions
%
%Sometimes, you need to do something more complicated than one of the
%operators described in part 1 can do. For these purposes, you have
%pre-written functions that can operate on data in some complicated way.
%
%The data that you input to a function are called "arguments." Operands 
%are to operators as arguments are to functions. The general syntax is as
%follows:
%output = functionName(argument1,argument2,argument3).
%
%There can be a variable number of arguments to a function.
%
%you can write your own functions too.
%http://www.mathworks.com/help/matlab/matlab_prog/create-functions-in-files.html)
%
%Here are a few example functions. This is by no means exhaustive, nor are
%these necessarily the "best" functions in matlab.
%--------------------------------------DEMO CODE--------------------------------------------------
randomValues = rand(5) %the rand function makes an nxn matrix
randomValues2 = rand([10 3]) %if you argue a matrix to rand, it will return a matrix of random values where the ith dimension is of the size specified by the ith value in the matrix.

s1 = 100;
s2 = 5;
bigmatrix = zeros(s1,s2); %makes a s1xs2 matrix of zeros. Useful when you don't want to manually make large matrices, or if some variable programming logic sets the values of s1 and s2.

[dim1,dim2] = size(bigmatrix);%the size function gets the length of each dimension of the argued matrix.
if(dim1==s1 && dim2==s2)
    disp('some functions return more than one value') %the disp function prints its argument to the console
end

%the linspace function returns a uniformly spaced vector between its first two arguments, with a number of elements equal to the third argument.
lowerend = 0;
upperend = 10*pi;%matlab knows what pi is by default
nelements = 1000;
xvalues = linspace(lowerend,upperend,nelements);

%The mod function returns the remainder when the first operator is divided
%by the second. This is like the modulus operator in other languages.
mod(7,3) %remainder 1
mod(10,5) %remainder 0

%To figure out what any function does, type help then the function name
help linspace

%-----------------------------------------------------------------------------------------------------
%Usually, if you want to do something in matlab, it has been done. Use
%google gratuitously when undertaking a programming project, and also to
%look up functionality in matlab. 
%Mathworks.com publically hosts user-defined functions that are submitted 
%so that all matlab users can download them if they desire. These functions
%can be incredibly time-saving and useful. As with your own code, always 
%verify that it works before you trust it!
%
%for example, try searching "shaded error bars in matlab"


%The plot function
%
%The plotting function is one of the reasons that people use MATLAB over
%other (free) languages. It makes data visualization very easy. 
%--------------------------------------DEMO CODE--------------------------------------------------
x = linspace(0,10*pi,1000);
y = sin(x); %The sin function evaluates the sin function at each value in its argued vector (or matrix).

plot(x,y); %The simplest usage of the plotting function. Plots y against x.
close all; %This closes all open plotting windows.

%You can even plot multiple series to the same window.
y1 = sin(x);
y2 = cos(x);
plot(x,y1,'-r') %the third argument is a line type formatting argument. the - means make a solid line, the 'r' means make a red line. 
hold on; %if you want to plot multiple things on the same plot, you need to include this line, otherwise the plots will overwrite eachother.
plot(x,y2,':b') %: means make a dotted line, b means make a blue line.
%-----------------------------------------------------------------------------------------------------




%Anonymous functions
%
%Sometimes you want to specify your own function, but it's too simple to
%warrant its own file. For this, you can use anonymous functions.
%
%Anonymous functions can always be replaced by functions written in files. 
%However, it is sometimes useful to have the function you want to write in
%the same file as a script you want to run. It can also keep your coding
%directories nice and clean by not clogging them with functions that you
%intend to use once or twice.
%
%There are also some functions that take other functions as arguments, such
%as the fminsearch function used for optimization (e.g., model-fitting).
%Anonymous functions can be really useful in those cases.
%--------------------------------------DEMO CODE--------------------------------------------------
%The @ tells matlab that you're writing an anonymous function. The list of 
%variables in parenthesis are the names of the (2) argued values in the 
%function. The subsequent logic specifys how the function will operate on
%the arguments.

comparator = @(x,y) x>y; %This will function exactly like a greater than operator.

comparator(5,3)
comparator(5,7)

%The reason that they're called "anonymous" functions is because the
%function behaves like data. In other words, you assign the function to a
%variable, and you can pass around the value of the function between
%variable names.
newcomparator = comparator;
newcomparator(5,3)
newcomparator(5,7)

%You can even pass around named functions like anonymous functions by using
%the @ operator to 'anonymize' a named function.
bestfunction = @zeros; %here, we have anonymized the 'zeros' function that i used above.
bestfunction(5,3) %and it behaves just like zeros, because it IS zeros.


%Anonymous functions can be useful when there is an equation that you will
%use repeatedly in the same script. Rather than write it out every time,
%you can just write it once in an anonymous function and call it several
%times.

logistic = @(x,b) 1./(1+exp(-b*x)); %This is a function you will see again in this course.

b = 5;
x = linspace(-1,1,1000);
plot(x,logistic(x,b))
%-----------------------------------------------------------------------------------------------------
