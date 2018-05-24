function varargout = dspblksfw2(action, varargin)
% DSPBLKSFW2 DSP System Toolbox Signal From Workspace block helper function.

% Copyright 1995-2012 The MathWorks, Inc.

if nargin==0, action = 'dynamic'; end

fullblk       = getfullname(gcb);
FromWorks_blk = [fullblk '/From Workspace'];
ExtendOutput  = get_param(fullblk, 'OutputAfterFinalValue');

switch action
case 'init'
   % Setting Simulink FromWorkspace parameter
   if ~strcmp(get_param(FromWorks_blk, 'OutputAfterFinalValue'), ExtendOutput)
       try %#ok
           % This try is necessary since "initBlock" below creates the data
           % "s" required by the from workspace block. However, if the
           % MATLAB workspace has an exisiting variable "s", this set_param
           % fails and since the value is reverted back to the original
           % value, the "initBlock" function never gets a chance to
           % execute, thus causing this block to fail in simulation.
           % This was detected when simulating model "commgardnerphrecov".
           set_param(FromWorks_blk,'OutputAfterFinalValue', ExtendOutput);
       end
   end
   
   varargout = initBlock(fullblk, FromWorks_blk, ExtendOutput, varargin);
   
case 'dynamic'
   blk = gcbh;

   old_mask_visibles = get_param(blk, 'MaskVisibilities');
   new_mask_visibles = old_mask_visibles;
   
   if ~(strcmp(get_param(blk,'OutputAfterFinalValue'),'Cyclic repetition'))
     new_mask_visibles{5} = 'off';
   else
     new_mask_visibles{5} = 'on';
   end

   if ~(isequal(new_mask_visibles, old_mask_visibles))
     set_param(blk, 'MaskVisibilities', new_mask_visibles);
   end
   
   return;
end  % end switch/case



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function argsOut = initBlock(fullblk, FromWorks_blk, ExtendOutput, argsIn)

   X      = argsIn{1};
   
   if isa(X,'timeseries')
       error(message('dsp:dspblksfw2:TimeseriesNotAllowed'));
   end
   
   if (isstruct(X))
       error(message('dsp:dspblksfw2:StructNotAllowed'));
   end
   
   Ts     = double(argsIn{2});
   nSamps = double(argsIn{3});

   
   % Set Frame Status Conversion block
   setOutputFrameStatus(fullblk, X, nSamps);

   if isempty(X) || isempty(Ts) || isempty(nSamps)
       % If any of the fields are empty then assign defaults
       % This let's us hit the apply button with parameters
       % yet to be defined in the MATLAB workspace.
       s.time               = [];
       s.signals.values     = 0;
       s.signals.dimensions = [1 1];

       newTs  = Ts;  % Sample time of Simulink FromWorkspace block

       % If you are about to run, the all params must be defined.
       if(strcmp(get_param(bdroot(gcs),'SimulationStatus'),'initializing'))
       		if isempty(X),      error(message('dsp:dspblksfw2:paramEmptyError1')); end
       		if isempty(Ts),     error(message('dsp:dspblksfw2:paramEmptyError2')); end
       		if isempty(nSamps), error(message('dsp:dspblksfw2:paramEmptyError3')); end
       end

   else
       if (ndims(X) > 3)
         error(message('dsp:SignalBlockset:GreaterThan3DSignalsNotAllowed'));
       end
       if nSamps <= 0,
           error(message('dsp:dspblksfw2:paramOutOfRange1'));
       end

       if (Ts <= 0) & (Ts ~= -1),
           error(message('dsp:dspblksfw2:paramOutOfRange2'));
       end

       % Prepare data and add buffer block if needed
       s = PrepareDataForFromWorkspace(fullblk, X, nSamps, ExtendOutput);

       if(exist_block(fullblk, 'Buffer'))
           newTs = Ts;             % Don't change sample time
           if (Ts < 0)
               % Buffer exists only in cyclic repetition
               % If buffer exists then there is multi-rate and hence
               % the from workspace block can not work under a triggered subsystem
               error(message('dsp:dspblksfw2:paramOutOfRange3'));
           end
       else
           if (Ts >= 0)
               newTs = Ts * nSamps;    % Update sample time for output:
           else
               newTs = Ts;             % if -1 do not multiply by frame len
           end
       end
   end

   argsOut(1:2) = {s, newTs};


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function  s = PrepareDataForFromWorkspace(fullblk, X, nSamps, ExtendOutput)

makeItComplex = 0;
if ~(isreal(X))
  makeItComplex = 1;
end

if ndims(X)==3
    % 3D inputs can be passed directly to the underlying
    % Simulink FromWorkspace block.
    if nSamps ~= 1,
        error(message('dsp:dspblksfw2:paramOutOfRange4'));
    end

    [outRows,outCols,steps] = size(X);
    UU = X;
else
    % 1 or 2D inputs needs to be reshaped to be passed
    % to the underlying Simulink FromWorkspace block.
    % The variable to the Simulink FromWorkspace block (UU) is
    % made to be 3D, so that each frame is output as a 2D page.
    outRows = nSamps;

    [xRows, xCols] = size(X);

    % Row is a single Channel (Convenience rule)
    if(xRows==1)
        xRows = xCols;
        xCols = 1;
        X = X(:);
    end

    switch ExtendOutput
    case 'Setting to zero'
        [UU, outCols] = reshape2D(X,nSamps);
        % Nothing extra needed for this case
        remove_Buffer(fullblk);

    case 'Cyclic repetition'
    	% If using Cyclic Repetition, the we need the workspace variable
    	% to have its number of rows to be an even multiple of the
    	% framesize.  Because the current implementation would erroneously
    	% zero pad the output and repeat the last zero padded frame.

       if(xRows > nSamps)
            R = mod(xRows, nSamps);
        else
            R = nSamps - xRows;
        end

        if (R == 0) || (nSamps == 1)
            [UU, outCols] = reshape2D(X,nSamps);
            % Samplebased or signals with length that are multiple
            % of the framesize do not need the buffer block.
            remove_Buffer(fullblk);

        else
            % Framebased signals that have lengths which are not
            % multiples of the framesize need the buffer block.
            % We'll pass the variable to the FromWorkspace block
            % which will output samples one row at a time to the buffer.
            
            fullblk_nonewline = strrep(fullblk,sprintf('\n'),' ');
            diagnostic_setting = get_param(fullblk, 'ignoreOrWarnInputAndFrameLengths');

            if strcmp(diagnostic_setting,'on')
              s = warning('query','backtrace');
              warning off backtrace;
              warning(message('dsp:SignalFromWorkspace:Multirate', fullblk_nonewline));
              warning(s);
            end
            
            if(xRows > nSamps)
                IC = X(1:nSamps,:);    % First frame to go into IC

                UUU = [X(nSamps+1:end, :); X(1:nSamps,:)].';  % pad samples at end
                UU  = reshape(UUU, 1, xCols, []);             % make 3-D
            else
                rep = ceil(nSamps / xRows);              % Duplicate input in frame
                UU = repmat(X, rep, 1);
                IC = UU(1:nSamps,:);                     % IC equals first frame
                UUU = [UU(nSamps+1:end,:); UU(1:R,:)].'; % Circular shift data to beginning
                UU = reshape(UUU, 1, xCols, []);
            end

            outRows = 1;      % We are feeding samplebased rows to the buffer block
            outCols = xCols;  % Number of channels stays the same

            insert_Buffer(fullblk, IC);
        end

    case 'Holding final value'
        [UU, outCols] = reshape2D(X,nSamps);

    	% We have more work to do if HOLD FINAL VALUE is selected
    	% samples per frame is greater than one.  Fill out the remaining
    	% frame with the last value and then build an additional frame
    	% full of final values to be repeated.

        remove_Buffer(fullblk);

        lastRow = X(end,:); % This is the values to hold

        if(xRows > nSamps)
            % Input has one full frame and a partially full frame
            R = mod(xRows, nSamps);
            if(R > 0)
                % Fill last part of frame with last value
				% xxx
                % pad = ones(nSamps-R,1) * lastRow;
                % UU(R+1:end,:,end) = pad;
                UU(R+1:end,:,end) = lastRow( ones(nSamps-R,1), :);
            end
            % Create a full frame of last values
			% xxx
            % lastFrame = ones(nSamps,1) * lastRow;
            % UU(:,:,end+1) = lastFrame;
            UU(:,:,end+1) = lastRow( ones(nSamps,1), :);

        else
            % There will always be a remainder of the frame
            % that must be filled because the signal length
            % is less than the frame length in this case.
            R = nSamps-xRows;
            if(R > 0)
                % Fill last part of frame with last value
				% xxx
                % pad = ones(R,1) * lastRow;
                % UU(end-R+1:end,:) = pad;
                UU(end-R+1:end,:) = lastRow(ones(R,1), :);
            end
            % Create a full frame of last values
			% xxx
            % lastFrame = ones(nSamps,1) * lastRow;
            % UU = cat(3, UU, lastFrame);

            % REPLACE with this line when fi supports 'cat'
            %UU = cat(3, UU, lastRow(ones(nSamps,1), :));
            [mm,nn,ll] = size(UU);
            UU(1:mm,1:nn,ll+1) = lastRow(ones(nSamps,1),:);
        end
    end  % End of Switch/case

end

% Form structure input for Simulink From Workspace block
s.time               = [];
if makeItComplex && isreal(UU)
  s.signals.values     = complex(UU);
else
  s.signals.values     = UU;
end
s.signals.dimensions = [outRows outCols];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [UU, nChans] = reshape2D(U,nSamps)

% if U is 1D then it is a column

% Reshape data
[m,n] = size(U);

nChans = size(U,2);

% need this line for fi objects
UU = U(1);

if (nSamps == 1)
   % Single sample per channel
   % Move  rows into 3D matrix
   UU(1,1:n,1:m) = U.';

else

   if (m==1) || (n==1)
      % VECTOR input to create new 3D output:
      UU(1:nSamps,1,1:ceil(m*n/nSamps)) = buffer(U(:,1),nSamps);
   else
      % MATRIX input
      U = reshape(U.',m*n,1);       % Force into column
      V = buffer(U,nChans*nSamps);  % Buffer U

      % Reshape and put into 3D array
      nSteps = size(V,2);
      if (nSteps < nChans)   %choose the faster loop for rearranging
        for i = 1:nSteps
            UU(1:nSamps,1:nChans,i) = reshape(V(:,i),nChans,nSamps).';
        end
      else
        for i=1:nChans
            UU(1:nSamps,i,1:nSteps) = V(i:nChans:nChans*nSamps,:);
        end
      end
   end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function setOutputFrameStatus(fullblk, X, nSamps)

   frame_conv_blk  = [fullblk '/Frame Status'];
   frameStr        = get_param(frame_conv_blk, 'OutFrame');

   % Decide if data is to be output as framebased or not
   if (nSamps > 1) & (ndims(X) ~= 3),
      if ~strcmp(frameStr,'Frame-based')
         set_param(frame_conv_blk, 'OutFrame', 'Frame based');
      end
   else
      if ~strcmp(frameStr,'Sample-based')
         set_param(frame_conv_blk, 'OutFrame', 'Sample based');
      end
   end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function insert_Buffer(fullblk, IC)
% If the Buffer block does not exist, then insert it

buffer_blk  = [fullblk '/Buffer'];

if ~exist_block(fullblk, 'Buffer')
   delete_line(fullblk,'From Workspace/1','Frame Status/1');
   load_system('dspbuff3');  % Library must be loaded to add_block
   add_block('dspbuff3/Buffer',buffer_blk);

   set_param(buffer_blk,'Position',[140    20   190    70]);

   add_line(fullblk,'From Workspace/1','Buffer/1');
   add_line(fullblk,'Buffer/1','Frame Status/1');

end

% Setting the parameters of the Buffer block
set_param(buffer_blk, 'ic', mat2str(double(IC)));
set_param(buffer_blk, 'N', mat2str(size(IC,1)));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function remove_Buffer(fullblk)
%If the blocks exist, then remove them

if exist_block(fullblk, 'Buffer')
   delete_line(fullblk,'From Workspace/1','Buffer/1');
   delete_line(fullblk,'Buffer/1','Frame Status/1');
   delete_block([fullblk '/Buffer']);
   add_line(fullblk,'From Workspace/1','Frame Status/1')
end

% [EOF] dspblksfw2.m
