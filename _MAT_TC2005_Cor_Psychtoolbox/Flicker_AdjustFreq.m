function RGratio=Flicker_AdjustFreq

nPixels = 96;
nMeas=1;
%Color1=[0.25+0.5  0.25  0.25];
%Color2=[0.25  0.25+0.3  0.25];
Color1=[0.5+0.3  0.5-0.3  0.5];
Color2=[0.5-0.3  0.5+0.3  0.5];
TFreq=1;
    
% Load calibration file
calCM = LoadCalFile(0);
calCM = SetGammaMethod(calCM,1);

% pixel value 0-255
stmIndex=1;
bkgIndex=2;
msgIndex=0;

bkglevel=0.5;

% Open up the a window on the screen, initialize the clut,
[window,screenRect] = SCREEN(0,'OpenWindow',bkgIndex,[],8);
offClut=repmat([0:255]',1,3);
offClut(bkgIndex+1,:) = PrimaryToSettings(calCM,[bkglevel bkglevel bkglevel]')'; % bkg

SCREEN(window,'SetClut',offClut);
Image = stmIndex*ones(nPixels,nPixels);
SCREEN(window,'PutImage',Image); % uniform rect

theText=sprintf('%03.1fHz',TFreq);
s=24;
Screen(window,'TextFont','Arial');
Screen(window,'TextSize',s);
textRect=SetRect(0,0,Screen(window,'TextWidth',theText(1,:)),s+8);
textRect=CenterRect(textRect,screenRect);
textRect=OffsetRect(textRect,0,100);
%Screen(window,'DrawText',theText,textRect(RectLeft),textRect(RectTop),msgIndex);

%WaitSecs(2);
% Adjustment
HideCursor;
for t=1:nMeas
    resp=-1;
    while(resp~=0)
        resp=GetResp;
        if(resp==1)
            TFreq=TFreq+1;
        elseif(resp==2)
            TFreq=TFreq-1;
        elseif(resp==0)
            break;
        elseif(resp==9)
            SCREEN('CloseAll');
            return;
        end
        if TFreq<1, TFreq=1;
        elseif TFreq>30.0, TFreq=30.0;
        end
        theCluts=ComputeCluts(Color1,Color2,TFreq,calCM,offClut,stmIndex);
        Present(window,theCluts);
        % Print instructions
        %theText=sprintf('%03.1fHz',TFreq);
        
        %Screen(window,'PutImage',bkgIndex*ones(size(textRect)),textRect);
        %Screen(window,'DrawText',theText,textRect(RectLeft),textRect(RectTop),msgIndex);
        

    end
    SCREEN(window,'SetClut',offClut);
    
    WaitSecs(1);
end
ShowCursor;
SCREEN('CloseAll');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function theCluts=ComputeCluts(Color1,Color2,TFreq,calCM,offClut,stmIndex)
% Rcont, Gcont 0-1
framePerImage=round(FrameRate(0)/TFreq/2);
nCluts = framePerImage*2;
theCluts= repmat(offClut,[1 1 nCluts]);

bkglevel=0.5;

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

       




