function [y,z] = farrowfdfilter(this,C,x,d,z)
%FARROWFDFILTER   

%   Author(s): V. Pellissier
%   Copyright 2006 The MathWorks, Inc.

nd = size(C,1);
nx = size(x,1);
z = [z(1,:);z];
[nz nchans] = size(z);
resetlog(C);

% Re-construct FI coeff for DataTypeOverride to work all the time
d = fi(d,0,this.privfdwl,this.privfdfl);
resetlog(d);

% Quantize input
[x, inlog] = quantizeinput(this,x);

% Create output
yWL = this.OutputWordLength;
yFL = this.OutputFracLength;
y = fi(zeros(size(x)), 'Signed', true, 'WordLength', yWL, ...
    'FractionLength', yFL, 'fimath', this.fdfimath);
resetlog(y);

% Build temp to work around fi limitations (avoid creation of temp by 
% subsref because it causes fi to loose the log report.
zlog = repmat(z,[1 1 nx]);
for m=1:nx-1,
    zlog(1,:,m) = x(m,:);
    zlog(2:nz,:,m+1) = zlog(1:nz-1,:,m);
end 
zlog(1,:,nx) = x(nx,:);
resetlog(zlog);

% Final states
z = zlog(1:nz-1,:,nx);

% Create polyphase output
p = fi(zeros(nd-1,nx), 'Signed', true, 'WordLength', this.AccumWordLength, ...
    'FractionLength', this.AccumFracLength, 'fimath', this.fdfimath);
resetlog(p);
plast = fi(zeros(1,nx), 'Signed', true, 'WordLength', this.AccumWordLength, ...
    'FractionLength', this.AccumFracLength, 'fimath', this.fdfimath);
resetlog(plast);
fdprod = fi(zeros(1,nx), 'Signed', true, 'WordLength', this.FDProdWordLength, ...
    'FractionLength', this.FDProdFracLength, 'fimath', this.fdfimath);
resetlog(fdprod);
mult = fi(zeros(1,nx), 'Signed', true, 'WordLength', this.privmultwl, ...
    'FractionLength', this.privmultfl, 'fimath', this.fdfimath);
resetlog(mult);

% Attach fimaths
C.fimath = this.fimath;
zlog.fimath = this.fimath;
fp = fimath('RoundMode', this.fimath.RoundMode, 'OverflowMode', this.fimath.OverflowMode); % Full Precision
d.fimath = this.fdfimath;

% Workaround: avoid creation of temp by subsref into C because it causes fi
% to loose the log report.
Clast = copy(C);
Clast(1:nd-1,:) = [];
resetlog(Clast);
C(nd,:) = [];
resetlog(C);

for nchan=1:nchans
    % ---------------------------------------------------------------------
    % Step 1: Bank of FIR Filters c(n,l+1) in harris
    % ---------------------------------------------------------------------
    % Apply Differentiating Filters (they share the same states)
    p(:,:)=C*squeeze(zlog(:,nchan,:));
    
    % ---------------------------------------------------------------------
    % Step 2: Interpolation based on the fractional delay d
    % ---------------------------------------------------------------------
    mult(:,:) = p(1,:);
    multlog  = get(getqloggerstruct(mult,0));
    multlog.Range = double(range(mult));
    fdprod(1,:) = d*mult;
    fdprodlog = get(getqloggerstruct(d,2));
    fdprodlog.Range = double(range(fdprod));

    for i=2:nd-1,
        fdprod(1,:) = d*(fdprod+p(i,:)); 
        % Log FDProduct info here because of FI limitation
        aux = get(getqloggerstruct(d,2));
        fdprodlog.Min = min(fdprodlog.Min,aux.Min);
        fdprodlog.Max = max(fdprodlog.Max,aux.Max);
        fdprodlog.NOverflows = fdprodlog.NOverflows+aux.NOverflows;
        fdprodlog.NUnderflows = fdprodlog.NUnderflows+aux.NUnderflows;
        fdprodlog.NOperations = fdprodlog.NOperations+aux.NOperations;

        % Log Multiplicand info here because of FI limitation
        if isreal(y),
            aux  = get(getqloggerstruct(fdprod,1));
        else
            aux  = get(getqloggerstruct(fdprod,3));
        end
        multlog.Min = min(multlog.Min,aux.Min);
        multlog.Max = max(multlog.Max,aux.Max);
        multlog.NOverflows = multlog.NOverflows+aux.NOverflows;
        multlog.NUnderflows = multlog.NUnderflows+aux.NUnderflows;
        multlog.NOperations = multlog.NOperations+aux.NOperations;
    end
    plast(:,:) = Clast*squeeze(zlog(:,nchan,:));     % Last phase is not quantized to the multiplicand format
    y(1:nx,nchan) = fp.add(fdprod(1,1:nx),plast);    % Last sum done in full precision
end

%----------------------------------------------------------------------
% Logging: min/max, range
%----------------------------------------------------------------------
if isloggingon(this),
    if nchans>1,
        % FI limitation: can't use subsref (i.e. write a for loop) because
        % it creates a temp and causes fi to loose the log report.
        warning(message('dsp:quantum:abstractfixedfarrowfdfilterq:farrowfdfilter:ChannelsIgnored'));
    end
    f = fipref;

    %----------------------------------------------------------------------
    % Fixed-point logging: min/max, range
    %----------------------------------------------------------------------
    [prodlog, outlog, acclog, multlog, fdprodlog] = getlog(this,C,Clast,p,plast,y,multlog,fdprodlog,d,x);
    %----------------------------------------------------------------------
    % Build Report
    %----------------------------------------------------------------------
    if strcmpi(f.DataTypeOverride , 'forceoff'),
        qlog = quantum.fdfarrowreport('Fixed', ...
            quantum.fixedlog(inlog), ...
            quantum.fixedlog(outlog), ...
            quantum.fixedlog(prodlog), ...
            quantum.fixedlog(acclog),...
            quantum.fixedlog(multlog),...
            quantum.fixedlog(fdprodlog));
    elseif strcmpi(f.DataTypeOverride , 'ScaledDoubles')
        qlog = quantum.fdfarrowreport('Double', ...
            quantum.doublelog(inlog), ...
            quantum.doublelog(outlog), ...
            quantum.doublelog(prodlog), ...
            quantum.doublelog(acclog),...
            quantum.doublelog(multlog),...
            quantum.doublelog(fdprodlog));
    end

    % Store Report in filterquantizer
    this.loggingreport = qlog;
end


% [EOF]
