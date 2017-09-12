function model = model_Vsr()

	model.init = @modelinit;
	model.update = @modelupdate;
	model.eval = @modeleval;
	model.choose = @modelchoose;

function model = modelinit(model,game)

	% parameters
	model.param.epsilon = .1;
	model.param.sr_alpha = .5;
	model.param.w_alpha = .5;
	model.param.discount = .95;

	% structures
	n_s = length(game.Rs)+1; M = eye(n_s);  M(101:end,:) = 0;  w = zeros(n_s,1);
	model.M = M; model.w = w;

	% state/action index
	model.s = game.current_state;
	model.s_prime = 0;
	model.a = 0;
	model.a_prime = 0;
	model.r = 0;


function model = modelupdate(model,game)
	% update M
	oldM = model.M;
	model.M = m_update(model.s,model.s_prime,model,game);
	% update w 
	model.w = w_update(model.s,model.r,model.s_prime,model,oldM);

function a = modelchoose(Qvals,game)
	epsilon = .1;
	action_prob = zeros(length(Qvals),1);
	[maxval, max_a] = max(Qvals);
	[bestA] = find(Qvals==maxval);
    action_prob(bestA) = (1 - epsilon)/length(bestA);
	action_prob = action_prob + epsilon/length(Qvals);
    a = find(rand < cumsum(action_prob),1);

function [Q,model] = modeleval(model,game)
	model.V = model.M*model.w;
	next_state = game.nextState(game.current_state,:);
	next_state(next_state == 0) = [];
	Q = model.V(next_state);

function M = m_update(s,s_prime, model,game)
	oldM = model.M; M = oldM;
	t = zeros(length(oldM),1); t(s) = 1;
	M(s,:) = (1-model.param.sr_alpha)*oldM(s,:) + model.param.sr_alpha*(t' + model.param.discount*oldM(s_prime,:));

function w =  w_update(s,r,s_prime,model,oldM);
	w = model.w + model.param.w_alpha*(r + model.param.discount*model.V(s_prime) - model.V(s))*oldM(s,:)';

%	if any(model.w < -5)
%		keyboard
%	end

