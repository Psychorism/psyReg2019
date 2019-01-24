%% Sum of Squares

%% Define Variables
X0 = repelem(1, 3)';
X1 = [1,-2,3]';
Y  = [-1,-2,5]';

%% SS : X0 -> X1
figure; hold on; grid on;
xlim([-3, 7]); ylim([-3, 7]); zlim([-3, 7])
h1 = quiver3(0,0,0, Y(1), Y(2), Y(3), 'Color', 'blue', 'LineWidth', 3, 'AutoScale','off');
h2 = text(-1,-2,5,'(-1,-2,5)');
h3 = quiver3(0,0,0, X0(1), X0(2), X0(3), 'Color', 'black', 'LineWidth', 3, 'AutoScale','off');
h4 = text(1,1,1,'(1,1,1)');
[x, y] = meshgrid(-3:7,-3:7); z = 0*x;
h5 = mesh(x,y,z);

pause; % span X space
h6 = plot3([-3, 7], [-3, 7], [-3, 7], ':', 'LineWidth', 3);

pause; % plot yHat
X = X0;
Yhat = X*inv(X'*X)*X'*Y;
h7 = quiver3(0,0,0, Yhat(1),Yhat(2),Yhat(3),'Color', 'green', 'LineWidth', 3, 'AutoScale','off');

pause; % calculate SSE(0)
plot3([Yhat(1), Y(1)], [Yhat(2), Y(2)], [Yhat(3), Y(3)], ...
    'Color', 'magenta', 'LineWidth', 2);
for i = [1,2,3] 
    YhatPast(i) = Yhat(i);
end


pause; % add X1
h8 = quiver3(0,0,0, X1(1), X1(2), X1(3), 'Color', 'black', 'LineWidth', 3, 'AutoScale','off');
h9 = text(1,-2,3,'(1,-2,3)');

pause; % add X2
normals = cross(X0, X1);
[x, y] = meshgrid(-3:7,-3:7);
z = (-x * normals(1) -y * normals(2))/normals(3);
h10 = mesh(x,y,z);

pause; % plot yHat
X = [X0, X1];
Yhat = X*inv(X'*X)*X'*Y;
h11 = quiver3(0,0,0, Yhat(1),Yhat(2),Yhat(3),'Color', 'green', 'LineWidth',3, 'AutoScale','off');

pause; % calculate SSE(0,1)
plot3([Yhat(1), Y(1)], [Yhat(2), Y(2)], [Yhat(3), Y(3)], ...
    'Color', 'magenta', 'LineWidth', 2);

pause; % triangle!
plot3([Yhat(1), YhatPast(1)], [Yhat(2), YhatPast(2)], [Yhat(3), YhatPast(3)], ...
    'Color', 'magenta', 'LineWidth', 2);

pause; % turn off

for i = 1:11
    set(eval(sprintf('h%d', i)),'Visible','off')
end

hold off;


%% SS : X1 -> X0
figure; hold on; grid on;
xlim([-3, 7]); ylim([-3, 7]); zlim([-3, 7])
h1 = quiver3(0,0,0, Y(1), Y(2), Y(3), 'Color', 'blue', 'LineWidth', 3, 'AutoScale','off');
h2 = text(-1,-2,5,'(-1,-2,5)');
h3 = quiver3(0,0,0, X1(1), X1(2), X1(3), 'Color', 'black', 'LineWidth', 3, 'AutoScale','off');
h4 = text(1,-2,3,'(1,-2,3)');
[x, y] = meshgrid(-3:7,-3:7); z = 0*x;
h5 = mesh(x,y,z);

pause; % span X space
h6 = plot3([-1, 2], [2, -4], [-3, 6], ':', 'LineWidth', 3);

pause; % plot yHat
X = X1;
Yhat = X*inv(X'*X)*X'*Y;
h7 = quiver3(0,0,0, Yhat(1),Yhat(2),Yhat(3),'Color', 'green', 'LineWidth', 3, 'AutoScale','off');

pause; % calculate SSE(0)
plot3([Yhat(1), Y(1)], [Yhat(2), Y(2)], [Yhat(3), Y(3)], ...
    'Color', 'magenta', 'LineWidth', 2);
for i = [1,2,3] 
    YhatPast(i) = Yhat(i);
end

pause; % add X1
h8 = quiver3(0,0,0, X0(1), X0(2), X0(3), 'Color', 'black', 'LineWidth', 3, 'AutoScale','off');
h9 = text(1,1,1,'(1,1,1)');

pause; % add X2
normals = cross(X0, X1);
[x, y] = meshgrid(-3:7,-3:7);
z = (-x * normals(1) -y * normals(2))/normals(3);
h10 = mesh(x,y,z);

pause; % plot yHat
X = [X0, X1];
Yhat = X*inv(X'*X)*X'*Y;
h11 = quiver3(0,0,0, Yhat(1),Yhat(2),Yhat(3),'Color', 'green', 'LineWidth',3, 'AutoScale','off');

pause; % calculate SSE(0,1)
plot3([Yhat(1), Y(1)], [Yhat(2), Y(2)], [Yhat(3), Y(3)], ...
    'Color', 'magenta', 'LineWidth', 2);

pause; % triangle!
plot3([Yhat(1), YhatPast(1)], [Yhat(2), YhatPast(2)], [Yhat(3), YhatPast(3)], ...
    'Color', 'magenta', 'LineWidth', 2);

pause; % turn off

for i = 1:11
    set(eval(sprintf('h%d', i)),'Visible','off')
end

hold off;