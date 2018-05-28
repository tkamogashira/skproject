% PEST と　three-down/up one-up/down testの複合テスト
function Trial=PitchMatchLtoRPESTthreedownoneup01(F0,F1,W1,W2,Z1,Z2)
% F0;基準周波数で毎施行左耳に提示される基準音の周波数。
% F1;初期試験周波数。右耳に提示される試験音の第１回目の施行のときの周波数。
% W1;初期周波数変化幅。変化幅はだんだんちいさくなっていきます。
% W2;後半部分の周波数変化幅。後半部分は各施行変化幅は固定になります
% Z1;PESTの試行回数。試験の前半部分の試行回数。
% Z2;全試行回数。後半部分＝three-down/up and one-up/down の試行回数はZ2-Z1となります
t=(0:(1/8192):2);ANSWER=zeros([2,Z2]);Freq=zeros([2,Z2]);Width=zeros([2,Z2]);
Control=(sin(2*pi*t*F0))';
Silence2=zeros([(8192*2+1),1]);
SilenceDemi=zeros([(8192*0.25),1]);
Freq(1,1)=F1;
Pair=[[Control Silence2];[SilenceDemi SilenceDemi];[Silence2 (sin(2*pi*t*Freq(1,1)))']];
sound(Pair)
ANSWER(1,1)=input('The latter tone is lower(-1), same(0) or higher(1)?');
while (ANSWER(1,1)~=1)&(ANSWER(1,1)~=0)&(ANSWER(1,1)~=-1)
    ANSWER(1,1)=input('Incorrect Value! Re-Input!');
end;
Width(1,1)=W1;
if ANSWER(1,1)==-1
        Freq(1,2)=Freq(1,1)+Width(1,1);
else
        Freq(1,2)=Freq(1,1)-Width(1,1);
    end;
Pair=[[Control Silence2];[SilenceDemi SilenceDemi];[Silence2 (sin(2*pi*t*Freq(1,2)))']];
sound(Pair)
ANSWER(1,2)=input('The latter tone is lower(-1), same(0)  or higher(1)?');
while (ANSWER(1,2)~=1)&(ANSWER(1,2)~=0)&(ANSWER(1,2)~=-1)
    ANSWER(1,2)=input('Incorrect Value! Re-Input!');
end;
if ANSWER(1,2)==ANSWER(1,1)
    Width(1,2)=Width(1,1);
else
    Width(1,2)=Width(1,1)*(1/2);
end;
if ANSWER(1,2)==-1
        Freq(1,3)=Freq(1,2)+Width(1,2);
else
        Freq(1,3)=Freq(1,2)-Width(1,2)
end;
Pair=[[Control Silence2];[SilenceDemi SilenceDemi];[Silence2 (sin(2*pi*t*Freq(1,3)))']];
sound(Pair)
ANSWER(1,3)=input('The latter tone is lower(-1), same(0)  or higher(1)?');
while (ANSWER(1,3)~=1)&(ANSWER(1,3)~=0)&(ANSWER(1,3)~=-1)
    ANSWER(1,3)=input('Incorrect Value! Re-Input!');
end;
if ANSWER(1,3)==ANSWER(1,2)
    Width(1,3)=Width(1,2);
else
    Width(1,3)=Width(1,2)*(1/2);
end;
if ANSWER(1,3)==-1
        Freq(1,4)=Freq(1,3)+Width(1,3);
else
        Freq(1,4)=Freq(1,3)-Width(1,3);
end;
for m=4:Z1    
    Pair=[[Control Silence2];[SilenceDemi SilenceDemi];[Silence2 (sin(2*pi*t*Freq(1,m)))']];
    sound(Pair)
    ANSWER(1,m)=input('The latter tone is lower(-1), same(0)  or higher(1)?');
    while (ANSWER(1,m)~=1)&(ANSWER(1,m)~=0)&(ANSWER(1,m)~=-1)
        ANSWER(1,m)=input('Incorrect Value! Re-Input!');
    end;
    if (ANSWER(1,m)==ANSWER(1,(m-1)))&(ANSWER(1,m)==ANSWER(1,(m-2)))&(ANSWER(1,m)==ANSWER(1,(m-3)))
            Width(1,m)=Width(1,(m-1))*2;
    elseif ANSWER(1,m)==ANSWER(1,(m-1))
            Width(1,m)=Width(1,(m-1));
    else
            Width(1,m)=Width(1,(m-1))*(1/2);
    end;
    if ANSWER(1,m)==-1
        Freq(1,m+1)=Freq(1,m)+Width(1,m);
    else
        Freq(1,m+1)=Freq(1,m)-Width(1,m);
    end;
end;
% ここからsecond quarter
Freq(1,Z1+1)=ceil(Freq(1,Z1+1));
Pair=[[Control Silence2];[SilenceDemi SilenceDemi];[Silence2 (sin(2*pi*t*Freq(1,Z1+1)))']];
sound(Pair)
ANSWER(1,Z1+1)=input('The latter tone is lower(-1), same(0) or higher(1)?');
while (ANSWER(1,Z1+1)~=1)&(ANSWER(1,Z1+1)~=0)&(ANSWER(1,1+Z1)~=-1)
    ANSWER(1,Z1+1)=input('Incorrect Value! Re-Input!');
end;
if ANSWER(1,Z1+1)==-1 
    Width(1,Z1+1)=0;
else
    Width(1,Z1+1)=-W2;
end;
Freq(1,Z1+2)=Freq(1,Z1+1)+Width(1,Z1+1);
for m=Z1+2:Z2
    Pair=[[Control Silence2];[SilenceDemi SilenceDemi];[Silence2 (sin(2*pi*t*Freq(1,m)))']];
    sound(Pair)
    ANSWER(1,m)=input('The latter tone is lower(-1), same(0)  or higher(1)?');
    while (ANSWER(1,m)~=1)&(ANSWER(1,m)~=0)&(ANSWER(1,m)~=-1)
        ANSWER(1,m)=input('Incorrect Value! Re-Input!');
    end;
    if (ANSWER(1,m)==-1)&(ANSWER(1,m-1)==-1)&(ANSWER(1,m-2)==-1)&(Freq(1,m)==Freq(1,m-2))
            Width(1,m)=W2;
    elseif (ANSWER(1,m)==-1)
            Width(1,m)=0;
    else
            Width(1,m)=-W2;
    end;
    Freq(1,(m+1))=Freq(1,m)+Width(1,m);
end;
%ここから上下動が逆の別試験 third quarter
Latterpart=input('May I continue this test? yes=1,no=-1  ');
while Latterpart~=1
    Latterpart=input('May I continue this test? yes=1,no=-1  ');
end
Freq(2,1)=2*F0-F1;
Pair=[[Control Silence2];[SilenceDemi SilenceDemi];[Silence2 (sin(2*pi*t*Freq(2,1)))']];
sound(Pair)
ANSWER(2,1)=input('The latter tone is lower(-1), same(0) or higher(1)?');
while (ANSWER(2,1)~=1)&(ANSWER(2,1)~=0)&(ANSWER(2,1)~=-1)
    ANSWER(2,1)=input('Incorrect Value! Re-Input!');
end;
Width(2,1)=W1;
if ANSWER(2,1)==1
    Freq(2,2)=Freq(2,1)-Width(2,1);
else
    Freq(2,2)=Freq(2,1)+Width(2,1);
end;
Pair=[[Control Silence2];[SilenceDemi SilenceDemi];[Silence2 (sin(2*pi*t*Freq(2,2)))']];
sound(Pair)
ANSWER(2,2)=input('The latter tone is lower(-1), same(0)  or higher(1)?');
while (ANSWER(2,2)~=1)&(ANSWER(2,2)~=0)&(ANSWER(2,2)~=-1)
    ANSWER(2,2)=input('Incorrect Value! Re-Input!');
end;
if ANSWER(2,2)==ANSWER(2,1)
    Width(2,2)=Width(2,1);
else
    Width(2,2)=Width(2,1)*(1/2);
end;
if ANSWER(2,2)==1
    Freq(2,3)=Freq(2,2)-Width(2,2);
else
    Freq(2,3)=Freq(2,2)+Width(2,2);
end;
Pair=[[Control Silence2];[SilenceDemi SilenceDemi];[Silence2 (sin(2*pi*t*Freq(2,3)))']];
sound(Pair)
ANSWER(2,3)=input('The latter tone is lower(-1), same(0)  or higher(1)?');
while (ANSWER(2,3)~=1)&(ANSWER(2,3)~=0)&(ANSWER(2,3)~=-1)
    ANSWER(2,3)=input('Incorrect Value! Re-Input!');
end;
if ANSWER(2,3)==ANSWER(2,2)
    Width(2,3)=Width(2,2);
else
    Width(2,3)=Width(2,2)*(1/2);
end;
if ANSWER(2,3)==1
    Freq(2,4)=Freq(2,3)-Width(2,3);
else
    Freq(2,4)=Freq(2,3)+Width(2,3);
end;
for m=4:Z1    
    Pair=[[Control Silence2];[SilenceDemi SilenceDemi];[Silence2 (sin(2*pi*t*Freq(2,m)))']];
    sound(Pair)
    ANSWER(2,m)=input('The latter tone is lower(-1), same(0)  or higher(1)?');
    while (ANSWER(2,m)~=1)&(ANSWER(2,m)~=0)&(ANSWER(2,m)~=-1)
        ANSWER(2,m)=input('Incorrect Value! Re-Input!');
    end;
    if (ANSWER(2,m)==ANSWER(2,(m-1)))&(ANSWER(2,m)==ANSWER(2,(m-2)))&(ANSWER(2,m)==ANSWER(2,(m-3)))
            Width(2,m)=Width(2,(m-1))*2;
    elseif ANSWER(2,m)==ANSWER(2,(m-1))
            Width(2,m)=Width(2,(m-1));
    else
            Width(2,m)=Width(2,(m-1))*(1/2);
    end;
    if ANSWER(2,m)==1
        Freq(2,m+1)=Freq(2,m)-Width(2,m);
    else
        Freq(2,m+1)=Freq(2,m)+Width(2,m);
    end;
end;
Freq(2,Z1+1)=ceil(Freq(2,Z1+1));
Width(2,Z1+1)=W2;
Pair=[[Control Silence2];[SilenceDemi SilenceDemi];[Silence2 (sin(2*pi*t*Freq(2,Z1+1)))']];
sound(Pair)
ANSWER(2,Z1+1)=input('The latter tone is lower(-1), same(0) or higher(1)?');
while (ANSWER(2,Z1+1)~=1)&(ANSWER(2,Z1+1)~=0)&(ANSWER(2,1+Z1)~=-1)
    ANSWER(2,Z1+1)=input('Incorrect Value! Re-Input!');
end;
if ANSWER(2,Z1+1)==1 
    Width(2,Z1+1)=0;
else
    Width(2,Z1+1)=W2;
end;
Freq(2,Z1+2)=Freq(2,Z1+1)+Width(2,Z1+1);
for m=Z1+2:Z2
    Pair=[[Control Silence2];[SilenceDemi SilenceDemi];[Silence2 (sin(2*pi*t*Freq(2,m)))']];
    sound(Pair)
    ANSWER(2,m)=input('The latter tone is lower(-1), same(0)  or higher(1)?');
    while (ANSWER(2,m)~=1)&(ANSWER(2,m)~=0)&(ANSWER(2,m)~=-1)
        ANSWER(2,m)=input('Incorrect Value! Re-Input!');
    end;
    if (ANSWER(2,m)==1)&(ANSWER(2,m-1)==1)&(ANSWER(2,m-2)==1)&(Freq(2,m)==Freq(2,m-2))
            Width(2,m)=-W2;
    elseif (ANSWER(2,m)==1)
            Width(2,m)=0;
    else
            Width(2,m)=W2;
    end;
    Freq(2,(m+1))=Freq(2,m)+Width(2,m);
end;
RESULT=[Freq(1,(1:Z2));ANSWER(1,(1:Z2));Width(1,(1:Z2));Freq(2,(1:Z2));ANSWER(2,(1:Z2));Width(2,(1:Z2))];
assignin('base','RESULT',RESULT);
Tnumber=(1:1:Z2);
plot(Tnumber(1,(1:Z2)),Freq(1,(1:Z2)),Tnumber(1,(1:Z2)),Freq(2,(1:Z2)))
end