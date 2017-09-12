function displaySR(game,model, state)

	sr  = model.M;


	a = sr(state,:);

	b = reshape(a(1:100),[10 10]);

	imagesc(b)
	colormap gray;
	axis off