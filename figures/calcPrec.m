function precision = calcPrec(confMatrix)
    precision = confMatrix(2,2)/(confMatrix(1,2)+confMatrix(2,2));
end