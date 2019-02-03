%% Joint Confidence Region
set(0, 'DefaultFigureWindowStyle', 'normal');
Cement = readtable("../Dataset/MPV/cement.csv");

%%
CementLinear = fitlm(Cement, 'y ~ x1 + x3');
CementBeta = CementLinear.Coefficients.Estimate;

N = numel(Cement.x1); p = 2 + 1;
X = [repelem(1, N)', Cement.x1, Cement.x3];
XtX = X' * X;

Alpha  = 0.05;
Falpha = finv(1-Alpha, p, N-p);

[x, y, z] = meshgrid (-200:2:400, -2:0.04:10, -4:0.04:4) ;

v = XtX(1,1)*(CementBeta(1) - x).^2 + ...
    XtX(2,2)*(CementBeta(2) - y).^2 + ...
    XtX(3,3)*(CementBeta(3) - z).^2 + ...
    2*XtX(1,2)*(CementBeta(1) - x).*(CementBeta(2) - y) + ...
    2*XtX(1,3)*(CementBeta(1) - x).*(CementBeta(3) - z) + ...
    2*XtX(2,3)*(CementBeta(2) - y).*(CementBeta(3) - z);


figure;
xlabel('{\beta_0}'); ylabel('{\beta_1}'); zlabel('{\beta_2}');
h1 = patch( isosurface(x,y,z,v,p * Falpha * CementLinear.MSE) );
h1.EdgeColor = [0.5,0,0];
h1.FaceColor = [1,0,0];
h1.FaceAlpha = 0.7;
legend('Joint CI')

%%
[x, y, z] = meshgrid (-200:2:400, -2:0.04:10, -4:0.04:4);


CementLinear = fitlm(Cement, 'y ~ x1 + x3');
CementBetaSE = CementLinear.Coefficients.SE;

BonferroniDelta = tinv(1 - Alpha/(2*p), N-p);
ScheffeDelta    = sqrt(2 * finv(1 - Alpha, p, N-p));

xHitBonferroni = x(:) >= CementBeta(1) - BonferroniDelta * CementBetaSE(1) & ...
    x(:) <= CementBeta(1) + BonferroniDelta * CementBetaSE(1);
xHitScheffe    = x(:) >= CementBeta(1) - ScheffeDelta * CementBetaSE(1) & ...
    x(:) <= CementBeta(1) + ScheffeDelta * CementBetaSE(1);

yHitBonferroni = y(:) >= CementBeta(2) - BonferroniDelta * CementBetaSE(2) & ...
    y(:) <= CementBeta(2) + BonferroniDelta * CementBetaSE(2);
yHitScheffe    = y(:) >= CementBeta(2) - ScheffeDelta * CementBetaSE(2) & ...
    y(:) <= CementBeta(2) + ScheffeDelta * CementBetaSE(2);

zHitBonferroni = z(:) >= CementBeta(3) - BonferroniDelta * CementBetaSE(3) & ...
    z(:) <= CementBeta(3) + BonferroniDelta * CementBetaSE(3);
zHitScheffe    = z(:) >= CementBeta(3) - ScheffeDelta * CementBetaSE(3) & ...
    z(:) <= CementBeta(3) + ScheffeDelta * CementBetaSE(3);


BonferroniHits = xHitBonferroni & yHitBonferroni & zHitBonferroni;
BonferroniHits = reshape(BonferroniHits, size(x));

ScheffeHits = xHitScheffe & yHitScheffe & zHitScheffe;
ScheffeHits = reshape(ScheffeHits, size(x));

figure; hold on;
h1 = patch( isosurface(BonferroniHits, 0.5) );
h1.EdgeColor = 'none';
h1.FaceColor = [1,0,0];
h1.FaceAlpha = 0.2;

h2 = patch( isosurface(ScheffeHits, 0.5) );
h2.EdgeColor = 'none';
h2.FaceColor = [0,1,0];
h2.FaceAlpha = 0.2;

legend('Bonferroni', 'Scheffe');
hold off;


%% Minimum Volume Enclosing Ellipsoid
[ center, radii, evecs, v, chi2 ] = ellipsoid_fit([Cement.x1, Cement.x3, Cement.y], '0');

figure,
plot3( Cement.x1, Cement.x3, Cement.y, '.r' );
hold on;

%draw fit
mind = min( [ Cement.x1, Cement.x3, Cement.y ] );
maxd = max( [ Cement.x1, Cement.x3, Cement.y ] );
nsteps = 50;
step = ( maxd - mind ) / nsteps;
[ x, y, z ] = meshgrid( linspace( mind(1) - step(1), maxd(1) + step(1), nsteps ), linspace( mind(2) - step(2), maxd(2) + step(2), nsteps ), linspace( mind(3) - step(3), maxd(3) + step(3), nsteps ) );
Ellipsoid = v(1) *x.*x +   v(2) * y.*y + v(3) * z.*z + ...
          2*v(4) *x.*y + 2*v(5)*x.*z + 2*v(6) * y.*z + ...
          2*v(7) *x    + 2*v(8)*y    + 2*v(9) * z;
p = patch( isosurface( x, y, z, Ellipsoid, -v(10)*.8 ) );
hold off;
set( p, 'FaceColor', 'g', 'EdgeColor', 'none' );
axis vis3d equal;
camlight
lighting phong;