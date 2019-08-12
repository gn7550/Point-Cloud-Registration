function pointpair=pa3pairing(samplereading)
tri= pa3closeset('Problem3MeshFile.sur');
p= tri(1:3,:);
q= tri(4:6,:);
r= tri(7:9,:);

d= pa3seekd(samplereading);
%d - p = lamda*(q-p) + mu*(r-p) ;
%d - p =  [q-p r-p] [lamda ; mu ] ;
c=zeros(3,3135,15);
for i=1:15
    for j=1:3135
lamdaandmu(:,j,i)= [q(:,j)-p(:,j), r(:,j)-p(:,j)]\ [ d(:,i)-p(:,j)] ; %2x3135x15
     lamda(:,j,i)=lamdaandmu(1,j,i); %1x3135x15
     mu(:,j,i) = lamdaandmu(2,j,i); %1x3135x15
     c(:,j,i) = p(:,j) + lamda(1,j,i)*( q(:,j)-p(:,j) ) + mu(1,j,i)*(r(:,j) - p(:,j)) ; %3x3135x15. closest point on triangle
    if lamda(1,j,i) >= 0 && mu(1,j,i) >=0 && lamda(1,j,i)+mu(1,j,i)<=1
       c(:,j,i)= c(:,j,i);
    elseif lamda(1,j,i)+ mu(1,j,i) > 1
       beta= (c(:,j,i) - q(:,j))'*(r(:,j) - q(:,j))/((r(:,j) - q(:,j))'*(r(:,j) - q(:,j)));
         if 0<= beta <=1
             betas= beta;
         elseif beta<1
             betas=0;
         elseif beta>1
             betas=1;
         end
       c(:,j,i) = q(:,j) + betas*(r(:,j) - q(:,j));
    elseif lamda(1,j,i)<0
         beta= (c(:,j,i) - r(:,j))'*(p(:,j) - r(:,j))/((p(:,j) - r(:,j))'*(p(:,j) - r(:,j)));
          if 0<= beta <=1
             betas= beta;
         elseif beta<0
             betas=0;
         elseif beta>1
             betas=1;
         end
       c(:,j,i) = r(:,j) + betas*(p(:,j) - r(:,j));
     elseif mu(1,j,i)<0
         beta= (c(:,j,i) - p(:,j))'* (q(:,j) - p(:,j))/((q(:,j) - p(:,j))'*(q(:,j) - p(:,j)));
          if 0<= beta <=1
             betas= beta;
         elseif beta<0
             betas=0;
         elseif beta>1
             betas=1;
         end
         c(:,j,i) = p(:,j) + betas*(q(:,j) - p(:,j));
     end
    end
end
   distance=zeros(15,3135);
   
    for i=1:15
        for j=1:3135
    distance(i,j)= norm( d(:,i)-c(:,j,i) ); %15x3135. 
        end
    end
  
    for i=1:15
        val(i,:)=min(distance(i,:));
        col(i,:)=find(val(i,:)==distance(i,:));
    end
    
    
    for i=1:15
    final_c(:,i)= c(:,col(i),i);
    end
    
    
    for i=1:15
        bcdistance(:,i)=norm(d(:,i)-final_c(:,i));
    end
    dandc=[d' final_c' bcdistance'];
    disp(dandc);
    
    pointpair=final_c;
end


