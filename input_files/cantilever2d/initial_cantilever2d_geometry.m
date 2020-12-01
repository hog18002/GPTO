function initial_cantilever2d_geometry()
%
%% Initial design input file 
%
% *** THIS SCRIPT HAS TO BE CUSTOMIZED BY THE USER ***
%
% In this file, you must create two matrices that describe the initial
% design of bars.
%
% The first matrix contains the IDs (integer) and coordinates of the
% endpoints of the bars (point_matrix).
%
% The second matrix defines the IDs of the points that make up each bar.
% This matrix also sets the initial value of each bar's size variable, and
% the initial bar radius (half-width of the bar in 2-d).
%
% Note that this way of defining the bars allows for bars to be 'floating'
% (if the endpoints of a bar are not shared by any other bar) or
% 'connected' (if two or more bars share the same endpoint).
%

% *** Do not modify the line below ***
global FE GEOM 

% Format of point_matrix is [ point_id, x, y] for 2-d problems, and 
% [ point_id, x, y, z] for 3-d problems)

point_matrix = ... 
    [
          1    0, 10  % 56 points for 28 bars frame-like initial design
     2    10, 10 
     3    10, 10 
     4    20, 10 
     5    20, 10 
     6    30, 10 
     7    30, 10 
     8    40, 10 
     
     9    0, 5 
     10   10, 5 
     11   10, 5 
     12   20, 5 
     13   20, 5 
     14   30, 5 
     15   30, 5 
     16   40, 5     
     
     17    0, 0  
     18    10, 0 
     19    10, 0 
     20    20, 0 
     21    20, 0 
     22    30, 0 
     23    30, 0 
     24    40, 0 
     
     25    0, 10 
     26    10, 5 
     27    0, 5 
     28    10, 10 
     29    10, 10 
     30    20, 5 
     31    10, 5 
     32    20, 10 
     33    20, 10  
     34    30, 5 
     35    20, 5 
     36    30, 10 
     37    30, 10 
     38    40, 5 
     39    30, 5 
     40    40, 10 
     
     41    0, 5 
     42    10, 0 
     43    0, 0 
     44    10, 5 
     45    10, 5 
     46    20, 0 
     47    10, 0 
     48    20, 5     
     49    20, 5  
     50    30, 0 
     51    20, 0
     52    30, 5 
     53    30, 5
     54    40, 0 
     55    30, 0 
     56    40, 5 
     
%      1    2.4, 2.5  
%      2    2.6, 2.5 
%      3    7.4, 2.5 
%      4    7.6, 2.5 
%      5   12.4, 2.5 
%      6   12.6, 2.5 
%      7   17.4, 2.5 
%      8   17.6, 2.5 
%      9    2.4, 7.5 
%      10   2.6, 7.5 
%      11   7.4, 7.5 
%      12   7.6, 7.5 
%      13  12.4, 7.5 
%      14  12.6, 7.5 
%      15  17.4, 7.5 
%      16  17.6, 7.5 
     ];

 % Format of bar_matrix is [ bar_id, pt1, pt2, alpha, w/2 ], where alpha is
 % the initial value of the bar's size variable, and w/2 the initial radius
 % of the bar.
 %
bar_matrix = ... 
     [1 , 1 , 2 , 0.5, 0.5
      2 , 3 , 4 , 0.5, 0.5
      3 , 5 , 6 , 0.5, 0.5
      4 , 7 , 8 , 0.5, 0.5
      5 , 9 , 10, 0.5, 0.5
      6 , 11, 12, 0.5, 0.5
      7 , 13, 14, 0.5, 0.5
      8 , 15, 16, 0.5, 0.5
         9 , 17 , 18 , 0.5, 0.5
      10 , 19 , 20 , 0.5, 0.5
      11 , 21 , 22 , 0.5, 0.5
      12 , 23 , 24 , 0.5, 0.5
      13 , 25 , 26 , 0.5, 0.5
      14 , 27 , 28 , 0.5, 0.5
      15 , 29 , 30 , 0.5, 0.5
      16 , 31 , 32 , 0.5, 0.5
      17 , 33 , 34 , 0.5, 0.5
      18 , 35 , 36 , 0.5, 0.5
      19 , 37 , 38 , 0.5, 0.5
      20 , 39 , 40 , 0.5, 0.5
      21 , 41 , 42, 0.5, 0.5
      22 , 43 , 44, 0.5, 0.5
      23 , 45 , 46, 0.5, 0.5
      24 , 47 , 48, 0.5, 0.5
      25 , 49 , 50 , 0.5, 0.5
      26 , 51 , 52 , 0.5, 0.5
      27 , 53 , 54 , 0.5, 0.5
      28 , 55 , 56 , 0.5, 0.5
      ];

% *** Do not modify the code below ***
GEOM.initial_design.point_matrix = point_matrix;
GEOM.initial_design.bar_matrix = bar_matrix;

fprintf('initialized %dd initial design with %d points and %d bars\n',...
    FE.dim,...
    size(GEOM.initial_design.point_matrix,1),...
    size(GEOM.initial_design.bar_matrix,1));