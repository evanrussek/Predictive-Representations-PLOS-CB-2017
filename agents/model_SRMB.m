function model = model_SRMB()

model.init = @modelinit;
model.update = @modelupdate;
model.eval = @modeleval;
model.choose = @modelchoose;
model.dyna_update = @dyna_update;
model.qlearn_update = @qlearn_update;

function model = modelinit(model,game, params_in)


	if nargin < 3
		% parameters
		model.param.epsilon = .1;
		model.param.p_alpha = .1;
		model.param.w_alpha = .25;
		model.param.discount = .9;
	else
		model.param = params_in;
	end

	model.param.build = 0;

	% structures
	n_s = length(game.Rs)+1; M = eye(n_s);  M(101:end,:) = 0;  w = zeros(n_s,1);
	model.M = M; model.w = w;

	n_s = length(game.Rs)+1;
	[next_state, available_actions] = initialize_next_state(game);
	policy = .25*available_actions;
	w = zeros(n_s,1);

	model.next_state = next_state;
	model.available_actions = available_actions;
	model.policy = policy;
	model.w = w;

	model.s = game.current_state;
	model.s_prime = 0;
	model.a = 0;
	model.a_prime = 0;
	model.r = 0;

function [Q,model] = modeleval(model,game)
	
	if model.param.build == 1
		model.T = buildT(model.next_state, model.available_actions, model.policy);
		model.M = buildM(model.T,model.param.discount);
	end

	model.V = model.M*model.w;

	next_state = game.nextState(game.current_state,:);
	next_state(next_state == 0) = [];
	Q = model.V(next_state);

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


function model = modelupdate(model,game)
	% update available_actions
	oldM = model.M;
	model.available_actions = aa_update(model.s_prime,model,game);
	% update w 
	model.w = w_update(model.s,model.r,model.s_prime,model,oldM);
	% update policy
	model.policy = policy_update(model.s_prime,model.a_prime,model);



function [w, w_error, w_change]  =  w_update(s,r,s_prime,model,oldM);
	feature_rep_s = oldM(s,:);
	norm_feature_rep_s = feature_rep_s./(feature_rep_s*feature_rep_s');

	w_error = r + model.param.discount*model.V(s_prime) - model.V(s);
	w_change = w_error*oldM(s,:)';
	w = model.w + model.param.w_alpha*(r + model.param.discount*model.V(s_prime) - model.V(s))*norm_feature_rep_s';


function aa = aa_update(s_prime,model,game)
	aa = model.available_actions;
	this_state_aa = aa(s_prime,:);
	this_state_aa(game.nextState(s_prime,:) == s_prime) = 0;
	aa(s_prime,:) = this_state_aa;

function policy = policy_update(s_prime,a_prime,model)
	policy = model.policy;
	this_state_p = policy(s_prime,:);
	outcome = zeros(1,4); outcome(a_prime) = 1;
	policy(s_prime,:) = model.param.p_alpha*outcome + (1 - model.param.p_alpha)*this_state_p;


function [next_state, available_actions] = initialize_next_state(game)
	% the sr gets to start with accurate knowledge of next state (e.g. basic physics of gridworld), but does not know about any walls
	modelgame = makegame2(game.locations,zeros(size(game.locations,1),1), []);
	next_state = modelgame.nextState;
	next_state(next_state>100) = 0;
	available_actions = ones(size(next_state));

	% deal w/ actions in terminal states (in fact the model represents nothing about terminal states)
	available_actions(next_state == 0) = 0;

function T = buildT(next_state, available_actions, policy)
	T = zeros(length(next_state), length(next_state));
	% next_state
	for s = 1:length(next_state)
		% get policy in s
		sp = policy(s,:); sp(~available_actions(s,:)) = 0; sp = sp/sum(sp);
		ns = next_state(s,:); ns = ns(logical(available_actions(s,:)));
        if ~isempty(ns)
            T(s,ns) = sp(sp~=0);
        end
	end

function M = buildM(T,discount)
	M = inv(eye(length(T)) - discount*T);







