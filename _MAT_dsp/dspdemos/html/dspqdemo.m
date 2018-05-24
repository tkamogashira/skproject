%% Queues
% This example shows how to push and pop elements from a queue using a
% Queue block with a system of selection switches.
%%

% Copyright 2007-2012 The MathWorks, Inc.

open_system('dspqdemo');
%%
bdclose dspqdemo

%% Applications
% Queues have many practical applications. They are used in modeling to
% study communication traffic over limited bandwidth channels and in any 
% application where there is a limited resource serving an unknown number 
% of clients. A simple example is people lining up in front of a teller at
% a bank.
%
% Queues are used in messaging systems to provide reliable delivery. 
% In multitasking systems, they are used to buffer requests for limited 
% system resources.

%% Exploring the Example
% While the model is running, toggle the 'Push Next Input' switch to update 
% the signal from the Triggered Signal From Workspace block and to 
% trigger the Push port of the Queue block. The signal is pushed into the 
% block's FIFO register, and is shown on the 'Input Data' display. Next, 
% toggle the 'Pop Queue' switch to trigger the Queue block's Pop port, 
% which causes the block to output from its FIFO register. The output
% signal is shown on the 'Queue Data' display.
%
% The 'Queue Status' display shows the state of the Queue's FIFO. The Queue 
% block is configured to store a maximum of three signal samples. Try 
% changing this value in the block's Register size parameter and observe the 
% behavior of the Queue block's Empty and Full states as signals are 
% input and output from the FIFO.



