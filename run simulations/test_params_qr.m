function test_params_qr(con_input)

[eps_ind, alpha_ind] = ind2sub([3,5],con_input);

eps_vec = [.1, .3, .5];

alpha_vec = [.1, .3, .5, .7, .9];

param.epsilon = eps_vec(eps_ind);
param.alpha = alpha_vec(alpha_ind);
param.discount = 0.9;

nruns = 500;

r2 = qr_maze(nruns,param);

file_name = ['qr_results/qr',num2str(con_input)];

save(file_name, 'r2')




