% M Chs Distribution
function Distribution(M)
for n=1:202
    if M(5,n)>0
        if M(2,n)>0
            text(M(3,n),M(4,n),[num2str(M(5,n))],'Color','r'),axis([-70 70 -70 70]),hold on
        else
            text(M(3,n),M(4,n),[num2str(M(5,n))],'Color','k'),axis([-70 70 -70 70]),hold on
        end
    else
        plot(M(3,n),M(4,n),'.k'),axis([-70 70 -70 70]),hold on
    end
end
plot(-39.322, 36.037,'.k',-25.08,-53.609,'.k'),hold on
end