function model = model_QSR()

model.init = @modelinit;
model.update = @modelupdate;
model.eval = @modeleval;
model.choose = @modelchoose;
model.dyna_update = @dyna_update;
model.qlearn_update = @qlearn_update;

function model = modelinit(model,game)

	n_sa = length(game.sa_to_nextstate);
	H = eye(n_sa);
	H(n_sa,:) = 0;

	w = zeros(n_sa,1);

	model.param.epsilon = .1;
	model.param.sr_alpha = .4;
	model.param.w_alpha = .1;
	model.param.discount = .9;
	model.param.nsamples = 10000;

	model.H = H;
	model.w = w;
	model.samples = zeros(10000,5); % may need more than this
	model.dn = 1;

	model.s = game.current_state;
	model.s_prime = 0;
	model.a = 0;
	model.a_prime = 0;
	model.r = 0;

function model = modelupdate(model,game)

	% update w 
	%model.w = w_update(model,game);

	% update H
	model.H = sarsa_update(model.s,model.a,model.s_prime,model.a_prime,model,game);

	model.w = w_update(model.s,model.a,model.r,model.s_prime,model.a_prime,model,game);


	% update samples? -- add later
	if model.dn > size(model.samples,1)
		model.samples = [model.samples; zeros(10000,5)];
	end
	model.samples(model.dn,:) = [model.s, model.a, model.r, model.s_prime, model.a_prime];
	model.dn = model.dn + 1;

	model = model.dyna_update(model,game,40);


function [Q,model] = modeleval(model,game)
	model.Q = model.H*model.w;
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

 %    epsilon = .1;
	% % which of these actions are actually availalbe
	% next_state = game.nextState(game.current_state,:);
	% next_state(next_state == 0) = [];

	% available_choices = find(~(next_state == game.current_state));
	% action_prob = zeros(length(Qvals),1);
	% [maxval, max_aa] = max(Qvals(available_choices));
	% all_best_aa = find(Qvals(available_choices)==maxval);
	% all_best_c = available_choices(all_best_aa);
 %    action_prob(all_best_c) = (1 - epsilon)/length(all_best_c);
	% action_prob(available_choices) = action_prob(available_choices) + epsilon/length(available_choices);
 %    a = find(rand < cumsum(action_prob),1);




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
	pdf = exponential(model.dn-1:-1:1,model.dn/5);
	pdf = pdf/sum(pdf);

	for k = 1:nsamples
		n = find(rand < cumsum(pdf),1);
		%n = ceil(model.dn*rand);
		sample = model.samples(n,:);
		s = sample(1); a = sample(2); r = sample(3); s_prime = sample(4); a_prime = sample(5);
		[H] = qlearn_update(s,a,r,s_prime,a_prime,model,game);
		model.H = H;
		%model.w = w;
		model.Q = model.H*model.w;
	end

function w = w_update(s,a,r,s_prime,a_prime,model,game)

	model.Q = model.H*model.w;

	feature_vec = model.H(sa,:)';
	feature_vec = feature_vec./(model.H(sa,:)*model.H*(sa,:)');

	w = model.w;
	sa = game.available_sa(s,a);
	sa_prime = game.available_sa(s_prime,a_prime);



	w = w + model.param.w_alpha*(r + model.param.discount*model.Q(sa_prime) - model.Q(sa))*feature_vec;


function y = exponential(x,mu)

y = (1/mu).*exp(-x./mu);
