function AddToUImessStack(h);

% adds message text handles to global stack so that
% ui message handlers know where to direct the message
global UImessStack

UIenable(h); % make sure that stuff can be written to it
UImessStack = [UImessStack h]; % row vector

% while we're here, why not clean up dead handles?
cleanUImessstack;
