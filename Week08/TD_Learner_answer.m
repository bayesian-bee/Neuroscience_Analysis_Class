function h = TD_Learner_answer(alpha,beta,choices,rewards)
%--------------------------------------YOUR CODE HERE--------------------------------------------------
ntrial = length(choices);
logistic = @(b,x) 1./(1+exp(-b*x)); 


%The initial estimates of the value
Qa1 = zeros(ntrial,1);
Qa2 = zeros(ntrial,1);
new_Qa1 = .5;
new_Qa2 = .5;

%The task. Iterate through trials.
h = zeros(ntrial,1);
for i=1:ntrial
    %update reward probabilities
    Qa1(i) = new_Qa1;
    Qa2(i) = new_Qa2;
    
    %predict the animals' action
    h(i) = logistic(beta,Qa1(i)-Qa2(i));
    
    %Updated the believed value of the chosen action based on the outcome.
    if(choices(i)==1)
        new_Qa1 = (1-alpha)*Qa1(i) + alpha*rewards(i);
    else
        new_Qa2 = (1-alpha)*Qa2(i) + alpha*rewards(i);
    end
    
end
%-------------------------------------------------------------------------------------------------
