%% Define Get Group Cluster Function
% Inputs:
%       video: the array of binarized images of size [height width]
%       frame: the current frame of the video
%       start_row: the row of the starting pixel
%       start_col: the column of the starting pixel
%       visited_in: a matrix of size [height width] whose elements are either
%            0 (unvisited) or 1 (visited)
%       currentGroup: the current group number of the neuron contained at
%            the starting index
%       
%       curGroupCluster_in: a matrix of size [height width] whose elements are
%            either 0(background) or n(neuron), where n is the groupNumber
%
%       curGroupNum: the current group number
%
%       NOTE: this value will be modified and returned as
%       curGroupCluster_out
%
% Return:
%       curGroupCluster_out: a matrix of size [height width] whose elements are
%            either 0(background) or n(neuron), where n is the groupNumber
%       NOTE: this is a modified version of curGroupCluster_in
%       visited_out: a matrix of size [height width] whose elements are either
%            0 (unvisited) or 1 (visited)
%
% Note: in curGroupCluster(frame), n <= array_of_groupNums(frame)


function [curGroupCluster_out, visited_out] = ...
    getGroupCluster(video, frame, start_row, start_col, visited_in, curGroupCluster_in, curGroupNum)
    
    %declare local variables
    q = java.util.LinkedList;
    visited = visited_in;
    curGroupCluster = curGroupCluster_in;
    
    %add start pixel to queue
    q.add([start_row; start_col]);
    
    %as long as there are pixels in the cluster to be processed
    while ~q.isEmpty()
        targetPixel = q.remove();    %remove next value from queue
        
        % call function to return indices of neighboring pixels
        validNeighbors = getValidNeighbors(targetPixel(1), targetPixel(2), squeeze(video(frame, :,:)));
        
        [~, neighbors_width] = size(validNeighbors);
        for i = 1:neighbors_width
            % For unvisited neighboring pixels (in bounds), 
            % check if pixel is white (intensity > 0)
            neighbor_row = validNeighbors(1, i);
            neighbor_col = validNeighbors(2, i);
            
            if visited(neighbor_row,neighbor_col) == 0 %if unvisited
                %if unvisited and bright
                if video(frame, neighbor_row, neighbor_col) > 0
                    q.add([neighbor_row; neighbor_col]);     %add to queue
                    visited(neighbor_row, neighbor_col) = 1;
                    
                    %mark pixel as being in the current group
                    curGroupCluster(neighbor_row, neighbor_col) = curGroupNum;
                end
            end
        end
    end
    
    %update return values
    visited_out = visited;
    curGroupCluster_out = curGroupCluster;
end