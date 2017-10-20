function test_params_SRDYNA_high(num_in)

%con_input = num_in;
con_input = 1;

eps_vec = [.1, .3, .5];
sr_vec = [.1, .3, .5, .7, .9];
w_vec = [.1, .3, .5, .7, .9];


[eps_ind, sr_ind, w_ind] = ind2sub([3,5,5],con_input);


param.epsilon = .1; %eps_vec(eps_ind);
param.sr_alpha = .3; %sr_vec(sr_ind);
param.w_alpha = .3; %w_vec(w_ind);
param.discount = 0.95;
param.b_samples = 10;

nruns = 1;

% run latent learning nad policy revaluation
%r2 = SRDYNAmaze(nruns, 10000, param);

%r2.param = param;

%file_name = ['results/qsrm_high',num2str(con_input)];

%save(file_name, 'r2')

% run detour task
r3 = SRDYNAdetour(nruns, 10000, param);

%file_name = ['results/qsrd_high',num2str(con_input)];

%save(file_name, 'r3')






