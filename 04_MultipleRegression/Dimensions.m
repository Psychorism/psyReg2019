%%
set(0, 'DefaultFigureWindowStyle', 'normal');

%%
Cement = readtable("../Dataset/MPV/cement.csv");


%% 1D Linear regression
mdl1D = fitlm([Cement.x1], Cement.y);
betas = mdl1D.Coefficients.Estimate;

figure; hold on;
scatter(Cement.x1, Cement.y, 'black', 'filled');
xlabel('x1'); ylabel('y');

plot(0:25, [0:25] * betas(2) + betas(1), 'LineWidth', 2)


%% 2D Linear regression
mdl2D = fitlm([Cement.x1, Cement.x3], Cement.y);
betas = mdl2D.Coefficients.Estimate;

[x, y] = meshgrid(0:25, 0:25);
z  = betas(2) .* x + betas(3) .* y + betas(1) ;

figure; hold on;
scatter3(Cement.x1, Cement.x3, Cement.y, 'black', 'filled');
xlabel('x1'); ylabel('x3'); zlabel('y');
mesh(x,y,z);


%% 3D linear regression
varMin = varfun(@min, Cement(:,{'x1', 'x2', 'x3'}));
varMax = varfun(@max, Cement(:,{'x1', 'x2', 'x3'}));

[X1,X2,X3] = meshgrid( 0:25, 20:80, 0:25);
mdl = fitlm(Cement(:, [3:5,2]));
Y = predict(mdl, [X1(:),X2(:),X3(:)]);
Y = reshape(Y, size(X1));

figure; hold on
scatter3(Cement.x1, Cement.x2, Cement.x3, 50, Cement.y, 'filled');
pcolor3(X1, X2, X3, Y);
alpha(.1);
colormap(jet);
colorbar;
xlabel('x1'); ylabel('x2'); zlabel('x3');
