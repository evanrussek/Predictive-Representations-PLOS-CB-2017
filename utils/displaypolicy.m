function displaypolicy(game,state_val)

global yx_to_state
hold on


%figure(
implied_policy =  getpolicy(game,state_val);

[hor vert] = makepolarrows(implied_policy,game);
state_val(game.wallstates) = 0;
state_val_im = reshape(state_val(1:100),[10,10]);
imagesc(state_val_im(10:-1:1,:));
colormap gray

scale = .38;
x = repmat(1:10,[10 1]);
y =repmat((10:-1:1)', [1 10]);
lh = quiver(x,y,hor,vert, scale, 'MaxHeadSize', 50);
%adjust_quiver_arrowhead_size(lh, 3)

%keyboard
% line, marker, length, scale

% plotting parameters

set(lh,'linewidth',2.7);     
set(lh,'color',[1,0,0]);
set(lh,'autoScaleFactor',.28)

axis square
axis off

%width = 1; height = 1;
%set(gcf,'PaperPosition', myfiguresize);


%width = 3; height = 3;
%set(gcf,'PaperSize',[4.5,4.5])

%set(gcf,'InvertHardcopy','on');
%set(gcf,'PaperUnits', 'inches');
%papersize = get(gcf, 'PaperSize');
%left = (papersize(1)- width)/2;
%bottom = (papersize(2)- height)/2;
%myfiguresize = [left, bottom, width, height];
%set(gcf,'PaperPosition', myfiguresize);




