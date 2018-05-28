function E = digitize(FN)
% digitize - digitize graph data from a picture
%
%   S = digitize('foo') shows the picture 'foo.*' and assists in digitizing
%   data from a graph in that picture. First, some specifications of the
%   X-axis are asked. Subsequently, axis limits are specified by clicking.
%   After repeating this for the Y-axis, data in the picture are digitized
%   by clicking on individual points. The output of Digitize is a struct 
%   (or struct array if multiple datasets are stored) with fields Xdata 
%   and Ydata. Supported file formats are listed in IMFORMATS.
%
%   See also IMFORMATS, IMREAD, ginput.
%

% Load image
I = imread(FN);
himage = imshow(I);
clc;
haxis = get(himage,'Parent');
set(haxis,'NextPlot','add')
hfigure = get(haxis,'Parent');
set(hfigure,'CloseRequestFcn','')

% Calibrate image
S = local_calib;

% Get data from picture
D = local_getdata;

% Convert data to actual values
E = local_convert(D,S);

set(hfigure,'CloseRequestFcn',@(h,evnt) closereq)


function E = local_convert(D,S)
% LOCAL_CONVERT - converts picture-space data to actual data space

% Logarithm of calibration dataspace if necessary
if strcmp(S.Xscale,'log')
    S.Xdata = log(S.Xdata);
end
if strcmp(S.Yscale,'log')
    S.Ydata = log(S.Ydata);
end
% Compute parameters of interpolation
Xalpha = diff(S.Xdata)/diff(S.Xpict);
Xbeta = S.Xdata(2)-Xalpha*S.Xpict(2);
Yalpha = diff(S.Ydata)/diff(S.Ypict);
Ybeta = S.Ydata(2)-Yalpha*S.Ypict(2);

for iD = 1:numel(D)
    % Convert raw data to normalized data
    D(iD).Xdata = (D(iD).Xpict.'-min(xlim))./diff(xlim);
    D(iD).Ydata = (D(iD).Ypict.'-min(ylim))./diff(ylim);
    % Calculate actual values
    E(iD).Xdata = Xalpha*D(iD).Xdata+Xbeta;
    E(iD).Ydata = Yalpha*D(iD).Ydata+Ybeta;
    % Exponent of digitized dataspace if necessary
    if strcmp(S.Xscale,'log')
        E(iD).Xdata = exp(E(iD).Xdata);
    end
    if strcmp(S.Yscale,'log')
        E(iD).Ydata = exp(E(iD).Ydata);
    end
end


function D = local_getdata
% LOCAL_GETDATA - gets data from graph using ginput

disp('Click on the points of the current dataset you wish to digitize and press ''enter'' when finished')

yesno = 'y';
count = 1;
while strcmpi(yesno,'y')
    [Xtemp Ytemp] = ginput;
    h = plot(gca,Xtemp,Ytemp,'g+'); % plot digitized points
    D(count).Xpict = Xtemp;
    D(count).Ypict = Ytemp;
    % Ask whether dataset is properly digitized
    keep = [];
    while ~strcmpi(keep,'y') && ~strcmpi(keep,'n')
        keep = input('Do you wish to continue and keep this dataset [y] or redo the current dataset [n]? y/n: ','s');
    end
    if strcmpi(keep,'n')
        continue
    end
    count = count+1;
    % Aske whether another dataset should be digitized
    yesno = [];
    while ~strcmpi(yesno,'y') && ~strcmpi(yesno,'n')
        yesno = input('Do you wish to digitize another dataset from this figure? y/n: ','s');
    end
    set(h,'Color','b')
end
disp(' ')


function S = local_calib
% LOCAL_CALIB - returns calibration struct

XL = xlim;
YL = ylim;

% Get calibration data for X-axis
Xmin = [];
while isempty(Xmin)
    Xmin = input('Specify the minimum of the X-axis: ');
end
disp(['     Xmin = ' num2str(Xmin)])
Xmax = [];
while isempty(Xmax)
    Xmax = input('Specify the maximum of the X-axis: ');
end
disp(['     Xmax = ' num2str(Xmax)])
S.Xdata = [Xmin Xmax];
scale = 'empty';
while ~strcmp(scale,'lin') && ~strcmp(scale,'log')
    scale = lower(input('Is the X-axis linear (lin) or logarithmic (log)? ','s'));
end
if strcmp(scale,'lin')
    disp('     linear scale')
else
    disp('     logarithmic scale')
end
S.Xscale = scale;

disp('Click on the minimum and maximum of the X-axis')
disp(' ')
pause(2)
[Xraw junk] = ginput(2); % get points from figure
%Xraw = sort(Xraw);
S.Xpict = (Xraw.'-min(xlim))./diff(xlim); % convert to normalized X-values

% Show X calibration lines in picture
plot(gca,[1 1]*Xraw(1),YL,'r-')
plot(gca,[1 1]*Xraw(2),YL,'r-')

% Get calibration data for Y-axis
Ymin = [];
while isempty(Ymin)
    Ymin = input('Specify the minimum of the Y-axis: ');
end
disp(['     Ymin = ' num2str(Ymin)])
Ymax = [];
while isempty(Ymax)
    Ymax = input('Specify the maximum of the Y-axis: ');
end
disp(['     Ymax = ' num2str(Ymax)])
S.Ydata = [Ymin Ymax];
scale = 'empty';
while ~strcmp(scale,'lin') && ~strcmp(scale,'log')
    scale = lower(input('Is the Y-axis linear (lin) or logarithmic (log)? ','s'));
end
if strcmp(scale,'lin')
    disp('     linear scale')
else
    disp('     logarithmic scale')
end
S.Yscale = scale;

disp('Click on the minimum and maximum of the Y-axis')
disp(' ')
pause(2)
[junk Yraw] = ginput(2); % get points from figure
Yraw = sort(Yraw,'descend');
S.Ypict = (Yraw.'-min(ylim))./diff(ylim); % convert to normalized Y-values

% Show Y calibration lines in picture
plot(gca,XL,[1 1]*Yraw(1),'r-')
plot(gca,XL,[1 1]*Yraw(2),'r-')

