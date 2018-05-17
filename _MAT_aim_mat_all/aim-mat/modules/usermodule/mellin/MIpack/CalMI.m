%
%	Calculation of Mellin Image from SAI3d
%	IRINO T
%	10 Jan. 2002
%  
% function  [MI3d, MIparam] = CalMI(SAI3d,NAPparam,SAIparam,MIparam)
%
%   INPUT:  SAI3d : 3D SAI
%	    NAPparam: Parameter for NAP
%	    SAIparam: Parameter for SAI
%	    MIparam: Parameter for MI
%   OUTPUT: MI3d: 3D Mellin Image
%
function  [MI3d, MIparam] = CalMI(SAI3d,NAPparam,SAIparam,MIparam)

%%%%%%%%%
if nargin < 4, MIparam = []; end;
if isfield(MIparam,'NSAIPhsCmp') == 0,  MIparam.NSAIPhsCmp = [];   end;
if length(MIparam.NSAIPhsCmp) == 0, 
	MIparam.NSAIPhsCmp  = 0; %was 2 but now window is causal - Rich
end;
if isfield(MIparam,'F0mode') == 0,  MIparam.F0mode = [];   end;
if length(MIparam.F0mode) == 0, 
	MIparam.F0mode = 300;   
end;
if isfield(MIparam,'TFval') == 0,  MIparam.TFval = [];   end;
if length(MIparam.TFval) == 0, 
	MIparam.TFval =  [0:0.05:15];   %was 15
end;
if isfield(MIparam,'c_2pi') == 0,  MIparam.c_2pi = [];   end;
if length(MIparam.c_2pi) == 0, 
	MIparam.c_2pi =  [0:0.05:30];
end;
if isfield(MIparam,'Mu') == 0,  MIparam.Mu = [];   end;
if length(MIparam.Mu) == 0, 
	MIparam.Mu = 0.5; % flat   if Mu <0.5: high pass, Mu>0.5 low pass
end;

[NumCh, LenSAI, LenFrame] = size(SAI3d);

Lenc2pi = length(MIparam.c_2pi);
LenTF   = length(MIparam.TFval);
%MI3d    = zeros(Lenc2pi,LenTF,LenFrame); 

disp('*** MI Calculation ***');
MIparam.RangeAudFig = [];
disp(MIparam)

%saving the SAI3d for comparison with AIM's
     savefile = 'SAI3d_Irino.mat';
     SAI3d_Irino=SAI3d/max(max(max(SAI3d)));
     save(savefile,'SAI3d_Irino');

tic
%%%%%%%% For each frame %%%%%%%%% 
for nfr = 1:LenFrame,

    SAIval = SAI3d(:,:,nfr);

    SAIPhsCmp = zeros(size(SAIval));
    for nch = 1:NumCh,
	NPeriod = NAPparam.fs/NAPparam.Frs(nch) * MIparam.NSAIPhsCmp;
	vv = [zeros(1,fix(NPeriod)), SAIval(nch,:)];
	SAIPhsCmp(nch,1:LenSAI) = vv(1:LenSAI);
 %   MI3d(:,:,nfr) = SAIPhsCmp;
    end;	

    if MIparam.F0mode == 0
	%%% F0 estimation if necessary
    else
	F0est(nfr) = MIparam.F0mode; % No estimation of F0
    end;
    ZeroLoc = abs(SAIparam.Nwidth)*NAPparam.fs/1000+1;
    % MarginAF = fix(0.3 * NAPparam.fs/1000);       % 0.3 ms margin
    MarginAF = 0;  % No margin by introducing WinAF 
    MIparam.RangeAudFig = ...
	 [ZeroLoc+[0 , (fix(NAPparam.fs/F0est(nfr))-MarginAF)]];
    %RangeAudFigKeep(1:2,nfr) = MIparam.RangeAudFig(:);
%MIparam.RangeAudFig=[1 300] %added as an experiment
    %%%%%%%% Mellin Coefficients %%%%%%%%% 

    [MImtrx] = CalMellinCoef(SAIPhsCmp,NAPparam,MIparam);
	%% 80 times faster than showSSI + showMI

    %MI3d(1:Lenc2pi,1:LenTF,nfr) = MImtrx; 
    MI3d(:,:,nfr) = MImtrx; %added line - should behave no different
    if rem(nfr, 20) == 0 | nfr == LenFrame
       disp(['Mellin Image Frame #' int2str(nfr) '/#' int2str(LenFrame) ...
	     ':  elapsed_time = ' num2str(toc,3) ' (sec)']);
	%   if SwPlot > 0, CalMI_plotImage; end;   drawnow; 
    end;


    if 0
    subplot(3,1,1)
    image(flipud(SAI3d(:,:,nfr))*5)
    subplot(3,1,2)
    image(flipud(SAIPhsCmp)*5)
    subplot(3,1,3)
    image(flipud(abs(MI3d(:,:,nfr)))*20)
    drawnow
    end;


end; %    for nfr = 1:LenFrame 
