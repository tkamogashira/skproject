function Curve = CalcVSPHCurve(Spt, IndepVal, Param)

%% ---------------- CHANGELOG -----------------------
%  Mon Jan 24 2011  Abel   
%	- Warn if none of the R values meets the rayleigh significance criterion
%	- Return calculated z-value in struct: RayleighSign() and
%  VectorStrength() now returns the z-value.
%  Wed Jan 26 2011  Abel   
%	- Documentation
%	- Addapted/bugfix wrapping (WPh was not in cycles) 
%  Wed Feb 9 2011
%	- Addapted wrapping: no more subtraction of mean, no more comparison to
%	first element. Cycle now from 0 -> 1 or 0 -> 2pi.



NSubSeqs = length(Param.isubseqs);
[NSpk, R, Ph, RaySign, Z] = deal(zeros(1, NSubSeqs));
for n = 1:NSubSeqs
    if strcmpi(Param.intncycles, 'yes')
        AnWin = ApplyIntNCycles(Param.anwin, Param.binfreq(n)); 
    else
        AnWin = Param.anwin;
    end
    
    SptTr = Spt(Param.isubseqs(n), Param.ireps{n});
    %Subtraction of time constant from spiketimes must be done first ...
    SptTr = ApplyTimeSubtr(SptTr, Param.timesubtr);
    SptTr = ApplyMinISI(SptTr, Param.minisi);
    SptTr = ApplyAnWin(SptTr, AnWin);
    
    SpkTr = cat(2, SptTr{:});
    NSpk(n) = length(SpkTr);
	if (Param.binfreq(n) == 0)
		%By Abel: Z is now an optional output of VectorStrength()
		[R(n), RaySign(n), Z(n)] = deal(NaN, 1);
	else
		%By Abel: Z is now an optional output of VectorStrength()
		[R(n), RaySign(n), Z(n)] = VectorStrength(SpkTr, Param.binfreq(n));
	end
	%Phase Ph(n) in RAD
	[R(n), Ph(n)] = deal(abs(R(n)), angle(R(n)));
end

%Shift to modulus 0->2pi
Ph = Ph +(2*pi);     %shift all by 2pi (removes negative angles)
Ph = mod(Ph, 2*pi);  %modulus -> puts everthing in the 0->2pi interval

%Get index of significant values accordind to Rayleigh criterion.
iSign = find(RaySign <= Param.raycrit);

%Phase convention (leading or lagging?)
if strcmpi(Param.phaseconv, 'lead')
    PhSign = -1;
else
    PhSign = 1;
end

%%%% Unwrap phase (= angle vector strength, Wrapped == periodic)
% Unwrap the phase vs stimulus frequency curve (or any indepval which
% changes the response frequnecy: SPL,...). Phase is the phase difference
% between stimulus and response (from cycle histogram). 
% WPh: wrapped, phase between 0 and 1 cycles (1 cycle: 0:2pi or 0:1
%	rad, Period = 2*pi and 1 cycle = 1 period, thus to transfer cycles =
%	devide by 2pi) Ph: unwrapped, phase between 0 and inf (number of cycles in
%	experiment) 
% CompPh: Compensation phase, which is 0 ms by default (compensation for
%	delay speaker vs micro).
ComPh = Param.binfreq .' * 2 * pi * 1e-3 .* Param.compdelay;
ComPh = ComPh(:)';
WPh = Ph;

%Unwrap phase:
% Ph can only vary within one cycle (period) for each indepval. Variations
% larger than the period wrap around. The unwrapping algorithm looks at the
% trend in sequential points and estimates whether or not the following
% point was wrapped around. However, since the jump tolorance for unwrap is
% pi by default (half a cycle), Ph changes smaller than this value will not
% be detected as a new period. In this case, the plot of Ph will be within 1 cycle
% (0:1).
Ph = Ph-ComPh;	%apply CompDelay
Ph = PhSign*Ph;	%apply lead/lag convention
Ph = unwrap(Ph); %unwrap phase
Ph = Ph/(2*pi); % to cycles
WPh = WPh/(2*pi); % to cycles

%Performing running average (=curve smoothing) on curve before extraction of calculation
%parameters
R  = runav(R, Param.runav);
Ph = runav(Ph, Param.runav);

if ~isempty(iSign)
    [MaxR, idx] = max(R(iSign));
    ValatMax = IndepVal(iSign(idx));
    maxRonSign = 'yes';
else
    [MaxR idx] = max(R);
    ValatMax = IndepVal(idx);
    maxRonSign = 'no';
	%by Abel: Warn if none of the R values meets the rayleigh significance criterion
	warning('SGSR:Info', 'None of the calculated R values meets the suggested Rayleigh significance criterion:%d\n returning the Max R value (maxRonSign = no), not pre-selected for significance.', Param.raycrit); 
end
if (length(iSign) >= 2)
    if strcmpi(Param.phaselinreg, 'normal')
        P = num2cell(linregfit(IndepVal(iSign), Ph(iSign), ...
            ones(1, length(IndepVal(iSign)))));
    else %Number of spikes is proportional to rate ...
        Wg = NSpk .* R;
        P = num2cell(linregfit(IndepVal(iSign), Ph(iSign), Wg(iSign)));
    end
    [Slope, Yintrcpt] = deal(P{:});
    regressionOnSign = 'yes';
else
    P = num2cell(linregfit(IndepVal, Ph, ones(1, length(IndepVal))));
    [Slope, Yintrcpt] = deal(P{:});
    regressionOnSign = 'no';
end

try
    CutOffR = MaxR*10^-(Param.cutoffthr/20);
    idx = max(iSign(R(iSign) > CutOffR));
    if isempty(idx)
        error('To catch block ...');
    end
    idx = idx + [0, 1];
    if ~all(ismember(idx, iSign))
        error('To catch block ...');
    end
    if isequal(R(idx(1)), R(idx(2)))
        error('To catch block ...');
    end
    CutOffVal = polyval(polyfit(R(idx), IndepVal(idx), 1), CutOffR); %inverse interpolation
catch
    [CutOffVal, CutOffR] = deal(NaN);
end
    
%By Abel: Add Z to output
Curve = CollectInStruct(IndepVal, R, Ph, WPh, RaySign, iSign, MaxR, ...
    maxRonSign, ValatMax, Slope, Yintrcpt, regressionOnSign, CutOffVal, CutOffR, Z);
