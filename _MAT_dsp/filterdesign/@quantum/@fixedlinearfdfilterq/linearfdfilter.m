function [y,z] = linearfdfilter(this,x,d,z)
%LINEARFDFILTER   

%   Author(s): V. Pellissier
%   Copyright 2006 The MathWorks, Inc.

% Re-construct FI coeff for DataTypeOverride to work all the time
d = fi(d,0,this.privfdwl,this.privfdfl);
resetlog(d);

% Quantize input
[x, inlog] = quantizeinput(this,x);
nx = size(x,1);

% Create output
yWL = this.OutputWordLength;
yFL = this.OutputFracLength;
y = fi(zeros(size(x)), 'Signed', true, 'WordLength', yWL, ...
    'FractionLength', yFL, 'fimath', this.fimath);
resetlog(y);

% Build temp to work around fi limitations (avoid creation of temp by 
% subsref because it causes fi to loose the log report.
zlog = copy(z(1,:));
zlog(2:nx,:) = x(1:nx-1,:);
resetlog(zlog);
tapsum = fi(zeros(size(zlog)),1,...
    this.fdfimath.SumWordLength,this.fdfimath.SumFractionLength);
resetlog(tapsum);

% Attach fimaths
x.fimath = this.fdfimath;
z.fimath = this.fdfimath;
zlog.fimath = this.fdfimath;
d.fimath = this.fimath;
tapsum.fimath = this.fimath;

% Vectorized algorithm.
% Differences, products, and sums split out to capture logs.
zlog_minus_x = zlog-x;
tapsum(:,:) = zlog_minus_x;  % tapsum(:,:) = zlog-x;
x.fimath = this.fimath;
d_times_tapsum = d*tapsum; 
x_plus_d_times_tapsum = x+d_times_tapsum;
y(:,:) = x_plus_d_times_tapsum;  % y(:,:) = x+d*tapsum; 
z(1,:) = x(nx,:);

%----------------------------------------------------------------------
% Logging: min/max, range
%----------------------------------------------------------------------
if isloggingon(this),
    f = fipref;

    %----------------------------------------------------------------------
    % Fixed-point logging: min/max, range
    %----------------------------------------------------------------------
    % [prodlog, outlog, acclog, tapsumlog] = getlog(this,d,y,x,zlog);
    [prodlog, outlog, acclog, tapsumlog] = ...
        getlog(this,...
               d_times_tapsum,...
               y,...
               x_plus_d_times_tapsum,...
               zlog_minus_x);
    %----------------------------------------------------------------------
    % Build Report
    %----------------------------------------------------------------------
    if strcmpi(f.DataTypeOverride , 'forceoff'),
        qlog = quantum.linearfdreport('Fixed', ...
            quantum.fixedlog(inlog), ...
            quantum.fixedlog(outlog), ...
            quantum.fixedlog(prodlog), ...
            quantum.fixedlog(acclog),...
            quantum.fixedlog(tapsumlog));
    elseif strcmpi(f.DataTypeOverride , 'ScaledDoubles')
        qlog = quantum.linearfdreport('Double', ...
            quantum.doublelog(inlog), ...
            quantum.doublelog(outlog), ...
            quantum.doublelog(prodlog), ...
            quantum.doublelog(acclog),...
            quantum.doublelog(tapsumlog));
    end

    % Store Report in filterquantizer
    this.loggingreport = qlog;
end


% [EOF]

