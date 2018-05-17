function parameters = handsy(command, argument, g0, nws, sr, bgs)
%HANDSY Interactive synthesis parameter tool
%   I = HANDSY allows the user to interactively specify the control
%   parameters for the Klatt80 speech synthesizer. The structure returned
%   in I can be used by the function PARCOEF to generate the actual
%   parameters used by the speech synthesizer COEWAV.
%   
%   HANDSY(DUR, NFC, G0, NWS, SR, BGS) additionally allows the user to
%   specify several other parameters, all of which are optional. DUR gives
%   the effective duration of the utterance in miliseconds. NFC gives the
%   number of formants in the cascade branch of the speech synthesizer. G0
%   gives the overall gain in dB. SR is the sampling rate in Hz. BGS is
%   the bandwidth of the second glottal resonator. If unspecified, the
%   default values for these parameters are 200 ms, 5 formants, 47 dB, 50
%   samples, 10 kHz, and 200 Hz respectively. All arguments must be
%   integer scalars.
%
%   The most common usage is simply:
%   
%   i = handsy(DUR);
%
%   which specifies the duration.

%   Copyright (c) 2000 by Michael Kiefte

%   Based on the FORTRAN program HANDSY.FOR in Klatt (1980) "Software for
%   a cascade/parallel formant synthesizer," J. Acoust. Soc. Am. 67,
%   971-995.

% default duration is 200 ms
if nargin < 1 command = 200; end

if ~ischar(command)

	title = 'Klatt Cascade/Parallel Formant Synthesizer';

	% process arguments

	% number of cascade formants
	if nargin < 2
		nfc = 5;
	elseif	~isnumeric(argument) | max(size(argument)) ~= 1 | ...
			argument < 4 | argument > 6 | ...
			round(argument) ~= argument
		error('Number of cascade formants must be 4, 5, or 6.')
	else
		nfc = argument;
	end

	% overall gain
	if nargin < 3
		g0 = 47;
	elseif ~isnumeric(g0) | max(size(g0)) ~= 1 | ...
			g0 < 0 | g0 > 80 | round(g0) ~= g0
		error('Overall gain must be an integer between 0 and 80.')
	end

	% number of samples per update chunk
	if nargin < 4
		nws = 50;
	elseif ~isnumeric(nws) | max(size(nws)) ~= 1 | ...
			nws < 1 | nws > 200 | round(nws) ~= nws
		error(['Number of waveform samples per chunk must be ' ...
			'an integer between 1 and 200.'])
	end

	% sampling rate
	if nargin < 5
		sr = 10000;
	elseif ~isnumeric(sr) | max(size(sr)) ~= 1 | ...
			sr < 5000 | sr > 20000 | round(sr) ~= sr
		error(['Sampling rate must be an integer between ' ...
			'5000 and 20000.'])
	end

	% second glottal resonator bandwidth
	if nargin < 6
		bgs = 200;
	elseif ~isnumeric(bgs) | max(size(bgs)) ~= 1 | bgs < 100 | ...
			bgs > 1000 | round(bgs) ~= bgs
		error(['Second glottal resonator bandwidth must be ' ...
			'an integer between 100 and 1000.'])
	end

	% effective utterance duration
	if isnumeric(command)
		uttdur = fix(command);
		maxdur = ceil(nws/sr*1000);
		if ~isnumeric(uttdur) | max(size(uttdur)) ~= 1 | ...
				uttdur < ceil(maxdur) | ...
				 round(uttdur) ~= uttdur
			error(sprintf(['Duration must be an integer ' ...
				'no less than %d.'], maxdur))
		end
	else	
		uttdur = 200;
	end

	% tooltips for parameter buttons
	hints = {'Amplitude of voicing (dB)', ...
		'Amplitude of frication (dB)', ...
		'Amplitude of aspiration (dB)', ...
		'Amplitude of sinusoidal voicing (dB)', ...
		'Fundamental freq. of voicing (Hz)', ...
		'First formant frequency (Hz)', ...
		'Second formant frequency (Hz)', ...
		'Third formant frequency (Hz)', ...
		'Fourth formant frequency (Hz)', ...
		'Nasal zero frequency (Hz)', ...
		'Nasal formant amplitude (dB)', ...
		'First formant amplitude (dB)', ...
		'Second formant amplitude (dB)', ...
		'Third formant amplitude (dB)', ...
		'Fourth formant amplitude (dB)', ...
		'Fifth formant amplitude (dB)', ...
		'Sixth formant amplitude (dB)', ...
		'Bypass path amplitude (dB)', ...
		'First formant bandwidth (Hz)', ...
		'Second formant bandwidth (Hz)', ...
		'Third formant bandwidth (Hz)', ...
		'Cascade/parallel switch', ...
		'Glottal resonator 1 frequency (Hz)', ...
		'Glottal resonator 1 bandwidth (Hz)', ...
		'Glottal zero frequency (Hz)', ...
		'Glottal zero bandwidth (Hz)', ...
		'Fourth formant bandwidth (Hz)', ...
		'Fifth formant frequency (Hz)', ...
		'Fifth formant bandwidth (Hz)', ...
		'Sixth formant frequency (Hz)', ...
		'Sixth formant bandwidth (Hz)', ...
		'Nasal pole frequency (Hz)', ...
		'Nasal pole bandwidth (Hz)', ...
		'Nasal zero bandwidth (Hz)'};
		
	% button strings
	names = {'av','af','ah','avs','f0','f1','f2','f3','f4','fnz', ...
		'an','a1','a2','a3','a4','a5','a6','ab','b1','b2', ...
		'b3','sw','fgp','bgp','fgz','bgz','b4','f5','b5','f6', ...
		'b6','fnp','bnp','bnz'};
	nfield = length(names);

	maxval = [80,80,80,80,500,900,2500,3500,4500,700, ...
		80,80,80,80,80,80,80,80,1000,1500, ...
		2000,1,600,2000,5000,10000,3000,4900,4000,4999, ...
		2000,500,500,500];
	minval = [0,0,0,0,0,150,500,1300,2500,200, ...
		0,0,0,0,0,0,0,0,40,40, ...
		40,0,0,100,0,100,100,3500,150,4000, ...
		200,200,50,50];
	values = [0,0,0,0,0,450,1450,2450,3300,250, ...
		0,0,0,0,0,0,0,0,50,70, ...
		110,0,0,100,1500,6000,250,3750,200,4900, ...
		1000,250,100,100];

	% should the final node be forced to 0? Otherwise the final
	% node is fixed to value of the penultimate node (you can't
	% actually move the final node
	term0 = [1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, ...
		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ...
		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ...
		0, 0, 0, 0];

	% set up dialog
	% fix figure size
	cf = dialog('Visible', 'off', ...
		'Pointer', 'arrow', ...
		'BackingStore', 'off', ...
		'IntegerHandle', 'off', ...
		'WindowStyle', 'normal', ...
        'resize', 'on', ...
		'HandleVisibility', 'callback', ...
		'Name', title);
    
	% arange parameters as three columns of equal sized buttons on
	% the left-hand side
	pos = get(cf, 'Position');
    ncol = 3;
	nrow = ceil(nfield/ncol);
	bsize = pos(4)/nrow;

	% draw buttons
	% UserData property contains parameter information including:
	% nodes: handle to nodes line (MarkerType = 'o')
	% contour: handle to contour line (Color = 'r')
	% xdata: node times
	% ydata: node values
	% xdata and ydata must be the same length and have a minimum
	% of two nodes including the first and last
	for i = 1:nfield
		c = fix((i-1)/nrow) + 1;
		r = nrow - (i - (c-1)*nrow) + 1;
		h = uicontrol('Position', [(c-1)*bsize, (r-1)*bsize, ...
					bsize, bsize], ...
            'Parent', cf, ...
			'String', names{i}, ...
			'CallBack', 'handsy(''draw'')', ...
			'BackgroundColor', [.75 .75 .75], ...
			'Tag', 'parameter', ...
			'TooltipString', hints{i}, ...
			'UserData', struct('maxval', maxval(i), ...
				'minval', minval(i), ...
				'term0', term0(i), ...
				'xdata', [0 uttdur], ...
				'ydata', values([i i]), ...
				'nodes', [], ...
				'contour', []));
        set(h, 'Units', 'normalized');    
	end

	% allow reediting of parameter structs
	if isstruct(command)
		if nargin > 1
			error('Only one struct argument allowed.')
		end

		bgs = double(command.bgs);
		sr = double(command.sr);
		nws = double(command.nws);
		g0 = double(command.g0);
		nfc = double(command.nfc);
		d = nws/sr*1000;
		uttdur = 0;

		% get button names and match them up with struct
		% fields
		h = findobj(cf, 'Tag', 'parameter');
		for i = 1:length(h)
			s = get(h(i), 'UserData');
			field = getfield(command, get(h(i), ...
				'String'));
			s.maxval = field.maxval;
			s.minval = field.minval;
			s.term0 = field.term0;
			s.xdata = field.xdata;
			s.ydata = field.ydata;
			uttdur = max(uttdur, max(s.xdata));
			set(h(i), 'UserData', s)
		end
	end

	% OK button returns control to the main window. Should
	% probably warn the user. UserData contains the parameter
	% update rate in ms
	h = uicontrol('Position', [ncol*bsize+bsize/4 bsize/4 bsize bsize/2], ...
		'Parent', cf, ...
		'String', 'OK', ...
		'TooltipString', 'Return now', ...
		'CallBack', 'handsy(''close'')', ...
		'UserData', nws/sr*1000, ...
		'Tag', 'deltat');
    set(h, 'units', 'normalized');

	h = uicontrol('Position', [ncol*bsize+bsize/4 bsize+bsize/4 bsize bsize/2], ...
		'Parent', cf, ...
		'String', 'play', ...
		'TooltipString', 'Synthesize and play utterance', ...
		'CallBack', 'handsy(''play'')', ...
		'UserData', [bgs, sr, nws, g0, nfc], ...
		'Tag', 'const');
    set(h, 'Units', 'normalized');
		
	h = uicontrol('Parent', cf, ...
		'Position', [ncol*bsize+bsize/2 pos(4)/2-bsize 2*bsize/3 2*bsize/3], ...
		'TooltipString', 'lower value', ...
		'CallBack', 'handsy(''label'',''v'')', ...
		'String', 'v');
    set(h, 'Units', 'normalized')
	h = uicontrol('Parent', cf, ...
		'Position', [ncol*bsize+bsize/2 pos(4)/2+bsize 2*bsize/3 2*bsize/3], ...
		'TooltipString', 'raise value', ...
		'CallBack', 'handsy(''label'',''^'')', ...
		'String', '^');
    set(h, 'Units', 'normalized');
    pos = get(h, 'Position');
	% XLim property indicates effective duration
	axes('Units', 'normalized', ...
		'Position', [pos(1)+.1 .05 1-pos(1)-.15 .9], ...
		'Parent', cf, ...
		'XLim', [0 uttdur], ...
		'YTick', [], ...
		'DrawMode', 'fast', ...
		'XGrid', 'on', ...
		'YGrid', 'on', ...
		'Box', 'on')

 	uiwait(cf)
 	parameters = get(cf, 'UserData');
	close(cf)
 
else

	% this function is also used for callback routines which must
	% have a string as the first argument (command)

	switch command

	% move a node
	% argument must be either the new point or empty (in the case
	% of node dragging
	case 'change'
		if isempty(argument)
			pp = get(gca, 'CurrentPoint');
			p = pp(1,1:2);
		else
			p = argument;
		end

		u = get(gcbf, 'UserData'); % see comment below in
						% 'contour'

		% times and values are always rounded to integers
		x = round(p(1)/u(3))*u(3);
		y = min(max(round(p(2)), u(4)), u(5));
		xdata = get(u(1), 'XData');
		ydata = get(u(1), 'YData');
		ydata(u(2)) = y; % set parameter value
		
		% only if an intermediate node
		if u(2) ~= 1 & u(2) ~= length(xdata)
			xdata(u(2)) = x;
		end

		% if a node has an illegal time value (before the last
		% node or after the next node) the contour is not drawn
		% (since MATLAB's interp1q will produce an error).
		% Nodes that are dragged to illegal time values are
		% ultimately deleted in 'set' below
		if u(2) == 1 | u(2) == length(xdata) | ...
				(x > xdata(u(2)-1) & x < xdata(u(2)+1))

			% if there is no restriction on the value of the
			% terminal node, make sure it's the same as the
			% next-to-last node
			if u(2) >= length(xdata) - 1 & ~u(10)
		 		ydata(end-1:end) = y;
			end

			[yi, xi] = track(xdata, ydata, u(3));

			% draw contour line (in red)
			xi = [xi(1); xi(repmat(2:length(xi), 2, 1),:)];
			yi = [yi(repmat(1:length(yi)-1, 2, 1),:); ...
					yi(end)];
			set(u(9), 'XData', xi, 'YData', yi)
		else
			% illegal time value
			set(u(9), 'XData', [], 'YData', [])
		end

		% update time and value labels
		set(u(6), 'String', num2str(xdata(u(2))))
		set(u(7), 'String', num2str(ydata(u(2))))

		% update node line ('MarkerType' = 'o')
		set(u(1), 'XData', xdata, 'YData', ydata)

	% finished changes
	case 'set'

		% for some reason I decided to pass the current
		% figure's UserData as the argument.
		u = argument;

		h = get(u(1), 'UserData');
		s = get(h, 'UserData');

		% node data
		xdata = get(u(1), 'XData');
		ydata = get(u(1), 'YData');

		% if illegal time value, delete that node
		if (u(2) > 1 & xdata(u(2)) <= xdata(u(2)-1)) | ...
				(u(2) < length(xdata) & ...
				xdata(u(2)) >= xdata(u(2)+1))
			xdata(u(2)) = [];
			ydata(u(2)) = [];

			% deleted next-to-last node
			if u(2) == length(xdata)
				if s.term0
					ydata(end-1) = ydata(end);
				else
					ydata(end) = ydata(end-1);
				end
			end
			[yi, xi] = track(xdata, ydata, u(3));

			% redraw line
			xi = [xi(1); xi(repmat(2:length(xi), 2, 1),:)];
			yi = [yi(repmat(1:length(yi)-1, 2, 1),:); yi(end)];
			set(u(9), 'XData', xi, 'YData', yi)
			set(u(1), 'XData', xdata, 'YData', ydata)
			set(u(6:7), 'UserData', [])	
		end

		% make sure structure in the button's UserData is
		% updated
		s.xdata = xdata;
		s.ydata = ydata;
		set(h, 'UserData', s);

	% close figure and return control to main window
	case {'close','play'}
		if strcmp(command, 'close') ...
			& strcmp(questdlg('Do you really want to quit', ...
				'No'), 'No')
			return
		end
		pars = []; % to be put in figure UserData
		d = get(findobj(gcbf,'Tag', 'deltat'), ...
			'UserData'); % update rate
		h = findobj(gcbf, 'Tag', 'parameter');
		for i = 1:length(h)
			s = get(h(i), 'UserData');
			s = rmfield(rmfield(s, 'nodes'), ...
				'contour');
			pars = setfield(pars, get(h(i), 'String'), s);
		end
		h = findobj(gcbf, 'Tag', 'const');
		const = get(h, 'UserData');
		pars.bgs = const(1);
		pars.sr = const(2);
		pars.nws = const(3);
		pars.g0 = const(4);
		pars.nfc = const(5);
		if strcmp(command, 'close')
			set(gcbf, 'UserData', pars)
			uiresume(gcbf) % return control to main
					% program
		else
			fs = pars.sr;
			n = parmcont(pars);
			c = parcoef(n);
			x = coewave(c);
			delete(findobj(gcbf, 'Type', 'image'))
			y = filter([1, -.96], 1, x);
			winlen = round(2*fs/320);
			cf = findobj('Tag', 'spectrogram');
			if isempty(cf)
				cf = figure;
				set(cf, 'Tag', 'spectrogram', ...
					'Name', 'spectrogram')
			else
				delete(findobj(cf, 'Type', 'axes'))
			end
			set(0, 'CurrentFigure', cf)
			a = axes;
			units = get(a, 'Units');
			set(a, 'Units', 'pixels');
			pos = get(a, 'Position');
			set(a, 'Units', units);
			hop = min(max(round((length(y) - winlen) ...
				/(pos(3) - 1)), 1), winlen-1);
			nfft = max(2*2^nextpow2(pos(4)), ...
				2^nextpow2(winlen));
			window = hamming(winlen);
			[b f t] = specgram(y, nfft, fs, window, ...
				winlen - hop);

			amp = 20*log10(abs(b));
			amp = amp - max(amp(:));
			amp(amp < -41) = -41;
			imagesc((t+winlen/(2*fs))*1000, f, amp);
			axis xy
			colormap(jet)
			xlabel('Time (ms)')
			ylabel('Frequency (Hz)')
			grid on
			for i = 1:6
				h = findobj(gcbf, 'Tag', 'parameter', ...
					'String', sprintf('f%d', i));
				sf = get(h, 'UserData');
				h = findobj(gcbf, 'Tag', 'parameter', ...
					'String', sprintf('b%d', i));
				sb = get(h, 'UserData');
				[yf xf] = track(sf.xdata, sf.ydata, d);
				line(xf, yf, 'EraseMode', 'xor', ...
					'LineWidth', 2)
			end
			hold off

			cf = findobj('Tag', 'waveform');
			if isempty(cf)
				cf = figure;
				set(cf, 'Tag', 'waveform', ...
					'Name', 'waveform');
			end
			set(0, 'CurrentFigure', cf);
			plot((0:length(x)-1)/fs*1000, x)
			xlabel('Time (ms)')
			sound(x, fs)
			set(0, 'CurrentFigure', gcbf)
			figure(gcbf)
		end

	% clicking on x and y labels allows the user to input time or
	% parameter value. Argument is either 'x' or 'y'.
	case 'label'
		h = findobj(gcbf, 'Tag', 'xlabel');
		if isempty(h)
			return
		end
		u = get(h, 'UserData');
		if isempty(u) | ~ishandle(u(1))
			return
		end % safeguard

		xdata = get(u(1), 'XData');
		ydata = get(u(1), 'YData');
		oldx = str2num(get(u(6), 'String'));
		oldy = str2num(get(u(7), 'String'));

		switch argument
		case 'v'
			isy = 1;
			new = oldy - 1;
		case '^'
			isy = 1;
			new = oldy + 1;
		otherwise
			isy = argument == 'y';
			answer = inputdlg(sprintf('New %s value', argument), ...
				'Change value', 1, {num2str(data)});
			% returns a cellstr
			if ~isempty(answer)
				new = str2num(answer{1}); 
			else
				% pressed cancel
				return
			end
		end

		if isy
			data = oldy;
		else
			data = oldx;
		end

		% input a valid number
		if ~isempty(new)
			if isy
				p = [oldx new];
			else
				p = [new oldy];
			end
			
			% update lines
			handsy('change', p)
			handsy('set', u)
		end

	% clicked on the node line
	case 'contour'
		u = get(gcbf, 'UserData');

		% get rid of x and y labels
		if ~isempty(u)
			delete(u(6:7))
			set(gcbf, 'UserData', [])
		end

		pos = get(gca, 'CurrentPoint');
		pos = pos(1, 1:2);

		% update rate
		d = get(findobj(gcbf, 'Tag', 'deltat'), 'UserData');

		% this allows for a bit of error when selecting an
		% already-present node
		pos(1) = round(pos(1)/d)*d;
		pos(2) = round(pos(2));

		h = get(gcbo, 'UserData'); % handle to button object
		s = get(h, 'UserData'); % which contains parameter
					% data

		% don't know if we clicked on node line or contour
		% line so we have to use s.nodes instead of gcbo
		xdata = get(s.nodes, 'XData');
		ydata = get(s.nodes, 'YData');

		if ~any(pos(1) == xdata)
			% new node
			% insert node in line
			ydata = [ydata pos(2)];
			[xdata i] = sort([xdata pos(1)]);
			ydata = ydata(i);

			% update lines
			set(s.nodes, 'XData', xdata, 'YData', ydata)
			[yi, xi] = track(xdata, ydata, d);
			xi = [xi(1); xi(repmat(2:length(xi), 2, 1),:)];
			yi = [yi(repmat(1:length(yi)-1, 2, 1),:); yi(end)];
			set(s.contour, 'XData', xi, 'YData', yi)
		elseif pos(1) == xdata(end)
			% can't change terminal node manually
			return
		end

		% get default x and y label position from axes.
		% if we actually used the x and y labels handles from
		% the axes properties, the axes would flicker every time
		% we update the time and parameter values. So we put a
		% text object on top of the x and y label positions
		% independently of the axes properties to eliminate
		% flicker.
		h = xlabel('');
		p = get(h, 'Position');

		% xlabel indicates time
		xl = text(p(1), p(2), int2str(pos(1)), ...
			'HorizontalAlignment', 'center', ...
			'VerticalAlignment', 'top', ...
			'Tag', 'xlabel', ...
			'ButtonDownFcn', 'handsy(''label'',''x'')');
		h = ylabel('');
		p = get(h, 'Position');

		% ylabel indicates value
		yl = text(p(1), p(2), int2str(pos(2)), ...
			'Rotation', 90, ...
			'HorizontalAlignment', 'center', ...
			'VerticalAlignment', 'bottom', ...
			'ButtonDownFcn', 'handsy(''label'',''y'')');

		% u is a vector of useful data put into the UserData
		% property of the dialog. The elements are (by index):
		% 1: handle to nodes line (linestyle = none and
		% markertype = 'o'
		% 2: index of current node being modified
		% 3: parameter update rate in miliseconds
		% 4: minimum allowable value for current parameter
		% 5: maximum allowable value for current parameter
		% 6: handle of time value string (in xlabal position)
		% 7: handle of parameter value string (in ylabel
		% position)
		% 8: effective duration of utterance in miliseconds
		% (no longer used)
		% 9: handle of contour line (color = red)
		% 10: flag indicating whether terminal node must be 0

		u = [s.nodes, find(pos(1) == xdata), d, s.minval, ...
			s.maxval, xl, yl, NaN, s.contour, s.term0];
		
		% put this in the x and y labels too.
		set([xl yl], 'UserData', u, 'FontSize', 16, ...
			'FontWeight', 'bold')

		% eliminate flicker by using xor
		set([s.nodes s.contour xl yl], 'EraseMode', 'xor');

		set(gcbf, 'UserData', u, 'WindowButtonMotionFcn', ...
			'handsy(''change'',[])', ...
			'WindowButtonUpFcn', ...
			['u=get(gcbf,''UserData'');' ...
			 'handsy(''set'',u),' ...
			 'set(u([1 9]),''EraseMode'',''normal''),' ...
			 'set(gcbf,''WindowButtonMotionFcn'','''',' ...
			 '''WindowButtonUpFcn'','''')'])
			 
	% erase parameter lines
	case 'delete'
		delete(findobj(gcbf, 'Type', 'image'))
		if nargin == 2
			cbo = findobj(gcbf, 'tag', 'parameter', ...
				'String', argument);
		else
			cbo = gcbo;
			argument = get(cbo, 'String');
		end
		s = get(cbo, 'UserData');
		h = s.nodes;
		delete(s.nodes)
		delete(s.contour)
		s.nodes = [];
		s.contour = [];
		set(cbo, 'BackgroundColor', [.75 .75 .75], 'Callback', ...
			sprintf('handsy(''draw'',''%s'')', argument), ...
			'UserData', s)
		redrawplot

	% draw parameter lines
	case 'draw'
		if nargin == 2
			cbo = findobj(gcbf, 'Tag', 'parameter', ...
				'String', argument);
		else
			cbo = gcbo;
			argument = get(cbo, 'String');
		end

		s = get(cbo, 'UserData');
		% usefull markers for nodes---all polygons
		markers = {'o', 'square', 'diamond', ...
			'v', '^', '>', '<', 'pentagram', 'hexagram'};

		% find out which markers aren't being used
		h = findobj(gcbf, 'Tag', 'nodes');
		[c, i] = setdiff(markers, get(h, 'Marker'));

		% if all used, don't draw a new line
		if isempty(c) return, end

		unused = markers{min(i)};

		% update rate
		d = get(findobj(gcbf, 'Tag', 'deltat'), 'UserData');

		% draw lines
		[yi, xi] = track(s.xdata, s.ydata, d);
		xi = [xi(1); xi(repmat(2:length(xi), 2, 1),:)];
		yi = [yi(repmat(1:length(yi)-1, 2, 1),:); yi(end)];

		% contour line indicates the actual parameter values
		% after interpolation and rounding (red line)
		s.contour = line(xi, yi, ...
			'Color', 'r', ...
			'MarkerFaceColor', 'auto', ...
			'Tag', 'contour', ...
			'UserData', gcbo);

		% nodes line just gives the nodes as markers (no
		% actual line).
		s.nodes = line(s.xdata, s.ydata, ...
			'Color', 'k', ...
			'Marker', unused, 'MarkerSize', 8, ...
			'LineStyle', 'none', ...
			'MarkerfaceColor', 'auto', ...
			'Tag', 'nodes', 'UserData', cbo);
		set([s.contour s.nodes], 'ButtonDownFcn', ...
			sprintf('handsy(''contour'',''%s'')', ...
				argument))

		% make button lighter when line displayed
		set(cbo, 'BackgroundColor', [.9 .9 .9], ...
			'CallBack', 'handsy(''delete'')', ...
			'UserData', s)
		redrawplot
	end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function clearall(dummy)

h = findobj(gcbf, 'Tag', 'nodes');
if isempty(h) return, end
for i = 1:length(h)
	u = get(h(i), 'UserData');
	handsy('delete', u)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function redrawplot(dummy)
% this function updates the y-axis limits and the legend

u = get(gcbf, 'UserData');

% get rid of x and y labels
if ~isempty(u) 
	delete(u(6:7))
	set(gcbf, 'UserData', [])
end
legend off % get rid of current legend

% find all currently plotted parameter tracks
h = findobj(gcbf, 'Tag', 'nodes');

if isempty(h)
	% no tracks currently displayed
	set(gca, 'YLim', [0 1], 'YTick', [])
else
	% get handles to buttons of currently drawn parameter tracks
	param = get(h, 'UserData');

	% returned as a cell array if more than one
	if length(param) > 1 param = [param{:}]; end

	% find global minimum and maximum parameter values for all
	% currently displayed tracks
	ylim = [Inf -Inf];
	for i = 1:length(param)
		s = get(param(i), 'UserData');
		if s.minval < ylim(1) ylim(1) = s.minval; end
		if s.maxval > ylim(2) ylim(2) = s.maxval; end
	end
	set(gca, 'YLim', ylim, 'YTickMode', 'auto')
	legend(h, get(param, 'String'));
end
