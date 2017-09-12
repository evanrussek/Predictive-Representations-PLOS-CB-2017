function r2 = qsrmaze(nruns, nsamples,param)


%nruns = 1;
postr_hor = zeros(10,10,nruns); postr_vert = zeros(10,10,nruns);
postr2_hor = zeros(10,10,nruns); postr2_vert= zeros(10,10,nruns);
postr_Q = zeros(403,nruns);  postr2_Q = zeros(403,nruns);

parfor t = 1:nruns
tic
t

[locations, magnitude, wallloc] = makemazegame();
game = makegame2(locations,magnitude,wallloc);

% make model
model = model_Qsr2;

model = model.init(model,game,param);


% explore phase
nexploresteps = 10000;
step = 0;

while step < nexploresteps
	game.current_state = game.start_state;
	model.s = game.start_state;
	model.a = 0;
	model.s_prime= 0; 
	model.a_prime = 0;
	while (game.current_state <= 100) && (step < nexploresteps)
		[game, model] = gamestep2(game,model,0);
		step = step + 1;
	end
end

% increase R
game.Rsa(401) = 10;
% drop  in reward state, show new reward % verify that this changes w
nrevaltrials = 20;
for i = 1:nrevaltrials
	game.current_state = game.reward_states(1);
	model.s = game.reward_states(1);
	model.a = 0;
	model.s_prime= 0; 
	model.a_prime = 0;
	[game, model] = gamestep2(game,model,0);
end

%keyboard

%% can we now save it
model = model.dyna_update(model,game,nsamples);

% record policy
model.Q = model.H*model.w
%[implied_policy, state_val] =  get_pol_from_q(game,model);
postr_Q(:,t) = model.Q;
%game_postr = game;
%[r2.postr_hor(:,:,t) r2.postr_vert(:,:,t)] = makepolarrows(implied_policy,game);




% run new training (nonrandom) % make sure these actually 
yx_to_state = reshape(1:100,10,10);
maxstep = 500;
% new reval
ntrials = 20;
ind = 1;

tr = 1;

while tr < ntrials + 1
	if mod(tr,2) == 0
		game.current_state = game.start_state;
		model.s = game.start_state;
	else
		game.current_state = yx_to_state(9,9);
		model.s = game.current_state;
	end
	model.a = 0;
	model.s_prime = 0;
	model.a_prime = 0;
	model.r = 0;
	step = 0;
	while and(game.current_state <= 100, step < maxstep)
		%modelhist(ind) = model;
		%gamehist(ind) = game;
		[game,model] = gamestep2(game,model,0);
		step = step+1;
		ind = ind+1;
	end
	if or(game.current_state == 101, step >= maxstep)
		tr = tr+1;
	end
end



% raise R2
game.Rsa(402) = 20;
% drop  in reward state, show new reward % verify that this changes w
nrevaltrials = 20;
for i = 1:nrevaltrials
	game.current_state = game.reward_states(2);
	model.s = game.reward_states(2);
	model.a = 0;
	model.s_prime= 0; 
	model.a_prime = 0;
	[game, model] = gamestep2(game,model,0);
end


%% can we now save it
model = model.dyna_update(model,game,nsamples);

% record policy
model.Q = model.H*model.w
%[implied_policy, state_val] =  get_pol_from_q(game,model);
postr2_Q(:,t) = model.Q;
%game_postr2 = game;
%[r2.postr2_hor(:,:,t) r2.postr2_vert(:,:,t)] = makepolarrows(implied_policy,game);
toc
end

r2.postr_Q = postr_Q;
r2.postr2_Q = postr2_Q;

%figure(1)
%postr_Q = median(r2.postr_Q,2);  displaypolicyQ(game_postr,postr_Q);
%figure(2)
%postd_Q = median(r2.postr2_Q,2); displaypolicyQ(game_postr2,postd_Q);
