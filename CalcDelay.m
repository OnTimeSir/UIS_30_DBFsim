function delay = CalcDelay( probe_type, x_mm, d_mm, steera, R0, approx)
% CalcDelay 
%   Detailed explanation goes here

if nargin<3
    error(' Insufficient parameters');
else
    if nargin < 6
        approx = 0;
    end
    if nargin <5
        R0 = 60;
    end
    
    if nargin<4
        steera = 0;
    else
end

sina = sin(steera*pi/180);
cosa = cos(steera*pi/180);

%%
ch = length(x_mm);
Nu = length(d_mm);
delay = zeros(ch,Nu);

% re format input
x_mm = reshape(x_mm, length(x_mm), 1);
x = repmat(x_mm, 1, Nu);
d_mm = reshape(d_mm, 1, length(d_mm));
d = repmat(d_mm, ch, 1);
%
switch lower(probe_type)
    case {'linear','phase'}  
        if approx==0
            delay = -sqrt(x.*x + d.*d + 2*sina*d.*x) + d; 
        else
            delay = -sina*x - cosa*cosa*(d.^(-1)).*(x.^2)/2;             
        end
    case {'convex'}
        theta = x/R0;
        ax = atan(sina*d.*(d*cosa+R0).^(-1));
        r = (R0+d*cosa).*(cos(ax)).^(-1);    
        delay = -sqrt(r.*r + R0*R0 - 2*cos(theta-ax).*r*R0) + d;
    otherwise
        return;
end
end

