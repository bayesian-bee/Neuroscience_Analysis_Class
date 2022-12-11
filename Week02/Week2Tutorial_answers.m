%Behavioral Data Analysis: Visualization of Choice Data

%In order to understand and model behavior, we must first be able to 
%describe the data. We will look at two mock data sets, in the context of 
%some task being performed, and try to quantify performance.

%These three commands are important!
%1) clear removes all the variables from your workspace.
%2) close all closes every plotting window
%3) clc clears your command window
%--------------------------------------RUN THIS CODE--------------------------------------------------
clear
close all
clc
%-----------------------------------------------------------------------------------------------------

% Several steps are involved:
% 1)	Organize and arrange the data (e.g. loading/saving data, data 
%       structures)
% 2)	Plot the data in various ways (e.g. psychometric curve, 
%       chronometric curve)
% 3)	Calculate basic statistics and determine the animals? performance 
%       (e.g. speed/accuracy tradeoff in a reaction time task)
% 
% The data is in a file called data.csv in the directory /data 
%First, load in the dataset. The data.csv data has the following 
%columns: coherence, direction, choice, correct, and reaction time, where 
%coherence is the strength of the stimulus, direction is the direction of 
%the stimulus(left=0, right=1), choice is the choice the monkey made 
%(left=0, right=1), correct specifies if the answer was correct (and the 
%animal was rewarded), and reaction time specifies the time the animal took
%to make a choice.

%--------------------------------------DEMO CODE--------------------------------------------------
floc = 'data/'; %Will need slash in the other direction for Windows
floc = 'C:\Users\bee\Dropbox\class\yale\Fall_2015\compneuro\CompNeuroClass\Tutorials\Week2\data\';
fname = 'data.csv';
data = csvread(strcat(floc,fname));
%-------------------------------------------------------------------------------------------------

%What are the dimensions of the data file? How many rows, how many columns?

%--------------------------------------DEMO CODE--------------------------------------------------
size(data)
%-------------------------------------------------------------------------------------------------

%Note that if you were loading a different data structure, such as from a 
%.mat file, you would use:
%load(?data.mat?);
%For .dat files, you could also use: data = dlmread('data/data.dat');

%Here are the first 5 rows of the data:
%--------------------------------------DEMO CODE--------------------------------------------------
data(1:5,:)
%-------------------------------------------------------------------------------------------------
%Now determine some descriptive statistics: 
%what is the mean percent correct? 
%How many unique coherences are there in data?

%--------------------------------------YOUR CODE HERE---------------------------------------------
coherences = data(:,1); %gets the coherences
correct = data(:,4); %gets the performance of the animal at each coherence value

percent_correct = mean(data(:,4)); %gets the mean performance of the animal; mean percent correct.
unique_coherences = unique(coherences); %finds the possible values that coherence can take
%-------------------------------------------------------------------------------------------------

%Make a histogram of correct choices from the data.
%--------------------------------------YOUR CODE HERE---------------------------------------------
figure;
hist(data(:,4),30)
%-------------------------------------------------------------------------------------------------

%A psychometric curve generally has, as its y-axis, either Percent Correct,
%or Probability of a particular action. Generate a Percent Correct 
%psychometric curve as a function of coherence in data, collapsing across 
%directions. To do this, you may first have to organize the data by 
%coherence, so you can compute the percent correct choices at each 
%coherence value. 
%--------------------------------------YOUR CODE HERE---------------------------------------------
coherences = data(:,1); %gets the coherences
correct = data(:,4); %gets the performance of the animal at each coherence value
unique_coherences = unique(coherences); %finds the possible values that coherence can take
ncoherences = length(unique_coherences); %number of possible coherences

for i=1:ncoherences %for each possible value of coherence
	trials_with_thiscoherence = find(coherences==unique_coherences(i)); %finds trial numbers with coherence equal to unique_coherence(i)
	performance_at_thiscoherence = correct(trials_with_thiscoherence); %finds the value of 'correct' at all of the trial numbers in thiscoherence
	percent_correct(i) = mean(performance_at_thiscoherence); %saves the average performance at this coherence
end
%-------------------------------------------------------------------------------------------------

%Plot the psychometric curve, showing Percent Correct as a function of 
%coherence.
%--------------------------------------YOUR CODE HERE---------------------------------------------
figure(1)
plot(unique_coherences,percent_correct)
%-------------------------------------------------------------------------------------------------

%Now plot the full psychometric curve, showing the probability of choosing
%a particular direction (in this case, rightward) as a function of the 
%stimulus strength in that direction.
%--------------------------------------YOUR CODE HERE--------------------------------------------------
coherences = data(:,1);
directions = data(:,2);
choices = data(:,3);
left_trials = find(directions==0);
coherences(left_trials) = -coherences(left_trials);
%------------------------------------------------------------------------------------------------------


%Now, let's plot average chosen direction (i.e., probability of choosing 
%rightward) as a function.
%--------------------------------------YOUR CODE HERE--------------------------------------------------
unique_coherences = unique(coherences); %finds the possible values that coherence can take
ncoherences = length(unique_coherences); %number of possible coherences

percent_right = zeros(ncoherences,1);%makes a string of zeroes to hold 'probability of choosing rightward' info
for i=1:ncoherences %for each possible value of coherence
	trials_with_thiscoherence = find(coherences==unique_coherences(i)); %finds trial numbers with coherence equal to unique_coherence(i)
	choices_at_thiscoherence = choices(trials_with_thiscoherence); %finds the value of 'correct' at all of the trial numbers in thiscoherence
	percent_right(i) = mean(choices_at_thiscoherence); %saves the average performance at this coherence
end

figure(2);
plot(unique_coherences,percent_right,'o')
xlabel('rightward vector of stimulus movement')
ylabel('probability of choosing right')

%------------------------------------------------------------------------------------------------------

%Now plot the chronometric curve, showing the reaction time as a function 
%of the decision variable (i.e., coherence).

%--------------------------------------YOUR CODE HERE--------------------------------------------------
RT = data(:,5); %gets the RT of the animal at each coherence value
for i=1:ncoherences %for each possible value of coherence
	trials_with_thiscoherence = find(coherences==unique_coherences(i)); %finds trial numbers with coherence equal to unique_coherence(i)
	RT_at_thiscoherence = RT(trials_with_thiscoherence); %finds the value of 'RT' at all of the trial numbers in thiscoherence
	meanRT(i) = mean(RT_at_thiscoherence); %saves the average performance at this coherence
end

figure(3)
plot(unique_coherences,meanRT)
%------------------------------------------------------------------------------------------------------

