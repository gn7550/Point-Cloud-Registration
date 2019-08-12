function transmat= pa3seekF(samplereading, bodytextAorB, AorB)
trackerdata = dlmread(samplereading,',',1,0)';
a=zeros(3,6,15);

for i=1:15
    if AorB=='A'
a(:,:,i)= trackerdata(:, 1+(i-1)*16 : 6+(i-1)*16) ; %3x6x15. 
    elseif AorB=='B'
a(:,:,i)= trackerdata(:, 7+(i-1)*16 : 12+(i-1)*16) ;
    end
a_m(:,:,i) = 1/6 * sum(a(:,:,i),2); %3x1x15
a_w(:,:,i) = a(:,:,i) - a_m(:,:,i);  % 3x6x15
end

bodydatademo = importdata(bodytextAorB,' ',1);  % 
bodydata = bodydatademo.data' ;
A=bodydata(:, 1:6); % 3x6. LEDs on body A or B wrt its body
tip= bodydata(:, 7); % 3x1. tip of body A or B wrt its body
A_m= 1/6*sum(A,2); %3x1
A_w= A - A_m;  % 3x6

% a=FA

H_a=zeros(3,3,15);
sum_H_a=zeros(3,3,15);
for i=1:15 %to get R_a
    for j=1:6
       
            H_a(:,:,i) = [A_w(1,j)*a_w(1,j,i) A_w(1,j)*a_w(2,j,i) A_w(1,j)*a_w(3,j,i); %3x3x15
                          A_w(2,j)*a_w(1,j,i) A_w(2,j)*a_w(2,j,i) A_w(2,j)*a_w(3,j,i);
                          A_w(3,j)*a_w(1,j,i) A_w(3,j)*a_w(2,j,i) A_w(3,j)*a_w(3,j,i)];
                      
            sum_H_a(:,:,i) = sum_H_a(:,:,i)+H_a(:,:,i) ;  %3x3x15
    end
end

for i=1:15
sum_H_atrans(:,:,i) = sum_H_a(:,:,i)';
end

for i=1:15
traceH_a(:,:,i)= sum_H_a(1,1,i) + sum_H_a(2,2,i) + sum_H_a(3,3,i);  %1X1X15
delta_a(:,:,i) = [ sum_H_a(2,3,i) - sum_H_a(3,2,i) ; sum_H_a(3,1,i) - sum_H_a(1,3,i) ; sum_H_a(1,2,i) - sum_H_a(2,1,i) ]; %3X1X15
delta_a_trans(:,:,i) = delta_a(:,:,i)';
intermediate = sum_H_a(:,:,i)+sum_H_atrans(:,:,i)-(traceH_a(:,:,i)*eye(3));
G_a(:,:,i) = [ traceH_a(:,:,i) delta_a_trans(:,:,i); delta_a(:,:,i) intermediate]; %4X4X15
end

for i=1:15
[Q_a(:,:,i), L_a(:,:,i)] = eig(G_a(:,:,i));  %4X4X15 and 4X4X15
[eigena(:,:,i), eigenb(:,:,i)]= sort(diag(real(L_a(:,:,i))));
temp_value(:,:,i) = eigenb(4,:,i);

q(:,:,i) = Q_a(:,temp_value(:,:,i),i);

R_a(:,:,i) = quat2rotm(q(:,:,i)');
t_a(:,:,i) = a_m(:,:,i) - R_a(:,:,i) * A_m;  % determine 8 t_a's
F_a(:,:,i) = [ R_a(:,:,i) t_a(:,:,i) ; 0 0 0 1];
end


transmat= F_a;

end

