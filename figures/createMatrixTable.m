function tmp = createMatrixTable(matrices,titles)

    % Gathering size info
    numMatrices = numel(matrices);
%     if(mod(numMatrices,2) == 0)
%         numRows = 2;
%         numCols = numMatrices/2;
%     elseif(mod(numMatrices,3) == 0)
%         numRows = 3;
%         numCols = 3;
%     else
%         numRows = 1;
%         numCols = numMatrices;
%     end

    % Creating figure and tiled layout
    fig = figure(1);
    t = tiledlayout(fig,"flow","TileSpacing","compact","Padding","tight");
    ylabel(t,"True Class");
    xlabel(t,"Predicted Class");
    for index = 1:numMatrices
        curMatrix = matrices{index};
        curTitle = titles{index};
        nexttile;
        c = confusionchart(curMatrix,["bee" "no bee"]); title(curTitle);
        c.YLabel = "";
        c.XLabel = "";
        c.FontName = "Times New Roman"; c.FontSize = 11;
    end

    tmp = 1;

end