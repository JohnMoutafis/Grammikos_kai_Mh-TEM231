function T = Askhsh_2(A,b,p)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
T = totbl(A,b,p);

flag = 0;
[m,n] = size(T.val);

while flag == 0
    [Elem_1,Col] = min(T.val(m,1:n-1));
    
    if Elem_1 >= 0
        flag = 1;
    else
        tmp_vec = T.val(1:m-1,n);
        for i = 1:m
            [Elem_2, Row] = min(tmp_vec);
            if Elem_2 < 0
            tmp_vec(Row) = 1000;
            else
                break
            end     
        end
        T = ljx(T,Row,Col);
    end
end
fprintf('\n\n\nH aristh lush einai : \n\n\n');
for i = 1:m-1 
    if strcmp(T.bas(i),'x1')==1
        fprintf('x1= %f \n', T.val(i,n)); 
    elseif strcmp(T.bas(i),'x2')==1
       fprintf('x2= %f \n', T.val(i,n)); 
    elseif strcmp(T.bas(i),'x3')==1
       fprintf('x3= %f \n', T.val(i,n)); 
    else
        fprintf('x%d =0 \n', i);  
    end
end
fprintf('\n\n To min(ÐÃÐ)= %f\n\n\n',T.val(m,n));
end

