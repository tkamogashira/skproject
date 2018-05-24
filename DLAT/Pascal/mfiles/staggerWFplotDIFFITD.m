function ArgOut = staggerWFplotDIFFITD(DLAT, intensity,delay,normintens, sf)

% StaggerWFplotDIFFITD(DLAT, intensity, delay, normintens, sf))
%
% subtracts waterfallplot-curve at delay zero from curve at 'delay' (in ms) of a non-reference intensity1 (thus ITD 'delay' vs ITD of 0 ms),
% in order to estimate the change in activity for a change in ITD
%
% a struct array is returned with fiber information and the values of the differences in activity
%
% normintens is the intensity whose correlogram all correlograms are normalized to, and
% sf is the scaling factor (Hz/unit magnitude)
%
%
% TF 13/09/2005

xmin = -0.5;
xmax = 0.5;
ymin = 0;
ymax = 5000;

figure;
axis([xmin xmax ymin ymax]);
title(['Difference in activity for ITD ' num2str(delay) 'ms vs. 0 ms delay, @' num2str(intensity) 'dB-70dB']);
xlabel('Delay (ms)');
ylabel(['CF (Hz)']);
line([(xmin+xmax)/2 (xmin+xmax)/2],[ymin ymax],'color',[0 0 0],'LineStyle','--');

% Plotting unit box
% Calculate sizes of current axis ...
A=axis; XRng=A(1:2); YRng=A(3:4);
Xsize = abs(diff(XRng)); Ysize = abs(diff(YRng));
%Find coordinates of lower left corner ...
[Xllc, Yllc] = deal(XRng(1) + 0.050*Xsize, YRng(1) + 0.025*Ysize);
%Find width and height of box ...
[Width, Height] = deal(0.005*Xsize, sf);
%Plot unitbox ...
rectangle('Position', [Xllc, Yllc, Width, Height], 'EdgeColor', 'k', ...
    'FaceColor', [1 1 1], 'LineStyle', '-');
rectangle('Position', [Xllc, Yllc, Width, Height/2], 'EdgeColor', 'k', ...
    'FaceColor', [0 0 0], 'LineStyle', '-');
%Plot legend ...
text(Xllc+Width+0.010*Xsize, Yllc, '0.0', 'fontsize', 5, ...
    'fontweight', 'light');
text(Xllc+Width+0.010*Xsize, Yllc+(Height/2), '0.5', 'fontsize', 5, ...
    'fontweight', 'light');
text(Xllc+Width+0.010*Xsize, Yllc+Height, '1.0', 'fontsize', 5, ...
    'fontweight', 'light');
text(Xllc-0.02*Xsize, Yllc+0.2*Height,['Activity difference'], 'fontsize', 10, 'fontweight', 'normal', 'Rotation', 90);
hold off;
%Show scaling factor
text(XRng(2) - 0.2*Xsize, Yllc, ['current SF: ' num2str(sf) ' Hz/ms'], 'fontsize', 10, 'fontweight', 'light');

nd = numel(DLAT);
D=DLAT;

ArgOut = rmfield(DLAT, {'normco','xval','yval','ppnormmagn','spdelay','spnormmagn','slope'});
ArgOut(1).intensity = NaN;
ArgOut(1).delay = NaN;
ArgOut(1).diffactivity = NaN;

for i=1:nd
    
    if ~isempty(find(D(i).xval==intensity))
        
        idx = find(D(i).xval==intensity);
        nidx = find(D(i).xval==normintens);
        
        %Normalize
        nfactor = D(i).ppnormmagn(nidx); %the normalize factor is the height of the central peak of the normintensity-correlogram
        D(i).normco(idx,:) = (D(i).normco(idx,:))/nfactor; %normalize curves to primary peak of normto-intensity
        
        %compute change in activity for the given delay
        if (D(i).lag(idx,1)+delay) >= D(i).lag(idx,1), begintimedelay = D(i).lag(idx,1)+delay;else, begintimedelay = D(i).lag(idx,1);end
        begintime=begintimedelay-delay;    
        if (D(i).lag(idx,numel(D(i).lag(idx,:)))+delay) <= D(i).lag(idx,numel(D(i).lag(idx,:))), endtimedelay = D(i).lag(idx,numel(D(i).lag(idx,:)))+delay;else, endtimedelay = D(i).lag(idx,numel(D(i).lag(idx,:)));end    
        endtime=endtimedelay-delay; 
        beginidxdelay = find(abs(D(i).lag(idx,:)-begintimedelay)<=2.680e-014);
        beginidx = find(abs(D(i).lag(idx,:)-begintime)<=2.680e-014);
        endidxdelay = find(abs(D(i).lag(idx,:)-endtimedelay)<=2.680e-014);
        endidx = find(abs(D(i).lag(idx,:)-endtime)<=2.680e-014);
            
        diffnormco = D(i).normco(idx,beginidxdelay:endidxdelay) - D(i).normco(idx,beginidx:endidx);
        
        %scale to cf
        diffnormco = sf*diffnormco + D(i).cf; 
        
        % plot difnormco
        % (difcor data plotted as blue, non-difcor-data as red)
        if D(i).difcor == 1, 
            line(D(i).lag(idx,beginidx:endidx) , diffnormco, 'LineStyle', '-', 'Color', [0 0 1]);
        elseif D(i).difcor == 0,
            line(D(i).lag(idx,beginidx:endidx) , diffnormco, 'LineStyle', '-', 'Color', [1 0 0]);
        else, disp(['error with difcorness for row '  num2str(i)]);
        end
        
       
        ArgOut(i).intensity = intensity;
        ArgOut(i).delay = delay;
        ArgOut(i).diffactivity = diffnormco;
    end
end