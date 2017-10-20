function test_params_SRMB(num_in)

% just vsr2 maze - length of nums to go is 4



con_input = num_in;

[eps_ind, p_ind, w_ind] = ind2sub([3,5,5],con_input);
eps_ind
p_ind
w_ind

eps_vec = [.1, .3, .5];

p_vec = [.1, .3, .5, .7, .9];

w_vec = [.1, .3, .5, .7, .9];


param.epsilon = eps_vec(eps_ind);
param.p_alpha = p_vec(p_ind);
param.w_alpha = w_vec(w_ind);
param.discount = 0.95;

nruns = 1;

r2 = SRMBmaze(nruns, param);

%r2.param = param;

%file_name = ['vsr2_results/vsr2m',num2str(con_input)];

%save(file_name, 'r2')

%r3 = SRMBdetour(nruns,param);

%r3.param = param;

%file_name = ['vsr2_results/vsr2d',num2str(con_input)];

%save(file_name, 'r3')
