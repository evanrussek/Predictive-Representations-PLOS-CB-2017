function [game, model] = gamestep2(game,model,show)
	%when is it done?
	% first situation : e.g. there is an s, but no a, no s_prime, 
	% 
	if (model.a == 0) % first action
		%keyboard

		[Qvals, model] = model.eval(model,game);

		model.a = model.choose(Qvals,game,model.param.epsilon);
		model.r = game.Rsa(game.available_sa(model.s,model.a));
		model.s_prime = game.nextState(model.s,model.a);

		game.current_state = model.s_prime;
		asa = game.available_sa(game.current_state,:);
		[Qvals_prime, model] = model.eval(model,game);
		model.a_prime = model.choose(Qvals_prime,game,model.param.epsilon);

		model = model.update(model,game);
	else 
		%keyboard
		model.s = model.s_prime;
		model.a = model.a_prime;
		model.r = game.Rsa(game.available_sa(model.s,model.a));

		model.s_prime = game.nextState(model.s,model.a);

		game.current_state = model.s_prime;
		
		[Qvals, model] = model.eval(model,game);

		model.a_prime = model.choose(Qvals,game,model.param.epsilon);

		model = model.update(model,game);
	end



	if (show == 1 & game.current_state <= 100)
		figure(1)
			subplot(3,1,1)
		displaygame(game)
		title('game')
			subplot(3,1,2)
			displaySR(game,model,game.current_state)
			title('state representation')
			subplot(3,1,3)
			displayWeights(game,model)
            title('weights')
			pause(.01)
	end	

