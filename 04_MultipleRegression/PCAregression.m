%% Principal Component Regression
Cement = readtable("../Dataset/MPV/cement.csv");

%% 
X = [Cement.x1, Cement.x3, Cement.y];
[coeff,score,roots] = pca(X);
basis = coeff(:,1:2);
normal = coeff(:,3); 

pctExplained = roots' ./ sum(roots);
[n,p] = size(X);
meanX = mean(X,1);

Xfit = repmat(meanX,n,1) + score(:,1:2)*coeff(:,1:2)';
residuals = X - Xfit;
error = abs((X - repmat(meanX,n,1))*normal);
sse = sum(error.^2);

[xgrid,ygrid] = meshgrid(linspace(min(X(:,1)),max(X(:,1)),25), ...
                         linspace(min(X(:,2)),max(X(:,2)),25));
zgrid = (1/normal(3)) .* (meanX*normal - (xgrid.*normal(1) + ygrid.*normal(2)));

mdl2D = fitlm([Cement.x1, Cement.x3], Cement.y);
betas = mdl2D.Coefficients.Estimate;

[x, y] = meshgrid(0:25, 0:25);
z  = betas(2) .* x + betas(3) .* y + betas(1) ;

figure; hold on;
mesh(xgrid,ygrid,zgrid,'FaceColor','g', 'FaceAlpha',0.3, 'EdgeColor','none');
mesh(x,y,z, 'FaceColor','r', 'FaceAlpha',0.3, 'EdgeColor','none');
xlabel('x1'); ylabel('x3'); zlabel('y');
legend('Orthogonal Regression', 'Linear Regression', 'Data Points');
scatter3(Cement.x1, Cement.x3, Cement.y, 50, 'black', 'filled');
