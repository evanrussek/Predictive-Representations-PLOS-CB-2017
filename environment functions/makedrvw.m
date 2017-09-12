function [locations,magnitude,wallloc,start_pos] = makedrvw()

x1 = 2:9;
y1 = repmat(5,size(x1));
y2 = 5;
x2 = repmat(2,size(y2));
%x3 = 2:8;
%y3 = repmat(3,size(x3));
y4 = 5;
x4 = repmat(8,size(y2));
y5 = 9;
x5 = [2];
x6 = 2:8;
y6 = repmat(10, size(x6));
y7 = 9;
x7 = repmat(8,size(y7));
y8 = 4:6;
x8 = [10 10 10];

mazeloc = [y1' x1'; y2' x2'; y4' x4'; y5' x5'; y6' x6'; y7' x7'; 5 1; y8' x8'];
map = zeros(10,10);
for i = 1:size(mazeloc,1)
	map(mazeloc(i,1), mazeloc(i,2)) = 1;
end
[r c] = find(~map);
wallloc = [r c];

locations = [5, 10];
magnitude = 0;
start_pos = [5,1];