function recall = calcRecall(confMatrix)
    recall = confMatrix(2,2)/(confMatrix(2,1)+confMatrix(2,2)); 
end