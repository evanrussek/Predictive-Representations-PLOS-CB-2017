function gamemtx = displaygame(game)

	gamemtx = zeros(game.rows,game.cols);
	% draw wall
	for i = 1:size(game.wallloc,1)
		gamemtx(game.wallloc(i,1), game.wallloc(i,2)) = -1;
	end

	% draw reward
	
	%nlocations = length(game.reward_states);
	%for i = 1:nlocations
	%		gamemtx(game.reward_states(i)) =  (game.R(game.reward_states(i)) > 0);
	%end

	% draw player
	if isfield(game,'cs')

		for i = 1:length(game.cs)
			[r c] = ind2sub([game.rows game.cols],game.cs(i));

			%gamemtx(r,c) = -2;
			gamemtx(r,c) = 1;

			
		end

	else
	 [r c] = ind2sub([game.rows game.cols],game.current_state);
	 %gamemtx(r,c) = -2;
	 gamemtx(r,c) = 1;

	end

	imagesc(gamemtx);
	colormap gray
	axis off
	%imagesc(gamemtx(end:-1:1,:));
