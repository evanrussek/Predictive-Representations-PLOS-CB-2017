function test_params_SRDYNA_low(con_input)

eps_vec = [.1, .3, .5];
sr_vec = [.1, .3, .5, .7, .9];
w_vec = [.1, .3, .5, .7, .9];

[eps_ind, sr_ind, w_ind] = ind2sub([3,5,5],con_input);


param.epsilon = eps_vec(eps_ind);
param.sr_alpha = sr_vec(sr_ind);
param.w_alpha = w_vec(w_ind);
param.discount = 0.9;
param.b_samples = 10;

nruns = 1;

r2 = SRDYNAmaze(nruns, 10, param);

r2.param = param;

%file_name = ['results/qsrm_low',num2str(con_input)];

%save(file_name, 'r2')

%r3 = SRDYNAdetour(nruns, 10, param);

%file_name = ['results/qsrd_low',num2str(con_input)];

%save(file_name, 'r3')






