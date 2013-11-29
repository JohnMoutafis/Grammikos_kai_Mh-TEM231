function [T,time] = Askhsh_1 (A, b)
%
% Epilyei to systhma y = Ax - b me thn me8odo Jordan pivot.
% Xrhsimopoioume tis me8odous tobl kai ljx tou bibliou, Linear
%Programming with MATLAB.
% Epistrefei akomh kai ton xrono ekteleshs.
%Syntax: [T,time] = Askhsh_1(A,b).
%

T = totbl(A, b);

[m,n] = size(A);
previous_Js = zeros(n);
tic;
    for i = 1:m-1
        for j = 1:n
            if T.val(i,j) ~= 0 && previous_Js(j) ~= 1
                previous_Js(j) = 1;
                T = ljx(T, i, j);
                break
            end
        end
    end
time = toc;
end