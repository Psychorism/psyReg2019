%% Load data
Titanic = readtable('../Dataset/Titanic/train.csv','Format','%f%f%f%q%C%f%f%f%q%f%q%C');
Names = Titanic.Properties.VariableNames;

Sex = Titanic.Sex(~isnan(Titanic.Age));
Sex = grp2idx(Sex) - 1;

Age  = Titanic.Age(~isnan(Titanic.Age));
Fare = Titanic.Fare(~isnan(Titanic.Age));
Survival = Titanic.Survived(~isnan(Titanic.Age));

ModelPred = csvread("ModelPrediction.csv");

x = linspace(0, 80, 200);
y = linspace(0, 512, 200);
[xx, yy] = meshgrid(x, y);

AgeFare = table2array(table(Age, Fare, 'VariableNames', {'Age','Fare'}));

model = polyfitn(AgeFare, Survival, 2);
zz = polyvaln(model, [xx(:) yy(:)]);
zz = reshape(zz, size(xx));
zz = zz * 100;
Pred = (1-ModelPred)*100;

figure('Renderer','opengl')
line(AgeFare(:,1), AgeFare(:,2), Survival*100, 'LineStyle','none', ...
    'Marker','.', 'MarkerSize',10, 'Color','r')
surface(xx, yy, zz, ...
    'FaceColor','interp', 'EdgeColor','b', 'FaceAlpha',0.2)
grid on; axis tight equal;
xlabel x; ylabel y; zlabel z;
colormap(cool(64))

