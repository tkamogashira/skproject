function h = parmcont(n)
%PARMCONT Convert time-value pairs to linear tracks.

%   Copyright (c) 2001 by Michael Kiefte.

names = fieldnames(n);
h = n;
deltat = n.nws/n.sr*1000;
for i = 1:length(names)
	field = getfield(n, names{i});
	if isstruct(field)
		h = setfield(h, names{i}, track(field.xdata, ...
			field.ydata, deltat)); 
	end
end
