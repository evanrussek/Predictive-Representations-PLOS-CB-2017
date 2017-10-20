function r2 = SRTDdetour(nruns,param)

%vsr2

% this works!!!

postr_hor = zeros(10,10,nruns); postr_vert = zeros(10,10,nruns);
postd_hor = zeros(10,10,nruns); postd_vert= zeros(10,10,nruns);
postr_V = zeros(100,nruns);  postd_V = zeros(100,nruns);

for t = 1:nruns
	t;
	

yx_to_state = reshape(1:100,10,10);

[locations,magnitude,wallloc,start_pos] = makedetourgame();
game = makegame2(locations,magnitude,wallloc,start_pos);

% make model
model = model_SRTD;
%param.epsilon = .1;
%param.p_alpha = .3;
%param.w_alpha = .3;
%param.discount = .95;
model = model.init(model,game,param);

nexploresteps = 50000;
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
maxstep = 500;
% increase R
game.Rsa(401) = 10;
% drop  in reward state, show new reward % verify that this changes w
nrevaltrials = 1;
%for i = 1:nrevaltrials
%	game.current_state = game.reward_states(1);
%	model.s = game.reward_states(1);
%	model.a = 0;
%	model.s_prime= 0; 
%	model.a_prime = 0;
%	[game, model] = gamestep2(game,model,0);
%end

model.param.build = 1;

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
			if tr == 1
				if ind > 1
					%modelhist(tr).inst(ind-1) = model;
					%gamehist(tr).inst(ind-1) = game;
				end
					[game,model] = gamestep2(game,model,0);
					ind = ind+1;
			else
				if ind > 1
					%modelhist(tr).inst(ind-1) = model;
					%gamehist(tr).inst(ind-1) = game;
				end

				[game,model] = gamestep2(game,model,0);
				ind = ind+1;
			end
			step = step+1;
	end
end

% record value, policy
model.V = model.M*model.w;
postr_V(:,t) = model.V(1:100);
%implied_policy = getpolicy(game,model.V);
game_postr = game;
%[r2.postr_hor(:,:,t) r2.postr_vert(:,:,t)] = makepolarrows(implied_policy,game);


% basically remake game.
newwallloc = [wallloc; 5, 6];
newmag = 10;
game = makegame2(locations,newmag,newwallloc,start_pos);
drop_state = 45;
% reval
ndroptrials = 50;

for i = 1:ndroptrials
	game.current_state = drop_state;
	model.s = drop_state;
	model.a = 0;
	model.a_prime = 0;
	model.s_prime = 0;
	[game,model] = gamestep2(game,model,0);
end

% can it now be saved?

% record policy
model.V = model.M*model.w;
postd_V(:,t) = model.V(1:100);
%implied_policy = getpolicy(game,model.V);
game_postd = game;
%[postd_hor(:,:,t) postd_vert(:,:,t)] = makepolarrows(implied_policy,game);
end

figure(2)
r2.postr_V = postr_V;
r2.postd_V = postd_V;

postr_val = median(r2.postr_V,2);  displaypolicy(game_postr,postr_val);
figure(3)
postd_val = median(r2.postd_V,2); displaypolicy(game_postd,postd_val);
