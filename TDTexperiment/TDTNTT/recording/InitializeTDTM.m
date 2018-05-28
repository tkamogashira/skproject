%InitializeTDTM -- A version of InitializeTDT for multichannel recording
%Initialize TDT devices and keep ActX handles in global
%variables such as RP2 PA5 RA16 zBus
%

global RP2 PA5 RA16 zBus %Active X controls for the TDT System3 modules

%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialize System III

%%% PA5 %%%
e=PA5Control('Initialize',[1 2]);
if ~e
    errordlg('Error in initializing PA5','Error','modal');
    return;
end
%Use maximum attenuation to reduce noise due to initializing other
%TDT devices
e=PA5Control('SetAtten',[1 2],[120 120]);
if ~e
    error('Error in setting PA5');
end

%%% zBus %%%
e=zBusControl('Initialize');
if ~e
    errordlg('Error in initializing zBus','Error','modal');
    return;
end

%%% RP2 %%%
e=RP2PlayEz('Initialize');
if ~e
    errordlg('Error in initializing RP2','Error','modal');
    return;
end

%%% RA16 %%%
e=RA16RecordEzM('Initialize');
if ~e
    errordlg('Error in initializing RA16','Error','modal');
    return;
end


%Run the TDT circuits
e=e*RP2PlayEz('Run');
e=e*RA16RecordEzM('Run');

