% procedure for 'aim-mat'
% 
%   INPUT VALUES:
%  
%   RETURN VALUE:
%
% 
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org




function handles=setupnames(handles,signame_org)
% set up all relevant names according to the signal in signame

[pathstr,signame,ext] = fileparts(signame_org);

uniqueworkingname=signame;
directoryname=uniqueworkingname;

handles.info.start_directory=pathstr;
signalname=fullfile(directoryname,sprintf('%s.signal.mat',uniqueworkingname));
originalwavename=fullfile(directoryname,sprintf('%s.original_signal.wav',uniqueworkingname));
% originalwavename=sprintf('%s/%s.original_signal.wav',directoryname,uniqueworkingname);

signalwavename=fullfile(directoryname,sprintf('%s.wav',uniqueworkingname));
% signalwavename=sprintf('%s/%s.wav',directoryname,uniqueworkingname);
oldsignalwavename=sprintf('%s.wav',uniqueworkingname);

pcpname=fullfile(directoryname,sprintf('%s.pcp.mat',uniqueworkingname));
% pcpname=sprintf('%s/%s.pcp.mat',directoryname,uniqueworkingname);
bmmname=fullfile(directoryname,sprintf('%s.bmm.mat',uniqueworkingname));
% bmmname=sprintf('%s/%s.bmm.mat',directoryname,uniqueworkingname);
napname=fullfile(directoryname,sprintf('%s.nap.mat',uniqueworkingname));
% napname=sprintf('%s/%s.nap.mat',directoryname,uniqueworkingname);
strobesname=fullfile(directoryname,sprintf('%s.strobes.mat',uniqueworkingname));
% strobesname=sprintf('%s/%s.strobes.mat',directoryname,uniqueworkingname);
thresholdsname=fullfile(directoryname,sprintf('%s.thresholds.mat',uniqueworkingname));
% thresholdsname=sprintf('%s/%s.thresholds.mat',directoryname,uniqueworkingname);
sainame=fullfile(directoryname,sprintf('%s.sai.mat',uniqueworkingname));
% sainame=sprintf('%s/%s.sai.mat',directoryname,uniqueworkingname);

% TCW AIM2006 Added for pitchresonance compatibility
pitch_imagename=fullfile(directoryname,sprintf('%s.pitch_image.mat',uniqueworkingname));

usermodulename=fullfile(directoryname,sprintf('%s.usermodule.mat',uniqueworkingname));
% usermodulename=sprintf('%s/%s.usermodule.mat',directoryname,uniqueworkingname);

% look which movies are there
% mnames = fieldnames(handles.all_options.movieoptions);
% moviename=[];
% for i=1:length(mnames)
%     cn=mnames(i);
%     mname=sprintf('%s/%s.%s.mov',directoryname,uniqueworkingname,cn{1});
%     if fexist(mname)
%         moviename{i}=mname;
%     end
% end
% moviename{1}=sprintf('%s/%s.dp.mov',directoryname,uniqueworkingname);
% moviename{2}=sprintf('%s/%s.dpai.mov',directoryname,uniqueworkingname);


% these one has a underscore instead of a dot. Otherwise we cant run it
parameterfilename=fullfile(directoryname,sprintf('%s_parameters.m',uniqueworkingname));
% parameterfilename=sprintf('%s/%s_parameters.m',directoryname,uniqueworkingname);
projectfilename=fullfile(directoryname,sprintf('%s_project.m',uniqueworkingname));
% projectfilename=sprintf('%s/%s_project.m',directoryname,uniqueworkingname);

% set the name of the figure
compname=[pwd '\' oldsignalwavename];
if isfield(handles,'figure1')
	set(handles.figure1,'Name',compname);
end


% we start here!
handles.info.original_soundfile_directory=pwd;

handles.info.completesoundfilename=compname;
handles.info.uniqueworkingname=uniqueworkingname;
handles.info.directoryname=directoryname;
handles.info.signalname=signalname;
handles.info.signalwavename=signalwavename;
handles.info.originalwavename=originalwavename;
handles.info.oldsignalwavename=oldsignalwavename;
handles.info.pcpname=pcpname;
handles.info.bmmname=bmmname;
handles.info.napname=napname;
handles.info.strobesname=strobesname;
handles.info.thresholdsname=thresholdsname;
handles.info.sainame=sainame;

% TCW AIM2006 Added for pitchresonance compatibility
handles.info.pitch_imagename=pitch_imagename;

handles.info.usermodulename=usermodulename;
% handles.info.moviename=moviename;
handles.info.parameterfilename=parameterfilename;
handles.info.projectfilename=projectfilename;

