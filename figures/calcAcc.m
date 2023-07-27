function accuracy = calcAcc(confMatrix)
    accuracy = (confMatrix(1,1)+confMatrix(2,2))/sum(confMatrix,"all");
end