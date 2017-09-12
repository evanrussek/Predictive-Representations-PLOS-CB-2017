function [implied_policy, state_val] =  getpolicy(game,Q)

implied_policy = zeros(100,1);
state_val = zeros(100,1);


for i = 1:100
		% get q values
		asa = game.available_sa(i,:);
		asa(asa == 0) = [];
		Qvals = Q(asa);
		epsilon = 0;
		action_prob = zeros(length(Qvals),1);
		[maxval, max_a] = max(Qvals);
		%keyboard
		state_val(i) = maxval;
		[bestA] = find(Qvals==maxval);
		if length(bestA) > 1
			implied_policy(i) = 0;
		else
			action_prob(bestA) = (1 - epsilon)/length(bestA);
			action_prob = action_prob + epsilon/length(Qvals);
			implied_policy(i) = find(rand < cumsum(action_prob),1);
		end

	if or(ismember(i,game.wallstates), ismember(i,game.reward_states))
		implied_policy(i) = 0;
	end

	%if ismember(i,game.wallstates)
	%	keyboard
	%	state_val(i) = -.5;
	%end

end

