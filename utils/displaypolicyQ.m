function displaypolicy(game,Qval)

global yx_to_state
hold on

%keyboard
%figure(
[implied_policy, state_val] =  get_pol_from_q(game,Qval);

[hor vert] = makepolarrows(implied_policy,game);
mins = min(state_val);
maxs = max(state_val);
ranges = maxs - mins;
state_val(game.wallstates) = min(min(state_val)) - .15*ranges;
state_val_im = reshape(state_val(1:100),[10,10]);
imagesc(state_val_im(10:-1:1,:));
colormap gray

scale = .38;
x = repmat(1:10,[10 1]);
y =repmat((10:-1:1)', [1 10]);
%lh = quiver(x,y,hor,vert, scale, 'MaxHeadSize', 50);
quiver(x,y,hor,vert, scale, 'MaxHeadSize', 50);
%adjust_quiver_arrowhead_size(lh, 3)

%keyboard
% line, marker, length, scale

% plotting parameters

%set(lh,'linewidth',2.7);     
%set(lh,'color',[1,0,0]);
%set(lh,'autoScaleFactor',.28)

axis square
axis off

width = 3; height = 3;
set(gcf,'PaperSize',[4.5,4.5])

set(gcf,'InvertHardcopy','on');
set(gcf,'PaperUnits', 'inches');
papersize = get(gcf, 'PaperSize');
left = (papersize(1)- width)/2;
bottom = (papersize(2)- height)/2;
myfiguresize = [left, bottom, width, height];
set(gcf,'PaperPosition', myfiguresize);




