%% Load data
Titanic = readtable('../Dataset/Titanic/train.csv','Format','%f%f%f%q%C%f%f%f%q%f%q%C');

varfun(@class, Titanic)
Names = Titanic.Properties.VariableNames;


%% Split data
rng(1234)
numRow  = size(Titanic); numRow  = numRow(1);
trainIndx  = datasample (1:1:numRow , round(numRow*.7,0), 'Replace', false);

TitanicTrain = Titanic(trainIndx, :);
TitanicTest  = Titanic(setdiff(1:1:numRow, trainIndx),:);


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

%%% PassengerId
TitanicTrain(:, 'PassengerId') = [];
TitanicTest(:, 'PassengerId') = [];

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


%% SVM vs. Boosted Trees
gaussianSVMpredict = gaussianSVMtrained.predictFcn(TitanicTest);
[Xsvm, Ysvm, ~, AUCsvm] = perfcurve(TitanicTest.Survived, gaussianSVMpredict, 1); 

RFpredict = boostedTreesTrained.predictFcn(TitanicTest);
[XRF, YRF, ~, AUCRF] = perfcurve(TitanicTest.Survived, RFpredict, 1); 


figure; hold on;
curves(1) = plot(Xsvm, Ysvm);
labels{1} = sprintf('AUC of gaussian SVM : %.1f%%', AUCsvm*100);
curves(2) = plot(XRF, YRF);
labels{2} = sprintf('AUC of boosted trees : %.1f%%', AUCRF*100);
curves(3) = refline(1,0); 
labels{3} = 'Reference Line'; hold off;

set(curves(1),'Color','r');
set(curves(2),'Color','b');
set(curves(3),'Color','g');
xlabel('FPR');
ylabel('TPR');
title('ROC Plot');
legend(curves, labels, 'Location', 'SouthEast');



%% 
categoricalPredictors = {'Pclass', 'Sex', 'Embarked'};

RF = TreeBagger(200, TitanicTrain(:, 2:8), TitanicTrain.Survived,...
    'PredictorNames', TitanicTrain.Properties.VariableNames(2:8), ...
    'Method','classification','CategoricalPredictors', categoricalPredictors, 'oobvarimp', 'on');

vars = TitanicTrain.Properties.VariableNames(2:8);
[~,order] = sort(RF.OOBPermutedVarDeltaError);  % sort the metrics
figure
barh(RF.OOBPermutedVarDeltaError(order))        % horizontal bar chart
title('Feature Importance Metric')
ax = gca; ax.YTickLabel = vars(order);          % variable names as labels



%% Submission : Preprocessing
TestData = readtable("../Dataset/Titanic/test.csv");

TestData.Sex = grp2idx(string(TestData.Sex));
TestData.Embarked = grp2idx(string(TestData.Embarked));

TestData.Age = fillmissing(TestData.Age, 'spline');
TestData.Fare = fillmissing(TestData.Fare, 'spline');


%% Submission 
gaussianSVMsol = gaussianSVMtrained.predictFcn(TestData);
RFpredictsol = boostedTreesTrained.predictFcn(TestData);

submissionSVM = table(TestData.PassengerId, 1*~gaussianSVMsol, ...,
    'VariableNames', {'PassengerId', 'Survived'});
submissionRF = table(TestData.PassengerId, 1*~RFpredictsol, ...,
    'VariableNames', {'PassengerId', 'Survived'});

writetable(submissionSVM, 'submissionSVM.csv')
writetable(submissionRF, 'submissionRF.csv')
