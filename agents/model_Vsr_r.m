function model = model_Vsr()

	model.init = @modelinit;
	model.update = @modelupdate;
	model.eval = @modeleval;
	model.choose = @modelchoose;

function model = modelinit(model,game,params_in)

	if nargin < 3
		% parameters
		model.param.epsilon = .1;
		model.param.sr_alpha = .25;
		model.param.w_alpha = .25;
		model.param.discount = .9;
	else
		model.param = params_in;
	end


	% structures
	n_s = length(game.Rs)+1; M = eye(n_s);  M(101:end,:) = 0;  w = zeros(n_s,1);
	model.M = M; model.w = w;

	% state/action index
	model.s = game.current_state;
	model.s_prime = 0;
	model.a = 0;
	model.a_prime = 0;
	model.r = 0;


	% store other things
	model.w_error = 0;
	model.w_change = zeros(size(M,1),1);
	model.m_error = zeros(size(M,1),1);


function model = modelupdate(model,game)
	% update M
	oldM = model.M;
	[model.M, model.m_error] = m_update(model.s,model.s_prime,model,game);
	% update w 
	[model.w, model.w_error, model.w_change] = w_update(model.s,model.r,model.s_prime,model,oldM);

function a = modelchoose(Qvals,game,epsilon)
	%epsilon = .1;
	action_prob = zeros(length(Qvals),1);
	[maxval, max_a] = max(Qvals);
	[bestA] = find(Qvals==maxval);
    action_prob(bestA) = (1 - epsilon)/length(bestA);
	action_prob = action_prob + epsilon/length(Qvals);
    a = find(rand < cumsum(action_prob),1);

    if isempty(a)
    	keyboard
    end

function [Q,model] = modeleval(model,game)
	model.V = model.M*model.w;
	next_state = game.nextState(game.current_state,:);
	next_state(next_state == 0) = [];
	Q = model.V(next_state);

	if any(isnan(Q))
		keyboard
	end

function [M, m_error] = m_update(s,s_prime, model,game)
	oldM = model.M; M = oldM;
	t = zeros(length(oldM),1); t(s) = 1;
	m_error = model.param.discount*oldM(s_prime,:) + t' - oldM(s,:);
	M(s,:) = (1-model.param.sr_alpha)*oldM(s,:) + model.param.sr_alpha*(t' + model.param.discount*oldM(s_prime,:));

function [w, w_error, w_change]  =  w_update(s,r,s_prime,model,oldM);
	w = model.w;

	w_error = r - w(s);
	w_change = model.param.w_alpha*(r-w(s));
	w(s) = w(s) + model.param.w_alpha*(r - w(s));

	if any(isnan(w))
		keyboard
	end

%	if any(model.w < -5)
%		keyboard
%	end

