function sub10801(action)
% used in EX10801
switch(action)
    case 'helix'
        t=0:pi/50:10*pi;
        plot3(sin(t),cos(t),t)
    case 'sinc'
        [X Y]=meshgrid(-8:0.5:8);
        R=sqrt(X.^2+Y.^2)+eps;
        Z=sin(R)./R;
        mesh(Z)
    otherwise
        close
end