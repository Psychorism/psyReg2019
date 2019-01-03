%% 
Titanic = readtable('../Dataset/Titanic/train.csv','Format','%f%f%f%q%C%f%f%f%q%f%q%C');

Titanic.Name
Titanic.Sex
Titanic.Survived

sum(ismissing(Titanic.Name))
size(Titanic.Name)

%% 
FirstName = string([]);

for i = 1:1:891
    res = regexp(Titanic.Name{i}, '(Mr\. |Miss\. |Master. |Mrs\.[A-Za-z ]*\()([A-Za-z]*)', 'once', 'match');
    res = strsplit(res);
    if all(size(res) == [1,1]) || res{1,2} ==""
       continue 
    end
    res = res{1,2};
    if res(1) == "(" || res(1) == ")"
        res = extractAfter(res, 1);
    end
    FirstName(i) = res; 
end


ranks = tabulate(FirstName);
ranks = sortrows(ranks,2);
ranks = cell2table(ranks);

%%
Titanic_more = horzcat(Titanic, table(FirstName', 'VariableNames', {'ShortName'}));
LuckyTitanic = Titanic_more(ismember(FirstName, ranks.ranks1(ranks.ranks2 >= 8)), :);
LuckyTitanic_names = table(LuckyTitanic.ShortName, LuckyTitanic.Survived, ...
    'VariableNames', {'ShortName', 'Survived'});

ResRes = varfun(@mean, LuckyTitanic_names, 'GroupingVariables', 'ShortName');
ResRes = sortrows(ResRes,'mean_Survived', 'descend');


%%
h = figure;
subplot(1,1,1);

bar([ResRes.mean_Survived]);
XTickLabel=ResRes.ShortName;
XTick=1:1:length(ResRes.ShortName);
set(gca, 'XTick',XTick);
set(gca, 'XTickLabel', XTickLabel);
set(gca, 'XTickLabelRotation', 45);

saveas(h,'LuckyNames','jpg');
