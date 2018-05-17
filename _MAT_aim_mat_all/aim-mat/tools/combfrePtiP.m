% tool
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


function combfrePtiP(framestruct_a);
% combined graphic of frequency axis and time interval axis 
% on one axis
% plots one graphic that consists of two parts:
% the frequency profile and the interval profile on one axis

graphix=1;  % for debugging


if ~isstruct(framestruct_a)
    framestruct.current_frame=framestruct_a;
else
    framestruct=framestruct_a;
end

if ~isfield(framestruct,'show_time');
    show_time=1;
else
    show_time=framestruct.show_time;
end

% scaling of the two individual profiles:
if isfield(framestruct,'frequency_profile_scale');
    frequency_profile_scale=framestruct.frequency_profile_scale;
else
    frequency_profile_scale=1;
end
if isfield(framestruct,'time_profile_scale');
    time_profile_scale=framestruct.time_profile_scale;
else
    time_profile_scale=1;
end

current_frame=framestruct.current_frame;

pitch_current_frame=current_frame;
% schmeisse die physikalisch nicht sinnvollen Bereiche raus!
% current_frame=extractpitchregion(current_frame);

% berechne die pitches vom Orginal
% pitch=calcresidualprobability(pitch_current_frame,graphix);

% calculate the sum of the frequencies
fresumme=getfrequencysum(current_frame);

nrchannels=getnrchannels(current_frame);
% smoothwidth=128/nrchannels;
% smooth the sum with a smoothwidth of 1
% fresumme=smooth(fresumme,smoothwidth);

% calculate the sum from interval profile
intsumme=getsum(current_frame);

% bastel zwei lineare Funktionen zusammen: eine aus dem zeitlichen Verlauf,
% und eine aus dem spektralen. 
minimum_time_interval=1;
maximum_time_interval=32;

% if the intervals are plotted positiv to the right, turn around the signal
if getminimumtime(intsumme) >= 0
    intsumme=reverse(intsumme);
    intsumme=setstarttime(intsumme,-0.035);
end
   
    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Die Intervallsumme muss von linear auf logarithmisch umgestellt werden
nr_points=getnrpoints(intsumme);
intervalsum=logsigx(intsumme,-maximum_time_interval/1000,-minimum_time_interval/1000,nr_points);
intervalsum=setstarttime(intervalsum,0);
% ab nun haben wir eine lineare Zeitachse mit logarithmischen Werten

global fnull;global stepsperoctave;    % brauch ich unten in den Unterfunktionen
% fnull=1000/32.389;  % per Definition die niedrigste Frequenz
fnull=1000/maximum_time_interval;  % per Definition die niedrigste Frequenz = Anfangsfrequenz der gesamten Achse

% soviel "cent" hat die Zeitachse.
stepsperoctave=log2(maximum_time_interval/minimum_time_interval)/getnrpoints(intervalsum);  % soviel octaven/Pixel
intervalsum=setsr(intervalsum,1/stepsperoctave);
% intervalsum now goes from -32 to -1 ms in the interval profile



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Die Frequenzsumme
% plot the frequency profile in the same Graphic
cfs=getcf(current_frame);
minimum_fre=cfs(1); % the lowest frequency 
maximum_fre=cfs(end); % the lowest frequency 
srate=getsr(current_frame);

% Die Frequenzsumme muss von erb (oder cfs) auf logarithmisch umgestellt werden
fresumme=erb2log(fresumme,cfs);


total_length=f2p(maximum_fre); % gesamte Länge des Plots
start_fre_profile=f2p(minimum_fre); % Startpunkt der Frequenzachse
stop_int_profile=f2p(1000/minimum_time_interval); % Ende des Überlapps

nr_addpoints=total_length-stop_int_profile; % soviel Punkte müssen hinten an die Intervallachse
tsig=signal(zeros(floor(nr_addpoints),1),getsr(intervalsum));   % Ein Nullensignal mit den richtigen Daten
intervalsum=append(intervalsum,tsig);   % hänge es an die Intervallsumme hinten an
% glätte die Frequenzachse noch:
% intervalsum=smooth(intervalsum,smoothwidth);


nr_addpoints=start_fre_profile; % soviel Punkte müssen vor die Frequenzsumme gehängt werden

% wieviel Punkte pro Octave in der Frequenzachse
freoctrelation=log2(maximum_fre/minimum_fre)/getnrpoints(fresumme);  % soviel octaven/Pixel
fresumme=setsr(fresumme,1/freoctrelation);  % anpassen der Zahl der Punkte auf die Intervalachse
fresumme=changesr(fresumme,getsr(intervalsum));

tsig=fresumme;
tsig=setlength(tsig,bin2time(fresumme,nr_addpoints));
tsig=mute(tsig);
% tsig=signal(zeros(floor(nr_addpoints),1),getsr(fresumme));  % 
fresumme=append(tsig,fresumme);
fresumme=setstarttime(fresumme,0);

% scale both signals to the specified scaling values
% scaling value, if in a movie
scale_summe=getscalesumme(current_frame);
fre_scale=getscalefrequency(current_frame);
fresumme=scale(fresumme,1/fre_scale*frequency_profile_scale);
intervalsum=scale(intervalsum,1/scale_summe*time_profile_scale);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot it both
plot(intervalsum,'b');
[intermaxpos,interminpos,intermax,intermin]=getminmax(intervalsum);
intermaxpos=time2bin(intervalsum,intermaxpos);
interminpos=time2bin(intervalsum,interminpos);
hold on
plot(fresumme,'r');
[fremaxpos,freminpos,fremax,fremin]=getminmax(fresumme);
fremaxpos=time2bin(fresumme,fremaxpos);
freminpos=time2bin(fresumme,freminpos);
axis([1 getnrpoints(fresumme) 0 1])
% make x-Ticks
nr_labels=8;ti=50*power(2,[0:7]);tix=f2p(ti);ti=round(ti*10)/10;
set(gca,'XTick',tix);set(gca,'XTickLabel',ti);
xlabel('Frequency [Hz]');ylabel('PitchStrength');title('');

if show_time
    srate=getsr(current_frame);
    text_x=0.8*getnrpoints(fresumme);
    text_y=0.9;
    frame_number=getcurrentframenumber(current_frame);
    frame_time=getcurrentframestarttime(current_frame);
    text(text_x,text_y,sprintf('%3d  : %4.0fms',frame_number,frame_time*1000),'FontSize',8);
end

return

% Pixel 2 frequency
function f=p2f(pix)
global fnull;
global stepsperoctave;
f=fnull*power(2,(pix-1)*stepsperoctave);
return

function p=f2p(fre)
global fnull;
global stepsperoctave;
p=1/stepsperoctave*log2(fre/fnull)+1;
return
