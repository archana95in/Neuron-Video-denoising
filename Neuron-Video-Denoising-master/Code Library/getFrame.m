%% Define Write Grayscale Video Function
% Inputs:
%   video_array: an array of grayscale images(intensities: [0-255])
%   index: the frame to retrieve

function frame = getFrame(video_array, index)
    frame = squeeze(video_array(index,:,:));
end