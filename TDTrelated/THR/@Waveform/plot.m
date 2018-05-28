function plot(W, varargin);
% Waveform/plot - plot waveform object
%     plot(W, ...) plots waveform object

if size(W,1)>1, error('Cannot plot multiple waveforms unless L/R pair'); end

%set(gcf,'units', 'normalized', 'position', [0.6225 0.0775 0.35 0.35])

CLR = get(0,'defaultAxesColorOrder'); NCL = size(CLR,1);

Nchan = size(W,2);
dt = 1e3/W(1).Fsam; % sample period in ms
if isequal('replace', get(gca,'NextPlot')), cla; end
LegStr = {};
for ichan=1:Nchan,
    x = samples(W(ichan));
    switch W(ichan).DAchan,
        case 'L', clr = CLR(1,:);
        case 'R', clr = CLR(2,:);
        otherwise, clr = CLR(1+rem(ichan-1,NCL),:);
    end
    xdplot(dt,real(x), 'color', clr, varargin{:});
    %xdplot(dt,imag(x), 'color', clr, 'linestyle', ':');
    LegStr{end+1} = W(ichan).DAchan;    
end
xlim('auto');
XL = xlim;
xlim([mean(XL)+1.1*(XL-mean(XL))]);
%   Fsam: 3.2552e+004
%        DAchan: 'R'
%     MaxMagSam: 3.1623e-005
%         Param: [1x1 struct]
%       Samples: {[0]  [127x1 double]  [96x1 double]  [65x1 double]  [0]}
%          Nrep: [1 50 1 1 6509]
% 
legend(LegStr{:});
xlabel('Time (ms)');
ylabel('Amplitude (AU)');


