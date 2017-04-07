%-----------Exercises--------------

%1. Find the sum of the even numbers on the inclusive interval [1,10000].
%Bonus: Do it without any for-loops.
%--------------------------------------DEMO CODE--------------------------------------------------
interval=2:2:10000;
sum(interval)

%-----------------------------------------------------------------------------------------------------

%2. Plot the value of of the sin function on [0,10*pi] for 10 different 
%phase shifts between 0 and pi (inclusive). Put each line on the same plot.
%--------------------------------------DEMO CODE--------------------------------------------------
lower_shift = 0;
upper_shift = pi;
nshifts = 10;
phase_shifts = linspace(0,pi,10);

x = linspace(0,10*pi,10000);
for i=1:nshifts
    plot(x,sin(x+phase_shifts(i)));
    hold on;
end
%----------------------------------------------------------------------------------------------------

%3. Find the first 50 numbers of the fibonacci sequence. Plot the value of
%each number against its position in the sequence (i.e., fib(n) vs. n). 
%Bonus: Make the plot with a log-scaled y-axis.
%--------------------------------------DEMO CODE--------------------------------------------------
nfibs = 50;
fib = zeros(nfibs,1);
fib(1) = 0;
fib(2) = 1;

for i=3:nfibs
    fib(i) = fib(i-2)+fib(i-1);
end

plot(1:nfibs,fib)
semilogy(1:nfibs,fib);
%-----------------------------------------------------------------------------------------------------


%4. Take 10000 random samples (no replacement) of three numbers on the 
%inclusive interval [1,10]. Plot the distribution of the sum of these three
%numbers.
%--------------------------------------DEMO CODE--------------------------------------------------
nsamp = 10000;
k = 3;
samples = zeros(nsamp,k);
for i=1:nsamp
    samples(i,:) = randsample(10,3,false);
end

nbin = 20;
sum_of_samples = sum(samples,2);
hist(sum_of_samples,nbin)
%----------------------------------------------------------------------------------------------------

%Bonus: Find the value of the 10001st prime number.
%This problem was borrowed from Project Euler.
%--------------------------------------DEMO CODE--------------------------------------------------
nprimes = 10001;
nfoundprimes = 0;
i = 0;
while(nfoundprimes<nprimes)
    i = i+1;
    nfoundprimes = nfoundprimes + isprime(i);
end
i
%----------------------------------------------------------------------------------------------------