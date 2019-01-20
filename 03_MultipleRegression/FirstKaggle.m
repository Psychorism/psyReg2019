%% Load data
Titanic = readtable('../Dataset/Titanic/train.csv','Format','%f%f%f%q%C%f%f%f%q%f%q%C');

varfun(@class, TitanicTrain)
Names = Titanic.Properties.VariableNames;


%% Visualization

SexSurv = varfun(@(x) mean(x,'omitnan'), Titanic, ...
    'GroupingVariables', {'Sex'}, 'InputVariables', {'Survived'});
PclassSurv = varfun(@(x) mean(x,'omitnan'), Titanic, ...
    'GroupingVariables', {'Pclass'}, 'InputVariables', {'Survived'});

figure;
subplot(2,1,1);
bar(SexSurv.Sex, SexSurv.Fun_Survived);

subplot(2,1,2);
bar(PclassSurv.Pclass, PclassSurv.Fun_Survived);


%% Split data
rng(1234)
numRow  = size(Titanic); numRow  = numRow(1);
trainIndx  = datasample (1:1:numRow , round(numRow*.7,0), 'Replace', false);

TitanicTrain = Titanic(trainIndx, :);
TitanicTest  = Titanic(setdiff(1:1:numRow, trainIndx),:);


%% Missing values
TitanicTrain.Fare(TitanicTrain.Fare == 0) = NaN;
TitanicTest.Fare(TitanicTest.Fare == 0) = NaN;

figure;
imagesc(ismissing(TitanicTrain));
ax = gca;
ax.XTick = 1:12;
ax.XTickLabel = Names;
ax.XTickLabelRotation = 90;


%% Dropping Unused Variables
%%% Cabin
TitanicTrain(:, 'Cabin') = [];
TitanicTest(:, 'Cabin') = [];

%%% Name
TitanicTrain(:, 'Name') = [];
TitanicTest(:, 'Name') = [];

%%% Ticket
TitanicTrain(:, 'Ticket') = [];
TitanicTest(:, 'Ticket') = [];



%% Interpolation

%%% Age
TitanicTrain.Age = fillmissing(TitanicTrain.Age, 'spline');
TitanicTest.Age  = fillmissing(TitanicTest.Age, 'spline');

%%% Fare
FareTable = grpstats(TitanicTrain(:,{'Pclass','Fare'}),'Pclass');
for i = 1:height(FareTable)
    TitanicTrain.Fare(TitanicTrain.Pclass == i & isnan(TitanicTrain.Fare)) = FareTable.mean_Fare(i);
    TitanicTest.Fare(TitanicTest.Pclass == i & isnan(TitanicTest.Fare)) = FareTable.mean_Fare(i);
end


%%% Embarked
FreqEmbarked = mode(TitanicTrain.Embarked);

TitanicTrain.Embarked(isundefined(TitanicTrain.Embarked)) = FreqEmbarked;
TitanicTest.Embarked(isundefined(TitanicTest.Embarked)) = FreqEmbarked;


%% Digitalization

TitanicTrain.Embarked = double(TitanicTrain.Embarked);
TitanicTest.Embarked = double(TitanicTest.Embarked);

TitanicTrain.Sex = double(TitanicTrain.Sex);
TitanicTest.Sex  = double(TitanicTest.Sex);

figure;
imagesc(table2array (varfun(@(x) ((x - mean(x))/std(x) ), TitanicTrain)));


%% Model Building & Evaluation
LogisticNull = fitglm(TitanicTrain(:, [4, 2]), 'Distribution', 'binomial');
LogisticFull = fitglm(TitanicTrain(:, [1, 3:1:9, 2]), 'Distribution', 'binomial'); 

NullPredict = predict(LogisticNull, TitanicTest(:, [1, 3:1:9]));
FullPredict = predict(LogisticFull, TitanicTest(:, [1, 3:1:9]));

[Xnull, Ynull, ~, AUCnull] = perfcurve(TitanicTest.Survived, NullPredict, 1); 
[Xfull, Yfull, ~, AUCfull] = perfcurve(TitanicTest.Survived, FullPredict, 1); 

figure; hold on;
curves(1) = plot(Xnull, Ynull);
labels{1} = sprintf('AUC of Logistic Null Model : %.1f%%', AUCnull*100);
curves(2) = plot(Xfull, Yfull);
labels{2} = sprintf('AUC of Logistic Full Model : %.1f%%', AUCfull*100);
curves(3) = refline(1,0); 
labels{3} = 'Reference Line'; hold off;

set(curves(1),'Color','r');
set(curves(2),'Color','b');
set(curves(3),'Color','g');
xlabel('FPR');
ylabel('TPR');
title('ROC Plot');
legend(curves, labels, 'Location', 'SouthEast');


%% Submission
TestData = readtable("test.csv");

TestData.Sex = grp2idx(string(TestData.Sex));
TestData.Embarked = grp2idx(string(TestData.Embarked));

figure;
imagesc( isnan( table2array( TestData(:,LogisticFull.PredictorNames)  ))) ;

TestData.Age = fillmissing(TestData.Age, 'spline');
TestData.Fare = fillmissing(TestData.Fare, 'spline');

submissionNull = table(TestData.PassengerId, 1*~SurvivedNull, ...,
    'VariableNames', {'PassengerId', 'Survived'});
submissionFull = table(TestData.PassengerId, 1*~SurvivedFull, ...,
    'VariableNames', {'PassengerId', 'Survived'});

writetable(submissionNull, 'submissionNull.csv')
writetable(submissionFull, 'submissionFull.csv')

