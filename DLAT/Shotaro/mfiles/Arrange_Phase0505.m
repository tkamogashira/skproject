%Arrange Phase from -0.5 to +0.5 for structure
function NewStruct=Arrange_Phase0505(Struct)
L=size(Struct);
for n=1:L(2)
    NewStruct(n).Fiber1=Struct(n).Fiber1;
    NewStruct(n).Fiber2=Struct(n).Fiber2;
    NewStruct(n).BF=Struct(n).BF;
    NewStruct(n).DeltaCF=Struct(n).DeltaCF;
    NewStruct(n).MeanCF=Struct(n).MeanCF;
    NewStruct(n).ds1.filename=Struct(n).ds1.filename;
    NewStruct(n).ds1.icell=Struct(n).ds1.icell;
    if Struct(n).CF1>Struct(n).CF2
        NewStruct(n).CF1=Struct(n).CF2;
        NewStruct(n).CF2=Struct(n).CF1;
        NewStruct(n).BP=Struct(n).BP*(-1);
        if (NewStruct(n).BP >= -0.5)&(NewStruct(n).BP < 0.5)
            NewStruct(n).BPm=NewStruct(n).BP;
        else
            NewStruct(n).BPm=NewStruct(n).BP-round(NewStruct(n).BP);
        end
        NewStruct(n).CD=Struct(n).CD*(-1);
        NewStruct(n).CP=1-(Struct(n).CP);
        if (NewStruct(n).CP >= -0.5)&(NewStruct(n).CP < 0.5)
            NewStruct(n).CPm=NewStruct(n).CP;
        else
            NewStruct(n).CPm=NewStruct(n).CP-round(NewStruct(n).CP);
        end
    else
        NewStruct(n).CF1=Struct(n).CF1;
        NewStruct(n).CF2=Struct(n).CF2;
        NewStruct(n).BP=Struct(n).BP;
        if (NewStruct(n).BP >= -0.5)&(NewStruct(n).BP < 0.5)
            NewStruct(n).BPm=NewStruct(n).BP;
        else
            NewStruct(n).BPm=NewStruct(n).BP-round(NewStruct(n).BP);
        end
        NewStruct(n).CD=Struct(n).CD;
        NewStruct(n).CP=Struct(n).CP;
        if (NewStruct(n).CP >= -0.5)&(NewStruct(n).CP < 0.5)
            NewStruct(n).CPm=NewStruct(n).CP;
        else
            NewStruct(n).CPm=NewStruct(n).CP-round(NewStruct(n).CP);
        end
    end;
end;
assignin('base','NewStruct',NewStruct);
end