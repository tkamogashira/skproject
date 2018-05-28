function thr = EvalERB(thr,doplot,supralevel)

% EVALERB -  Calculate the Equivalent Rectangular Bandwidth (ERB) of a threshold curve
%
%   THR = EVALERB(THR)  calculate the ERB of the threshold curve given in
%   the struct THR (return argument of evalTHR). The ERB and qERB are
%   added to the struct THR.
%
%   THR = EVALERB(THR,PLOTSTRING)  PLOTSTRING values are 'yes' or 'no'
%
%   THR = EVALERB(THR,PLOTSTRING,STL)  STL is the supra-threshold level
%   given in dB SPL and indicates the level above threshold which is
%   considered when calculating the ERB.
%
%   Usage example -
%   thr = evalthr(dataset('S0605','2-2'),'plot','no');
%   thr = EvalERB(thr,'no',30);
%   thr = EvalERB(thr,'no',20);

% MMCL 26/02/2007

% check for plot
if nargin<2
    doplot = 'no';
end
if nargin<3
    supralevel = 0;
end

% ------- do calculation -----------

% get data
threshold = thr.thr.thr;
revthreshold = abs(threshold-max(threshold));

[revthreshold, numberind] = denan(revthreshold);
frequency = thr.thr.freq;
frequency = frequency(numberind);
[revthreshold, numberind] = dezero(revthreshold);
frequency = frequency(numberind);

if ~isnan(thr.fit.freq)
    Fthreshold = thr.fit.thr;
    Frevthreshold = abs(Fthreshold-max(Fthreshold));
    [Frevthreshold, Fnumberind] = denan(Frevthreshold);
    Ffrequency = thr.fit.freq;
    Ffrequency = Ffrequency(Fnumberind);
    [Frevthreshold, Fnumberind] = dezero(Frevthreshold);
    Ffrequency = Ffrequency(Fnumberind);
end

% check for supra-threshold level
if supralevel~=0
    MaxRevThr = max(revthreshold);
    if MaxRevThr<supralevel
        warning('Dynamc range of threshold curve is less than supra-threshold level. Returning nan values.');
        eval(['thr.thr.ERB' num2str(supralevel) ' = NaN;']);
        eval(['thr.thr.qERB' num2str(supralevel) ' = NaN;']);
        if ~isnan(thr.fit.freq)
            eval(['thr.fit.ERB' num2str(supralevel) ' = NaN;']);
            eval(['thr.fit.qERB' num2str(supralevel) ' = NaN;']);
        end
        return
    elseif isempty(revthreshold)
        warning('Cannot determine ERB. Returning nan values.');
        eval(['thr.thr.ERB' num2str(supralevel) ' = NaN;']);
        eval(['thr.thr.qERB' num2str(supralevel) ' = NaN;']);
        if ~isnan(thr.fit.freq)
            eval(['thr.fit.ERB' num2str(supralevel) ' = NaN;']);
            eval(['thr.fit.qERB' num2str(supralevel) ' = NaN;']);
        end
        return
    else % clip revthreshold around suprathreshold level
        cutofflevel = MaxRevThr - supralevel;

        % find rising edge
        Ind = find(revthreshold(1:end-1)<cutofflevel & revthreshold(2:end)>cutofflevel);
        if isempty(Ind)
            warning('Cannot find rising edge on threshold curve which crosses supra-threshold level. Returning nan values.');
            eval(['thr.thr.ERB' num2str(supralevel) ' = NaN;']);
            eval(['thr.thr.qERB' num2str(supralevel) ' = NaN;']);
            if ~isnan(thr.fit.freq)
                eval(['thr.fit.ERB' num2str(supralevel) ' = NaN;']);
                eval(['thr.fit.qERB' num2str(supralevel) ' = NaN;']);
            end
            return
        else
            CutInd(1) = Ind(1);
        end

        % find falling edge
        Ind = find(revthreshold(1:end-1)>cutofflevel & revthreshold(2:end)<cutofflevel);
        if isempty(Ind)
            warning('Cannot find falling edge on threshold curve which crosses supra-threshold level. Returning nan values.');
            eval(['thr.thr.ERB' num2str(supralevel) ' = NaN;']);
            eval(['thr.thr.qERB' num2str(supralevel) ' = NaN;']);
            if ~isnan(thr.fit.freq)
                eval(['thr.fit.ERB' num2str(supralevel) ' = NaN;']);
                eval(['thr.fit.qERB' num2str(supralevel) ' = NaN;']);
            end
            return
        else
            CutInd(2) = Ind(end);
        end

         % Interpolate to real cut off level    
        f_rising = interp1(revthreshold(CutInd(1):CutInd(1)+1),frequency(CutInd(1):CutInd(1)+1),cutofflevel);
        if CutInd(2)+1<length(revthreshold)
            f_falling = interp1(revthreshold(CutInd(2):CutInd(2)+1),frequency(CutInd(2):CutInd(2)+1),cutofflevel);
        else
            f_falling = NaN;
        end

        % added interpolated points to curves
        if isnan(f_falling)
            revthreshold = [cutofflevel revthreshold(CutInd(1)+1:CutInd(2)-1)];
            frequency = [f_rising frequency(CutInd(1)+1:CutInd(2)-1)];
        else
            revthreshold = [cutofflevel revthreshold(CutInd(1)+1:CutInd(2)-1) cutofflevel];
            frequency = [f_rising frequency(CutInd(1)+1:CutInd(2)-1) f_falling];
        end
        
        if isempty(revthreshold)
            warning('Cannot determine properly find suprathreshold level on thr curve. Returning nan values.');
            eval(['thr.thr.ERB' num2str(supralevel) ' = NaN;']);
            eval(['thr.thr.qERB' num2str(supralevel) ' = NaN;']);
            if ~isnan(thr.fit.freq)
                eval(['thr.fit.ERB' num2str(supralevel) ' = NaN;']);
                eval(['thr.fit.qERB' num2str(supralevel) ' = NaN;']);
            end
            return
        end

        revthreshold = revthreshold-min(revthreshold);

        if ~isnan(thr.fit.freq)
            if Frevthreshold(1)>=cutofflevel
                FCutInd(1) = 1;
            else
                Ind = find(Frevthreshold(1:end-1)<cutofflevel & Frevthreshold(2:end)>cutofflevel);
                FCutInd(1) = Ind(1);
            end
            if Frevthreshold(end)>=cutofflevel
                FCutInd(2) = length(Frevthreshold);
            else
                Ind = find(Frevthreshold(1:end-1)>cutofflevel & Frevthreshold(2:end)<cutofflevel);
                FCutInd(2) = Ind(end);
            end
            % Interpolate to real cut off level
            Ff_rising = interp1(Frevthreshold(FCutInd(1):FCutInd(1)+1),Ffrequency(FCutInd(1):FCutInd(1)+1),cutofflevel);
            if FCutInd(2)+1<length(Frevthreshold)
                Ff_falling = interp1(Frevthreshold(FCutInd(2):FCutInd(2)+1),Ffrequency(FCutInd(2):FCutInd(2)+1),cutofflevel);
            else
                Ff_falling = NaN;
            end

            % added interpolated points to curves
            if isnan(Ff_falling)
                Frevthreshold = [cutofflevel Frevthreshold(FCutInd(1)+1:FCutInd(2)-1)];
                Ffrequency = [Ff_rising Ffrequency(FCutInd(1)+1:FCutInd(2)-1)];
            else
                Frevthreshold = [cutofflevel Frevthreshold(FCutInd(1)+1:FCutInd(2)-1) cutofflevel];
                Ffrequency = [Ff_rising Ffrequency(FCutInd(1)+1:FCutInd(2)-1) Ff_falling];
            end
            Frevthreshold = Frevthreshold-min(Frevthreshold);
        end
    end
end

% change to power and calc erb
power = db2P(revthreshold);
if isempty(power) | length(power)<2%
    warning('Cannot determine power. Returning nan values.');
    eval(['thr.thr.ERB' num2str(supralevel) ' = NaN;']);
    eval(['thr.thr.qERB' num2str(supralevel) ' = NaN;']);
    if ~isnan(thr.fit.freq)
        eval(['thr.fit.ERB' num2str(supralevel) ' = NaN;']);
        eval(['thr.fit.qERB' num2str(supralevel) ' = NaN;']);
    end
    return
end
% power = runav(power,3);
% avgpower = (power(1:end-1)+power(2:end))/2;
% diffreq = diff(frequency);
AreaUnderCurve = trapz(frequency,power);
pmax = max(power);
ERB = AreaUnderCurve/pmax;
eval(['thr.thr.ERB' num2str(supralevel) ' = ' num2str(ERB) ';']);
eval(['thr.thr.qERB' num2str(supralevel) ' = ' num2str(thr.thr.cf/ERB) ';']);

if ~isnan(thr.fit.freq)
    Fpower = db2P(Frevthreshold);
    %     Fpower = runav(Fpower,3);
    %     Favgpower = (Fpower(1:end-1)+Fpower(2:end))/2;
    %     Fdiffreq = diff(Ffrequency);
    FAreaUnderCurve = trapz(Ffrequency,Fpower);
    Fpmax = max(Fpower);
    FERB = FAreaUnderCurve/Fpmax;
    eval(['thr.fit.ERB' num2str(supralevel) ' = ' num2str(FERB) ';']);
    eval(['thr.fit.qERB' num2str(supralevel) ' = ' num2str(thr.fit.cf/FERB) ';']);
end

% do plot
if strcmpi(doplot,'yes')
    CF = thr.thr.cf;
    LeftFreq = CF+ERB/2;
    RightFreq = CF-ERB/2;
    figure;
    subplot(2,1,1)
    patch([LeftFreq RightFreq RightFreq LeftFreq],[0 0 pmax pmax],[0.75 0.75 0.75])
    hold on;
    plot(frequency,power)
    ylabel('power')
    title(['ERB = ' num2str(ERB)])

    subplot(2,1,2)
    plot(frequency,revthreshold);
    ylabel('dB SPL')
    xlabel('Frequency (Hz)')

    if ~isnan(thr.fit.freq)
        CF = thr.fit.cf;
        LeftFreq = CF+FERB/2;
        RightFreq = CF-FERB/2;
        figure;
        subplot(2,1,1)
        patch([LeftFreq RightFreq RightFreq LeftFreq],[0 0 Fpmax Fpmax],[0.75 0.75 0.75])
        hold on;
        plot(Ffrequency,Fpower)
        ylabel('power')
        title(['(Fit) ERB = ' num2str(FERB)])

        subplot(2,1,2)
        plot(Ffrequency,Frevthreshold)
        ylabel('dB SPL')
        xlabel('Frequency (Hz)')
    end
end

%----------------------------------------------------------
function [x,ind] = dezero(x)

% DEZERO - remove ZEROs from array
%     DEZERO(X) returns only those elements of X
%     that are not ZEROs.
%     [Y, I] = DEZERO(X) also returns an index vector I
%     such that Y = X(I).

% MMCL 03/01/2008

zind = find(x==0);
x(zind) = NaN;
[x ind] = denan(x);
