function test_params_dynaQ(con_input)

% should go from 1-15

eps_vec = [.1, .3, .5];
alpha_vec = [.1, .3, .5, .7, .9];
ns_vec = [10,10000]


[eps_ind, sr_ind, n_samples] = ind2sub([3,5,2],con_input);


param.epsilon = eps_vec(eps_ind);
param.alpha = sr_vec(sr_ind);
param.w_alpha = w_vec(w_ind);
param.discount = 0.9;

nruns = 500;

r2 = qsrmaze(nruns, n_samples, param);

r2.param = param;

file_name = ['results/qsrm_low',num2str(con_input)];

save(file_name, 'r2')

r3 = qsrdetour(nruns, n_samples, param);

file_name = ['results/qsrd_low',num2str(con_input)];

save(file_name, 'r3')






