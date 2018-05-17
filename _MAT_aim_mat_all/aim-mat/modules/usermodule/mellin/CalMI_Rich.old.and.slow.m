%  tester generating function for Calculation of the Mellin Image in 'aim-mat'
% 
%   INPUT VALUES:  SAI3d : 3D SAI
%	    NAPparam: Parameter for NAP
%	    SAIparam: Parameter for SAI
%	    MIparam: Parameter for MI
%   RETURN VALUE:
%       MI3d: 3D Mellin Image
% 
% (c) 2003, University of Cambridge, Medical Research Council 
% Original Code	IRINO T
%	10 Jan. 2002
% Modified by R. Turner (ret26@cam.ac.uk)
%   Feb. 2003
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org


function  [MI3d] = CalMI_Rich(SAI3d,options,sample_rate)

%here we setup all the variables that the function requires
%%% CHANGE THE NAMES SO IT'S CLEAR WHAT'S GOING ON!!! 

%what do these do?
MIparam.NSAIPhsCmp  = 0; %was 2 but aim uses a window starting at 0ms 
MIparam.F0mode = 300; 

%these values set the resolution and scale of the axes in the final MT
%they are now defined in the parameter file
MIparam.TFval =  options.TFval;   
MIparam.c_2pi =  options.c_2pi;
Lenc2pi = length(MIparam.c_2pi);
LenTF   = length(MIparam.TFval);

%not sure what these do
MIparam.Mu = -0.5; % flat   if Mu <0.5: high pass, Mu>0.5 low pass
SAIparam.Nwidth     = 0; %sets the negative width of the window
MIparam.SSI = options.ssi;

%we find the maximum temporal interval size, the no of channels and the no
%of frames
[NumCh, LenSAI, LenFrame] = size(SAI3d);

%going to remove any information in the first N channels
% N=5;
% for no_ch = 1:N,
%     SAI3d(no_ch,:,:)=zeros(LenSAI,LenFrame);
% end;

%saving the SAI3d for comparison with irino's
%     savefile = 'SAI3d_AIM.mat';
%     SAI3d_AIM=SAI3d/max(max(max(SAI3d)));
%     save(savefile,'SAI3d_AIM');
     
%for using irino's SAI in AIM
%    load SAI3d_Irino.mat;
%    SAI3d=SAI3d_Irino;
    
%here we set up the Frs values for each channel
cf_afb = [100 6000]; %4500]; altered for 2dAT
NAPparam.Frs = FcNch2EqERB(min(cf_afb),max(cf_afb),NumCh);
NAPparam.fs = sample_rate; 

%We initialise the mellin image matrix (why is it best to do this - is it
%so we can spot errors more easily?
MI3d    = zeros(Lenc2pi,LenTF,LenFrame); 

%user information (commented out) + new wait bar 
%disp('*** MI Calculation ***');

%MIparam.RangeAudFig = [];
%disp(MIparam);
waithand=waitbar(0,'generating the MT'); 

% set the frame range, the mellin image is calculated for
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
	    NPeriod = NAPparam.fs/NAPparam.Frs(nch) * MIparam.NSAIPhsCmp;
	    shift_matrix = [zeros(1,fix(NPeriod)), SAIval(nch,:)];
	    SAIPhsCmp(nch,1:LenSAI) = shift_matrix(1:LenSAI);
        %MI3d(:,:,nfr) = SAIPhsCmp'; %added line
        %SAIPhsCmp = SAI3d(:,:,nfr); %tester line
    end;
    if MIparam.F0mode == 0
        % No estimation of F0    
    else
	    F0est(nfr) = MIparam.F0mode; 
    end;

    %Here we extract the information required to ensure that we have 
    %only one presentation of the 'timbre' information
    ZeroLoc = abs(SAIparam.Nwidth)*NAPparam.fs/1000+1;
    MarginAF = 0;  % No margin by introducing WinAF 
    
    % maah: set the range for the auditory image
    if (options.do_all_image == 1)
        MIparam.RangeAudFig = [1 LenSAI];
    else
        MIparam.RangeAudFig = options.audiorange;
    end;
	% maah: was MIparam.RangeAudFig = [ZeroLoc+[0 , (fix(NAPparam.fs/F0est(nfr))-MarginAF)]];

    % Calculation of the Mellin Coefficients  
    [MImtrx] = CalMellinCoef_Rich(SAIPhsCmp,NAPparam,MIparam);
	
    %Output into the 3d matrix   
    MI3d(1:Lenc2pi,1:LenTF,nfr) = MImtrx;
    
    % maah: Magnitude
    MI3d(1:Lenc2pi,1:LenTF,nfr) = abs(MI3d(1:Lenc2pi,1:LenTF,nfr));
    %MI3d(:,:,nfr) = MImtrx;     %added line
    
end;
    
close(waithand); 