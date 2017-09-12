function model = model_dynaQ()

model.init = @modelinit;
model.update = @modelupdate;
model.eval = @modeleval;
model.choose = @modelchoose;
model.dyna_update = @dyna_update;
model.q_update = @q_update;

% store samples, but 

function model = modelinit(model,game,params_in)
	n_sa = length(game.sa_to_nextstate);
	Q = zeros(n_sa,1);

	if nargin < 3

		model.param.epsilon = .1;
		model.param.alpha = .3;
		model.param.discount = .9;
		model.param.b_samples = 20;
	else
		model.param = params_in;
	end

	model.Q = Q;
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
	model.Q = q_update(model.s,model.a,model.r,model.s_prime,model.a_prime,model,game);

	sa_num = game.available_sa(model.s,model.a);
	model.sa(sa_num).samples(model.sa(sa_num).dn,:) = [model.s, model.a, model.r, model.s_prime, model.a_prime];
	model.sa(sa_num).dn = model.sa(sa_num).dn + 1;
	model.sa_list(model.dn_tot) = sa_num;
	model.dn_tot = model.dn_tot + 1;

	% if dyna mode
	model = model.dyna_update(model,game,model.param.b_samples); % run 40 samples

function [Q,model] = modeleval(model,game)
	asa = game.available_sa(game.current_state,:);
	asa(asa==0) = [];
	Q = model.Q(asa);

function a = modelchoose(Qvals,game,epsilon)
	action_prob = zeros(length(Qvals),1);
	[maxval, max_a] = max(Qvals);
	[bestA] = find(Qvals==maxval);
    action_prob(bestA) = (1 - epsilon)/length(bestA);
	action_prob = action_prob + epsilon/length(Qvals);
    a = find(rand < cumsum(action_prob),1);

function Q = q_update(s,a,r,s_prime,a_prime,model,game)

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

	oldQ = model.Q;
	Q = oldQ;
	Q(sa) = (1 - model.param.alpha)*oldQ(sa) + model.param.alpha*(r + model.param.discount*oldQ(sa_prime_star));

function model = dyna_update(model,game,nsamples)
	u_sa = unique(model.sa_list(1:model.dn_tot-1)); % should have no zeors

	for k = 1:nsamples
		ind = ceil(rand*length(u_sa)); % pick an index from unique elements in sa_list
		sa_num = u_sa(ind);
		%if sa_num == 401
		%	keyboard
		%end
		% choose a sample from the list for this sa
		%pdf = exponential(model.sa(sa_num).dn-1:-1:1,model.sa(sa_num).dn/20);
		%pdf = pdf/sum(pdf);
		%plot(pdf)
		%n = find(rand < cumsum(pdf),1);

		%sample = model.sa(sa_num).samples(n,:);
		sample = model.sa(sa_num).samples(model.sa(sa_num).dn-1,:);

		s = sample(1); a = sample(2); r = sample(3); s_prime = sample(4); a_prime = sample(5);
		old401 = model.Q(401);
		model.Q = q_update(s,a,r,s_prime,a_prime,model,game);
		new401 = model.Q(401);
		if new401 < old401
			keyboard
		end
	end

function y = exponential(x,mu)

	y = (1/mu).*exp(-x./mu);

