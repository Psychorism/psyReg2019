%% Sum of Squares : No Intercept Model 
orange = [ 0.91 0.41 0.17];

X0 = repelem(1, 3)';
X1 = [-1,1,2]';
X2 = [2,-1,4]';
Y  = [-2,-1,3]';

%% No Intercept Model : X1 -> X2
figure; hold on; grid on;
xlim([-3, 7]); ylim([-3, 7]); zlim([-3, 7])
h1 = quiver3(0,0,0, Y(1), Y(2), Y(3), 'Color', orange, 'LineWidth', 3, 'AutoScale','off');
h2 = text(Y(1), Y(2), Y(3),"y:"+Label3DVector(Y));
h3 = quiver3(0,0,0, X0(1), X0(2), X0(3), 'Color', 'black', 'LineWidth', 3, 'AutoScale','off');
h4 = text(X0(1), X0(2), X0(3),Label3DVector(X0));
h5 = quiver3(0,0,0, X1(1), X1(2), X1(3), 'Color', 'black', 'LineWidth', 3, 'AutoScale','off');
h6 = text(X1(1), X1(2), X1(3),Label3DVector(X1));
[x, y] = meshgrid(-3:7,-3:7); z = 0*x;
h7 = mesh(x,y,z);

pause; % span mean vector
h8 = plot3([-3, 7], [-3, 7], [-3, 7], ':', 'LineWidth', 3);

pause; % span X1 space ... Smarter Ways?
h9 = plot3([1.5, -3], [-1.5, 3], [-3, 6], ':', 'LineWidth', 3);

pause; % plot yHat1
X = X1;
Yhat = X*inv(X'*X)*X'*Y;
quiver3(0,0,0, Yhat(1),Yhat(2),Yhat(3),'Color', 'red', 'LineWidth', 3, 'AutoScale','off');

YhatPast = Yhat;

pause; % add X2
h10 = quiver3(0,0,0, X2(1), X2(2), X2(3), 'Color', 'black', 'LineWidth', 3, 'AutoScale','off');
h11 = text(X2(1), X2(2), X2(3),Label3DVector(X2));

pause; % span X1,X2 space 
normals = cross(X1, X2);
[x, y] = meshgrid(-3:7,-3:7);
z = (-x * normals(1) -y * normals(2))/normals(3);
h12 = mesh(x,y,z);

pause; % plot yHat1,2
X = [X1, X2];
Yhat = X*inv(X'*X)*X'*Y;
quiver3(0,0,0, Yhat(1),Yhat(2),Yhat(3),'Color', 'green', 'LineWidth',3, 'AutoScale','off');

pause; % calculate SSR(2|1)
plot3([Yhat(1), YhatPast(1)], [Yhat(2), YhatPast(2)], [Yhat(3), YhatPast(3)], ...
    'Color', 'blue', 'LineWidth', 2);

pause; % turn off

for i = 1:12
    set(eval(sprintf('h%d', i)),'Visible','off')
end

hold off;