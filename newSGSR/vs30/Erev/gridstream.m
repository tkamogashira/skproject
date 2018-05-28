function [Ekin, Epot, Flux] = gridstream(Nx,Ny,Aspect, y1,y2, omega, s2);
% gridstream - 2-D flow in a rectangle with in- and outlets at opposing sides
%   syntax:
%    gridstream(Nx,Ny,Aspect, y1,y2, omega, s2);

if nargin<6, omega=1; end;  % no stifness : HF limit, mass dominated
if nargin<7, s2 = 0*y2; end; % outlets are perfectly compliant

[X,Y] = meshgrid(linspace(0,Aspect,Nx), linspace(0,1,Ny)); 
% jitter the inner points
X(2:end-1, 2:end-1) = X(2:end-1, 2:end-1) + 0.5*Aspect/Nx*(rand(size(X)-2)-0.5); 
Y(2:end-1, 2:end-1) = Y(2:end-1, 2:end-1) + 0.5/Ny*(rand(size(Y)-2)-0.5); 


X = X(:); Y = Y(:); 

% indices of inlet and outlet
iy1 = 1+floor(y1*Ny); % first column
iy2 = 1+floor(y2*Ny) + Ny*(Nx-1); % last column
TRI = delaunay(X,Y);
% deform to get tapered form
%X = (max(X(:))-X).*(0.1+(0.2./(0.2+Y)).^2);

triplot(TRI, X, Y); figure(gcf);

% find oriented area of all triangles and also point of gravity
Ntri = size(TRI,1); ONES = [1;1;1];
Area = zeros(1,Ntri);
Pgr = zeros(Ntri,2);
for itri = 1:Ntri, 
    tri = TRI(itri,:);
    vertex = [X(tri), Y(tri)];
    Pgr(itri,:) = sum(vertex)/3;
    % patch(vertex(:,1), vertex(:,2), rand(1,3));
    Area(itri) = 0.5*(det([vertex, ONES]));
    sides(3*itri+[-2:0],1:2) = [sort(tri([1 2])); sort(tri([2 3])); sort(tri([3 1]))];
end

% change the order of the vertices of the negative-surface triangles ..
% .. so that the oriented areas become all positive
ineg = find(Area<0);
TRI(ineg,[1 2]) = TRI(ineg,[2 1]);
Area = abs(Area);
% Kinetic energy is two-form in flow with diagonal matrix given by areas;
KinMat = diag(Area);

% now collect all sides of all triangles; this is where the boundary conditions are
sides = zeros(Ntri*3,2);
for itri = 1:Ntri, 
    tri = TRI(itri,:);
    sides(3*itri+[-2:0],1:2) = [tri([1 2]); tri([2 3]); tri([3 1])];
    %xplot(Pgr(itri,1), Pgr(itri,2), '*m')
end
Nside = 3*Ntri; % inner sides are counted double

% boundary conditions
inlet = iy1+[0 1];  % external side functioning as inlet
outlet = [iy2(:), iy2(:)+1]; % idem outlet(s)
[outlet isort] = unique(outlet,'rows');
stiffness = s2(isort);
% Each side of each triangle contributes one constraint (except the outlet).
% There are four kinds of sides:
%  1. inlet: flux is 1 per definition
%  2. outlet: flux is free (but should end up equal to inlet)
%  3. all remaining outer sides: zero flux
%  4. inner side: flux matches that of neighboring triangle (fluid conservation)

PotMat = zeros(2*Ntri); % potential energy matrix
Mconstr = []; % constraint matrix
Vconstr = []; % constraint vector
revsides = flipLR(sides); % sides with vertices reversed
Xoutsides = []; Youtsides = [];
for iside=1:Nside,
    itri = 1 + floor((iside-1)/3);
    s = sides(iside,:);
    svec = [diff(X(s)), diff(Y(s))]; % vector along the side
    nvec = [1 -1].*svec([2 1]); % outward normal vector of side
    mc = zeros(1,2*Ntri); % initialize new row for constr matrix
    mc([itri+[0 Ntri]]) = nvec; % constr describes flux across current side  
    vc = 0; % default: homogeneous constraint
    % what type of side is this (see above list)
    if isequal(sort(s), inlet),
        %disp('inlet')
        vc = 1; % inhomogeneous constraint
    elseif ismember(sort(s), outlet,'rows'),
        ioutlet = find(ismember(outlet, sort(s), 'rows'));
        st = stiffness(ioutlet);
        %disp('outlet')
        mc = []; vc = []; %no constraint at all
        pm = st*nvec'*nvec;
        PotMat(itri,itri) = pm(1,1);
        PotMat(itri+Ntri,itri+Ntri) = pm(2,2);
        PotMat(itri+Ntri,itri) = pm(2,1);
        PotMat(itri,itri+Ntri) = pm(1,2);
    else, % inner or outer side?
        % find matching side
        jside = find(ismember(revsides, s, 'rows'));
        if isempty(jside), 
            %disp('outer side')
            xplot(X(s),Y(s),'r','linewidth',4); 
            Xoutsides = [Xoutsides, X(s)];
            Youtsides = [Youtsides, Y(s)];
        else, 
            %disp('inner side')
            % to which triangle does this side belong?
            jtri = 1 + floor((jside-1)/3);
            if jside<iside, continue; end % already visited from other triangle
            xplot(X(s),Y(s),'g'); 
            mc([jtri+[0 Ntri]]) = -nvec;
        end
    end
    % at constraint to matrx and vector
    Mconstr = [Mconstr; [mc]];
    Vconstr = [Vconstr; vc]; 
end

KinMat = diag([Area, Area]);
Flux = constrmin(KinMat*omega.^2+PotMat, Mconstr, Vconstr);
Flux = reshape(Flux,Ntri,2);
absFlux = sqrt(Flux(:,1).^2 + Flux(:,2).^2);
MaxFlux = max(absFlux);
fluxColor = 1+floor(sqrt(absFlux/MaxFlux)*64);
for itri = 1:Ntri, 
    flux = Flux(itri,:);
    tri = TRI(itri,:);
    patch(X(tri),Y(tri), fluxColor(itri),'edgecolor','none');
    xplot(Pgr(itri,1)+flux(1)*[-1 1]/50, Pgr(itri,2)+flux(2)*[-1 1]/50,'k','linewidth',1);
end
xplot(Xoutsides, Youtsides, 'k', 'linewidth',6);

xlim([0 Aspect]); ylim([0 1]);

Ekin = Flux(:)'*KinMat*Flux(:)*omega^2;
Epot = Flux(:)'*PotMat*Flux(:);






