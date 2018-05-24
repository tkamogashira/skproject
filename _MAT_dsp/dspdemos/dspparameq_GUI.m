function dspparameq_GUI(state)
%dspparameq_GUI
%   Copyright 2008-2011 The MathWorks, Inc.


persistent Fs NdB axisStyle notfirst
persistent pk1 centerfreq1 bandw1
persistent pk2 centerfreq2 bandw2
persistent pk3 centerfreq3 bandw3

%Set NdB
NdB = 0.707;
Fs = 48000; 

% X-axis limits for each band
xlim_band1 = [(45*2*pi/Fs) (1200*2*pi/Fs)]; % band1- Red
xlim_band2 = [(2400*2*pi/Fs) (4800*2*pi/Fs)]; % band1- Blue
xlim_band3 = [(6000*2*pi/Fs) (12000*2*pi/Fs)]; % band1- Black
%Maximum allowed bandwidth for any band
maxBW =  5000;
% Maximum Gain/Attenuation Limits
gainLowerLim = -8 ;
gainUpperLim  = 8 ;

% Global persistent for controlling log or regular frequency axis. Choose
% 'log' if you want a logarithmic X-axis; if not, use 'normal'
axisStyle = 'normal';

color1 = [255 0 0]/255;     % Red
color2 = [0 0 255]/255;     % Blue 
color3 = [0 0 0]/255;       % Black
axisColor = [159 188 191]/255;
figColor = [.9 .9 .9];

if nargin==0 || strcmp(state,'reset')
           
     reset=false;
     if nargin~=0 && strcmp(state,'reset')
         reset = true;
     end
    
    if isempty(notfirst) || reset    
    % Init PEQ
        bandw1 = 0.3;
        centerfreq1 = 0.1;
        pk1= 5;
    
        bandw2 = 0.3;
        centerfreq2 = 0.314159;
        pk2 = 3.680453;
    
        bandw3 = 0.3;
        centerfreq3 = 0.785398;
        pk3 = -4.791667;
        
        notfirst = true;
    end
    
    %Initial Input Parameters correspond to the same filter coefficients that
    % are initialized by dspparameq_data.m . 
    
    %Filter1
    [b1 a1 txt1] = peq(0,pk1,centerfreq1,bandw1,NdB,1);
    [h1,w1] = freqz(b1,a1);
    %Filter2
    [b2 a2 txt2] = peq(0,pk2,centerfreq2,bandw2,NdB,1);
    [h2,w2] = freqz(b2,a2);
    
    %Filter3 
    [b3 a3 txt3]= peq(0,pk3,centerfreq3,bandw3,NdB,1);
    [h3,w3] = freqz(b3,a3);
    
    
    % This demo assumes the coefficient variables are already declared to
    % their initial values in the base workspace by the accompanying
    % initialization function dspparameq_data.m. This GUI file will
    % attempt to modify the existing parameter values whenever the filter
    % values are changed by the user. 

    writeCoeffToWS(b1,a1,1,txt1);
    writeCoeffToWS(b2,a2,2,txt2);
    writeCoeffToWS(b3,a3,3,txt3);
    
    
    %Convert back to dB
    h1 = 20*log10(abs(h1));
    h2 = 20*log10(abs(h2));
    h3 = 20*log10(abs(h3));
         
    %% -------------------BAND ONE----------------------------------------
    %Create the plot
    figureName = 'Three Band Equalizer';
    % If figure already exists, bring to front
    hFig = findall(0, 'type', 'figure', 'Name', figureName );
    if ~isempty(hFig)
        figure(hFig);
    end

    if strcmp(axisStyle,'log')
        line1 = semilogx(w1,h1,'tag','line1','linewidth',2); hold on;
    elseif strcmp(axisStyle, 'normal')
        line1 = plot(w1,h1,'tag','line1','linewidth',2); hold on;  
    end;

    set(line1,'color',color1);
    %axis off;
    grid on;
    xlim(([0 1])*pi);
    ylim([-15 15]);
    
    %Customize the looks of the Figure Window
    set(gcf,'menubar','none');
    set(gcf,'Name',figureName);
    
    % and the axis
    xlabels=.1:.1:3.0;   % setup 1 2 5 sequence for xlabels
    set(gca,'xtick',xlabels*pi);
    
    for k=1:length(xlabels)
        xstring{k} = sprintf('%3.0f',(xlabels(k)*Fs/2));
    end;
    set(gca,'xticklabel',xstring)
    
    set(gcf,'color',figColor);
    set(gca,'color',axisColor);
    if ( exist('state', 'var') && ~strcmp(state,'reset')) || (nargin==0)
        set(gcf,'position',[450 350 516 350]);
    end
    set(gca,'position',[0.1000    0.1500    0.8150    0.6150]);
    set(gcf,'resize','off');
    set(gca,'xcolor','k','ycolor','k');

    set(get(gca,'ylabel'),'String','Gain in dB','color','k','fontangle','italic');
    
     %Create Title Text
   ttext = text(0.5,.5,'Parametric Audio Equalizer User Interface');
    set(ttext,'color','k','fontweight','bold','tag','ttext','position',[.0055 23.80],...
        'FontSize',16); %'BackgroundColor',[.9 .9 .9],'EdgeColor','black'
    
    %Create Help Text at the top of the Figure Window
    htext = text(0.5,.5,'Click and drag on the Round Markers or the Lines');
    set(htext,'color','k','fontangle','oblique','fontweight','bold','tag','text1','position',[.0055 19.70],...
        'EdgeColor','black','BackgroundColor',[.7 .9 .7]);
    
    %Create Text box for Parameter Value display
    freqText = text(0.0057,16.65,'Center Frequency:','color',figColor,'tag','freqText');
    peakText = text(1.30,16.65,'Peak Value:','color',figColor,'tag','peakText');
    bandwText = text(2.30,16.65,'Band Width:','color',figColor,'tag','bandwText');
    
    %Create the Note Text
%Create the Note Text
    noteText = text(0.0036,-19.2083,'The overall response is given in yellow.',...
        'color','k','tag','noteText','fontweight','demi','fontangle','italic'); %'EdgeColor','black','BackgroundColor',[.7 .9 .7]
    
    %Create a Reset Button
    reset = uicontrol(gcf);
    set(reset,'position',[460 8 50 15],'string','Reset');
    set(reset,'callback','dspparameq_GUI(''reset'')');
    
    %Add Markers that will be used for manipulating the parameters
    if pk1>0
       [h1max,indexh1] = max(h1); 
   else
       [h1max,indexh1] = min(h1); 
   end
    
    w1max = w1(indexh1);
    % the marker is plotted as a line object
    gain1 = line(w1max,h1max,'Marker','o','MarkerEdgeColor','k', ...
        'MarkerFaceColor',color1,'tag','peakgain1','LineStyle','none','markersize',6);
    %-------------------END CODE FOR BAND ONE--------------------------------------
    
%% -------------------BAND TWO--------------------------------------------------
    
    %Create the plot

    if strcmp(axisStyle,'log')
        line2 = semilogx(w2,h2,'tag','line2','linewidth',2);
    elseif strcmp(axisStyle, 'normal')
        line2 = plot(w2,h2,'tag','line2','linewidth',2);  
    end;
    set(line2,'color',color2);
    
    %Add Markers that will be used for manipulating the parameters
    if pk2>0
        [h2max,indexh2] = max(h2);    % this does not work, it can be a max or a min!
    else
        [h2max,indexh2] = min(h2);    % this does not work, it can be a max or a min!
    end;
    
    w2max = w2(indexh2);
    % the marker is plotted as a line object
    gain2 = line(w2max,h2max,'Marker','o','MarkerEdgeColor','k', ...
        'MarkerFaceColor',color2,'tag','peakgain2','LineStyle','none','markersize',6);
    %-------------------END CODE FOR BAND TWO--------------------------------------
%% --------------------------BAND THREE------------------------------------------
    %Create the plot
    if strcmp(axisStyle,'log')
        line3 = semilogx(w3,h3,'tag','line3','linewidth',2);
    elseif strcmp(axisStyle, 'normal')
        line3 = plot(w3,h3,'tag','line3','linewidth',2);
    end;
    set(line3,'color',color3);
        
    %Add Markers that will be used for manipulating the parameters
    if pk3>0
       [h3max,indexh3] = max(h3);
    else
       [h3max,indexh3] = min(h3);
    end
    w3max = w3(indexh3);
    % the marker is plotted as a line object
    gain3 = line(w3max,h3max,'Marker','o','MarkerEdgeColor','k', ...
        'MarkerFaceColor',color3,'tag','peakgain3','LineStyle','none','markersize',6);
    %-------------------END CODE FOR BAND THREE--------------------------------------
%% Sum of all Bands    
    sumH = h1+h2+h3;
    % Normalize (if needed) the sum of responses to value bet -15 & +15 for
    % plotting purpose. In this case, the normSumH doesn't do anything
    % except pass through the value as is. 
    normSumH = sumNorm(sumH);
    %Plot sum of all responses
    line4 = plot(w2,normSumH,'y--','tag','line4','linewidth',1,'hittest','off');
    hold off;

    
    %Store sum of all response in GCF to display sum of responses
    allH = normSumH; 
    setappdata(gcf,'allH', allH);
          
    %Also save the equalizer responses and current parameters in a
    %structure: eqData.H ,eqData.centerFreq, eqData.bandW
    eqData.H = [h1 h2 h3];
    eqData.centerFreq = [centerfreq1 centerfreq2 centerfreq3];
    eqData.bandW = [bandw1 bandw2 bandw3];
    setappdata(gcf,'eqData', eqData);
    
    % Update Model
    try
        set_param(bdroot,'SimulationCommand','update');
    catch me
        error (message('dsp:dspparameq_GUI:modelUpdateFailed'));%error('Cannot update Simulink model');
    end
    
    %Set the button down function
    set(gcf,'WindowButtonDownFcn','dspparameq_GUI(''down'')');
    
    %Eliminate flicker
    set(gcf,'DoubleBuffer','on');       
    
    %Set the mouse move while button down function
    set(gcf,'WindowButtonMotionFcn','','WindowButtonUpFcn','');
    
    % Init the Attrib value display text
    numFreq = numFormat(centerfreq1,Fs);
    numBandw = numFormat(bandw1,Fs);
    peakVal = sprintf('%0.1f',pk1);
    set(freqText,'string',['Center Frequency: ',numFreq],'color','r','fontangle','italic');
    set(peakText,'string',['Peak Value: ',peakVal,' dB'],'color','r','fontangle','italic');
    set(bandwText,'string',['Bandwidth: ',numBandw],'color','r','fontangle','italic');
    
    % Create Legend
    legend([line1 line2 line3],'Band1','Band2','Band3');

    %Create a Legend Button to Toggle it
    leg = uicontrol(gcf);
    set(leg,'position',[400 8 50 15],'string','Legend');
    set(leg,'callback','legend(''toggle'')');
    

    % Execute the WindowButtonDownFcn
elseif strcmp(state,'down')
    
    %Get the current complete info on filter responses
    EqData = getappdata(gcf,'eqData');
    cfreq = EqData.centerFreq;
    
    %Identify the Band that was clicked
    htype = get(gco,'type');
    
    %If Line is clicked, then set the Point Down information in the Figure
    if strcmp(htype,'line')
        tag = get(gco,'tag');
        tagIndex = eval(tag(end));
        
        set(gcf,'WindowButtonMotionFcn','dspparameq_GUI(''move'')', ...
            'WindowButtonUpFcn','dspparameq_GUI(''up'')');  
        
        cp = get(gca,'CurrentPoint');
        xDown = cp(1,1);
        yDown = cp(1,2);
        
        setappdata(gcf,'pointDown',[xDown cfreq(tagIndex)]); 
        
        text1 = findobj(gcf,'tag','text1');
        line4 = findobj(gcf,'tag','line4');
        if strcmp(tag,'peakgain1')||strcmp(tag,'peakgain2')||strcmp(tag,'peakgain3') 
            set(text1,'string','Drag to move the peak around');
        elseif strcmp(tag,'line1')||strcmp(tag,'line2')||strcmp(tag,'line3')
            set(text1,'string','Drag to change the bandwidth');
        elseif strcmp(tag,'line4')
            set(text1,'string','This is the actual response. Change this by moving individual bands');
        end
    end
    
% Execute the WindowButtonMotionFcn    
elseif strcmp(state,'move')
    
    %Get the current complete info on filter responses
    EqData = getappdata(gcf,'eqData');
    cfreq = EqData.centerFreq;
    H = EqData.H;
    bandw = EqData.bandW;
    
    %Find handles of blocks in Simulink Model whose value is set here
    text1 = findobj(gcf,'tag','text1');
    
    line1 = findobj(gcf,'tag','line1');
    gain1 = findobj(gcf,'tag','peakgain1');

    line2 = findobj(gcf,'tag','line2');
    gain2 = findobj(gcf,'tag','peakgain2');
    
    line3 = findobj(gcf,'tag','line3');
    gain3 = findobj(gcf,'tag','peakgain3');
    
    line4 = findobj(gcf,'tag','line4');
   
    freqText = findobj(gcf,'tag','freqText');
    peakText = findobj(gcf,'tag','peakText');
    bandwText = findobj(gcf,'tag','bandwText');
     
    cp = get(gca,'CurrentPoint');

    
    tag = get(gco,'tag');
    tagIndex = eval(tag(end));
    switch tag(end)
        case '1'
            col = color1;
            xlims = xlim_band1; 
        case '2' 
            col = color2;
            xlims = xlim_band2; 
        case '3' 
            col = color3;
            xlims = xlim_band3; 
    end
    %-----------------------------------
    %If the user drags the point out of the axis reset
    %the corresponding point to the axis limits
    x = cp(1,1); %xlims = get(gca,'xlim'); 
    %if x<xlims(1), x = xlims(1);end;
    if x<xlims(1), x = xlims(1) ;end; % Center frequency cannot be lower than 45 Hz
    if x>xlims(2), x = xlims(2);end;
    
    y = cp(1,2); ylims = [gainLowerLim gainUpperLim];%ylims = get(gca,'ylim'); 
    if y<ylims(1), y = ylims(1);end;
    if y>ylims(2), y = ylims(2);end;
    %------------------------------------
    
    %Get the original ButtonDown x,y coordinates
    xyDown = getappdata(gcf,'pointDown');
    allH = getappdata(gcf,'allH');
    
    %IF THE GAIN POINT IS MOVED ==>
    if strcmp(tag,'peakgain1')||strcmp(tag,'peakgain2')||strcmp(tag,'peakgain3') 
        set(text1,'string','Change the Center Frequency and Peak Gain of the frequency band');
        myH = H(:,tagIndex);
        
        %Change the Shape and color of Marker while it's moving
        set(eval(['gain' tag(end)]),'xdata',x,'ydata',y,'marker','diamond','markersize',12,'markerfacecolor','y');
        [ b a] = peq(0,y,x,bandw(tagIndex),NdB,0);
        [newh,neww] = freqz(b,a);
        newh = 20*log10(abs(newh));
        
        set(eval(['line' tag(end)]),'ydata',newh,'xdata',neww,'linewidth',2);
        H(:,tagIndex) = newh;
        
        %Update the sum response plot to improve readability
        allH = sumNorm(sum(H,2));
        set(line4,'ydata',allH,'xdata',neww);
                
        %Set the new parameters for the modified band
        EqData.H = H;
        cfreq(tagIndex) = x; 
        EqData.centerFreq = cfreq;
        EqData.bandW = bandw;
        setappdata(gcf,'eqData',EqData);
        setappdata(gcf,'allH',allH);
        
        %Display the parameters as the user moves the UIobjects
        numFreq = numFormat(x,Fs);
        numBandw = numFormat(bandw(tagIndex),Fs);
        peakVal = sprintf('%0.1f',y);
        set(freqText,'string',['Center Frequency: ',numFreq],'color',col,'fontangle','italic');
        set(peakText,'string',['Peak Value: ',peakVal,' dB'],'color',col,'fontangle','italic');
        set(bandwText,'string',['Bandwidth: ',numBandw],'color',col,'fontangle','italic');
        
        drawnow
    
    %IF THE LINE (Bandwidth) IS MOVED ==>   
    elseif strcmp(tag,'line1')||strcmp(tag,'line2')||strcmp(tag,'line3')
        set(text1,'string','Dragging the colored lines changes the bandwidth of the frequency band ');
        %Get the response of the current band
        myH = H(:,tagIndex);
        %Change the Shape and color of line while it's moving
        set(eval(['line' tag(end)]),'color','c','linewidth',3);
        
        %Get the value of the peak gain
        peakG = get(eval(['gain' tag(end)]),'ydata');
        
        bwDiff = (x-xyDown(2));
        bandww = 2*abs(bwDiff);
        if bandww<50*2*pi/Fs
            bandww = 50*2*pi/Fs; %Minimum Bandwidth allowed is 50 hertz
        elseif bandww>(maxBW*2*pi/Fs) %Maximum Bandwidth allowed is 20000 hertz
            bandww = maxBW*2*pi/Fs;
        end
        bandw(tagIndex) = bandww; 
        
        %Center Frequency cfreq doesn't change
        
        %Compute New Filter parameters
        [b a] = peq(0,peakG,cfreq(tagIndex),bandww,NdB,0);
       [newh,neww] = freqz(b,a);
        newh = 20*log10(abs(newh));
        
        %Update Line for the chosen band
        set(eval(['line' tag(end)]),'ydata',newh,'xdata',neww);
        set(eval(['gain' tag(end)]),'Marker','o','MarkerEdgeColor','k',...
             'MarkerFaceColor',col,'LineStyle','none','markersize',6);

        H(:,tagIndex) = newh;
        EqData.H = H;
        %EqData.centerFreq = cfreq;
        EqData.bandW = bandw;

        
        allH = sumNorm(sum(H,2));
        setappdata(gcf,'allH',allH);
        set(line4,'ydata',allH,'xdata',neww);
        
        setappdata(gcf,'eqData',EqData);
        
        peakVal = sprintf('%.1f',peakG);
        numFreq = numFormat(cfreq(tagIndex),Fs);
        numBandw = numFormat(bandw(tagIndex),Fs);
        
        set(freqText,'string',['Center Frequency: ',numFreq],'color',col,'fontangle','italic');
        set(peakText,'string',['Peak Value: ',peakVal,' dB'],'color',col,'fontangle','italic');
        set(bandwText,'string',['Bandwidth: ',numBandw],'color',col,'fontangle','italic');
        
        drawnow
    end;
    
% Execute the WindowButtonUpFcn        
elseif strcmp(state,'up')
    
    tag = get(gco,'Tag');
    tagIndex = eval(tag(end));
    switch tag(end)
        case '1', col = color1;
        case '2', col = color2;
        case '3', col = color3;
    end
    
    eqData = getappdata(gcf,'eqData');
    H = eqData.H;
    myH = H(:,tagIndex);
    hmax = max(myH);
    hmin = min(myH);
    
    if abs(hmax) < 0.00001
        hmax = hmin;
    end
    
    cf = eqData.centerFreq;
    cfreq = cf(tagIndex);
    bw = eqData.bandW;
    bandw = bw(tagIndex);

    text1 = findobj(gcf,'tag','text1');
    gain1 = findobj(gcf,'tag','peakgain1');
    line1 = findobj(gcf,'tag','line1');
    
    gain2 = findobj(gcf,'tag','peakgain2');
    line2 = findobj(gcf,'tag','line2');
    
    gain3 = findobj(gcf,'tag','peakgain3');
    line3 = findobj(gcf,'tag','line3');   
    
    % Call the PEQ function to get the filter coefficients
    [b a descTxt] = peq(0,hmax,cfreq,bandw,0.707,1);

    disp(['Changing filter coefficients for band: ',num2str(tag(end))]);
    writeCoeffToWS(b,a,tag(end),descTxt);
    
    % Update Model with new parameters.
    try
        set_param(bdroot,'SimulationCommand','update');    
    catch me
        error (message('dsp:dspparameq_GUI:modelUpdateFailed'));%error('Cannot update Simulink model'); 
    end

    set(text1,'string','Click and drag on the Colored Round Markers or the Colored Lines');
    set(eval(['gain' tag(end)]),'Marker','o','MarkerEdgeColor','k',...
            'MarkerFaceColor',col,'LineStyle','none','markersize',6);
    set(eval(['line' tag(end)]),'color',col,'linewidth',2);

    set(gcf,'WindowButtonMotionFcn','');
    set(gcf,'WindowButtonUpFcn','');
    
    % Save the new settings in the persistent variables
    
    switch str2double(tag(end))
        case 1
            bandw1 = bandw;
            centerfreq1 = cfreq;
            pk1= hmax;
        case 2
            bandw2 = bandw;
            centerfreq2 = cfreq;
            pk2 = hmax;
        case 3
            bandw3 = bandw;
            centerfreq3 = cfreq;
            pk3 = hmax;
    end
    
elseif strcmp(state,'close')
    clear notfirst;    
    clear pk1;
    clear centerfreq1;
    clear bandw1;
    clear pk2;
    clear centerfreq2;
    clear bandw2;
    clear pk3; 
    clear centerfreq3; 
    clear bandw3;
end

function out = numFormat(x,Fs)
%This function is for formatting the display of the frequency values
x = x*Fs/(2*pi); %Convert from radians/sec to absolute frequency in Hz
if (x/1000)<1
    out = [sprintf('%0.1f',x) ' Hz'];
else
    s = sprintf('%0.3g',x/1000);
    out = [s,' kHz'];
end

function normSumH = sumNorm(x)
% Look for the center of the freq response range, and force this to be 0 dB.
normSumH= x; % -(max(x)+min(x))/2;

%% PEQ - Calculate Parametric Equalizer Coefficient
function [b a desctxt] = peq(Gref, G0, w0, BW, NdB,descOrNot)
% Returns a DFILT filter object after designing the parametric equalizer
% given the filter specification attributes.
Fs = 48000;
BW = BW*Fs/(2*pi);
F0 = w0*Fs/(2*pi);
GBW = G0*NdB;
tmptxt = [];
f = design( fdesign.parameq(...
      ['N,' 'F0,' 'BW,' 'Gref,' 'G0,' 'GBW'],...
        2,   F0,   BW,   Gref,   G0,   GBW, Fs));
%myfilt = design(f);
[b,a] = tf(f);
if descOrNot
    desctxt = getDesignInfoFromDfilt(f);
end
    

    
%% Helper Functions

function writeCoeffToWS(b, a, bandIndex,txt) %bandIndex)
% This helper function takes the filter coeff and the band index passed in
% as the input arguments, and writes it to the base workspace to the corresponding 
% band's coefficient variable. It also writes the value and the filter description  
% to the appropriate MPT object. 
%

    myCoeffsMatrix = [b(1) b(2) b(3) a(2) a(3)]';
        
    varName = ['coeffsMatrix' num2str(bandIndex)];
    mptObjName = ['CoeffsMatrix' num2str(bandIndex)];
    assignin('base', varName, myCoeffsMatrix);
        
    % Write filter coeff value to MPT Object
    evalin(  'base', [mptObjName '.Value = ' varName ';']);
    
   if nargin == 4 
       %Get the filter description and write it to MPT Object
        assignin('base','tmptxt',txt);
        evalin(  'base', [mptObjName '.Description =  tmptxt ;']);
        evalin( 'base','clear tmptxt');
   end



