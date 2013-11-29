function [T,time] = Askhsh_2(A,b,p)
%
% Epilyei provlhma elaxistopoihshs grammikou programmatismou, me thn
%me8odo Simplex.
% Xrhsimopoioume tis me8odous tobl kai ljx tou bibliou, Linear
%Programming with MATLAB.
% Epistrefei akomh kai ton xrono ekteleshs.
%Syntax: [T,time] = Askhsh_2(A,b,p)
%

T = totbl(A,b,p);

flag = 0;
[m,n] = size(T.val);

tic;
while flag == 0
    [Elem_1,Col] = min(T.val(m,1:n-1));
    
    if Elem_1 >= 0
        flag = 1;
    else
        check_vec = (-T.val(1:m-1,n))./(T.val(1:m-1,Col));
        check_flag = 0;
        while check_flag == 0
            [Elem_2,Row] = min(check_vec);
            if Elem_2 <= 0
                check_vec(Row) = 1000;
            else
                T = ljx(T,Row,Col);
                check_flag = 1;
            end
        end
    end
end
time = toc;
fprintf('\n\n\nH aristh lush (X*) einai: \n');
for i = 1:m-1 
    str_cat = strcat('x',num2str(i));
    ind = find(ismember(T.bas,str_cat));
    if size(ind) ~= 0
        fprintf('%s = %f \n',str_cat,T.val(ind,n));   
    else
        fprintf('%s = 0 \n', str_cat);  
    end
end
fprintf('\nTo min(ÐÃÐ)= %f\n\n\n',T.val(m,n));
end

