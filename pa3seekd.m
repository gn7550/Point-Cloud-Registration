function ansd=pa3seekd(samplereading)

F_A=pa3seekF(samplereading,'Problem3-BodyA.txt','A');
F_B=pa3seekF(samplereading,'Problem3-BodyB.txt','B');
bodydatademo = importdata('Problem3-BodyA.txt',' ',1);  % 
bodydata = bodydatademo.data' ; % 

A_tip= bodydata(:, 7); % 3x1. tip of body A or B wrt its body

for i=1:15
    d(:,i)= F_B(:,:,i) \ F_A(:,:,i) * [A_tip ; 1] ; %4x1x15
end

ansd=d(1:3, :);%3x15
end
