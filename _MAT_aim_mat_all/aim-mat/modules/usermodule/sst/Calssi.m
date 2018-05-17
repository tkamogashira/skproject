%  Function for the calculation of the SSI
% 
%   INPUT VALUES:   SAI3d : 3D SAI
%	                NAPparam: Parameter for NAP
%	                SAIparam: Parameter for SAI
%	                SSIparam: Parameter for SSI
%   RETURN VALUE:   SSI3d: 3D Size-Shape Image
% 
% (c) 2003-2008, University of Cambridge, Medical Research Council 
% Original Code	IRINO T, 10 Jan. 2002
%
% Modified for the size shape image
% Marc A. Al-Hames
% April 2003
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org


function  [SSI3d] = Calssi(SAI3d,options,sample_rate)

SSIparam.NSAIPhsCmp  = 0;
SSIparam.F0mode = 300; 
SSIparam.TFval =  options.TFval;   
SSIparam.c_2pi =  options.c_2pi;
Lenc2pi = length(SSIparam.c_2pi);
LenTF   = length(SSIparam.TFval);
SSIparam.Mu = -0.5; % flat   if Mu <0.5: high pass, Mu>0.5 low pass
SAIparam.Nwidth     = 0; %sets the negative width of the window

[NumCh, LenSAI, LenFrame] = size(SAI3d);
    
%here we set up the Frs values for each channel
if isfield(options, 'lowest_frequency')
    fre1=options.lowest_frequency;
else
    fre1=100;
end
if isfield(options, 'highest_frequency')
    fre2=options.highest_frequency;
else
    fre2=6000;
end
cf_afb = [fre1 fre2];
NAPparam.Frs = FcNch2EqERB(min(cf_afb),max(cf_afb),NumCh);
NAPparam.fs = sample_rate; 

%We initialise the SSI matrix 
SSI3d    = zeros(NumCh,LenTF,LenFrame); 

waithand=waitbar(0,'generating the SSI'); 

% set the frame range, the SSI is calculated for
if (options.do_all_frames == 1)
    start_frame = 1;
    end_frame = LenFrame;
else
    start_frame = options.framerange(1);
    end_frame = options.framerange(2);
end;
    
%this section does the filter response alignment
for nfr = start_frame:end_frame
    %set up the waitbar
    fraction_complete=nfr/LenFrame;
    waitbar(fraction_complete);
    
    %generate the new matricies of the frames
    SAIval = SAI3d(:,:,nfr);
    SAIPhsCmp = zeros(size(SAIval));

    %we shift each channel along the time interval axis by adding zeros
    for nch = 1:NumCh,
	    NPeriod = NAPparam.fs/NAPparam.Frs(nch) * SSIparam.NSAIPhsCmp;
	    shift_matrix = [zeros(1,fix(NPeriod)), SAIval(nch,:)];
	    SAIPhsCmp(nch,1:LenSAI) = shift_matrix(1:LenSAI);
    end;
    if SSIparam.F0mode == 0  
    else
	    F0est(nfr) = SSIparam.F0mode; 
    end;

    %Here we extract the information required to ensure that we have 
    %only one presentation of the 'timbre' information
    ZeroLoc = abs(SAIparam.Nwidth)*NAPparam.fs/1000+1;
    MarginAF = 0;  % No margin by introducing WinAF 
    
    % set the range for the auditory image
    if (options.do_all_image == 1)
        SSIparam.RangeAudFig = [1 LenSAI];
    else
        SSIparam.RangeAudFig = options.audiorange;
    end;
	% maah: was MIparam.RangeAudFig = [ZeroLoc+[0 , (fix(NAPparam.fs/F0est(nfr))-MarginAF)]];

    % Calculation of the SSI  
    [SSImtrx] = Calssicoef(SAIPhsCmp,NAPparam,SSIparam);
	
    %Output into the 3d matrix   
    SSI3d(:,:,nfr) = SSImtrx;
    
end;
    
close(waithand); 