function RGratio=Flicker_Adjust(TFreq)

nPixels = 96;
nMeas=4;
bkglevel=0.4;
%Color1=[0.25+0.5  0.25  0.25];
%Color2=[0.25  0.25+0.3  0.25];
Color1=[bkglevel+0.3  bkglevel-0.3  bkglevel];
Color2=[bkglevel-0.3  bkglevel+0.3  bkglevel];

% Load calibration file
calCM = LoadCalFile(0);
calCM = SetGammaMethod(calCM,1);

% pixel value 0-255
stmIndex=1;
bkgIndex=254;
msgIndex=0;

% Open up the a window on the screen, initialize the clut,
[window,screenRect] = SCREEN(0,'OpenWindow',bkgIndex,[],8);
offClut=repmat([0:255]',1,3);
offClut(bkgIndex+1,:) = PrimaryToSettings(calCM,[bkglevel bkglevel bkglevel]')'; % bkg
offClut(stmIndex+1,:) = PrimaryToSettings(calCM,Color1')'; 
offClut(stmIndex+2,:) = PrimaryToSettings(calCM,Color2')'; 
offClut(stmIndex+3,:) = PrimaryToSettings(calCM,1.5*Color2')'; 
offClut(stmIndex+4,:) = PrimaryToSettings(calCM,1.25*Color2')'; 
offClut(stmIndex+5,:) = PrimaryToSettings(calCM,0.75*Color2')'; 
offClut(stmIndex+6,:) = PrimaryToSettings(calCM,0.5*Color2')'; 

SCREEN(window,'SetClut',offClut);
Image = ones(nPixels,nPixels);
rect=SetRect(0,0,nPixels,nPixels);
rect=CenterRect(rect,screenRect);
rect0=OffsetRect(rect,-200,0);
rect1=OffsetRect(rect,200,0);
rect2=OffsetRect(rect,200,-300);
rect3=OffsetRect(rect,200,-150);
rect4=OffsetRect(rect,200,150);
rect5=OffsetRect(rect,200,300);
SCREEN(window,'PutImage',stmIndex*Image,rect0); % uniform rect
SCREEN(window,'PutImage',(stmIndex+1)*Image,rect1); % uniform rect
SCREEN(window,'PutImage',(stmIndex+2)*Image,rect2); % uniform rect
SCREEN(window,'PutImage',(stmIndex+3)*Image,rect3); % uniform rect
SCREEN(window,'PutImage',(stmIndex+4)*Image,rect4); % uniform rect
SCREEN(window,'PutImage',(stmIndex+5)*Image,rect5); % uniform rect

while(GetResp<0),end
SCREEN('CloseAll');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



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

       




