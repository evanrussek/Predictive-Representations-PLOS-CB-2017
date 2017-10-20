function test_params_rvw(con_input)

[eps_ind, sr_ind, w_ind] = ind2sub([3,5,5],con_input);

eps_vec = [.1, .3, .5];

sr_vec = [.1, .3, .5, .7, .9];

w_vec = [.1, .3, .5, .7, .9];

param.epsilon = eps_vec(eps_ind);
param.sr_alpha = sr_vec(sr_ind);
param.w_alpha = w_vec(w_ind);
param.discount = 0.9;

nruns = 1;

r2 = rvw_maze(nruns,param);

%file_name = ['rvw_results/rw',num2str(con_input)];

%save(file_name, 'r2')


