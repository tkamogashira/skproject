% constructor of class @signal
% parent class: none
% function sig=signal(length,samplerate,name,unit_x,unit_y,start_time)
%   INPUT VALUES:
%       length: length of signal in seconds [default 1]
%       samplerate: samplerate in Hz (points per seconds) [default: 1000]
%		name: display name of the signal (string)
%		unit_x: display unit on x-axis (string)
%		unit_y: display unit on y-axis (string)
%		start_time: virtual start time of the signal (default 0)
%
%   RETURN VALUE:
% 		@signal-object
%
% Valid constructor-calls:
% 	1: no or any number of arguments above
% 	2: signal(@other_signal_object) : Copy-Constructor
% 	3: signal(values): copies the values in the @signal
%
% a signal consist of n points according to its length*sr
% the time "0" is not associated with a bin. the first bin is time sr, the
% second 2*sr, etc the nth bin is the signal-duration
%
% This external file is included as part of the 'aim-mat' distribution package
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org

function sig=signal(laenge,samplerate,name,unit_x,unit_y,start_time)


if nargin < 6
    start_time=0;
end
if nargin < 5
    unit_y='amplitude';
end
if nargin < 4
    unit_x='time (ms)';
end
if nargin < 3
    name='generic Signal';
end
if nargin < 2
    samplerate=1000;
end
if nargin < 1
    laenge=1;
end

if isobject(laenge)
    sig.werte=laenge.werte;
    samplerate=laenge.samplerate;
    name=laenge.name;
    unit_x=laenge.unit_x;
    unit_y=laenge.unit_y;
    start_time=laenge.start_time;
%     sig.nr_x_ticks=laenge.nr_x_ticks;
%     sig.x_tick_labels=laenge.x_tick_labels;
else
    a1=size(laenge,1);    a2=size(laenge,2);
    if a1>1 & a2>1
        disp('Signal Constructor Error: input vector has more than one dimension');
    end
    % erst Abfrage, welche Konstruktionsmethode:
    if a2>1 %Benutzer hat Zeilenvektor eingegeben, wir wollen einen Spaltenvektor
        laenge=laenge';
        a1=a2;
    end
    if a1>1 % AHA! Ein Vektor
        sig.werte=laenge;
    else
        nr_points=round(laenge*samplerate);
        sig.werte=zeros(nr_points,1);
    end
end
sig.samplerate=samplerate;
sig.name=name;
sig.unit_x=unit_x;
sig.unit_y=unit_y;
sig.start_time=start_time;
sig.nr_x_ticks=9;
% if the ticks shell be numbers or something else
sig.x_tick_labels=[];

sig=class(sig,'signal');