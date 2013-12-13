function [T,time] = Seira_2_Askhseis_1_2(A,b,p,dual_flag)
%
%   Epilyei problhma megistopoihshs grammikou programmatismou,
%hte duiko problhma elaxistopoihshs/megistopoihshs (dinontas to katallhlo
%flag), me thn me8odo Simplex.
%   Xrhsimopoioume tis me8odous totbl,dualbl,ljx,addcol,addrow,delcol,delrow 
%tou bibliou, Linear Programming with MATLAB.
%   Epistrefei akomh kai ton xrono ekteleshs.
%
%Syntax_1: [T,time] = Seira_2_Askhseis_1_2(A,b,p) 
%          Problhma megistopoihshs.
%Syntax_2: [T,time] = Seira_2_Askhseis_1_2(A,b,p,dual_flag)
%          Dyiko problhma elaxistopoihshs/megistopoihshs
%
%Precondition:
%
%-Syntax_1:
%   O xrhsths ofeilei na dwsei ton pinaka A ,to dianysma b kai to dianysma p
%   se swsth morfh gia PGP megistopoihshs.
%
%-Syntax_2:
%   Opws sto Syntax_1, alla o xrhsths prepei na parexei plhroforia se morfh
%   string opou:
%        -'min': Dyiko problhma elaxistopoihshs.
%        -Opoiodhpote allo string: Dyiko problhma megistopoihshs.
%
T = totbl(A,b,p);
if nargin == 4
   fprintf('\nMaking the dual tableux representation of the problem.\n');
   T = dualbl(T);
end

[m,n] = size(T.val);%initial size

tic;
tmp_vec = find(b<0);

tmp_col = zeros(1,m);
tmp_row = zeros(1,n+1);

%Phase I of simplex method (if needed)

if size(tmp_vec) ~= 0
    fprintf('\nSimplex Phase I\n');
    for i = 1:size(tmp_vec)+1
        tmp_col(tmp_vec(i)+1) = 1;
    end
    tmp_row(n) = 1;

    fprintf('\nAdding x0 column and z0 row\n');
    T = addcol(T,tmp_col','x0',n);
    if nargin == 4
       T = dualbl(T); 
    end
    T = addrow(T,tmp_row,'z0',m+1);
    fprintf('\nAdded Succesfully\n');
    
    fprintf('\n1st step (without considering -(bi)/(Aij)>=0)\n');
    T = ljx(T,find(min(b))+1,n);
    [m,n] = size(T.val); %size after col and row adds
    
    flag = 0;
    step_count = 1;
    while flag == 0
        if size(find(ismember(T.nonbas,'x0'))) ~= 0
            tmp = T.val(m,1:n-1);
            Zo_ind = find(tmp == 1);
            if size(Zo_ind) == 1
                Xo_ind = find(ismember(T.nonbas,'x0'));
                if size(Xo_ind) == 1 
                    if Zo_ind == Xo_ind
                        flag = 1;
                        fprintf('\nEnd of Phase I, deleting z0 row and x0 column\n');
                        T = delrow(T,'z0');
                        T = delcol(T,'x0');
                        fprintf('\nDeleted Succesfully\n\nStart of Phase II\n');
                    end
                end
            end
        else
            Elem_col = min(T.val(m,1:n-1));
            s_col = find(T.val(m,1:n-1) == Elem_col);
            Theta = (-T.val(1:m-2,n))./(T.val(1:m-2,s_col));
            check_flag = 0;
            while check_flag == 0
                [Elem_row,s_row] = min(Theta);
                if Elem_row < 0
                    Theta(s_row) = 1000;
                else
                    step_count = step_count + 1;
                    fprintf('\nStep %d (considering -(bi)/(Aij)>=0)\n',step_count);
                    T = ljx(T,s_row,s_col);
                    check_flag = 1;
                end
            end
        end  
    end
end

%Phase II Simplex method
%The T.val size here is equal to the initial size
[m,n] = size(T.val);
flag = 0;
step_count = 1;
while flag == 0
    [Z_Elem,Col] = min(T.val(m,1:n-1));
    if Z_Elem >= 0
       flag = 1; 
    else
        tmp_col_vec = find(T.val(1:m-1,Col) < 0);
        Theta = (-T.val(1:m-1,n))./(T.val(1:m-1,Col));
        tmp_Theta = [];
        for i = 1:size(tmp_col_vec)
           tmp_Theta = [tmp_Theta Theta(tmp_col_vec(i))];
        end 
        fprintf('\nStep %d\n',step_count);
        Row = find(Theta == min(tmp_Theta));
        T = ljx(T,Row,Col);
        step_count = step_count + 1;
    end
end
time = toc;
fprintf('\n\n\nThe excellent solution (X*) is: \n');
for i = 1:n-1 
    str_cat = strcat('x',num2str(i));
    ind = find(ismember(T.bas,str_cat));
    if size(ind) ~= 0
        fprintf('%s = %f \n',str_cat,T.val(ind,n));   
    else
        fprintf('%s = 0 \n', str_cat);  
    end
end
if nargin == 4 && strcmpi(dual_flag,'min') == 1
    fprintf('\nThe min(PLP) = %f\n\n\n',T.val(m,n));
else
    fprintf('\nThe max(PLP) = %f\n\n\n',-T.val(m,n));
end
end