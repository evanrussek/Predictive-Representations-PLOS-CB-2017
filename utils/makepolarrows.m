function [hor vert] = makepolarrows(implied_policy,game)

im_polmtx = reshape(implied_policy,[10 10]);

hor = zeros(10,10); vert = zeros(10,10);
global yx_to_state;

for r = 1:10
	for c = 1:10
		thisp = im_polmtx(r,c);

		switch thisp
			case 1 % north
				hor(r,c) = 0; vert(r,c) = 1;
			case 2 % south
				hor(r,c) = 0; vert(r,c) = -1;
			case 3 % east
				hor(r,c) = 1; vert(r,c) = 0;
			case 4 % west
				hor(r,c) = -1; vert(r,c) = 0;
			case 0 % unavailable actions
				hor(r,c) = 0; vert(r,c) = 0;
		end

		%if or(ismember(yx_to_state(r,c), game.wallstates), ismember()
		%	hor(r,c) = 0; vert(r,c) = 0;
		%end

	end
end



