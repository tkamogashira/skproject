function [ff,aa,free_edges] = firpmedge(ff, aa, edge_prop)
% Check for unconstrained band-edge frequencies or fixed gain points.
% Used by FIRPM2.
%
%  [ff,aa,free_edges] = firpmedge(ff, aa, edge_prop)
%          ff: vector of band edges
%          aa: desired values at band edges
%   edge_prop: cell array of character strings:
%              'n': normal edge
%              'f': exactly-specified point (error=0 at this point)
%              's': single-point band
%              'i': indeterminate band edge.  Used when bands abut.
%
%         ff: vector of band edges.  Possibly modified by an 's'
%         aa: desired values at band edges.  Possibly modified by 's'
%             If aa is a cell array then the second element of the cell
%             array must contain the band edges.
% free_edges: one value per band edge:
%              1: indeterminate band edge.
%              0: normal band edge.
%             -1: exactly-specified point.

%   Author(s): D. Shpak
%   Copyright 1999-2011 The MathWorks, Inc.

free_edges = zeros(1, length(ff));
if isempty(edge_prop)
   return;
end
if length(ff) ~= length(edge_prop)
   error(message('dsp:firpmedge:InvalidDimensions'));
end
if ~ischar(strcat(edge_prop{:}))
   error(message('dsp:firpmedge:FilterErr'));
end

offset = 0;
nEdges = length(edge_prop);
for i=1:nEdges
   prop = lower(edge_prop{i});
   switch prop
   case 'f'
      % Edge is exactly fixed
      free_edges(i+offset) = -1;
   case 'i'
      % Edge is at a "nominal" indeterminate frequency and can move
      if (i == 1 || i == nEdges)
         error(message('dsp:firpmedge:InvalidParam1'));
      end
      free_edges(i+offset) = 1;
   case 's'
      if rem((i+offset),2) == 0
          error(message('dsp:firpmedge:InvalidParam2'));
      end
      % Duplicate the edge for single-point bands
      free_edges(i+offset) = -1;
      free_edges(i+offset+1) = -1;
      ff = [ff(1:i+offset) ff(i+offset:end)];
      
      if iscell(aa)
        % Band edge amplitudes should be in the second element of the cell,
        % first element is a function handle.
        aa{2} = [aa{2}(1:i+offset) aa{2}(i+offset:end)];
      else            
        aa = [aa(1:i+offset) aa(i+offset:end)];
      end
      offset = offset + 1;
   case 'n'
      free_edges(i+offset) = 0;
   otherwise
      error(message('dsp:firpmedge:InvalidParam3'));
   end
end

% Unconstrained band edges on both sides of the transition
% region are not allowed since you can't set up a grid
% for that case
nbands = length(ff)/2;
for i = 1:nbands-1
    if (free_edges(2*i) == 1 && free_edges(2*i+1) == 1)
        error(message('dsp:firpmedge:InvalidParam4'));
    end
end
   
