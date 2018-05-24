function ArgOut = staggerWFplotDIFFILD(DLAT, intensity1, intensity2, normintens, sf)

% StaggerWFplotDIFFILD(DLAT, intensity1, intensity2, normintens, sf))
%
% subtracts waterfallplot-curves of two non-reference intensities (thus two ILDs), in order to estimate the change in 
% activity for a change in ILD
% 'intensity1' and 'intensity2' specify from which two non-reference-intensities curves are taken. The activity associated
% with the curve at intensity 2 is substracted from that at intensity 1 and plotted
%
% a struct array is returned with fiber information and the values of the differences in activity
%
% normintens is the intensity whose correlogram all correlograms are normalized to, and
% sf is the scaling factor (Hz/unit magnitude)
%
% colorscale (see code) specifies if the activitydifference-values are plotted as colors or as waterfallplotcurves
%
% TF 13/09/2005

colorscale = 1;

xmin = -0.5;
xmax = 0.5;
ymin = 0;
ymax = 5000;

figure;
axis([xmin xmax ymin ymax]);
title(['Difference in activity for ILD ' num2str(intensity1) 'dB-70dB with respect to ' num2str(intensity2) 'dB-70dB']);
xlabel('Delay (ms)');
ylabel(['CF (Hz)']);
line([(xmin+xmax)/2 (xmin+xmax)/2],[ymin ymax],'color',[0 0 0],'LineStyle','--');

if colorscale == 0
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
text(Xllc-0.02*Xsize, Yllc+0.2*Height,['Activity difference: ' num2str(intensity1) 'dB/70dB - ' num2str(intensity2) 'dB/70dB'], 'fontsize', 10, 'fontweight', 'normal', 'Rotation', 90);
hold off;
%Show scaling factor
text(XRng(2) - 0.2*Xsize, Yllc, ['current SF: ' num2str(sf) ' Hz/ms'], 'fontsize', 10, 'fontweight', 'light');
end

nd = numel(DLAT);
D=DLAT;

ArgOut = rmfield(DLAT, {'normco','xval','yval','ppnormmagn','spdelay','spnormmagn','slope'});
ArgOut(1).intensity1 = NaN;
ArgOut(1).intensity2 = NaN;
ArgOut(1).diffactivity = NaN;

for i=1:nd
    
    if ~isempty(find(D(i).xval==intensity1))&~isempty(find(D(i).xval==intensity2))
        
        idx1 = find(D(i).xval==intensity1);
        idx2 = find(D(i).xval==intensity2);
        nidx = find(D(i).xval==normintens);
        
        %Normalize
        nfactor = D(i).ppnormmagn(nidx); %the normalize factor is the height of the central peak of the normintensity-correlogram
        D(i).normco(idx1,:) = (D(i).normco(idx1,:))/nfactor; %normalize curves to primary peak of normto-intensity
        D(i).normco(idx2,:) = (D(i).normco(idx2,:))/nfactor;
        
        
        diffnormco = D(i).normco(idx1,:) - D(i).normco(idx2,:);
        
        %scale to cf
        if colorscale == 0, diffnormco = sf*diffnormco + D(i).cf; 
        elseif colorscale ~= 1, error('variable ''colorscale'' has to be 0 or 1');
        end
        % plot difnormco
        if colorscale == 0
        % (difcor data plotted as blue, non-difcor-data as red)
        if D(i).difcor == 1, 
            line(D(i).lag , diffnormco, 'LineStyle', '-', 'Color', [0 0 1]);
        elseif D(i).difcor == 0,
            line(D(i).lag , diffnormco, 'LineStyle', '-', 'Color', [1 0 0]);
        else, disp(['error with difcorness for row '  num2str(i)]);
        end
        elseif colorscale == 1,
            %under construction
        end
        ArgOut(i).intensity1 = intensity1;
        ArgOut(i).intensity2 = intensity2;
        ArgOut(i).diffactivity = diffnormco;
    end
end