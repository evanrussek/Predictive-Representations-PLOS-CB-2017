function test_params_Vpunc(con_input)

[eps_ind, sr_ind, w_ind] = ind2sub([3,5,5],con_input);

eps_vec = [.1, .3, .5];

alpha_vec = [.1, .3, .5, .7, .9];

param.epsilon = eps_vec(eps_ind)

param.alpha = alpha_vec(sr_ind);
param.discount = 0.95;

nruns = 500;

r2 = vpuncmaze(nruns,param);

file_name = ['vpunc_results/m',num2str(con_input)];

save(file_name, 'r2')

r3 = vpuncdetour(nruns, param);

file_name = ['vpunc_results/d',num2str(con_input)];

save(file_name, 'r3')





