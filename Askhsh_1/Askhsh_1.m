function T = Askhsh_1 (A, b)
%
%
%

T = totbl(A, b);

[m,n] = size(A);
previous_Is = zeros(m);
previous_Js = zeros(n);
    for i = 1:m-1
        for j = 1:n
            if T.val(i,j) ~= 0 && previous_Js(j) ~= 1
                previous_Is(i) = 1;
                previous_Js(j) = 1;
                T = ljx(T, i, j);
                break
            end
        end
    end
    
    count_zeros = 0;
    for i = 1:m
        if previous_Is(i) == 0
            for j = 1:n
                if previous_Js(j) == 0
                    if T.val(i,j) == 0 
                        count_zeros = count_zeros + 1; 
                    end
                end
            end
        end
    end
end