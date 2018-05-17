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


function pitch=combfrePtiPdots(framestruct_a);
% combined graphic of frequency axis and time interval axis 
% on one axis
% plots one graphic that consists of two parts:
% the frequency profile and the interval profile on one axis

if nargin < 2
    grafix=0;  % for debugging
end
dot_scaler=200;  % wie gross Punkte dargestellt werden sollen in Punkt

% wie weit die Intervallsumme runterskaliert werden muss, damit die Zahlen vernünftigt werden
norm_intervalhight=100;
% wie weit die spektrale Summe runterskaliert werden muss, damit die Zahlen vernünftigt werden
norm_spektralhight=10;

% how big must the contrast of the envelope be to be recognised as one pitch
envcontrast_threshold=0.15;

% A single factor, that can vary between
% 0 = complete attention to temporal structure
% 1 = complete attention to spectral structure
spectral_attention_factor=0.5;

if ~isstruct(framestruct_a)
    framestruct.current_frame=framestruct_a;
else
    framestruct=framestruct_a;
end

if isfield(framestruct_a,'plot_only_highest') % if only one dot per line shell be plotted
    plot_only_highest=framestruct_a.plot_only_highest;
else
    plot_only_highest=0;
end

if isfield(framestruct_a,'plot_bw') % on paper work with different colors
    plot_bw=framestruct_a.plot_bw;
else
    plot_bw=0;
end

if isfield(framestruct_a,'normalise') % normalize the frame to a fixed value to get rid of effects of loudness and strobing points
    normalise=framestruct_a.normalise;
else
    normalise=0;
end

% ob vorher die Region unten rechts rausgeworfen werden soll
if ~isfield(framestruct_a,'extract_pitch_region');
    extract_pitch_region=0;
else
    extract_pitch_region=framestruct_a.extract_pitch_region;
end

current_frame=framestruct.current_frame;

% Wheh normalized, it is assumed that the overall energy in the stimulus is
% always the same
if normalise
    current_frame=normaliseto(current_frame,1);
end

pitch_current_frame=current_frame;
if extract_pitch_region
    % schmeisse die physikalisch nicht sinnvollen Bereiche raus!
    current_frame=extractpitchregion(current_frame);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % hier werden die Quellen berechnet:
parameters=framestruct;
pitch=calcresidualprobability(pitch_current_frame,parameters);

% calculate the sum of the frequencies
fresumme=getfrequencysum(current_frame);

nrchannels=getnrchannels(current_frame);
smoothwidth=128/nrchannels;
% smooth the sum with a smoothwidth of 1
fresumme=smooth(fresumme,smoothwidth);

% calculate the sum from interval profile
intsumme=getsum(current_frame);

% scaling value, if in a movie
scale_summe=getsumscale(current_frame);

% start plotting:
% clf;

% bastel zwei lineare Funktionen zusammen: eine aus dem zeitlichen Verlauf,
% und eine aus dem spektralen. 
minimum_time_interval=1;
maximum_time_interval=32;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Die Intervallsumme muss von linear auf logarithmisch umgestellt werden
nr_points=getnrpoints(intsumme);
intervalsum=logsigx(intsumme,-maximum_time_interval/1000,-minimum_time_interval/1000,nr_points);
intervalsum=setstarttime(intervalsum,0);
% ab nun haben wir eine lineare Zeitachse mit logarithmischen Werten

global fnull;global stepsperoctave;    % brauch ich unten in den Unterfunktionen
fnull=1000/maximum_time_interval;  % per Definition die niedrigste Frequenz = Anfangsfrequenz der gesamten Achse

% soviel "cent" hat die Zeitachse.
stepsperoctave=log2(maximum_time_interval/minimum_time_interval)/getnrpoints(intervalsum);  % soviel octaven/Pixel
intervalsum=setsr(intervalsum,1/stepsperoctave);
% intervalsum now goes from -32 to -1 ms in the interval profile
% empirische Werte zum Skalieren auf einen einheitlichen Wert (1)
intervalsum=scale(intervalsum,norm_intervalhight);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Die Frequenzsumme
% plot the frequency profile in the same Graphic
cfs=getcf(current_frame);
minimum_fre=cfs(1); % the lowest frequency 
maximum_fre=cfs(end); % the lowest frequency 

total_length=f2p(maximum_fre); % gesamte Länge des Plots
start_fre_profile=f2p(minimum_fre); % Startpunkt der Frequenzachse
stop_int_profile=f2p(1000/minimum_time_interval); % Ende des Überlapps

nr_addpoints=total_length-stop_int_profile; % soviel Punkte müssen hinten an die Intervallachse
tsig=signal(zeros(floor(nr_addpoints),1),getsr(intervalsum));   % Ein Nullensignal mit den richtigen Daten
intervalsum=append(intervalsum,tsig);   % hänge es an die Intervallsumme hinten an
% empirische Werte zum Skalieren auf einen einheitlichen Wert (1)

% glätte die Frequenzachse:
% intervalsum=smooth(intervalsum,smoothwidth);

% Die Frequenzsumme muss von erb (oder cfs) auf logarithmisch umgestellt werden
fresumme=erb2log(fresumme,cfs);

nr_addpoints=start_fre_profile; % soviel Punkte müssen vor die Frequenzsumme gehängt werden

% wieviel Punkte pro Octave in der Frequenzachse
freoctrelation=log2(maximum_fre/minimum_fre)/getnrpoints(fresumme);  % soviel octaven/Pixel
fresumme=setsr(fresumme,1/freoctrelation);  % anpassen der Zahl der Punkte auf die Intervalachse
fresumme=changesr(fresumme,getsr(intervalsum));

tsig=signal(zeros(floor(nr_addpoints),1),getsr(fresumme));  % 
fresumme=scale(fresumme,norm_spektralhight);

fresumme=append(tsig,fresumme);
fresumme=setstarttime(fresumme,0);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot it both
if plot_bw
    han=plot(intervalsum,'k--');
    set(han,'linewidth',1);
else
    plot(intervalsum,'b');
end
[intermaxpos,interminpos,intermax,intermin]=getminmax(intervalsum);
intermaxpos=time2bin(intervalsum,intermaxpos);
interminpos=time2bin(intervalsum,interminpos);
hold on
if plot_bw
    plot(fresumme,'k');
else
    plot(fresumme,'r');
end
[fremaxpos,freminpos,fremax,fremin]=getminmax(fresumme);
fremaxpos=time2bin(fresumme,fremaxpos);
freminpos=time2bin(fresumme,freminpos);
axis([1 getnrpoints(fresumme) 0 1])
% make x-Ticks
nr_labels=8;ti=50*power(2,[0:7]);tix=f2p(ti);ti=round(ti*10)/10;
set(gca,'XTick',tix);set(gca,'XTickLabel',ti);
xlabel('Frequency [Hz]');ylabel('PitchStrength');title('');



if plot_only_highest
    n=1;
else
    n=length(pitch):-1:1;
end

% if ~isempty(pitch)  % only, when temporal pitches occure
frequencydots=sortstruct(pitch,'spektral_profile.activity');
for i=n
    % Plotte die blauen Punkte (Intervalle)
    pfre=pitch{i}.interval_profile.fre;
    xx=f2p(pfre); %das liegt wegen Rundungsfehlern zu weit links??
    xx=getmaximumrightof(xx-1,intermaxpos,interminpos,intermax,intermin);
    hei=getbinvalue(intervalsum,xx);
    if i==1
        radius=max(2,dot_scaler*pitch{i}.residuumpitchstrength);
        if plot_bw
            plot(xx,hei,'k.','MarkerSize',radius/2,'Marker','^','MarkerFaceColor','k');
        else
            plot(xx,hei,'b.','MarkerSize',radius);
        end
%         text(xx+30,texthei*1.1,sprintf('%3.0f Hz %5.3f',pitch{i}.fre,pitch{i}.residuumpitchstrength));    % this is at a nice position
%         if pitch{i}.envcontrast > envcontrast_threshold
            a=text(xx+30,hei*1.2,sprintf('%3.0f Hz',pfre));    % this is at a nice position
            set(a,'Color','b');
            %         end
    else
        radius=max(2,dot_scaler*pitch{i}.residuumpitchstrength);
        plot(xx,hei,'b.','MarkerSize',radius);
    end

    % Plotte die roten Punkte (Frequenzen)
    pfre=chan2fre(current_frame,frequencydots{i}.spektral_profile.position);
    xx=f2p(pfre);   % suche den Punkt auf dem nächsten Maximum um Rundungsfehler zu vermeiden
    xx2=getmaximumrightof(xx-1,fremaxpos,freminpos,fremax,fremin);
    if xx2/xx < 1.015   % wenn das nächste Maximum nah dran ist, dann wars ein Fehler
        xx=xx2;
    end
    hei=getbinvalue(fresumme,xx);
    radius=max(2,dot_scaler*frequencydots{i}.spektral_profile.hight);
    if plot_bw
        plot(xx,hei,'k.','MarkerSize',radius);
    else
        plot(xx,hei,'r.','MarkerSize',radius);
    end
    a=text(xx+30,hei*1.2,sprintf('%4.2f kHz',pfre/1000));    % this is at a nice position
    set(a,'Color','r');
    
end

return



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
