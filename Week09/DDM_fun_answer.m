%A function that implements a drift-diffusion model.
%
%model: a struct with the following fields: a, b, noise_mean, th1, th2. The purposes of these fields are outlined below.
%coherence: a vector of coherence levels at which the model is evaluated. 
function [out,particle_position] = DDM_fun(model,coherence)

%Set up noise parameters based on function arguments.
drift_rate = model.a;			%How much the particle adjusts its position given some level of evidence.
noise_sd = model.b;				%The standard deviation of the gaussian random noise added to particle position.
noise_mean = model.noise_mean;	%The mean of the gaussian random noise that is added to the particle's position.
th1 = model.th1;				%The upper threshold for a decision.
th2 = model.th2;				%The lower threshold for a decision.

%The number of times the model will be run. It will be run once per coherence.
nreps = length(coherence);

rt = zeros(nreps,1);
choice = zeros(nreps,1);
particle_position = cell(nreps,1);
for i=1:nreps
    x = 0;
    ts = 0;
    particle_position{i} = [];
    while(x<=th1 && x>=th2)
        dx = drift_rate*coherence(i) + (randn+noise_mean)*noise_sd;
        x = x+dx;
        ts = ts+1;
        particle_position{i}(ts) = x;
    end
    rt(i) = ts;
    choice(i) = x>=th1;
end

out.rt = rt;
out.choice = choice;
out.x = particle_position;