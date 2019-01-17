%%
Titanic = readtable('../Dataset/Titanic/train.csv','Format','%f%f%f%q%C%f%f%f%q%f%q%C');


%% Equivalent tests : Fare and Sex
Dummies = dummyvar(Titanic.Sex);
Titanic.Sex = Dummies(:,2);

% linear regression
mdl = fitlm(Titanic, 'Fare ~ Sex');
Coeffs = mdl.Coefficients.Estimate;
Pvalue = mdl.Coefficients.pValue(2);
Pvalue;


figure;
scatter(Titanic.Sex, Titanic.Fare, 'jitter','on', 'jitterAmount', 0.05);
hold on
hline = refline(Coeffs(2), Coeffs(1));
hline.Color = 'red';
hline.LineWidth = 3;
xlabel('Sex')
ylabel('Fare')
title('Linear Regression of Fare by Sex')


% Reversed linear regression
mdl = fitlm(Titanic,'Sex ~ Fare');
Coeffs = mdl.Coefficients.Estimate;
Pvalue = mdl.Coefficients.pValue(2);
Pvalue;


figure;
scatter(Titanic.Fare, Titanic.Sex, 'jitter','on', 'jitterAmount', 0.05);
hold on
hline = refline(Coeffs(2), Coeffs(1));
hline.Color = 'red';
hline.LineWidth = 3;
xlabel('Sex')
ylabel('Fare')
title('Linear Regression of Sex by Fare')


% t test
[H,P] = ttest2(Titanic.Fare(Titanic.Sex==0), Titanic.Fare(Titanic.Sex==1));
P;

figure;
boxplot(Titanic.Fare', Titanic.Sex')

% anova
P = anova1(Titanic.Fare, Titanic.Sex, 'off');

figure;
boxplot(Titanic.Fare, Titanic.Sex)


% correlation coeffcieints
[R,P] = corrcoef(Titanic.Sex, Titanic.Fare);
P(1,2);
