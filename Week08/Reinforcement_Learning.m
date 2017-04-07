%Behavioral Modeling: Reinforcement Learning
%
%For a detailed treatment, see Sutton & Barto, 1998. Reinforcement learning: An
%introduction. Reinforcement learning as a computational framework has a
%rich history, and is currently seeing applications by major companies
%(e.g., Google) to solve a wide variety of big-data problems.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%PART 1: TEMPORAL-DIFFERENCE LEARNING
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%During a variety of behavioral tasks, a subject needs to keep track of
%continously moving quantities (such as reward rates of two actions) using 
%stochastic feedback about the values of the quantities (such as experienced 
%rewards following each action). If the subject can accurately track the 
%value of the quantities, then the subject can maximize their return. 
%Reinforcement learning (RL) algorithms are a class of programs that can 
%solve tasks like this. These algorithms use parametric learning rules for
%tracking hidden quantities in the environment based on noisy feedback, and
%use a parametric policy for choosing actions based on the estimated values of the 
%hidden quantities. 
%
%One popular RL algorithm is the Temporal-Difference (TD) learner, which
%uses the difference between its predictions about an outcome and the
%actual outcome to adjust its predictions in the future. In particular, if
%the TD learner is tracking an action's reward rate, Q, then it uses the
%following policy to adjust its estimate:
%
%Q(t+1) = Q(t) + a*(R(t) - Q(t))
%
%Where Q(t) is the estimated reward rate of the action at time step t, R(t) 
%is the experienced reward following that action (0 for no reward, 1 for 
%reward), a is a parametric learning rate on the interval [0,1], and Q(t+1)
%is the new estimated value of the action for the subsequent time step. 
%
%Try out the above equation. Lets say that the old estimate of the reward
%rate is .5, and the subject receives a reward. Lets suppose that the
%learning rate is also .5. What is the subjects new estimate of the reward?
%How is the estimate affected by using a different learning rate? Try 
%making a plot of the new value as a function of the learning rate. Then
%make a plot of the change in value (difference between new value and old
%estimate) as a function of the learning rate.
%--------------------------------------YOUR CODE HERE--------------------------------------------------
Q = .5;
R = 1;
a = 0:.1:1;
for i=1:length(a)
    new_Q(i) = Q + a(i)*(R-Q);
end

figure;
subplot(2,1,1)
plot(a,new_Q)
xlabel('Learning Rate')
ylabel('Q(t+1)')

subplot(2,1,2)
plot(a,new_Q-Q)
xlabel('Learning Rate')
ylabel('Change in estimated value')
%------------------------------------------------------------------------------------------------------
%It should be apparent that the larger the learning rate, the larger the
%change in the estimated value. The change is negative if the subject isn't
%rewarded, and it is positive if the subject is rewarded. We can arrive at 
%another way of thinking about this rule by rearranging the equation:
%
%Q(t+1) = (1-a)*Q + a*R
%
%In other words, Q(t+1) is a weighted average of the old estimate and the
%experienced outcome, and the learning rate sets the weights. If a is 1, 
%the new estimate is entirely driven by the experienced outcome, and if 
%a is 0, the new estimate is completely unaffected by experienced outcomes. 


%Let's say that our model has learned two values. How does it use those
%values to make a choice? A very simple decision-maker might simply choose
%the option associated with the larger value, but this might not be optimal
%in an environment in which values are changing, or the decision-maker has 
%low certainty about the identity of the optimal action.
%
%Recall the behavioral modeling tutorials of week 3. We used a logistic
%function to model the relationship between coherence in a random dots task
%and probability of making a particular action. So, let's use a logistic
%function here to map the difference in values to the probability of
%choosing the first action.

%Here is the logistic function, and two action values. 
%--------------------------------------DEMO CODE--------------------------------------------------
logistic = @(b,x) 1./(1+exp(-b*x)); 
Qa1 = .7; 
Qa2 = .3;
Qdiff = Qa1 - Qa2;
p_choose_action1 = logistic(1,Qdiff);
%-------------------------------------------------------------------------------------------------
%Thus, one can map the difference of values to the probability of choosing
%an action. 
%
%There is a free parameter, b, that sets the relationship
%between action value difference and probability of action selection. Try
%to determine the relationship between the value of b and the probability
%of choosing action 1. In other words, make a plot with probability of
%choosing action 1 on the y-axis for different values of b on the x-axis.
%Use the Qdiff given above, or perhaps try multiple values of Qdiff. (Hint:
%use very small values of b, such as values on the [0,10] interval). 
%--------------------------------------YOUR CODE HERE--------------------------------------------------
b = linspace(0,10,100);
figure;
plot(b,logistic(b,Qdiff),'o')
%-------------------------------------------------------------------------------------------------

%Now that we have a learning rule and a decision-making rule, let's try to
%implement a task that leverages both of these to track moving values, and
%attempt to maximize rewards.
%
%On each trial of our task, the subject will be faced with two actions (a1
%and a2) that each reward with some non-constant probability (p1 and p2).
%Our subject should first make a choice between a1 and a2 based on its
%beliefs about the value of both actions, Qa1 and Qa2, then update those 
%beliefs based on the experienced outcome (which should be proportional to 
%p1 and p2). Learning should be guided by some learning rate a, and
%decision-making should be guided by some value for b. 

%p1 and p2 will undergo a gaussian random walk. A  gaussian random walk is
%a process by which a value evolves in a number of discrete steps via the
%addition of gaussian noise at each time step:. p1 and p2 should never be
%greater than 1, or less than 0.
%
%Here is an example of a gaussian random walk:
%--------------------------------------DEMO CODE--------------------------------------------------
ntime = 1000; %number of time steps
walk_mean = 0;%mean of gaussian noise
walk_sigma = .025; %standard deviation of gaussian noise

reward_rate = zeros(ntime,2);
reward_rate(1,:) = [.5,.5]; %The values start at .5

%Generate the walk. The min(x,1) and max(x,0) ensures that the reward_rate
%is always on the interval [0,1]. 
%The two columns of reward-rate contain independent gaussian random walks
%for two options.
for i=2:ntime
    reward_rate(i,1) = max(min(reward_rate(i-1,1) + walk_sigma*randn(1)+walk_mean,1),0);
    reward_rate(i,2) = max(min(reward_rate(i-1,2) + walk_sigma*randn(1)+walk_mean,1),0);
end

figure;
plot(1:ntime,reward_rate)
legend({'V1','V2'})
%-------------------------------------------------------------------------------------------------
%Try to implement the task that I described above. I have included
%variables and some, but not all, of the task logic. It is up to you to
%implement the remaining logic. Make sure that you keep track of the 
%subject's choices and rewards on each trial so you can examine them later.
%Good luck!
%--------------------------------------YOUR CODE HERE--------------------------------------------------
ntrial = ntime;%Set in the above code block.

%Free parameters for our learner and our decision-maker.
a = .2;
b = .8;

%The initial estimates of the value
Qa1 = zeros(ntrial,1);
Qa2 = zeros(ntrial,1);
new_Qa1 = .5;
new_Qa2 = .5;

%The task
r = zeros(ntrial,1);%reward
ca1 = zeros(ntrial,1);%variable for tracking chosen actions
for i=1:ntrial
    %update reward probabilities
    Qa1(i) = new_Qa1;
    Qa2(i) = new_Qa2;
    p1 = reward_rate(i,1);
    p2 = reward_rate(i,2);
    
    %select an action
    pca1 = logistic(b,Qa1(i)-Qa2(i));%probability of choosing action 1, Qa1
    ca1(i) = rand([1,1])<pca1;
    
    %Instantiate a reward based on the reward probability of the chosen
    %action
    if(ca1(i))
        r(i) = rand([1,1])<p1;
    else
        r(i) = rand([1,1])<p2;
    end
    
    %Updated the believed value of the chosen action based on the outcome.
    if(ca1(i))
        new_Qa1 = (1-a)*Qa1(i) + a*r(i);
    else
        new_Qa2 = (1-a)*Qa2(i) + a*r(i);
    end
    
end
%-------------------------------------------------------------------------------------------------
%Now, we should see how the learner did. First, try plotting Qa1 and Qa2
%against the actual reward rate for each action. These should track
%each other. If they don't track each other very well, try adjusting the
%learning rate. 
%--------------------------------------YOUR CODE HERE--------------------------------------------------
figure;
subplot(2,1,1)
plot(1:ntrial,reward_rate(:,1),'-r','LineWidth',3)
hold on;
plot(1:ntrial,Qa1,'om')
legend({'Va1','Qa1'})
xlabel('Trial Number');
ylabel('Value');

subplot(2,1,2)
plot(1:ntrial,reward_rate(:,2),'-b','LineWidth',3)
hold on;
plot(1:ntrial,Qa2,'oc')
legend({'Va2','Qa2'})
xlabel('Trial Number');
ylabel('Value');
%-------------------------------------------------------------------------------------------------

%Now, try plotting the probability that the animal chooses a1 as a function
%of Qa1 - Qa2. Hint: Because Qa1-Qa2 is continuous, you will have to bin
%it to get a probability of a1 for small ranges of Qa1-Qa2. In other words,
%if you didn't bin things, you might have a problem where you have some
%value for Qa1-Qa2 and no other instances of that value, so you can't
%meaningfully compute the probability of choosing a1 at that specific value
%since you don't have any other data points at that exact value. Therefore
%you need to bin.
%--------------------------------------YOUR CODE HERE--------------------------------------------------
bins = [-.9,-.6;-.6,-.3;-.3,-.0;0,.3;.3,.6;.6,.9];
nbins = size(bins,1);
p_a1 = zeros(nbins,1);%probability of choosing action a1
for i=1:nbins
    Qdiff = Qa1-Qa2;
    Q_mask = Qdiff>=bins(i,1) & Qdiff<bins(i,2); %Q_mask is a vector of logicals the same size as Qdiff. Although it looks like a vector of numbers 1 and 0, it is not a double. You can use a vector of logicals to do indexing in the way shown immediately below.
    p_a1(i) = mean(ca1(Q_mask));
end

plot(mean(bins,2),p_a1)%x axis is intervals of Qdiff, y axis is probability of choosing a1
%-------------------------------------------------------------------------------------------------
%Here is a fancy sanity check: try using logistic regression to fit the
%probability that the animal chooses action 1 to the difference between Qa1
%and Qa2. The regression coefficient on Qa1-Qa2 should be about equal to 
%the b that you used above. Do you understand why?
%--------------------------------------YOUR CODE HERE--------------------------------------------------
betas = glmfit(Qa1-Qa2,ca1,'binomial');
betas(2),b
%-------------------------------------------------------------------------------------------------
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%PART 2: FITTING A TD LEARNING MODEL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Now that you understand how the TD learning model works, we can try to fit
%this model to some real data. Conceptually, fitting this model will not be
%very different from fitting the simpler behavioral models you did during 
%the first weeks - you will compare how well different parameterizations of
%your RL model can reproduce the choices of the subject. The difference is
%that, unlike the simpler models that we were using, you cannot specify the
%entire reinforcement learning model in a single line of code using an 
%anonymous function. You will have to define the function in a separate
%file.
%
%To see some information about defining functions in MATLAB, please refer
%to this page: http://www.mathworks.com/help/matlab/ref/function.html
%
%Here is the data that you will try to model. The animal completed a simple
%2-armed-bandit task, and the values of two actions (action 1, and action 2)
%were adjusted every trial according to two independent gaussian random 
%walks. The animal chose either action 1 or action 2 on each trial, and was
%either rewarded with a drop of juice or not rewarded. Column 1 is the 
%animals' choice (1 is action 1, 0 is action 2), and column 2 is the 
%animals' experienced outcome. Although you will not need these for 
%fitting, columns 3 and 4 are the reward rates for actions 2 and 1, 
%respectively.
%--------------------------------------RUN THIS CODE--------------------------------------------------
data = csvread('data.txt');
choices = data(:,1);
rewards = data(:,2);
%--------------------------------------------------------------------------------------------------
%
%Here is what you should do:
%
%1) Write a function in another file that takes the animals' choices and 
%experienced  outcomes on each trial, as well as a learning rate and a 
%softmax  temperature (i.e., the b for the logistic function), and runs a 
%TD learning algorithm to track the values of action 1 and action 2 on each 
%trial. This function should return the probability that the animal selects
%action 1 on each trial. This function will look a lot like what you
%implemented to simulate the TD learner above, except that instead of
%choosing a reward from a random walk you generated, you will use the
%animals' experienced rewards to update the value of the animals' chosen
%action.
%
%2) Using the cost function definition below, compare the model's predicted
%choices to the animals' actual choices to obtain the log-likelihood of the
%model.
%
%3) Just like in week 3, use fminsearch to minimize the negative
%log-likelihood (i.e., maximize the likelihood) of the model by adjusting
%the parameters.
%
%
%You should run the code below once you have defined TD_Learner, and you
%should get your estimate of the parameter values.
%Please refer to the last section of week 3 if you do not remember what
%this code is and how it works.
%--------------------------------------RUN THIS CODE--------------------------------------------------
cost = @(h,y) -sum(y.*log(max(h,.000001))+(1-y).*log(max(1-h,.000001)));

%This will be your objective function, once you have defined the TD-learner
%algorithm. p(1) is learning rate, p(2) is softmax temperature.
objective = @(p) cost(TD_Learner_answer(p(1),p(2),choices,rewards),choices);

%And this is the fitting procedure.
initial_alpha = 1;
initial_beta = 10;
[parameters,negative_LL] = fminsearch(objective,[initial_alpha,initial_beta]);
%smaller values of negative_LL are better.
break
predictions=TD_Learner_answer(parameters(1),parameters(2),choices,rewards);
predictions(find(predictions>0.5))=1;
predictions(find(predictions<0.5))=0;

1-(sum(abs(choices-predictions))/size(choices,1))%percent of choices the TD Learner predicted correctly

%visualize choices vs. predictions within a specific range..
interv=500:550;

figure;
plot(choices(interv),'ko')
hold on
plot(predictions(interv),'r+')

%--------------------------------------------------------------------------------------------------


