%% Define Get Analyze Cluster Function
% Inputs:
%       prevGroupCluster: a matrix of size [height width] whose elements are
%            either 0(background) or n_prev(neuron), where n is the groupNumber
%       NOTE: This is the previous frame (for the first frame, this will be
%       all zeros, but it will be ignored)
%
%       curGroupCluster: a matrix of size [height width] whose elements are
%            either 0(background) or n_current(neuron), where n is the groupNumber
%       NOTE: This is the current frame
%
%       start_row: the row of the starting pixel
%
%       start_col: the column of the starting pixel
%
%       frame: the current frame of the video
%
% Return:
%       allDark: true if all pixels in the current group of curGroupCluster
%           map to black (intensity = 0) pixels in prevGroupCluster
%       
%       oneGroup: true if all pixels in the current group of
%           curGroupCluster map to one and only one group number in
%           prevGroupCluster
%
% Note: in curGroupCluster(frame), n_current <= numGroups

function [allDark, oneGroup] = analyzeCluster(prevGroupCluster, ...
    curGroupCluster, start_row, start_col, frame)

    [height, width] = size(prevGroupCluster);
    groupNum = curGroupCluster(start_row, start_col);
    allDark = 1;
    oneGroup = 1;
        
    for row = start_row:height
        for col = start_col:width
            %if pixel is part of current group
            if curGroupCluster(row, col) == groupNum
                prevPixel = prevGroupCluster(row, col);
               
                %if corresponding pixel in previous frame is not 0
                if prevPixel ~= 0
                    allDark = 0;
                    
                    %if group number doesn't match previous frame
                    if prevPixel ~= groupNum && prevPixel ~= 0
                        oneGroup = 0;
                        
                        %if both conditions have been met, no need to keep
                        %searching
                        return
                    end
                end
            end
        end
    end
    
    if frame == 1
        oneGroup = 1;
        allDark = 1; %force increment
    end
    
end