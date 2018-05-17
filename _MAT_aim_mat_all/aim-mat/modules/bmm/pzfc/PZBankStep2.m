function [outputs, state1, state2] = PZBankStep2(inputs, pfreqs, pdamps, ...
    mindamp, maxdamp, xmin, xmax, rmin, rmax, za0, za1, za2, state1, state2, ...
    showconstellation, showtransfuns)
% function [outputs, state1, state2] = PZBankStep2(inputs, pfreqs, pdamps, ...
%     mindamp, maxdamp, xmin, xmax, rmin, rmax, za0, za1, za2, state1, state2, ...
%     showconstellation, showtransfuns)
% one time step of Pole-Zero-FilterBank, using row vectors of parameters
% inputs should contain shifted outputs from last time with new scalar
%   waveform input on the front:  inputs = [newin, outputs(1:N-1)];
% version 2 uses pole x and radius interpolation to adjust dampling
% the min and max are interpolation reference points, not limits to enforce
% and it should all work for multiple channels in parallel if the
% parameter vectors are all appropriately duplicated as well

if nargin < 15
    showconstellation = 0; % don't by default; value is used as fig num.
end

if nargin < 16
    showtransfuns = 0; % don't by default; value is used as fig num.
end

[nstages, nchans] = size(pfreqs); % number of filter channels and stereo channels

damprate = 1/(maxdamp - mindamp); % to save a bunch of divides

% limit to keep the poles reasonably stable:
interpfactor = (pdamps - mindamp)*damprate; 
% interpfactor = min(1.5, interpfactor); % seems to keep it stable

x = xmin + (xmax - xmin).*interpfactor;
r = rmin + (rmax - rmin).*interpfactor;

%optional improvement to constellation adds a bit to r:
fd = pfreqs.*pdamps;
r = r + 0.25*fd.*min(0.05, fd); % quadratic for small values, then linear

zb1 = -2*x;
zb2 = r.*r;

bExtraDelay = 1; % boolean to control whether to do allow extra sample of filter delay

if bExtraDelay
    % canonic  poles but with input provided where unity DC gain is assured
    % (mean value of state is always equal to mean value of input)
    newstate = inputs - (state1 - inputs).*zb1 - (state2 - inputs).*zb2;
    
    % canonic zeros part as before:

    outputs = za0 .* newstate + za1 .* state1 + za2 .* state2 ;
    outputs = outputs - 0.0001*outputs.^3; % cubic compression nonlinearity

    state2 = state1;
    state1 = newstate;
else
    input = inputs(1,:); % first stage input is top input; ignore the rest
    for stage = 1:nstages
        newstate = input - (state1(stage,:) - input).*zb1(stage) - (state2(stage,:) - input).*zb2(stage);
        % output of stage immediately becomes input for next stage, if needed:
        input = za0(stage) .* newstate + za1(stage) .* state1(stage,:) + za2(stage) .* state2(stage,:) ;
        input = input - 0.0001*input.^3; % cubic compression nonlinearity
        outputs(stage,:) = input;
        state2(stage,:) = state1(stage,:);
        state1(stage,:) = newstate;
    end
end


if showconstellation
    figure(showconstellation);
    % keyboard
    hold  off
    % I have exact x and r, just need y
    py = (r.*r - x.*x).^0.5;
    % let it error out if we get a complex y.
    plot(x,py,'x');
    hold on
    zr = (za2./za0).^0.5;
    zx = -0.5*(za1./za0);
    zy = (zr.*zr - zx.*zx).^0.5;
    %     zy(zy<0) = 0;
    %     zy = zy.^0.5;
    plot(zx, zy, 'o');
    
    drawnow
end

if showtransfuns % 1D indexing does only 1 channel for now
    fbasis = pi*2.^((-129:0)' /12); %% 120 semitones, 10 octaves, leading up to pi rad/samp
    z = exp(i*fbasis);
    z2 = z.*z;
    nch = size(pfreqs,1);
    nf = length(fbasis);
    chanxfns = zeros(nf, nch);
    cascxfns = ones(nf, nch);
    for ch = 1:length(pfreqs)
        chanxfns(:,ch) = abs((1+zb1(ch)+zb2(ch)).*(za0(ch)+za1(ch).*z+za2(ch).*z2)./(1+zb1(ch).*z+zb2(ch).*z2));
        cascxfns(:,ch) = cascxfns(:,max(1,ch-1)) .* chanxfns(:,ch);
    end

    figure(showtransfuns)
    hold off
    loglog(fbasis, chanxfns);
    axis([min(fbasis), max(fbasis), 0.1, 10]);

    figure(showtransfuns+1)
    hold off
    loglog(fbasis, cascxfns);
    axis([min(fbasis), max(fbasis), 0.02, 20000]);
end


return;

