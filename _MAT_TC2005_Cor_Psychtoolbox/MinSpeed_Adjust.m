function MinSpeed_Adjust
 
nPixels = 256;
cyclesPerImage = 6;
TF=6.0;
gtype=1;
Fcont=0.4;
nMeas=1;

wv=round(nPixels/cyclesPerImage);
switch gtype
    case [0 2], % 1d
        gratingVector=rem([1:nPixels],wv);
        gratingImage = ones(nPixels,1)*gratingVector;
    case 1, % radial
        wv=60;
        frameSize=nPixels/2;
        [x,y]=meshgrid(-frameSize+0.5:frameSize-0.5,-frameSize+0.5:frameSize-0.5);
        angle=180/pi*atan2(y,x)+360;
        dst=sqrt(x.*x+y.*y);
        anglePerCycle=360/cyclesPerImage;
        anglePerFrame=anglePerCycle/wv;
        gratingImage=rem(round(angle/anglePerFrame),wv);
        gratingImage(dst<frameSize*0.3)=255;
        gratingImage(dst>frameSize)=255;
end

% Open up the a window on the screen, initialize the clut,
[window,screenRect] = SCREEN(0,'OpenWindow',255,[],8);
calCM = LoadCalFile(0);
calCM = SetGammaMethod(calCM,1);
offClut = ones(256,1)*PrimaryToSettings(calCM,[0.5 0.5 0.5]')';
SCREEN(window,'SetClut',offClut);
SCREEN(window,'PutImage',gratingImage);

WaitSecs(2);
HideCursor;
for t=1:nMeas
    Vcont=rand(1)*0.9; %initial contrast 
    resp=-1;
    while(resp~=0)
        resp=GetResp;
        if(resp==1)
            Vcont=Vcont+0.04;
        elseif(resp==2)
            Vcont=Vcont-0.04;
        elseif(resp==0)
            break;
        elseif(resp==9)
            SCREEN('CloseAll');
            return;
        end
        if Vcont<0, Vcont=0;
        elseif Vcont>1.0, Vcont=1.0;
        end
        theCluts=ComputeCluts(Fcont,Vcont,TF,wv,calCM,gtype,offClut);
        Present(window,theCluts,calCM);
        %SCREEN(window,'SetClut',offClut);
        %WaitSec(0.2);
    end
    
    SCREEN(window,'SetClut',offClut);
    
    Vcont_all(t)=Vcont;
    %fprintf('Contrast ratio R:G = %f:%f\n',RCont,GCont);
    
    WaitSecs(1);% pause between runs
end

%ShowCursor;

% Close the window.
SCREEN('CloseAll');


function theCluts=ComputeCluts(Rcont,Gcont,TF,wv,calCM,gtype,offClut)
nCluts = FrameRate(0)/TF;
theCluts = zeros(256,3,nCluts);
x=([0:wv-1]/wv)';
clutEntries=zeros(wv,3);
for i = 1:nCluts
    sinEntries=sin(2*pi*x+2*pi*((i-1)/nCluts));
    if(nargin==6)
        if gtype==0
            id1=find(sinEntries>=0);
            id2=find(sinEntries<0);
            sinEntries(id1)=1;
            sinEntries(id2)=-1;
        end
    end

    clutEntries(:,1) =  0.5*Rcont*sinEntries+0.5;
    clutEntries(:,2) = -0.5*Gcont*sinEntries+0.5;
    clutEntries(:,3) = 0.5;
    theCluts(:,:,i)=offClut;
    theCluts(1:wv,:,i) = PrimaryToSettings(calCM,clutEntries')';
end

        
function Present(window,theCluts,calCM);
nCluts=size(theCluts,3);
framesPerClut=1;
clutCounter = 1;
nCycles=1;
for i=1:nCluts*nCycles
    SCREEN(window,'SetClut',theCluts(:,:,clutCounter));
    clutCounter=rem(clutCounter,nCluts)+1;
    %SCREEN(window,'WaitBlanking',framesPerClut-1);
    SCREEN(window,'WaitBlanking');
end

function resp=GetResp
[keyIsDown,secs,keyCode] = KbCheck;
resp=-1;
key1=KbName('['); 
key2=KbName(']'); 
key3=KbName('return');
key4=KbName('esc');
if keyCode(key1),
    resp=1;
end
if keyCode(key2),
    resp=2;
end
if keyCode(key3),
    resp=0;
end
if keyCode(key4),
    resp=9;
end

       

