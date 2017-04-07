%Behavioral Modeling: Response times and the drift-diffusion model
%
%Seminal work by Shadlen's group has made the drift-diffusion model very 
%popular in neuroscience. It is a simple, yet powerful, model that captures
%key features of response time and choice distributions in many
%decision-making tasks. For a detailed discussion of response times, see
%Luce 1991. For a discussion of the potential role of DDM in understanding
%LIP function, see Gold & Shadlen, 2002. 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%PART 1: DRIFT-DIFFUSION MODEL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%The drift-diffusion model (DDM) is simply a particle moving noisily
%in a one dimensional space; choice and response time are determined  when
%the particle drifts to either of two extreme positions. 
%
%Formally, let's call x(t) the position of the particle at time t. x changes
%over time according to the following differential equation:
%
%dx(t)/dt = a*c(t) + b*N(0,1)
%
%where c(t) is the signal at time t (e.g., coherent motion in a random dots
%stimulus), N(0,1) is gaussian noise with zero mean and unit standard
%deviation, a is the drift-rate, or the effect of the signal on the
%particles velocity, and b is a coefficient that determines the amplitude
%(i.e., standard deviation) of effect of noise on the particles' velocity.
%
%The particle ceases movement at t*, such that x(t*) >= th1 or x(t*) <= th2.
%importantly, th2 < x(t) <th1 for all t < t*, and x(t*+tau) is undefined. 
%In other words, the particle stops moving when its value becomes
%sufficiently extreme by hitting either a positive (th1) or negative (th2)
%threshold boundary, and continues moving until either of two boundaries are reached.
%
%Determining choice and response time from a single run of the model is 
%simple. The response time of the model is t*, and the choice is 1 if
%x(t*) >= th1, and 0 if x(t*) <= th2. 
%
%Try to implement the drift-diffusion model with a=.04, b=.03, th1=1 and 
%th2=-1. Coding this is more or less coding a gaussian random walk, except 
%that a while-loop is more appropriate than a for-loop because you don't 
%know how long each run will be in advance. 
%
%Plot the position of the particle for one run with 0 coherence (i.e., 
%c(t)=0 for all t).
%------------------------------YOUR CODE HERE------------------------------
a = .04;
b = .03;
th1 = 1;
th2 = -1;
c = 0;
clear x;x(1) = 0;
t = 1;
while(x(t) < th1 && x(t) > th2)
    dx = a*c + b*randn;
    t = t+1;
    x(t) = x(t-1)+dx;
end

plot(1:t,x,'-b','LineWidth',2);%plots position of the particle over time
hold all;
plot(1:t,ones(t,1)*th1,'--k');%plots the upper boundary
plot(1:t,ones(t,1)*th2,'--k');%plots the lower boundary
plot(1:t,zeros(t,1),':');%plots the x-axis; y=0 line
ylim([th2*1.05,th1*1.05]);%sets limits for y axis
ylabel('particle position');
xlabel('time (ms)');
%--------------------------------------------------------------------------

%At this point, it may be helpful to make a function for your DDM. This is 
%not necessary, but will be convenient for the remainder of the tutorial. 
%Your  function should take a, b, th1, th2, and c, and should return the 
%amount of time that the particle simulation took, and which boundary the 
%particle hit. Your function will have to be in a separate file. 
%
%see: http://www.mathworks.com/help/matlab/ref/function.html
%
%Now, run your code 1000 times and plot the distribution of response times.
%You can do this with the hist function, but make sure to use a reasonable
%number of bins (between 50 and 100). Use 0 coherence.
%-----------------------------------YOUR CODE HERE-------------------------
nrep = 1000;

model.a = .04;
model.b = .03;
model.th1 = 1;
model.th2 = -1;
c = zeros(nrep,1);

out = DDM_fun_answer(model,c);

figure;
hist(out.rt,100)
xlabel('response time');
ylabel('Count');

%---------------------------------------------------------------------------

%How does coherence affect the response time? Try varying your coherence
%between -.1 and .1, corresponding to strong evidence against and for 
%action 1, respectively. Plot the average response time at each
%coherence. Make sure to run several (e.g., 1000) simulations at each
%response time to have confidence in your estimates. 
%-----------------------------------YOUR CODE HERE-------------------------
%setup trials
nrep = 1000; %n reps per trial type
coh_range = [-.1,.1]; %range of trial types
ncoh = 11; %number of trial types
coh_vec = linspace(coh_range(1),coh_range(2),ncoh);%unique trial types
coherences = repmat(coh_vec',[nrep,1]); %repeat all trial types 1000 times

%model parameters
model.a = .04; %drift rate
model.b = .03; %noise SD
model.th1 = 1; %upper boundary
model.th2 = -1; %lower boundary

%simulate DDM
out = DDM_fun_answer(model,coherences);

%parse out chronometric and psychometric curves
chronometric = zeros(ncoh,1);
psychometric = zeros(ncoh,1);
for i=1:ncoh
    rts_at_this_coh = out.rt(coherences==coh_vec(i));
    choices_at_this_coh = out.choice(coherences==coh_vec(i));
    chronometric(i) = mean(rts_at_this_coh);
    psychometric(i) = mean(choices_at_this_coh);
end

%plot it all
figure;
subplot(1,2,1)
plot(coh_vec,psychometric);
xlabel('Coherence');
ylabel('P(choose 1)');
ylim([0 1]);

subplot(1,2,2)
plot(coh_vec,chronometric)
xlabel('Coherence');
ylabel('RT');
%---------------------------------------------------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%PART 2: FITTING THE DDM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Like all models we have worked with so far, the DDM can be fit to
%subjects' data. Because the model reproduces both response times and
%choices, In practice, fitting the drift-diffusion model involves fitting 
%both the distribution of choices and the distribution of response times, 
%which can be tricky or require more sophisticated methods.
%
%Today, we will just be fitting the response time distributions. For a 
%comparison of possible fitting methods, see:
%Ratcliff R, Tuerlinckx F. Estimating parameters of the diffusion model: 
%Approaches to dealing with contaminant reaction times and parameter 
%variability. Psychonomic bulletin & review. 2002;9(3):438-481.
%
%First, load in the data. Column 1 is coherence (negative is motion in
%direction 0, positive is motion in direction 1), column 2 is the animals
%categorization of the motion (either 0 or 1), and column 3 is the animals'
%response time in ms.
%-----------------------------------YOUR CODE HERE-------------------------
data = csvread('data.txt');
coherence = data(:,1);
choice = data(:,2);
rt = data(:,3);
%---------------------------------------------------------------------------
%Now, you have to generate the data that you want to fit. We want to fit
%the response time distribution at each coherence level. Because we are not
%fitting choices, a coherence of c and -c can be regarded as the same.
%
%Generate a histogram of response times at each absolute coherence level.
%Normalize the counts in each bin by the total number of trials at that
%absolute coherence level to get a probability density function, which is
%invariant to trial number. Make sure that the x-axis for each histogram is
%the same - you should choose your bin edges ahead of time, based on the
%RT range of the data. 25 bins should be ok.
%
%Make sure you plot your histograms! The bar function is useful here.
%-----------------------------------YOUR CODE HERE-------------------------
abs_coh = abs(coherence);
ucoh = unique(abs_coh);
ncoh = length(ucoh);
nbin = 25;

%generate coherence vector
minrt = 0;
maxrt = 2000;%max(rt) is 1986
nbins = 25;
edges = linspace(minrt,maxrt,nbins);
coh_counts = zeros(ncoh,nbins);
for i=1:ncoh
    coh_counts(i,:) = histc(rt(abs_coh==ucoh(i)),edges); %obtain counts at each coherence
    coh_counts(i,:) = coh_counts(i,:)/sum(coh_counts(i,:));%normalize to get PDF
end

%plot histograms
for i=1:ncoh
    subplot(2,3,i)
    bar(edges,coh_counts(i,:))
    xlabel('RT');
    xlim([0 maxrt]);
    title(sprintf('Coherence=%.2f',ucoh(i)));
    ylim([0 .4]);
end

%---------------------------------------------------------------------------
%To fit the DDM to the data, we will use a grid-search procedure, in which 
%we test all possible combinations of parameter values over some restricted
%ranges to test which combination of parameters best reproduces the data.
%Pick a range for the drift-rate parameter, and another range for the noise
%parameter. Your ranges should probably fall in the bigger range of [0,.1],
%and you should use decision boundaries of -1 and 1.
%
%Select m evenly spaced values from each range, and generate reaction time
%distributions for all combinations of these parameter values. Make sure
%that you do a sufficient number of simulations (n) at each combination of parameters.
%Then, compare the empirical reaction time to the simulated distributions.  
%
%A grid search is nice, but can get computationally expensive and
%time-consuming. The procedure that I have outlined above involves n*m^2
%runs of the DDM. Of course, each simulation takes time, so if you choose
%an n or m that is too large, you may have grid searches that will take days
%or even years to finish. Let's try to address this up front - first,
%determine the average time it takes to run one DDM simulation, run_time.
%Then, find a reasonable size for n and m such that run_time*n*m^2 is
%somewhat small (~1min or less). Make sure that n is large enough such that
%you can sample trials at each (absolute) coherence a sufficient number of 
%times.
%
%To determine how much time a particular operation takes, surround the
%operation with "tic" and "toc, then execute the code block.
%(http://www.mathworks.com/help/matlab/ref/tic.html).
%-----------------------------------DEMO CODE----------------------------
tic %starts the timer
magic(5); %operation in question
run_time = toc %ends the timer, and reports the run time
%---------------------------------------------------------------------------
%
%Once you have chosen a value of m and n that satisfies you, run the grid
%search. Perform the same binning procedure as above to the simulated runs
%at each parameter combination, and compute the squared error of the
%proportion of RTs in each bin between the simulated RT distribution and
%the empirical RT distribution. Find the parameter combination that
%minimizes the sum of bin-wise squared errors. 
%-----------------------------------YOUR CODE HERE-------------------------
%model parameters
model.a = .05; %drift rate
model.b = .04; %noise SD
model.th1 = 1; %upper boundary
model.th2 = -1; %lower boundary

%compute average run time
runtime = zeros(100,1);
for i=1:100
    tic
    DDM_fun_answer(model,0); %running at coherence 0 is worst case, so this will overestimate run time.
    runtime(i) = toc;
end

%choose m and n
m = 4;
n = 6*1000;%1000 reps at each unique coherence

%run time
fprintf('average worst case run time is: %.2f sec\n',mean(runtime)*n*(m^2));

%generate coherence vector based on unique absolute coherences from real
%experiment
coherence = repmat(ucoh,[n/6,1]);

%run simulations
drift_rate = linspace(.03,.06,m);
noise = linspace(.03,.06,m);
out = cell(m);
for i=1:m
    for j=1:m
        model.a = drift_rate(i);
        model.b = noise(j);
        out{i,j} = DDM_fun_answer(model,coherence);
    end
end

%make and compare histograms at each coherence for each parameter set
%generate coherence vector
minrt = 0;
maxrt = 2000;%max(rt) is 1986
nbins = 25;
edges = linspace(minrt,maxrt,nbins);

%compute bin-wise squared errors
cost = zeros(m);
coh_counts_sim = cell(m);
for i=1:m%drift rate
    for j=1:m%noise
        coh_counts_sim{i,j} = zeros(ncoh,nbins);
        for k=1:ncoh
            coh_counts_sim{i,j}(k,:) = histc(out{i,j}.rt(coherence==ucoh(k)),edges); %obtain counts at each coherence
            coh_counts_sim{i,j}(k,:) = coh_counts_sim{i,j}(k,:)/sum(coh_counts_sim{i,j}(k,:));%normalize to get PDF
        end
        %keyboard;
        squerrvec = (coh_counts-coh_counts_sim{i,j}).^2;
        cost(i,j) = sum(squerrvec(:));
    end
end

%plot cost to identify best fitting value.
imagesc(noise,drift_rate,cost);
colormap('hot')
set(gca,'XTick',noise,'YTick',drift_rate);
xlabel('Noise');
cb = colorbar;
ylabel(cb,'Cost');
ylabel('Drift rate');
%---------------------------------------------------------------------------

%Once you have identified the best fitting set of parameters, plot your
%simulated RT distributions against the empirical RT distributions to see
%how well you have done. 

figure;
for i=1:ncoh
    subplot(2,3,i)
    plot(edges,coh_counts(i,:),'-b');
    hold on;
    plot(edges,coh_counts_sim{2,2}(i,:),'-r');
    xlabel('time (ms)');
    ylabel('probability')
    title(sprintf('Coherence=%.2f',ucoh(i)));
end