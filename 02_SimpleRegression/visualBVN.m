%% Basic Settings

set(0, 'DefaultFigureWindowStyle', 'normal');

% parameters
muX = 1;
muY = 2;
sigma = 1;
rho = .3;

% x, y limits
xmin = -3;
xmax = 3;
ymin = -3;
ymax = 3;

x = linspace(xmin, xmax);
y = linspace(ymin, ymax);
[X,Y] = meshgrid(x,y);

z = BVN(X(:), Y(:), muX, muY, sigma, rho); % z = mvnpdf([X(:) Y(:)], [1,2], [1,.3;.3,1]);
z = reshape(z,length(y),length(x));


%% Run from here

% figure the graph
figure;
surf(x,y,z);
% shading interp;
% caxis([min(F1(:))-.5*range(F1(:)),max(F1(:))]);
% axis([-3 3 -3 3 0 .4])
xlabel('X'); ylabel('Y'); zlabel('Joint Density');


x0 = [0,1,2];
hold on
for i = x0
    patch([i,i,i,i],[ymin,ymin,ymax,ymax],[0,max(z(:)),max(z(:)),0],'w','FaceAlpha',0.7);
    twoDx = linspace(i,i);
    twoDy = linspace(ymin, ymax);
    twoDz = BVN(twoDx, twoDy, muX, muY, sigma, rho);
    plot3(twoDx, twoDy, twoDz, 'Color', 'red', 'LineWidth', 5);
end
hold off