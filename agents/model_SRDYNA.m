function model = model_SRDYNA()

	model.init = @modelinit;
	model.update = @modelupdate;
	model.eval = @modeleval;
	model.choose = @modelchoose;
	model.dyna_update = @dyna_update;
	model.qlearn_update = @qlearn_update;

function model = modelinit(model,game,params_in)

	n_sa = length(game.sa_to_nextstate);
	H = eye(n_sa);
	H(n_sa,:) = 0;

	w = zeros(n_sa,1);

	if nargin < 3

		model.param.epsilon = .1;
		model.param.sr_alpha = .3;
		model.param.w_alpha = .3;
		model.param.discount = .95;
		model.param.nsamples = 10000;
		model.param.bsamples = 10;
	else
		model.param = params_in;
	end

	model.H = H;
	model.w = w;

	model.dn_tot = 1;
	% store samples seperately for each state
	for i = 1:n_sa
		model.sa(i).samples = zeros(10000,5);
		model.sa(i).dn = 1;
	end
	model.sa_list = zeros(10000,1);


	model.s = game.current_state;
	model.s_prime = 0;
	model.a = 0;
	model.a_prime = 0;
	model.r = 0;

function model = modelupdate(model,game)


	% update H
	model.H = sarsa_update(model.s,model.a,model.s_prime,model.a_prime,model,game);

	% update w 
	%model.w = w_update(model,game);
	model.w = w_update(model.s,model.a,model.r,model.s_prime,model.a_prime,model,game);

	sa_num = game.available_sa(model.s,model.a);
	model.sa(sa_num).samples(model.sa(sa_num).dn,:) = [model.s, model.a, model.r, model.s_prime, model.a_prime];
	model.sa(sa_num).dn = model.sa(sa_num).dn + 1;
	model.sa_list(model.dn_tot) = sa_num;
	model.dn_tot = model.dn_tot + 1;

	model = model.dyna_update(model,game,model.param.b_samples);

function [Q,model] = modeleval(model,game)
	model.Q = model.H*model.w;
	asa = game.available_sa(game.current_state,:);
	asa(asa==0) = [];
	Q = model.Q(asa);

function a = modelchoose(Qvals,game, epsilon)
	%epsilon = .1;
	action_prob = zeros(length(Qvals),1);
	[maxval, max_a] = max(Qvals);
	[bestA] = find(Qvals==maxval);
    action_prob(bestA) = (1 - epsilon)/length(bestA);
	action_prob = action_prob + epsilon/length(Qvals);
    a = find(rand < cumsum(action_prob),1);


function H = sarsa_update(s,a,s_prime,a_prime,model,game)
	sa = game.available_sa(s,a);
	sa_prime = game.available_sa(s_prime,a_prime);
	newH = model.H;
	t = zeros(length(model.H),1); t(sa) = 1;
	newH(sa,:) = (1-model.param.sr_alpha)*model.H(sa,:) + model.param.sr_alpha*(t' + model.param.discount*model.H(sa_prime,:));
	H = newH;

function [H] = qlearn_update(s,a,r,s_prime,a_prime,model,game)
	sa = game.available_sa(s,a);
	available_sa_prime = game.available_sa(s_prime,:);
	available_sa_prime(available_sa_prime==0) = [];
	Qvals = model.Q(available_sa_prime);
	[maxval, max_a] = max(Qvals);
	[bestA] = find(Qvals==maxval);
	if length(bestA) > 1
		a_prime_star = a_prime;
	else
		a_prime_star = bestA;
	end
	sa_prime_star = game.available_sa(s_prime,a_prime_star);

	oldH = model.H;
	H = oldH;
	t = zeros(length(oldH),1);
	t(sa) = 1;
	H(sa,:) = (1-model.param.sr_alpha)*oldH(sa,:) + model.param.sr_alpha*(t' + model.param.discount*oldH(sa_prime_star,:));


function model = dyna_update(model,game,nsamples)

	%keyboard

	u_sa = unique(model.sa_list(1:model.dn_tot-1)); % should have no zeros

	for k = 1:nsamples
		ind = ceil(rand*length(u_sa)); % pick an index from unique elements in sa_list
		sa_num = u_sa(ind);

		% choose a sample from the list for this sa
		%pdf = exponential(model.sa(sa_num).dn-1:-1:1,5);
		pdf = exponential(1:100, 1/5);
		pdf = pdf/sum(pdf);
		n = find(rand < cumsum(pdf),1);
		if n > model.sa(sa_num).dn - 1
			n = model.sa(sa_num).dn - 1;
		end
		%sample = model.sa(sa_num).samples(n,:);
		sample = model.sa(sa_num).samples(model.sa(sa_num).dn-n,:);

		s = sample(1); a = sample(2); r = sample(3); s_prime = sample(4); a_prime = sample(5);
		[H] = qlearn_update(s,a,r,s_prime,a_prime,model,game);
		model.H = H;
		model.Q = model.H*model.w;
	end

		%	sample = model.sa(sa_num).samples(model.sa(sa_num).dn-1,:);


function w = w_update(s,a,r,s_prime,a_prime,model,game)

	w = model.w;
	sa = game.available_sa(s,a);
	sa_prime = game.available_sa(s_prime,a_prime);

	feature_rep_s = model.H(sa,:);
	norm_feature_rep_s = feature_rep_s./(feature_rep_s*feature_rep_s');

	w_error = r + model.param.discount*(model.H(sa_prime,:)*model.w) - (model.H(sa,:)*model.w);

	w = w + model.param.w_alpha*w_error*norm_feature_rep_s';


function y = exponential(x,mu)

y = (1/mu).*exp(-x./mu);
