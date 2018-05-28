% M Chs Distribution2
function Distribution2(M)
for n=1:202
    if M(5,n)==1
        if M(2,n)>0
            plot(M(3,n),M(4,n),'o','MarkerSize',4,'Color','r'),axis([-70 70 -70 70]),hold on
        else
            plot(M(3,n),M(4,n),'o','MarkerSize',4,'Color','k'),axis([-70 70 -70 70]),hold on
        end
    elseif M(5,n)==2
        if M(2,n)>0
            plot(M(3,n),M(4,n),'o','MarkerSize',7,'Color','r'),axis([-70 70 -70 70]),hold on
        else
            plot(M(3,n),M(4,n),'o','MarkerSize',7,'Color','k'),axis([-70 70 -70 70]),hold on
        end
    elseif M(5,n)==3
        if M(2,n)>0
            plot(M(3,n),M(4,n),'o','MarkerSize',10,'Color','r'),axis([-70 70 -70 70]),hold on
        else
            plot(M(3,n),M(4,n),'o','MarkerSize',10,'Color','k'),axis([-70 70 -70 70]),hold on
        end
    elseif M(5,n)==4
        if M(2,n)>0
            plot(M(3,n),M(4,n),'o','MarkerSize',13,'Color','r'),axis([-70 70 -70 70]),hold on
        else
            plot(M(3,n),M(4,n),'o','MarkerSize',13,'Color','k'),axis([-70 70 -70 70]),hold on
        end
    elseif M(5,n)==5
        if M(2,n)>0
            plot(M(3,n),M(4,n),'o','MarkerSize',16,'Color','r'),axis([-70 70 -70 70]),hold on
        else
            plot(M(3,n),M(4,n),'o','MarkerSize',16,'Color','k'),axis([-70 70 -70 70]),hold on
        end
     elseif M(5,n)==6
        if M(2,n)>0
            plot(M(3,n),M(4,n),'o','MarkerSize',19,'Color','r'),axis([-70 70 -70 70]),hold on
        else
            plot(M(3,n),M(4,n),'o','MarkerSize',19,'Color','k'),axis([-70 70 -70 70]),hold on
        end
    elseif M(5,n)==7
        if M(2,n)>0
            plot(M(3,n),M(4,n),'o','MarkerSize',22,'Color','r'),axis([-70 70 -70 70]),hold on
        else
            plot(M(3,n),M(4,n),'o','MarkerSize',22,'Color','k'),axis([-70 70 -70 70]),hold on
        end       
    else
        plot(M(3,n),M(4,n),'.k'),axis([-70 70 -70 70]),hold on
    end
end
plot(-39.322, 36.037,'.k',-25.08,-53.609,'.k'),hold on
end