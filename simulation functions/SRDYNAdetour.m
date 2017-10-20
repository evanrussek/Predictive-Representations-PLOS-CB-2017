function r2 = SRDYNAdetour(nruns,nsamples,params_in)

r2.postr_hor = zeros(10,10,nruns); r2.postr_vert = zeros(10,10,nruns);
r2.postd_hor = zeros(10,10,nruns); r2.postd_vert= zeros(10,10,nruns);
r2.postr_Q = zeros(402,nruns);  r2.postd_Q = zeros(402,nruns);

for t = 1:nruns
	t;

global yx_to_state;

[locations,magnitude,wallloc,start_pos] = makedetourgame();
game = makegame2(locations,magnitude,wallloc,start_pos);

% make model
model = model_SRDYNA;
model = model.init(model,game,params_in);

nexploresteps = 5000;
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
maxstep = 300;
% increase R
game.Rsa(401) = 10;
% drop  in reward state, show new reward % verify that this changes w
%nrevaltrials = 40;
%for i = 1:nrevaltrials
%	game.current_state = game.reward_states(1);
%	model.s = game.reward_states(1);
%	model.a = 0;
%	model.s_prime= 0; 
%	model.a_prime = 0;
%	[game, model] = gamestep2(game,model,0);
%end

% do n trials from start to finish
ntrials = 5;
ind = 1;
for tr = 1:ntrials
	game.current_state = game.start_state;
	model.s = game.current_state;
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
end

%% can we now save it
model = model.dyna_update(model,game,nsamples);

% record policy
model.Q = model.H*model.w;
%[implied_policy, state_val] =  get_pol_from_q(game,model);
r2.postr_Q(:,t) = model.Q;
game_postr= game;

%[r2.postr_hor(:,:,t) r2.postr_vert(:,:,t)] = makepolarrows(implied_policy,game);

% basically remake game.
newwallloc = [wallloc; 5, 6];
newmag = 10;
game = makegame2(locations,newmag,newwallloc,start_pos);

drop_state = 45;
% reval
ndroptrials = 40;
for i = 1:ndroptrials
	game.current_state = drop_state;
	model.s = drop_state;
	model.a = 0;
	model.a_prime = 0;
	model.s_prime = 0;
	[game,model] = gamestep2(game,model,0);
end


% can it now be saved?

%% can we now save it
model = model.dyna_update(model,game,nsamples);

% record policy
model.Q = model.H*model.w;
%[implied_policy, state_val] =  get_pol_from_q(game,model);
r2.postd_Q(:,t) = model.Q;
game_postd = game;
%[r2.postd_hor(:,:,t) r2.postd_vert(:,:,t)] = makepolarrows(implied_policy,game);
end

figure(1)
postr_val = median(r2.postr_Q,2);  displaypolicyQ(game_postr,postr_val);
figure(2)
postd_val = median(r2.postd_Q,2); displaypolicyQ(game_postd,postd_val);
