function iconstr = dspblkmagfft2(action)
% DSPBLKMAGFFT2 Mask dynamic dialog function for
% Magnitude FFT power spectrum estimation block

% Copyright 1995-2013 The MathWorks, Inc.

blk = gcb;
if nargin<1, action='dynamic'; end

% Determine "Inherit FFT length" checkbox setting
inhFftStr = get_param(blk,'fftLenInherit');
fftImplStr = get_param(blk, 'FFTImplementation');
wrapStr =    get_param(blk,'WrapInput');

switch action
case 'init'
    % Make model changes here, in response to mask changes

    % Compare 'inherit' checkbox of this block
    % to the setting of the underlying FFT block
    %
    % If not the same, push the change through:
    fftblk       = [blk '/FFT'];
    fftPopup     = get_param(fftblk,'InheritFFTLength');
    changePending = ~strcmp(inhFftStr, fftPopup);    
    if changePending
        % Update the FFT block underneath the top level
        set_param(fftblk, 'InheritFFTLength', inhFftStr);        
    end

    fftWrapPopup     = get_param(fftblk,'WrapInput');
    changePending = ~strcmp(wrapStr, fftWrapPopup);    
    if changePending
        % Update the FFT block underneath the top level
        set_param(fftblk, 'WrapInput', wrapStr);        
    end
    
    fftImplPopup = get_param(fftblk, 'FFTImplementation');
    changePending = ~strcmp(fftImplStr, fftImplPopup);
    if changePending
        set_param(fftblk, 'FFTImplementation', fftImplStr);
    end
    magflag = get_param(blk,'mag_or_magsq');
    if strcmp(magflag, 'Magnitude squared')
      iconstr='|FFT|^2';
    else
      iconstr='|FFT|';
    end

case 'dynamic'
    % Execute dynamic dialogs

    % Determine if FFT length edit box is visible
    iFFTedit = 4; iFFTWrap = 5; fftEditBoxEnabled = strcmp(inhFftStr, 'off');

    % Cache original dialog mask enables
    ena_orig = get_param(blk,'maskenables');
    vis_orig = get_param(blk,'maskvisibilities');
    vis = vis_orig;
    if fftEditBoxEnabled
        vis{iFFTedit} = 'on';
        vis{iFFTWrap} = 'on';
    else
        vis{iFFTedit} = 'off';
        vis{iFFTWrap} = 'off';
    end

    % Map true/false to off/on strings, and place into visibilities array:
    if ~isequal(vis,vis_orig),
        % Only update if a change was really made:
        set_param(blk,'maskvisibilities',vis);
    end
    if ~isequal(vis,ena_orig)
        %% Keep enables and visibles synced:
        set_param(blk,'maskenables',vis);
    end

case 'update'
    sqname = ['Magnitude' char(10) 'Squared'];
    sqrtname = 'Magnitude';
    fullblk  = getfullname(blk);
    % Determine "Mag or Mag Squared" setting
    magflag = get_param(blk,'mag_or_magsq');
    if strcmp(magflag, 'Magnitude squared')
      if exist_block(blk,sqrtname)
        delete_line(fullblk,'FFT/1',[sqrtname '/1'])
        delete_line(fullblk,[sqrtname '/1'], 'Out/1')
        pos = get_param([blk '/Magnitude'],'position');
        delete_block([blk '/Magnitude'])
        add_block('built-in/Math',[blk '/Magnitude Squared' char(10) ...
                    'Squared'],'position',pos, 'name', sqname,'function','magnitude^2')
        add_line(fullblk,'FFT/1',[sqname '/1'])
        add_line(fullblk,[sqname '/1'], 'Out/1')
      end
    else
      if exist_block(blk,sqname)
        delete_line(fullblk,'FFT/1',[sqname '/1'])
        delete_line(fullblk,[sqname '/1'], 'Out/1')
        pos = get_param([blk '/Magnitude Squared'],'position');
        delete_block([blk '/Magnitude Squared'])
        add_block('built-in/Abs',[blk '/Magnitude'],'position',pos,'name',sqrtname)
        add_line(fullblk,'FFT/1',[sqrtname '/1'])
        add_line(fullblk,[sqrtname '/1'], 'Out/1')
      end
    end

end

% [EOF] dspblkmagfft2.m
