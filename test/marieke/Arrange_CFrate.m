%Arrange CF2/CF1
function NewStruct2=Arrange_CFrate(Struct)
L=size(Struct);
for n=1:L(2)
    NewStruct2(n).Fiber1=Struct(n).Fiber1;
    NewStruct2(n).Fiber2=Struct(n).Fiber2;
    NewStruct2(n).BF=Struct(n).BF;
    NewStruct2(n).DeltaCF=Struct(n).DeltaCF;
    NewStruct2(n).MeanCF=Struct(n).MeanCF;
    NewStruct2(n).ds1.filename=Struct(n).ds1.filename;
    NewStruct2(n).ds1.icell=Struct(n).ds1.icell;
    if Struct(n).CF1>Struct(n).CF2
        NewStruct2(n).CF1=Struct(n).CF2;
        NewStruct2(n).CF2=Struct(n).CF1;
        NewStruct2(n).BP=Struct(n).BP*(-1);
        NewStruct2(n).CD=Struct(n).CD*(-1);
        NewStruct2(n).CP=1-(Struct(n).CP);
        NewStruct2(n).CF2perCF1=NewStruct2(n).CF2/NewStruct2(n).CF1;
        NewStruct2(n).BFperCF1=NewStruct2(n).BF/NewStruct2(n).CF1;
    else
        NewStruct2(n).CF1=Struct(n).CF1;
        NewStruct2(n).CF2=Struct(n).CF2;
        NewStruct2(n).BP=Struct(n).BP;
        NewStruct2(n).CD=Struct(n).CD;
        NewStruct2(n).CP=Struct(n).CP;
        NewStruct2(n).CF2perCF1=NewStruct2(n).CF2/NewStruct2(n).CF1;
        NewStruct2(n).BFperCF1=NewStruct2(n).BF/NewStruct2(n).CF1;
    end;
end;
assignin('base','NewStruct2',NewStruct2);
end