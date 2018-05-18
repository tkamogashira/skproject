% SDF
function SDF(V,Gt,G)
T=(1:1:200);
for n=1:length(V)
    for x=1:200
        if (x<(V(n)+min(Gt)))|(x>(V(n)+max(Gt)))
            Q(n,x)=0;
        else
            Q(n,x)=G(1,(x-V(n)+51));
        end;
    end;
end;
sdf=mean(Q,1);
plot(T,sdf)
end

    
    
    

