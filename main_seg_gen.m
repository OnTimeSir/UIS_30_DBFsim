% clear
clc
close all
%%
c       = 1540;     % sound speed, m/s
% hardware specification
CHNUM   = 64;       % max channel count supported.
Fu      = 64e6;     % update master clock, 64MHz  
Fs      = 260e6;    % system master clock, 260MHz
ele_mid = 31.25;

probe_type = 'linear';
%% probe parameters.
switch lower(probe_type)
    case {'linear'}
        pitchsz = 300e-6;   % um
        elenum  = 128;      % element number.
        % user dependent
        Fnum    = 1.5;
        steera  = 0;       % steer degree   
        maxd    = 120e-3;    % mm -> m     
    case {'phase'}
        pitchsz = 254e-6;   % um
        elenum  = 128;      % element number.
        % user dependent
        Fnum    = 1.5;
        steera  = -45;       % steer degree
        maxd    = 260e-3;    % mm -> m     
    case {'convex'}
        R0   	= 60e-3;    % mm
        pitchsz = 498e-6;   % um
        elenum  = 128;      % element number.
        % user dependent
        Fnum    = 1.5;
        steera  = 6;       % steer degree
        maxd    = 260e-3;    % mm -> m     
    otherwise
        return;
end
ch = 0:(CHNUM-1);
x = (ch-ele_mid)*pitchsz;       

%% calculated parameters.
Nu      = ceil(maxd/c*Fu);            % update zone needed 
du      = 1/Fu*c;                     % update depth/clock (m).
%% piece-wise approaching
probe_type = 'linear';
% span segement define.
span_cnt = 126;
switch lower(probe_type)
    case {'linear'}
        span_pos = Gen_seg_spec( Nu, 16, 120, 126); 
%         plot(span_pos,'ro') 
        filename = 'seg_spec_linear.dat';
        filename2 = 'seg_spec_linear.mat';
    case {'phase'}
        span_pos = Gen_seg_spec( Nu, 16, 400, 126); 
        filename = 'seg_spec_phase.dat';
        filename2 = 'seg_spec_phase.mat';
%         plot(span_pos,'ro')     
    case {'convex'}
        span_pos = Gen_seg_spec( Nu, 16, 300, 126); 
%         plot(span_pos,'ro')   
        filename = 'seg_spec_convex.dat';
        filename2 = 'seg_spec_convex.mat';
    otherwise
        return;
end
% stem(span_pos)
%% scale bit count
span_scale_bitcount = gen_slopescale126(probe_type);

save (filename2, 'span_pos', 'span_scale_bitcount');

fid = fopen(filename,'w');
fwrite(fid, uint32(span_pos), 'uint32');
fwrite(fid, uint32(span_scale_bitcount), 'uint32');
fclose(fid);

% span_scale = gen_slopescale126(probe_type);