function y = Label3DVector(numericVector)
    stringVector = string(numericVector);
    resultString = "(";
    
    for i=1:2
        resultString = resultString + stringVector(i) + ",";
    end 
    
    resultString = resultString + stringVector(3) + ")";    
    y = resultString;
end