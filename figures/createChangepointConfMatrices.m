load("../../results/changepoint-results/finalImageResults.mat");
load("../../results/changepoint-results/finalRowResults.mat");
%%

% Font Settings
paperFontName = "Times New Roman";
paperFontSize = 11;

% Figure 1 : Image Results
fig1 = figure(1);
t1 = tiledlayout(fig1,2,3,"TileSpacing","compact","Padding","tight");
t1.Title.String = "Image Results"; t1.Title.FontName = paperFontName; t1.Title.FontSize;
t1.XLabel.String = "Predicted"; t1.XLabel.FontName = paperFontName; t1.XLabel.FontSize = paperFontSize;
t1.YLabel.String = "True"; t1.YLabel.FontName = paperFontName; t1.YLabel.FontSize = paperFontSize;

    % gfpop Rows
    p1 = nexttile;
    c1 = confusionchart(finalImageResults{1,1},{'No Bee' 'Bee'});
    c1.Title = finalImageResults{2,1};
    c1.YLabel = ""; c1.XLabel = "";
    c1.FontName = paperFontName; c1.FontSize = paperFontSize;

    % gfpop Columns
    p2 = nexttile;
    c2 = confusionchart(finalImageResults{1,2},{'No Bee' 'Bee'});
    c2.Title = finalImageResults{2,2};
    c2.YLabel = ""; c2.XLabel = "";
    c2.FontName = paperFontName; c2.FontSize = paperFontSize;

    % gfpop Both
    p3 = nexttile;
    c3 = confusionchart(finalImageResults{1,3},{'No Bee' 'Bee'});
    c3.Title = finalImageResults{2,3};
    c3.YLabel = ""; c3.XLabel = "";
    c3.FontName = paperFontName; c3.FontSize = paperFontSize;

    % Matlab Rows
    p4 = nexttile;
    c4 = confusionchart(finalImageResults{1,4},{'No Bee' 'Bee'});
    c4.Title = finalImageResults{2,4};
    c4.YLabel = ""; c4.XLabel = "";
    c4.FontName = paperFontName; c4.FontSize = paperFontSize;

    % Matlab Columns
    p5 = nexttile;
    c5 = confusionchart(finalImageResults{1,5},{'No Bee' 'Bee'});
    c5.Title = finalImageResults{2,5};
    c5.YLabel = ""; c5.XLabel = "";
    c5.FontName = paperFontName; c5.FontSize = paperFontSize;
    
    % Matlab Both
    p6 = nexttile;
    c6 = confusionchart(finalImageResults{1,6},{'No Bee' 'Bee'});
    c6.Title = finalImageResults{2,6};
    c6.YLabel = ""; c6.XLabel = "";
    c6.FontName = paperFontName; c6.FontSize = paperFontSize;

    exportgraphics(fig1,"changepointImageMatrices.pdf","ContentType","vector");

% Figure 2 : Row Results
fig2 = figure(2);
t2 = tiledlayout(fig2,2,3,"TileSpacing","compact","Padding","tight");
t2.Title.String = "Row Results";
t2.XLabel.String = "Predicted";
t2.YLabel.String = "True";

    % gfpop Rows
    p7 = nexttile;
    c7 = confusionchart(finalRowResults{1,1},{'No Bee' 'Bee'});
    c7.Title = finalRowResults{2,1};
    c7.YLabel = ""; c7.XLabel = "";
    c7.FontName = paperFontName; c7.FontSize = paperFontSize;
    
    % gfpop Columns
    p8 = nexttile;
    c8 = confusionchart(finalRowResults{1,2},{'No Bee' 'Bee'});
    c8.Title = finalRowResults{2,2};
    c8.YLabel = ""; c8.XLabel = "";
    c8.FontName = paperFontName; c8.FontSize = paperFontSize;
    
    % gfpop Both
    p9 = nexttile;
    c9 = confusionchart(finalRowResults{1,3},{'No Bee' 'Bee'});
    c9.Title = finalRowResults{2,3};
    c9.YLabel = ""; c9.XLabel = "";
    c9.FontName = paperFontName; c9.FontSize = paperFontSize;
    
    % Matlab Rows
    p10 = nexttile;
    c10 = confusionchart(finalRowResults{1,4},{'No Bee' 'Bee'});
    c10.Title = finalRowResults{2,4};
    c10.YLabel = ""; c10.XLabel = "";
    c10.FontName = paperFontName; c10.FontSize = paperFontSize;
    
    % Matlab Columns
    p11 = nexttile;
    c11 = confusionchart(finalRowResults{1,5},{'No Bee' 'Bee'});
    c11.Title = finalRowResults{2,5};
    c11.YLabel = ""; c11.XLabel = "";
    c11.FontName = paperFontName; c11.FontSize = paperFontSize;
    
    % Matlab Both
    p12 = nexttile;
    c12 = confusionchart(finalRowResults{1,6},{'No Bee' 'Bee'});
    c12.Title = finalRowResults{2,6};
    c12.YLabel = ""; c12.XLabel = "";
    c12.FontName = paperFontName; c12.FontSize = paperFontSize;

    exportgraphics(fig1,"changepointRowMatrices.pdf","ContentType","vector");


%%

% Figure 3 : Statistics Table
t3 = table('Size',[6,7],'VariableTypes',["string" "double" "double" "double" "double" "double" "double"]);
t3.Properties.VariableNames = ["Method","Image Recall","Image Precision","Image Accuracy" "Row Recall" "Row Precision" "Row Accuracy"];
t3.Method = ["gfpop Rows";"gfpop Columns";"gfpop Both";"Matlab Rows";"Matlab Columns";"Matlab Both"];
t3.("Image Recall") = [calcRecall(finalImageResults{1,1});calcRecall(finalImageResults{1,2});calcRecall(finalImageResults{1,3});
             calcRecall(finalImageResults{1,4});calcRecall(finalImageResults{1,5});calcRecall(finalImageResults{1,6})];
t3.("Image Precision") = [calcPrec(finalImageResults{1,1});calcPrec(finalImageResults{1,2});calcPrec(finalImageResults{1,3});
               calcPrec(finalImageResults{1,4});calcPrec(finalImageResults{1,5});calcPrec(finalImageResults{1,6})];
t3.("Image Accuracy") = [calcAcc(finalImageResults{1,1});calcAcc(finalImageResults{1,2});calcAcc(finalImageResults{1,3});
               calcAcc(finalImageResults{1,4});calcAcc(finalImageResults{1,5});calcAcc(finalImageResults{1,6})];
t3.("Row Recall") = [calcRecall(finalRowResults{1,1});calcRecall(finalRowResults{1,2});calcRecall(finalRowResults{1,3});
             calcRecall(finalRowResults{1,4});calcRecall(finalRowResults{1,5});calcRecall(finalRowResults{1,6})];
t3.("Row Precision") = [calcPrec(finalRowResults{1,1});calcPrec(finalRowResults{1,2});calcPrec(finalRowResults{1,3});
               calcPrec(finalRowResults{1,4});calcPrec(finalRowResults{1,5});calcPrec(finalRowResults{1,6})];
t3.("Row Accuracy") = [calcAcc(finalRowResults{1,1});calcAcc(finalRowResults{1,2});calcAcc(finalRowResults{1,3});
               calcAcc(finalRowResults{1,4});calcAcc(finalRowResults{1,5});calcAcc(finalRowResults{1,6})];

t3