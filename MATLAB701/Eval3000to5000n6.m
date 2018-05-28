% Eval3000to5000n6
function Eval=Eval3000to5000n6(M,N)
for n=1:202
    for f=1:28
        if M(f,n)<0.01
            if N(f,n)>0
                Eval(f,n)=1
            else 
                Eval(f,n)=0
            end
        else
            Eval(f,n)=0
        end
    end
end
Eval((1:28),203)=M((1:28),203)
assignin('base','Eval',Eval);    
end



