%Behavioral Data Analysis: Modeling

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%PART 1: FITTING A SIMPLE MODEL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%A model is a compact description of a phenomenon that can describe existing 
%data and make predictions about unobserved data points. Using the data set 
%from last week, we will generate a simple model of the relationship between 
%coherence and choice that we observed in the previous tutorial.
%
%First, load in the dataset. Recall, The data1.csv data has the following 
%columns: coherence, direction, choice, correct, and reaction time, where 
%coherence is the strength of the stimulus, direction is the direction of 
%the stimulus(left=0, right=1), choice is the choice the monkey made 
%(left=0, right=1), correct specifies if the answer was correct (and the 
%animal was rewarded), and reaction time specifies the time the animal took to make a choice.

%--------------------------------------YOUR CODE HERE--------------------------------------------------
floc = 'C:\Users\bee\Dropbox\class\yale\Fall_2015\compneuro\CompNeuroClass\Tutorials\Week3\data\';
fname = 'data.csv';
data = csvread(strcat(floc,fname));
%------------------------------------------------------------------------------------------------------


%Now, we should plot the relationship between the decision variable (i.e. coherence) on the x-axis and the animal's 
%average choice (i.e., chosen direction) on the y-axis.
%
%It is helpful to have the decision-variable tell you both the motion strength and motion direction.
%One way to accomplish this is to make the coherence for all left-motion trials negative.
%Just as in the previous tutorial, logical indexing and the 'unique' function will be helpful here.
%--------------------------------------YOUR CODE HERE--------------------------------------------------
coherences = data(:,1);
directions = data(:,2);
choices = data(:,3);
left_trials = find(directions==0);
coherences(left_trials) = -coherences(left_trials);

unique_coherences = unique(coherences); %finds the possible values that coherence can take
ncoherences = length(unique_coherences); %number of possible coherences

percent_right = zeros(ncoherences,1);
for i=1:ncoherences %for each possible value of coherence
	trials_with_thiscoherence = find(coherences==unique_coherences(i)); %finds trial numbers with coherence equal to unique_coherence(i)
	choices_at_thiscoherence = choices(trials_with_thiscoherence); %finds the value of 'correct' at all of the trial numbers in thiscoherence
	percent_right(i) = mean(choices_at_thiscoherence); %saves the average performance at this coherence
end

figure;
plot(unique_coherences,percent_right)
%------------------------------------------------------------------------------------------------------

%This curve is what we want to model. Thus, our model should be 
%some function that takes the coherence value, and generates a predicted 
%probability of choosing rightward. 
%
%A good place to start is to see what kind of function the data looks like!
%Some of you might recognize the shape of this psychometric curve - an 
%s-shaped curve like this resembles a sigmoid.

%There are many sigmoid functions, but today we will use the logistic function:
%
% y = 1./(1+e^(-b*x))
%
%where b is the slope of the logistic function and x is the input to the logistic function.
%Try plotting a logistic function to see how it looks:

%--------------------------------------DEMO CODE--------------------------------------------------
values = -5:.01:5; %a vector of values from -5 to 5, spaced by .01.
slope = 1; % the slope of our logistic function.
logistic = @(b,x) 1./(1+exp(-b*x)); %This is a function. It takes the values in the parenthesis following the @ symbol as arguments (i.e., b and x) and operates on them using the following equation. You use it just like any other function - by typing its name (i.e., logistic) followed by the values of the arguments in parenthesis.
sigmoid_values = logistic(slope,values);
figure;
plot(values,sigmoid_values); %this is equivalent to 'plot(values,1./(1+exp(values,slope)))'
%--------------------------------------------------------------------------------------------------

%Because they look so similar, we will use a logistic function as our model
%for the relationship between probability of choosing rightward and stimulus coherence. 
%The predicted probabilities should resemble our observed probabilities. 
%In other words, we want to use coherence as our 'x' vector in the above 
%function, and have the resulting 'sigmoid_values'vector resemble our 
%predicted probabilities. We can achieve this by tuning the value of the 
%slope (i.e., 'b'). Model variables that are tuned to achieve some goal (e.g., 
%reproducing data) are called free parameters.
%
%Let's see if we can do this by hand! Try out a bunch of different values 
%of 'b' - lets say, 5 values between 10 and 20. Remember, we should be 
%using the possible values of coherences as our 'x' vector. Use my logistic
%function to generate your plots (i.e., plot(x,logistic(b,x))). 


%--------------------------------------YOUR CODE HERE--------------------------------------------------
nslopes = 5;
slope_values = linspace(15,30,nslopes);

unique_coherences = unique(coherences);

figure;
plot(unique_coherences,percent_right,'DisplayName','data')
hold all;
for i=1:nslopes
	plot(unique_coherences,logistic(slope_values(i),unique_coherences),'DisplayName',sprintf('slope=%d',slope_values(i)));%The 'DisplayName' optional argument lets me use the legend to label this plot later.
	hold all; %this makes sure that all the lines go on the same plot
end
%-------------------------------------------------------------------------------------------------------


%The previous exercise is a manual version of model fitting. Generally, 
%model fitting involves selecting a candidate function that can relate some
%predictor variable to an observed response variable (e.g., coherence to 
%P(choose right)), then tuning the free parameters of that function 
%(e.g., the slope: b) until the predicted values of the response variable look like 
%the experimentally observed values. 
%
%However, to do this efficiently and automatically, we need a quantitative
%way of assessing how well the predicted values match the observed values. 
%In other words, we need a function that can take the observed values of the 
%response variable and the predicted values from the model, then tell us 
%how similar they are. This is called a cost function. 
%
%One such cost function is the squared error function:

%sum((predicted - observed)^2)

%This equation quantifies the total (unsigned) deviation between the
%model's predictions and the expermiental data. The Method of Least Squares
%(https://en.wikipedia.org/wiki/Least_squares) is an approach to
%(1) determining how well a model fits the data and (2) systematically improving the model 
%to maximize its fit to the data ('model fitting'), whereby one minimizes the total deviation
%between the model's predictions and the experimental data. In other words,
%one tries to find the values of the model's free parameters that makes the
%squared error the smallest.
%
%To offer some context, the method of least squares is used to perform
%linear regression, and always yields the best possible coefficient estimates 
%for linear regression problems. 
%
%Let's try finding the squared error between the predictions of the model
%and the observed data for each of the above values of the slope, to see
%which fits best. You should make a plot of the squared-error on the y-axis against
%the value of the slope on the x-axis. Use this plot to make sure that you have chosen values of b that are both too small and too large.

%--------------------------------------YOUR CODE HERE--------------------------------------------------
squared_error = @(predicted,observed) sum((predicted-observed).^2);

deviation = zeros(nslopes,1);
for i=1:nslopes
    predicted_values = logistic(slope_values(i),unique_coherences);
    observed_values = percent_right;
    deviation(i) = squared_error(predicted_values,observed_values);
end

deviation
%------------------------------------------------------------------------------------------------------


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%PART 2: LOGISTIC REGRESSION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%The above way certainly works, but isn't ideal. For example, because the
%above variable just fits the mean values of p(choose right) at each value
%of coherence, it doesn't take into account how many trials occurred at
%each coherence level. In other words, it doesn't take the confidence in
%our estimate of the mean value of p(choose right) at each coherence.
%
%An alternative way to do this is with logistic regression, using the
%glmfit function.
%
%Logistic regression takes a similar approach to the method we used above -
%we minimize the value of some function that describes how well a sigmoid 
%fits the data. Except, rather than minimizing the difference between the
%sigmoid and the mean values of the function at each coherence, it 
%minimizes the difference between each individual data point and the model
%predictions. This is extremely similar, except that it implicitly takes 
%into account the error (i.e., standard error) of the estimate of the
%function value at each coherence level, because it tries to fit each
%individual trial.
%
%For more information about logistic regression, check out this link: 
%http://www.stat.cmu.edu/~cshalizi/uADA/12/lectures/ch12.pdf
%
%In matlab, the simplest way to do logistic regression is with the 'glmfit'
%function. This function is designed to fit any most types of general
%linear models, provided that you specify the distribution of the response
%variable
%--------------------------------------DEMO CODE--------------------------------------------------
%glmfit takes three arguments in this case: the predictor variables, the
%response variables, and the distribution of the response variables.
%Because choices are either 0 or 1, our response variable is binomial.
%glmfit knows to use logistic regression to do a logistic regression.

%You may already have the data loaded in and pre-processed. If you don 't,
%here is the code to do that again.
floc = 'C:\Users\bart\Dropbox\class\yale\Fall_2015\compneuro\CompNeuroClass\Tutorials\Week3\data\'
fname = 'data.csv';
data = csvread(strcat(floc,fname));
coherences = data(:,1);
directions = data(:,2);
choices = data(:,3);
left_trials = find(directions==0);
coherences(left_trials) = -coherences(left_trials);

%And here is the code to fit a logistic regression model.
[betas,p_values,stats] = glmfit(coherences,choices,'binomial');
%--------------------------------------------------------------------------------------------------

%But how does logistic regression work? It is outside the scope of the
%course to fully justify the logistic regression technique, but I can
%explain how to do it manually. 
%
%Implicitly, logistic regression tries to fit a binomial distribution where
%the mean number of successes is a linear function of the predictor 
%variables. In this way, logistic regression is just a special case of 
%linear regression, in which a binomially distributed variable is transformed
%using the logit function (i.e., the inverse of the logistic function) so that
%it lies on the [-inf,inf] interval rather than the [0,1] interval. This way,
%we can fit the transformed variable using simple linear regression.
%
%Generally, a logistic regression of the predictors x1,x2,...,xn onto the 
%binomially distributed regressand y looks like this:
%
%log(y./(1-y)) = b0 + b1*x1 + b2*x2 + ... + bn*xn
%
%Where b0,b1,b2,....,bn are the regression coefficients.
%

%--------------------------------------DEMO CODE--------------------------------------------------
%The cost function - the function we want to minimize - looks like this 
%for logistic regression:
cost = @(h,y) -sum(y.*log(h)+(1-y).*log(1-h));

%y is the actual observed response of the animal on each trial, and h is the
%model's predictions about the animals' response on each trial.
%This equation comes from taking the log of the equation for exactly 
%k successes on n trials, given a variable that comes from a binomial
%distribution with some fixed mean, p. It can be shown that this equation
%is equivalent to least-squares for logistic regresion problems, and thus
%optimal.

%Because log(0) is infinity, we're going to modify the function slightly so
%that the value of 'h', our model values, is never 0. This will ensure that
%the cost function will yield a finite value for all possible models. By
%using the 'max' function, we ensure that the input to our log function
%is never lower than .000001.
cost = @(h,y) -sum(y.*log(max(h,.000001))+(1-y).*log(max(1-h,.000001)));

%Again, for logistic regression we are fitting a sigmoid, so here is our
%sigmoid function. It is slightly different now - b is now an array, where
%the first value represents a constant term (the intercept of our model)
%and the second value represents the slope of our sigmoid. 
logistic = @(b,x) 1./(1+exp(-b(2)*x + b(1)));

%And now we're going to combine these two functions into a single
%"objective" function that knows about our data already, and takes a set of
%parameter values describing some model and tells us how well that model
%fits the data. All I've done here is create a function that takes the
%parameter values by replacing the 'x' in the logistic function with our
%coherences (our predictor variable), and the 'y' in the cost function with
%our choices (the response variable). 
objective = @(b) cost(logistic(b,coherences),choices);
%--------------------------------------------------------------------------------------------------

%Tada - we have set up our modeling problem!
%Now, we simply minimize the value of the objective function with respect
%to the parameters in b.
%
%In the examples in part 1, we did this manually - we tested a bunch of values
%of our slope, and found the one that minimized the squared error function.
%Now, we're going to have an algorithm do this automatically for our 
%objective function. It will iteratively test values of b to try to find 
%the smallest value of the cost function. By testing successive values of 
%b, the algorithm will determine which values to test next by keeping 
%track of whether increasing or decreasing the values in b have previously
%resulted in a smaller value for the objective function.
%
%We will use the 'fminsearch' function in matlab, which contains a number
%of algorithms that will attempt to minimize the objective function like
%this. We need to pass our initial parameter value guesses to the
%fminsearch function in order for it to start fitting. There are usually
%good ways to choose the initial values, but we'll start with something
%arbitrary.
%
%The values in 'best_b' should closely resemble the value in 'betas' that
%came out of glmfit, which we know are the best possible values. The value
%of the cost function is in negative_likelihood.
%--------------------------------------DEMO CODE--------------------------------------------------
initial_parameters = [.1,.1];
[best_b,negative_likelihood] = fminsearch(objective,initial_parameters);
%--------------------------------------------------------------------------------------------------

%These principles work for more than just logistic regression. In practice,
%the same concepts/equations are used to fit arbitrary models to any binary
%response variable (e.g., choice). 
%
%Lets try applying these principles to a novel data set from an 
%intertemporal choice experiment. In this experiment, a monkey chose
%between two options, one worth 3 drops of juice, and one worth 2 drops of
%juice. Each option was associated with a variable delay that the animal
%would have to wait before receiving their chosen value.
%
%See this paper for more details:
%Kim, S., Hwang, J., & Lee, D. (2008). Prefrontal coding of temporally
%discounted values during intertemporal choice. Neuron, 59(1), 161-172.

%Load up data2.csv, whose columns are as follows:
%
%1: delay of the left option (in seconds)
%2: delay of the right option (in seconds)
%3: value of the left option (in juice drops)
%4: value of the right option (in juice drops)
%5: whether the animal chose the option on the right
%
%Try to fit a hyperbolic discounting function to these choies, which is discussed
%in both Kim et al. and Kable & Glimcher. to the animals choices. 
%The hyperbolic discounting equation is as follows:
%
%DV = v./(1+k*d)
%
%where DV is discounted value, v is actual value of the option, d is the 
%delay associated with the option, and k is a free parameter controlling
%sensitivity to delay (i.e., larger means less patience).
%
%Remember that the decision variable here is the differnece between the
%discounted values of each option, i.e. DV_right - DV_left. As that number
%increases(decreases), the animal should be more likely to choose the option
%on the right(left).
%
%Use the cost function that I defined above, and the logistic function to
%convert the decision variable to a probability of choosing the option on
%the right. Use the fminsearch function to estimate the best value of
%logistic function slope and k. You do not have to use an intercept for the
%logistic function, so feel free to redefine a logistic function that does
%not have one (or make sure that you always set the slope to zero).
%
%This is a very real example of how computational models are used to 
%analyze choice data. Have fun!

%--------------------------------------YOUR CODE HERE--------------------------------------------------
floc = 'C:\Users\bart\Dropbox\class\yale\Fall_2015\compneuro\CompNeuroClass\Tutorials\Week3\data\'
fname = 'data2.csv';
data = csvread(strcat(floc,fname));
ld = data(:,1); %left delay
rd = data(:,2); %right delay
lv = data(:,3); %left value
rv = data(:,4); %right value
c = data(:,5); %whether the animal chose right

%The logistic function
logistic = @(b,x) 1./(1+exp(-b*x));

%the hyperbolic discounting function - value of v discounted by k*d.
hypdisc = @(k,v,d) v./(1+k.*d);

%the function that takes the difference of the discounted values
%associated with each option, given a value of k
dvfun = @(k,ld,rd,lv,rv) hypdisc(k,rv,rd) - hypdisc(k,lv,ld);

%the probability of choosing right given a value of b, k, and trial
%variables.
pright = @(b,k,ld,rd,lv,rv) logistic(b,dvfun(k,ld,rd,lv,rv));

%the objective function that combines the free parameters into one vector,
%and knows about the data.
objective = @(x) cost(pright(x(1),x(2),ld,rd,lv,rv),c);

%the optimization algorithm!
[xp,stats] = fminsearch(objective,[.1,.1])
%----------------------------------------------------------------------------------------------------


%If you are feeling fancy, make a curve that plots the actual probability of
%choosing right given the difference in discounted values, given the
%animals best fitting values of b and k. 
%
%You can also plot the model's predicted values on the same plot.
%
%For this problem, you will have to make a decision variable vector that is
%the difference between the discounted values of each option on each trial.
%--------------------------------------YOUR CODE HERE--------------------------------------------------
%create discounted values vector associated with each trial.
discounted_values = dvfun(xp(2),ld,rd,lv,rv);

%iterate through and grab probability of choosing a particular direction
%associated with each unique discounted value
udv = unique(discounted_values);
ndv = length(udv);

actual_pright = zeros(ndv,1);
for i=1:ndv
    actual_pright(i) = mean(c(discounted_values==udv(i)));
end

predicted_pright = logistic(xp(1),udv);

figure;
plot(udv,actual_pright,'-ko','DisplayName','data')
hold on;
plot(udv,predicted_pright,'-r','DisplayName','model');
xlabel('DV(right) - DV(left)')
ylabel('Probability of choosing right')
legend('location','NorthWest');
%----------------------------------------------------------------------------------------------------
