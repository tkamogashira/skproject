% From x Hz to 440 Hz Yes-No PEST
function RESULT=FromxTo440PEST(F1,W1,Z)
t=(1:(1/8192):3);
Control=(sin(2*pi*t*440))';
Silence2=zeros([(8192*2+1),1]);
SilenceDemi=zeros([(8192*0.5),1]);
Freq(1,1)=F1;
Width(1,1)=W1;
Pair=[[Control Silence2];[SilenceDemi SilenceDemi];[Silence2 (sin(2*pi*t*Freq(1,1)))']];
sound(Pair)
ANSWER(1,1)=input('The latter tone is lower(-1) or higher(1)?');
Freq(1,2)=Freq(1,1)+ANSWER(1,1)*(-1)*Width(1,1);
Pair=[[Control Silence2];[SilenceDemi SilenceDemi];[Silence2 (sin(2*pi*t*Freq(1,2)))']];
sound(Pair)
ANSWER(1,2)=input('The latter tone is lower(-1) or higher(1)?');
if ANSWER(1,2)==ANSWER(1,1)
    Width(1,2)=Width(1,1);
else
    Width(1,2)=Width(1,1)*(1/2);
end;
Freq(1,3)=Freq(1,2)+ANSWER(1,2)*(-1)*Width(1,2);
Pair=[[Control Silence2];[SilenceDemi SilenceDemi];[Silence2 (sin(2*pi*t*Freq(1,3)))']];
sound(Pair)
ANSWER(1,3)=input('The latter tone is lower(-1) or higher(1)?');
if ANSWER(1,3)==ANSWER(1,3)
    Width(1,3)=Width(1,2);
else
    Width(1,3)=Width(1,2)*(1/2);
end;
Freq(1,4)=Freq(1,3)+ANSWER(1,3)*(-1)*Width(1,3);
for m=4:Z    
    Pair=[[Control Silence2];[SilenceDemi SilenceDemi];[Silence2 (sin(2*pi*t*Freq(1,m)))']];
    sound(Pair)
    ANSWER(1,m)=input('The latter tone is lower(-1) or higher(1)?');
    if ANSWER(1,m)==ANSWER(1,(m-1))
        if (ANSWER(1,m)==ANSWER(1,(m-1)))&(ANSWER(1,m)==ANSWER(1,(m-2)))&(ANSWER(1,m)==ANSWER(1,(m-3)))
            Width(1,m)=Width(1,(m-1))*2;
        else
            Width(1,m)=Width(1,(m-1));
        end;
    else
        Width(1,m)=Width(1,(m-1))*(1/2);
    end;
    Freq(1,(m+1))=Freq(1,m)+ANSWER(1,m)*(-1)*Width(1,m);
end;
RESULT=[Freq(1,(1:Z));ANSWER(1,(1:Z));Width(1,(1:Z))];
assignin('base','RESULT',RESULT);
Tnumber=(1:1:Z);
plot(Tnumber(1,(1:Z)),Freq(1,(1:Z)))
end

