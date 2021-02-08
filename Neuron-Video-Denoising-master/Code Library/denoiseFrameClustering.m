%% Define Denoise Frame Function using image clustering
% Return:
%       updatedImage: denoised image (same dimensions as im)
%       groupNumberMatrix: a matrix indicating the status of a pixel
%          -1: dark & visited
%           0: unvisited
%           n: neuron cluster (where n is its neuron number)
%      numGroups: the number of clusters in the frame 


function [updatedImage, groupNumberMatrix, numGroups] = denoiseFrameClustering(im, threshold)
    [height, width] = size(im);
    visited = zeros(height, width);
    neuronNum = 1;  %to label neurons
    
    for row = 1:height
        for col = 1:width
            %if pixel is unvisited
            if visited(row, col) == 0
                %if pixel is bright
                if im(row, col) > threshold
                   %process neuron and update visited
                   [visited, isNeuron] = processNeuron(row,col,neuronNum,im,visited, threshold*(2/3));                   
                   %increment neuronNum if valid neuron is detected
                   if isNeuron
                      neuronNum = neuronNum + 1; 
                   end
                %if not bright, mark as dark & visited
                else
                   visited(row, col) = -1;
                end
            end
        end
    end
    %% Replace pixels in cluster and bright with 255, else 0
    updatedImage= zeros(height,width);
    for row = 1: height
       for column = 1: width
           %if neuron pixel, set to 255
           if visited(row,column)>=1
               updatedImage(row,column)=255;
               
           %if noise, set to 0    
           else
               updatedImage(row,column)=0;
           end
       end
   end
groupNumberMatrix  = visited;
numGroups = (neuronNum - 1);
   
end