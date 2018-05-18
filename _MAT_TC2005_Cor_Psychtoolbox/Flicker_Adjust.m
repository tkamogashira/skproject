function Flicker_Adjust(TFreq)

nPixels = 96;
nMeas=5;
bkglevel=0.4;
Color1=[bkglevel+0.3  bkglevel-0.3  bkglevel];
Color2=[bkglevel-0.3  bkglevel+0.3  bkglevel];

% Load calibration file
calCM = LoadCalFile(0);
calCM = SetGammaMethod(calCM,1);

% pixel value 0-255
stmIndex=1;
bkgIndex=2;
msgIndex=0;

% Open up the a window on the screen, initialize the clut,
[window,screenRect] = SCREEN(0,'OpenWindow',bkgIndex,[],8);
offClut=repmat([0:255]',1,3);
offClut(bkgIndex+1,:) = PrimaryToSettings(calCM,[bkglevel bkglevel bkglevel]')'; % bkg
SCREEN(window,'SetClut',offClut);
Image = stmIndex*ones(nPixels,nPixels);
SCREEN(window,'PutImage',Image); % uniform rect

% Adjustment
HideCursor;
for t=1:nMeas
    Vcont=rand(1)*0.9; %initial contrast 
    resp=-1;
    while(resp~=0)
        resp=GetResp;
        if(resp==1)
            Vcont=Vcont+0.02;
        elseif(resp==2)
            Vcont=Vcont-0.02;
        elseif(resp==0)
            break;
        elseif(resp==9)
            SCREEN('CloseAll');
            return;
        end
        if Vcont<0, Vcont=0;
        elseif Vcont>1.4, Vcont=1.4;
        end
        theCluts=ComputeCluts(Color1,Color2*Vcont,TFreq,calCM,offClut,stmIndex);
        Present(window,theCluts);
    end
    SCREEN(window,'SetClut',offClut);
    Vcont_all(t)=Vcont;
    
    WaitSecs(1);
end
ShowCursor;
SCREEN('CloseAll');


Vcont_mean=mean(Vcont_all);
save('Flicker.mat','Color1','Color2','Vcont_all', 'Vcont_mean');
plot_Flicker;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function theCluts=ComputeCluts(Color1,Color2,TFreq,calCM,offClut,stmIndex)
% Rcont, Gcont 0-1
framePerImage=round(FrameRate(0)/TFreq/2);
nCluts = framePerImage*2;
theCluts= repmat(offClut,[1 1 nCluts]);

fs=[1:framePerImage];
theCluts(stmIndex+1,:,fs) = repmat(PrimaryToSettings(calCM,Color1')',[1 1 framePerImage]);
theCluts(stmIndex+1,:,fs+framePerImage) = repmat(PrimaryToSettings(calCM,Color2')',[1 1 framePerImage]);

function Present(window,theCluts);
nCycles=1;
nCluts=size(theCluts,3);
framesPerClut=1;
clutCounter = 1;
for i=1:nCluts*nCycles
    SCREEN(window,'WaitBlanking');
    SCREEN(window,'SetClut',theCluts(:,:,clutCounter));
    clutCounter=rem(clutCounter,nCluts)+1;
    %SCREEN(window,'WaitBlanking',framesPerClut-1);
end


function resp=GetResp
[keyIsDown,secs,keyCode] = KbCheck;
resp=-1;
%key1=38; %up
%key2=40; %down
key1=KbName('['); 
key2=KbName(']'); 
key3=13; %return
key4=27; %escape
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

       




