function plotancdata_extrinsic(whichMode, wOrTitle, varargin)
%PLOTANCDATA_EXTRINSIC Plot data in dspAcousticNoiseCanceller_driver demo.

%   Copyright 2011 The MathWorks, Inc.

% ntraces -  number of traces
% npoints -  data points per trace for dummy data
persistent ntraces npoints iter s xlimX hbuff

mlcmexdir = [tempdir 'dspAcousticNoiseCancellermexdir'];
if(isequal(pwd,mlcmexdir))
    plotlabel= 'Filter Coefficients: Code Generation';
else
    plotlabel= 'Filter Coefficients: Simulation';
end
if isempty(ntraces) && nargin > 2
    ntraces = varargin{1};
end
if isempty(npoints) && nargin > 3
    npoints = varargin{2};
end
if isempty(iter)
    iter = -10;
end
if isempty(s)
    s = zeros(1,npoints);
end
if isempty(xlimX)
    xlimX = [-0.3 0.5];  % data range
end
if isempty(hbuff)
    hbuff = zeros(npoints,4); % Latency in plotting = 4
end
%fh = @updateplot;         % Return function handle for plotting

switch whichMode
    case 'init'
%-----------------------------------------------------------------
    % Setups up the waterfallplot

        totTraces = ntraces;
        xlimX = [-0.3 0.5];  % data range

        % setup transparency factors
        alpha = linspace(0.4,0.1,totTraces);        % identical translucency
        edgealpha = linspace(0.35,0.15,totTraces); % decreasing edges

        % If GUI is already open, tear it down.
        hfig = findobj('type','figure', ...
            'tag', 'Filter Coefficients');
        if ~isempty(hfig),
            close(hfig);
        end

        % setup patches
        hfig = figure('numbertitle','off', ...
            'name',wOrTitle, ...          
            'integerhandle','off');

        colormap(jet(totTraces))
        s = zeros(1,totTraces);
        for ii = 1:totTraces
            x = [xlimX(1) zeros(1,npoints) xlimX(1)];
            y = [1 1:npoints npoints];
            z = ii*ones(1, npoints+2);
            s(ii) = patch(x, y, z, ii, ...
                'cdatamapping', 'direct', ...
                'facealpha', alpha(ii), ...
                'edgealpha', edgealpha(ii));
        end

        % select camera view:  {cameraposition, cameraup}
        cam_view =  {[1 50 -10], [1 0 0]};

        % setup view
        grid on;
        set(gca, ...
            'xlim', xlimX, ...
            'ylim', [0 npoints+1], ...
            'zlim', [1 totTraces], ...
            'pos', [0.05 0.05 0.85 0.95]);
        set(gca,'CameraPosition', cam_view{1}, ...
          'CameraUpVector', cam_view{2})

        % turn on camera toolbar
        set(0, 'showhid', 'on');  % in case gca resolution fails
        cameratoolbar('NoReset');
        cameratoolbar('SetMode', 'orbit');
        cameratoolbar('SetCoordSys', 'x');  % or 'none'
        set(0, 'showhid', 'off');

        % draw labels
        xh = xlabel('Amplitude');
        yh = ylabel('Tap Position');
        zh = zlabel('Frames');
        set(xh, 'position', [0.4 19 -16]);
        set(yh, 'position', [0 6 -18]);
        set(zh, 'position', [0 -22 6]);
        set(zh, 'rotation', 0);
        set(xh, 'rotation', 90);
        set(xh, 'fontweight', 'bold');
        set(yh, 'fontweight', 'bold');
        set(zh, 'fontweight', 'bold');

        % insert title label
        uicontrol('style', 'text', ...
            'units', 'norm', ...
            'fontsize', 14, ...
            'fontweight', 'bold', ...
            'backgr', [0.8 0.8 0.8], ...
            'pos', [-0.1 0.9 1 0.1], ...
            'horiz', 'center', ...
            'string', plotlabel, ...
            'tag', 'Filter Coefficients');

        % Final tweaks:
        axis('vis3d')
        camzoom(.9);
        set(gca,'pos', [0 0 0.95 0.95]);
        colormap('autumn');
        set(gca,'color', [0.9 0.9 0.9]);
        set(hfig, ...
            'pos', [12 222 442 440], ...
            'color', [0.8 0.8 0.8]);
        
    case 'update'
        iter = iter + 1;
        updatefreq = 100;
        if ~mod(iter,updatefreq)
            ii = floor(mod(iter/updatefreq,4))+1;
            jj = ii - 1;
            if ~jj
                jj = 4;
            end
            hbuff(:,jj) = double(wOrTitle);
            x = get(s, 'xdata'); % get data from all traces
            x(2:ntraces) = x(1:ntraces-1); % move trace data back by one trace
            
            x(1) = {[xlimX(1) (hbuff(:,ii))' xlimX(1)]}; % add endpoints
            set(s, {'xdata'}, x);
            drawnow;
        end
end