function triangleset= pa3closeset(meshfile)
tridata= dlmread(meshfile,' ',0,0)';

vertices=tridata(1:3, 2:1569) ; %1568 vertices. 
indices= tridata(1:3, 1571:4705); % 3135 index sets of triangle. 

for i=1:3135
    indexp= indices(1,:)+1;
    indexq= indices(2,:)+1;
    indexr= indices(3,:)+1;
    p(:,i)=  vertices( :, indexp(i)) ; %one corner of triangle 
    q(:,i)=  vertices( :, indexq(i)) ; %one corner of triangle
    r(:,i)=  vertices( :, indexr(i)) ; %one corner of triangle
end
    triangleset=[ p ; q ; r] ;  % triangle consisting of three vertices p q r. %no error up to here in this m-file.
    
end
    