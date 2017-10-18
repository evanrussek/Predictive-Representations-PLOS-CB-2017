function test_params_dynaQ_high(con_input)


% 15 inputs
eps_vec = [.1, .3, .5];
alpha_vec = [.1, .3, .5, .7, .9];


[eps_ind, w_ind] = ind2sub([3,5],con_input);


param.epsilon = .1; %eps_vec(eps_ind);
param.alpha = .3; % alpha_vec(w_ind);
param.discount = 0.95;
param.b_samples = 10;

nruns = 1;
nsamples = 10000;

%r2 = dynaQmaze(nruns, nsamples, param);

%r2.param = param;

%file_name = ['dynahigh_results/dm',num2str(con_input)];

%save(file_name, 'r2')

r3 = dynaQdetour(nruns, nsamples, param);

%file_name = ['dynahigh_results/dd',num2str(con_input)];

%save(file_name, 'r3')




