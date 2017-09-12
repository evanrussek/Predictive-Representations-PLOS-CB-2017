function model = model_Vpunc()

	model.init = @modelinit;
	model.update = @modelupdate;
	model.eval = @modeleval;
	model.choose = @modelchoose;

function model = modelinit(model,game, params_in)

	if nargin < 3
		% parameters
		model.param.epsilon = .1;
		model.param.alpha = .25;
		model.param.discount = .9;
	else
		model.param = params_in;
	end

	% structures
	n_s = length(game.Rs)+1;
	V = zeros(n_s,1);
	model.V = V;

	% state/action index
	model.s = game.current_state;
	model.s_prime = 0;
	model.a = 0;
	model.a_prime = 0;
	model.r = 0;


function model = modelupdate(model,game)
	% update M
	[model.V] = v_update(model.s,model.r,model.s_prime,model);

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
	next_state = game.nextState(game.current_state,:);
	next_state(next_state == 0) = [];
	Q = model.V(next_state);

	if any(isnan(Q))
		keyboard
	end

function V = v_update(s,r,s_prime,model)
	V = model.V;

	V(s) = model.V(s) + model.param.alpha*(r + model.param.discount*model.V(s_prime) - model.V(s));

	if any(isnan(V))
		keyboard
	end




