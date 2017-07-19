function slope_scale = gen_slopescale126(probe_type)

if nargin==0
    probe_type = 'convex';
end

switch lower(probe_type)
    case {'linear'}
%         scale_ctrl_point = [1   5;
%                             12  6;
%                             20  7;
%                             30  8;
%                             40  9;
%                             60  10;
%                             75  12;
%                             90  13
%                             105 15 ];
        scale_ctrl_point = [1   3;
                            8   4;
                            12  5;
                            20  6;
                            30  7;
                            40  8;
                            52  9;
                            65  10;
                            75  11;
                            90  12];
    case {'phase'}
%         scale_ctrl_point = [1   6;
%                             8   7;
%                             12  8;
%                             20  9;
%                             30  10;
%                             40  11;
%                             52  12;
%                             65  13;
%                             75  14;
%                             90  15];
        scale_ctrl_point = [1   3;
                            8   4;
                            12  5;
                            20  6;
                            30  7;
                            40  8;
                            52  9;
                            65  10;
                            75  11;
                            90  12];
    case {'convex'}
%         scale_ctrl_point = [1   6;
%                             8   7;
%                             12  8;
%                             20  9;
%                             30  10;
%                             40  11;
%                             52  12;
%                             65  13;
%                             75  14;
%                             90  15];
        scale_ctrl_point = [1   3;
                            8   4;
                            12  5;
                            20  6;
                            30  7;
                            40  8;
                            52  9;
                            65  10;
                            75  11;
                            90  12];
    otherwise
        slope_scale = [];        
        return;
end
%
len = length(scale_ctrl_point);
for i=1:len-1
    slope_scale(scale_ctrl_point(i,1):scale_ctrl_point(i+1,1)-1) = scale_ctrl_point(i,2);
end
slope_scale(scale_ctrl_point(len):126) = scale_ctrl_point(len,2);
slope_scale = [4 slope_scale];   % init scale=4.
end

