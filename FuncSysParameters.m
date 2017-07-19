function sysparam = FuncSysParameters( probe_type )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
sysparam.c       = 1540;     % sound speed, m/s
% hardware specification
sysparam.CHNUM   = 64;       % max channel count supported.
sysparam.Fu      = 64e6;     % update master clock, 65MHz  
sysparam.Fs      = 256e6;    % rx clock, 256MHz
sysparam.Fs_tx   = 192e6;    % tx clock
% probe_type = 'linear';
%% probe parameters.
switch lower(probe_type)
    case {'linear'}
        sysparam.pitchsz = 300e-6;   % um
        sysparam.elenum  = 128;      % element number.
        % user dependent
        sysparam.Fnum    = 1.5;
        sysparam.steera  = 0;       % steer degree   
        sysparam.maxd    = 120e-3;    % mm -> m     
    case {'phase'}
        sysparam.pitchsz = 254e-6;   % um
        sysparam.elenum  = 128;      % element number.
        % user dependent
        sysparam.Fnum    = 1.5;
        sysparam.steera  = -45;       % steer degree
        sysparam.maxd    = 260e-3;    % mm -> m     
    case {'convex'}
        R0   	= 60e-3;    % mm
        sysparam.pitchsz = 498e-6;   % um
        sysparam.elenum  = 128;      % element number.
        % user dependent
        sysparam.Fnum    = 1.5;
        sysparam.steera  = 6;       % steer degree
        sysparam.maxd    = 260e-3;    % mm -> m     
    otherwise
        return;
end
     
%% calculated parameters.
sysparam.Nu      = ceil(sysparam.maxd/sysparam.c*sysparam.Fu);   % update zone needed 
sysparam.du      = 1/sysparam.Fu*sysparam.c;                     % update depth/clock (m).
sysparam.sina    = double(sin(sysparam.steera*pi/180));   
sysparam.cosa    = double(cos(sysparam.steera*pi/180)); 

sysparam.ch2sysclk = sysparam.pitchsz/sysparam.c*sysparam.Fu;
sysparam.ch2rxclk = sysparam.ch2sysclk*4;
end

