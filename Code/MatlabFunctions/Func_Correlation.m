function correlation = Func_Correlation(A , B)
%FUNC_CORRELATION Summary of this function goes here
%   Detailed explanation goes here
    s = size(A);
    correlation =  sum(A .* B , [1, 2]) / (s(1) * s(2));
end

