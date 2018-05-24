function varargout = dspblkshorttimefft2(action, varargin)
% DSPBLKSHORTTIMEFFT2 Mask dynamic dialog function for Periodogram spectrum analysis block
% Note: The Periodogram block used to be called Short-Time FFT block

% Copyright 1995-2011 The MathWorks, Inc.

blk = gcb;

switch action
case 'dynamic'
   % Execute dynamic dialogs

   % Determine "Inherit FFT length" checkbox setting
   inhFftStr   = get_param(blk,'inheritFFT');
   inhTsStr    = get_param(blk,'inheritTs');
   measurement = get_param(blk,'measurement');

   % Determine window popup setting
   win = lower(get_param(blk,'wintype'));

   % Cache original dialog mask enables
   vis_orig = get_param(blk,'maskvisibilities');
   ena_orig = get_param(blk,'maskenables');
   ena = ena_orig;

   % Determine if FFT length edit box is visible
   iFFTedit = 8; fftEditBoxEnabled = strcmp(inhFftStr, 'off');

   % Determine whether Stopband, Beta, and Window Sampling are visible:
   iRipple = 3; isCheby  = strcmp(win,'chebyshev');
   iBeta   = 4; isKaiser = strcmp(win,'kaiser');
   iWSamp  = 5; isGenCos = any(strcmp(win,{'hamming','hann','hanning','blackman'}));
   iInhTs  = 10; 
   iTs     = 11;
   
   if strcmpi(measurement,'Power spectral density')
       isPSD = 1;
       isInhTsOff = strcmpi(inhTsStr,'off');
   else
       isPSD = 0; 
       isInhTsOff = 0;
   end

   % Map true/false to off/on strings, and place into visibilities array:
   enaopt = {'off','on'};
   ena([iFFTedit iRipple iBeta iWSamp iInhTs iTs]) = enaopt([fftEditBoxEnabled ...
                       isCheby isKaiser isGenCos isPSD isInhTsOff]+1);
   if ~isequal(ena,ena_orig),
      % Only update if a change was really made:
      set_param(blk,'maskenables',ena);
   end
   if ~isequal(ena,vis_orig)
       %% Keep visibilities and enabledness in sync
       set_param(blk,'maskvisibilities',ena);
   end
   
case 'init'
    % Make model changes here, in response to mask changes
    
    % Always set Digital Filter block in sample-based mode
    digFiltblk      = [blk '/Digital Filter'];
    set_param(digFiltblk, 'InputProcessing', 'Elements as channels (sample based)');

    % Determine "Inherit FFT length" checkbox setting
    MeasurementType = varargin{1};
    inhFftStr       = varargin{2};
    inhTsStr        = varargin{3};
    nAvg            = varargin{4}; % Number of spectral averages
    Ts              = varargin{5}; % Sample time of original time series

    % validate Number of spectral averages parameter
    if (nAvg < 1) || (floor(nAvg) ~= nAvg) || ~isnumeric(nAvg) || ~isscalar(nAvg) || ...
            ~isreal(nAvg) || isnan(nAvg) || isinf(nAvg)
        error(message('dsp:dspblkshorttimefft2:paramPositiveIntegerError'));
    end    
    
    % Compare 'inherit' checkbox of this block
    % to the setting of the underlying mag-fft block
    %
    % If not the same, push the change through:
    magfftblk       = [blk '/Magnitude FFT'];
    magfftCheckbox  = get_param(magfftblk,'fftLenInherit');
    changePending   = ~strcmp(inhFftStr, magfftCheckbox);

    if changePending,
        % Update the Mag FFT block underneath the top level
        set_param(magfftblk, 'fftLenInherit', inhFftStr);
    end

    % Compare and push the FFT implementation setting 
    fftImplSetting = get_param(blk, 'FFTImplementation');
    magfftImplSetting = get_param(magfftblk,'FFTImplementation');
    changePending = ~strcmp(magfftImplSetting, fftImplSetting);
    if changePending
        set_param(magfftblk, 'FFTImplementation', fftImplSetting);
    end

    % Build the underlying system for 'Measurement' parameter
    % Position of the subsystem to be added
    blkPosition = [380 96 430 144];

    if (MeasurementType == 1)
        % Power spectral density
        % check if anything needs to be done
        blockToAdd = sprintf('Normalization\nFor PSD');
        isNormSysAbsent = isempty(find_system(blk, 'LookUnderMasks', 'all', 'FollowLinks',...
                                               'on', 'SearchDepth', 1, 'Name', blockToAdd));
        
        if isNormSysAbsent
            % Need to add Normalization For PSD block. Before doing that, need to delete
            % Normalization For MSS block and its connections.
            blockToDelete = sprintf('Normalization\nFor MSS');
            delete_line(blk, 'Window/2', [blockToDelete '/1']);
            delete_line(blk, [blockToDelete '/1'], 'Product/2');
            delete_block([blk '/' blockToDelete]);
            destBlkName = [blk '/' blockToAdd];
            load_system('dspmisc');
            set_param([blk '/Product'], 'inputs', '***', 'position', [505 22 545 218]);
            add_block(['dspmisc/' blockToAdd], destBlkName, 'Position', blkPosition);
            add_line(blk, 'Window/2', [blockToAdd '/1']);
            add_line(blk, [blockToAdd '/1'], 'Product/2');

            % else
            % Normalization For PSD block already present - no need to do anything
        end
        
        % Build the underlying system for 'Inherit sample time from input' parameter
        % 3rd input arg below is the block position for adding Frame Period To Sample Time OR
        % Constant block to the subsystem. This ensures straight lines in the subsystem.
        % 4th input arg below indicates whether the block is a Periodogram block or not. In 
        % this case, it is not - hence false.
        dspspect3_helper('init', blk, inhTsStr, Ts, [255 160 305 210], true);
        
    else
        % Mean-square spectrum
        % check if anything needs to be done
        blockToAdd = sprintf('Normalization\nFor MSS');
        isNormSysAbsent = isempty(find_system(blk, 'LookUnderMasks', 'all', 'FollowLinks',...
                                              'on', 'SearchDepth', 1, 'Name', blockToAdd));
        
        if isNormSysAbsent
            % Need to add Normalization For MSS block. Before doing that, need to delete
            % Normalization For PSD block, Frame Period To Sample Time or Constant block 
            % and their connections.
            blockToDelete = sprintf('Normalization\nFor PSD');
            delete_line(blk, 'Window/2', [blockToDelete '/1']);
            delete_line(blk, [blockToDelete '/1'], 'Product/2');
            delete_block([blk '/' blockToDelete]);

            % Also need to delete Frame Period To Sample Time or Constant block, which ever 
            % is present
            blockToDelete = 'Constant';
            isConstantAbsent = isempty(find_system(blk, 'LookUnderMasks', 'all', ...
                                                   'FollowLinks', 'on', 'SearchDepth', 1, ...
                                                   'Name', blockToDelete));
            if isConstantAbsent
                % Need to delete Frame Period To Sample Time block and its connections
                blockToDelete = sprintf('Periodogram -\nFrame Period\nTo Sample Time');
                delete_line(blk, 'In/1', [blockToDelete '/1']);
                delete_line(blk, [blockToDelete '/1'], 'Product/3');
                delete_block([blk '/' blockToDelete]);
            else
                % Need to delete Constant block and its connections
                delete_line(blk, 'Constant/1', 'Product/3');
                delete_block([blk '/Constant']);
            end

            destBlkName = [blk '/' blockToAdd];
            load_system('dspmisc');
            set_param([blk '/Product'], 'inputs', '**', 'position', [505 24 545 151]);
            add_block(['dspmisc/' blockToAdd], destBlkName, 'Position', blkPosition);
            add_line(blk, 'Window/2', [blockToAdd '/1']);
            add_line(blk, [blockToAdd '/1'], 'Product/2');

            % else
            % Normalization For MSS block already present - no need to do anything
        end        
        
    end    

  case 'icon'
    
   nAvg = varargin{1};
   if (nAvg > 1)
       iconStr = 'Welch';
   else
       iconStr = 'Periodogram';
   end

   [x, y, xe] = dspspect3_helper('icon');

   varargout = {x,y,xe,iconStr};

   % Update underlying blocks:
   wintype = get_param(blk,'wintype');
   winsamp = get_param(blk,'winsamp');
   set_param([blk '/Window'],'winsamp',winsamp,'wintype',wintype);
end

% [EOF] dspblkshorttimefft2.m

% LocalWords:  wintype maskvisibilities maskenables Stopband chebyshev
% LocalWords:  enabledness MSS dspmisc th winsamp
