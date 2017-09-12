function implied_policy =  getpolicy(game,state_val)

	implied_policy = zeros(100,1);
	

	for i = 1:100
		% calculate Q values in that state

		if or(ismember(i,game.wallstates), ismember(i,game.reward_states))
			implied_policy(i) = 0;
		else

			next_state = game.nextState(i,:);
			next_state(next_state==0) = [];
			Qvals = state_val(next_state);

	    epsilon = 0;
		% which of these actions are actually availalbe
		next_state = game.nextState(i,:);
		next_state(next_state == 0) = [];

		available_choices = find(~(next_state == i));
		action_prob = zeros(length(Qvals),1);
		[maxval, max_aa] = max(Qvals(available_choices));

		if maxval == state_val(i)
			implied_policy(i) = 0;
		else

		all_best_aa = find(Qvals(available_choices)==maxval);
		all_best_c = available_choices(all_best_aa);

		if length(all_best_c) > 1
			implied_policy(i) = 0;
		else

	    	action_prob(all_best_c) = (1 - epsilon)/length(all_best_c);
			action_prob(available_choices) = action_prob(available_choices) + epsilon/length(available_choices);
	    	implied_policy(i) = find(rand < cumsum(action_prob),1);
		end

		end
		end
	end


