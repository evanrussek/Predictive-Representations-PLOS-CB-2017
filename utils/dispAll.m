function dispAll(game,model)

		%figure(1)
			subplot(3,1,1)
		displaygame(game);
		title('game')
			subplot(3,1,2)
			displaySR(game,model,game.current_state);
			title('state representation')
			subplot(3,1,3)
			displayWeights(game,model);
            title('weights')
