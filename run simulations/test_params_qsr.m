function test_params_qsr(con_input)

[eps_ind, sr_ind, w_ind] = ind2sub([3,5,5],con_input);

eps_vec = [.1, .3, .5];

sr_vec = [.1, .3, .5, .7, .9];

w_vec = [.1, .3, .5, .7, .9];


param.epsilon = eps_vec(eps_ind);
param.sr_alpha = sr_vec(sr_ind);
param.w_alpha = w_vec(w_ind);
param.discount = 0.9;

nruns = 1;

r2 = qsrmaze(nruns, 10000 param);

r2.param = param;

file_name = ['results/vsr',num2str(con_input)];

save(file_name, 'r2')







