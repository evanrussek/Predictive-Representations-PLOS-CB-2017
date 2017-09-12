function displayWeights(game,model, state)

w = model.w(1:100);
b = reshape(w,[10 10]);
	imagesc(b)
	colormap gray;
		axis off
