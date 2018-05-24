function this = quantizertool(q,showclass,showheadings,lbl,lblwidth)
%   Copyright 1999-2002 The MathWorks, Inc.

if nargin<1, q=[]; end
if nargin<2, showclass=[]; end
if nargin<3, showheadings=[]; end
if nargin<4, lbl=''; end
if nargin<5, lblwidth = []; end
if isempty(q), q=quantizer; end
if isempty(showclass), showclass = true; end
if isempty(showheadings), showheadings = false; end
if isempty(lbl), lbl=''; end  % In case lbl=[]

this = fdtbxgui.quantizertool;

if nargin==1 & isstruct(q)
  % The first argument is a structure of settings from getstate
  set(this,q);
else
  quantizer2tool(this,q);
  this.ShowQuantizerClass = showclass;
  this.ShowHeadings = showheadings;
  this.Label = lbl;
  this.LabelWidth = lblwidth;
end