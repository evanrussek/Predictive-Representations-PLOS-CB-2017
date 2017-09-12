function game = makegame2(locations,magnitude,wallloc, startpos)

% setupmo
rows = 10;
cols = 10;
nstates = rows*cols;
nactions = 4;

if nargin < 4
startpos = [8 1];
end

% map y,x positions to  number
global yx_to_state
yx_to_state_t = zeros(cols,rows);
for c = 1:cols
	yx_to_state_t(c,:) = 1 + (c-1)*rows : rows*c;
end
yx_to_state = yx_to_state_t';

nwallstates = size(wallloc,1);
wallstates = zeros(nwallstates,1);
for i = 1:nwallstates
	wallstates(i) = yx_to_state(wallloc(i,1), wallloc(i,2));
end

% 
[Rs, Rsa] = makeR(nstates,locations,magnitude);

[T_init, nextstate_init] = makeT(rows,cols,nactions,locations);

% put in barrier
[newT newNextState] = addwall(T_init,nextstate_init, wallloc);

[available_sa, sa_to_nextstate, nextState] = configSA(newNextState,locations);

game.reward_states = [];
for i = 1:size(locations,1)
	game.reward_states = [game.reward_states; yx_to_state(locations(i,1), locations(i,2))];
end

game.rows = rows;
game.cols = cols;
game.T = newT;
game.nextState = nextState;
game.wallloc = wallloc;
game.Rs = Rs;
game.Rsa = Rsa;
game.available_sa = available_sa;
game.sa_to_nextstate = sa_to_nextstate;

game.pos = startpos;
game.start_state = yx_to_state(startpos(1),startpos(2));
game.current_state = game.start_state;
game.wallstates = wallstates;
game.locations = locations;
game.magnitude = magnitude;


function [Rs, Rsa] = makeR(nstates,locations,magnitude)

% locations should be number of reward locations X 2 - y then x
% magnitude should be number of reward locations X 1 - each value is size of reward
% R is nstates X 1, - R(i) is reward value for entering state i

global yx_to_state;
nlocations = length(magnitude);
Rs = zeros(nstates + nlocations,1);
nlocations = length(magnitude);

Rsa = zeros(400+nlocations+1,1);

for i = 1:nlocations
	state_i = yx_to_state(locations(i,1), locations(i,2));
	Rs(state_i) = magnitude(i);
	Rsa(400+i) = magnitude(i);
end

function [T , nextstate] =  makeT(rows,cols,nactions,locations)

% this function builds (nstatesxnactions) nextstate matrix
% nextstate mtx takes in (state,action) and gives next state

global yx_to_state;

nrewardlocs = size(locations,1);

nstates = rows*cols;

T = zeros(nstates,nactions,nstates);

newstate = zeros(1,nactions);
nextstate = zeros(nstates,nactions);
% want transition matrix
for x = 1:cols
	for y = 1:rows
		currstate = yx_to_state(y,x);
		% position after action 1 (north)
		newpos(1,:) = [(y-1) x];
		% position after action 2 (south)
		newpos(2,:) = [(y+1) x];
		% position after action 3 (east)
		newpos(3,:) = [y (x + 1)];
		% position after action 4 (west)
		newpos(4,:) = [y (x - 1)];

		newpos(newpos>rows) = rows; newpos(newpos < 1) = 1;

		% for each action
		for a = 1:4
			ns  = yx_to_state(newpos(a,1),newpos(a,2));
			newstate(a) = ns;
			T(currstate,a,ns) = 1;
		end
		nextstate(currstate,:) = newstate;

	end
end


function [newT newNextState] = addwall(oldT,oldNextState, wallloc)

% updates T and newState so that state-action pairs which lead into wall, lead to state

global yx_to_state;

% at states where there is a wall, 
nwallstates = size(wallloc,1);

newNextState = oldNextState;
newT = oldT;

for i = 1:nwallstates
	wallstate_i = yx_to_state(wallloc(i,1), wallloc(i,2));
	% find s-a pairs that lead to that state
	[s,a] = ind2sub(size(oldNextState),find(oldNextState == wallstate_i));
	for j = 1:length(s)
		% switch transition mtx so those states lead to themselves
		newNextState(s(j),a(j)) = s(j);
		newT(s(j),a(j), wallstate_i) = 0;
		newT(s(j),a(j), s(j)) = 1;
	end
end

function [available_sa, sa_to_nextstate, nextState] = configSA(nextState,locations)

nlocations = size(locations,1);
nstates = 100+nlocations+1;

% available_sa
available_sa = zeros(nstates,4);
available_sa(1:100,:) = reshape(1:400,[100 4]);

global yx_to_state

for i = 1:nlocations
	thisloc = locations(i,:);
	this_state = yx_to_state(thisloc(1), thisloc(2));
	available_sa(this_state,:) = [400+i, 0, 0, 0];
	available_sa(100+i,:) = [400+nlocations+1,0,0,0];
end


% sa_to_nextstate
sa_to_nextstate = zeros(400+nlocations+1,1);

for i = 1:nlocations
	thisloc = locations(i,:);
	this_state = yx_to_state(thisloc(1), thisloc(2));
	nextState(this_state,:) = [100+i, 0 0 0];
	nextState = [nextState; nstates, 0 , 0, 0];
end
nextState = [nextState; 0 0 0 0];

for i = 1:400+nlocations+1
	[row, col] = find(available_sa == i);
	if length(row) == 1
		sa_to_nextstate(i) = nextState(row,col);
	end
end


