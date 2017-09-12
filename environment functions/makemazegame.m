function [locations, magnitude, wallloc] = makemazegame()

%% set up game
% put in barrier
y1 = 1:10;
x1 = repmat(2,size(y1));

x2 = 1:6;
y2 = repmat(3,size(x2));

y3 = 1:10;
x3 = repmat(5,size(y3));

x4 = 4:8;
y4 = repmat(6, size(x4));

y5 = 1:10;
x5 = repmat(8,size(y5));

x6 = 7:10;
y6 = repmat(9,size(x6));

x7 = 8:10;
y7 = repmat(1,size(x7));

x8 = 1:2;
y8 = repmat(9, size(x8));
%for x = 1:2:10

x9 = 1:2;
y9 = repmat(8, size(x9));

x10 = 1:6;
y10 = repmat(2,size(x10));

x11 = 4:5;
y11 = repmat(3,size(x11));

x12 = 8:10;
y12 = repmat(2,size(x7));

x13 = 9:10;
y13 = [10 10];

x14 = 6:7;
y14 = [5 5];

mazeloc = [y1' x1'; y2' x2'; y3' x3'; y4' x4'; y5' x5'; y6' x6'; y7' x7'; y8' x8'; y9' x9'; y10' x10'; y11' x11'; 7 4; y12' x12'; y13' x13'; y14' x14'; 8 7; 8 4];
map = zeros(10,10);
for i = 1:size(mazeloc,1)
	map(mazeloc(i,1), mazeloc(i,2)) = 1;
end
[row c] = find(~map);
wallloc = [row c];

locations = [2 10; 9 10];
magnitude = [0; 0];