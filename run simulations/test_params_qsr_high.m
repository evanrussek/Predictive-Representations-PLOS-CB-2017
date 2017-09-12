function test_params_qsr_high(num_in)


 nums_to_go =[ 50    53    56    71    59    74    63    54    69    42    57    75];


con_input = nums_to_go(num_in);

eps_vec = [.1, .3, .5];
sr_vec = [.1, .3, .5, .7, .9];
w_vec = [.1, .3, .5, .7, .9];


[eps_ind, sr_ind, w_ind] = ind2sub([3,5,5],con_input);


param.epsilon = eps_vec(eps_ind);
param.sr_alpha = sr_vec(sr_ind);
param.w_alpha = w_vec(w_ind);
param.discount = 0.95;

nruns = 250;

%r2 = qsrmaze(nruns, 10000, param);

%r2.param = param;

%file_name = ['results/qsrm_high',num2str(con_input)];

%save(file_name, 'r2')

r3 = qsrdetour(nruns, 12000, param);

file_name = ['results/qsrd_high',num2str(con_input)];

save(file_name, 'r3')






