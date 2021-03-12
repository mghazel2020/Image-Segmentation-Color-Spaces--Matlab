%==========================================================================
% Project: COlor-Based Image Segmentation using K-means clustering
%==========================================================================
% File: apply_color_based_segmentation_using_k_means.m
% Author: Mohsen Ghazel
% Date: Mar 12, 2021 
%==========================================================================
% Specifications: 
%==========================================================================
% - Color-Based Segmentation Using K-Means Clustering:
%--------------------------------------------------------------------------
%   - Segment colors in an automated fashion using the specified:
%     1) Color space: HSV or CIE LAB
%     2) K-means clustering: Specified K-value
%==========================================================================
% Input:
%==========================================================================
% - input_img: The input color sub-image
% - k_means: The number of classes of K for the K-means algorithm 
% - color_space: The color space (HSV or CIE LAB)
% - output_folder: output folder
%==========================================================================
% Output:
%==========================================================================
% - status = 1 for success and -1 for failure
%--------------------------------------------------------------------------
% Execution: 
%
% >> [status, k_masks] = 
%    apply_color_based_segmentation_using_k_means( 
%              input_img, k_means, color_space, output_folder )
%
%==========================================================================
% History
%==========================================================================
% Date                      Changes
%==========================================================================
% Mar 12, 2021             Initial definition
%==========================================================================
% MIT License:
%==========================================================================
% Copyright (c) 2021 mghazel2021
%==========================================================================
function [status, k_masks] = apply_color_based_segmentation_using_k_means( input_img, k_means, color_space, output_folder )

%--------------------------------------------------------------------------
% Step 1: Initialize the output parameters
%--------------------------------------------------------------------------
% execution status
%--------------------------------------------------------------------------
status = -1;

%--------------------------------------------------------------------------
% the input image size
%--------------------------------------------------------------------------
[nrows, ncols, nchannels] = size(input_img);

%--------------------------------------------------------------------------
% Set the classification colors of the K = 7 clusters:
%--------------------------------------------------------------------------
% each color is normalized between 0 and 1:
classification_colors = [255, 0, 0;
                         0, 255, 0;
                         0, 0, 255; 
                         255, 255, 0;
                         0, 255, 255;
                         255, 0, 255; 
                         255, 255, 255]/255.0;
                        
%--------------------------------------------------------------------------
% initialize the k-means masks
%--------------------------------------------------------------------------
k_masks = uint8(zeros(nrows, ncols, k_means));

%--------------------------------------------------------------------------
% https://www.mathworks.com/help/images/
% color-based-segmentation-using-k-means-clustering.html
%--------------------------------------------------------------------------
% Color-Based Segmentation Using K-Means Clustering View MATLAB Command
% 
% This example shows how to segment colors in an automated fashion using
% the L*a*b* color space and K-means clustering.
%--------------------------------------------------------------------------
% Step 1: Read Image Read in hestain.png, which is an image of tissue
% stained with hemotoxylin and eosin (H&E). This staining method helps
% pathologists distinguish different tissue types.
%--------------------------------------------------------------------------
% Step 2: Convert Image from RGB Color Space to L*a*b* Color Space How many
% colors do you see in the image if you ignore variations in brightness?
% There are three colors: white, blue, and pink. Notice how easily you can
% visually distinguish these colors from one another. The L*a*b* color
% space (also known as CIELAB or CIE L*a*b*) enables you to quantify these
% visual differences. The L*a*b* color space is derived from the CIE XYZ
% tristimulus values. The L*a*b* space consists of a luminosity layer 'L*',
% chromaticity-layer 'a*' indicating where color falls along the red-green
% axis, and chromaticity-layer 'b*' indicating where the color falls along
% the blue-yellow axis. All of the color information is in the 'a*' and
% 'b*' layers. You can measure the difference between two colors using the
% Euclidean distance metric. Convert the image to L*a*b* color space using
% rgb2lab.
%--------------------------------------------------------------------------
% - We can use HSV, CIELAB (LAB) or RGB color space:
%--------------------------------------------------------------------------
if ( strcmp(color_space, 'HSV' ) == 1 )
    % convert from RGB to HSV doamin
    color_space_img = rgb2hsv(input_img);
elseif ( strcmp(color_space, 'LAB' ) == 1 )
    % convert from RGB to LAB domain
    color_space_img = rgb2lab(input_img);
elseif ( strcmp(color_space, 'RGB' ) == 1 )
    % keep RGB 
    color_space_img = input_img;
end
%--------------------------------------------------------------------------
% Step 3: Classify the Colors in 'a*b*' Space Using K-Means Clustering
% Clustering is a way to separate groups of objects. K-means clustering
% treats each object as having a location in space. It finds partitions
% such that objects within each cluster are as close to each other as
% possible, and as far from objects in other clusters as possible. K-means
% clustering requires that you specify the number of clusters to be
% partitioned and a distance metric to quantify how close two objects are
% to each other. Since the color information exists in the 'a*b*' color
% space, your objects are pixels with 'a*' and 'b*' values. Convert the
% data to data type single for use with imsegkmeans. Use imsegkmeans to
% cluster the objects into three clusters.
%--------------------------------------------------------------------------
% - Dentify the color channels:
%--------------------------------------------------------------------------
% - HSV: The color channels are HS
% - LAB: The color channels are AB
% - RGB: The color channels are RGB
%--------------------------------------------------------------------------
% the names of the channels of the transformed color space
color_space_channels_names = [];
if ( strcmp(color_space, 'HSV' ) == 1 )
    % for the HSV color space, the color channels are HS
    color_channels = color_space_img(:,:, 1:2);
    % the names of the channels of the transformed color space
    color_space_channels_names = ['H' 'S' 'V'];
elseif ( strcmp(color_space, 'LAB' ) == 1 )
     % for the HSV color space, the color channels are AB
    color_channels = color_space_img(:,:, 2:3);
    % the names of the channels of the transformed color space
    color_space_channels_names = ['L' 'A' 'B'];
elseif ( strcmp(color_space, 'RGB' ) == 1 )
    % for RGB, use all color channels
    color_channels = color_space_img(:,:, 1:3);
    % the names of the channels of the transformed color space
    color_space_channels_names = ['R' 'G' 'B'];
end

% convert to single precision
color_channels = im2single(color_channels);

%--------------------------------------------------------------------------
% 2) display the seperate channels:
%--------------------------------------------------------------------------
%    - the separate channels of the RGB
%    - the separate channels of the color space
%--------------------------------------------------------------------------
% 2.1.1) display the input image: Red channel
%--------------------------------------------------------------------------
subaxis(2, 3, 1,  'sh', 0.01, 'sv', 0.02);
% display the image
imshow(input_img(:,:,1))
% title
title(['R'], 'FontSize', 7);
%--------------------------------------------------------------------------
% 2.1.2) display the input image: Green channel
%--------------------------------------------------------------------------
subaxis(2, 3, 2,  'sh', 0.01, 'sv', 0.02);
% display the image
imshow(input_img(:,:,2))
% title
title(['G'], 'FontSize', 7);
%--------------------------------------------------------------------------
% 2.1.3) display the input image: Blue channel
%--------------------------------------------------------------------------
subaxis(2, 3, 3,  'sh', 0.01, 'sv', 0.02);
% display the image
imshow(input_img(:,:,3))
% title
title(['B'], 'FontSize', 7);
%--------------------------------------------------------------------------
% 2.2.1) display the input image: Red channel
%--------------------------------------------------------------------------
subaxis(2, 3, 4,  'sh', 0.01, 'sv', 0.02);
% display the image
if ( strcmp(color_space, 'HSV' ) == 1 )
   imshow((color_space_img(:,:,1)));
elseif ( strcmp(color_space, 'LAB' ) == 1 )
    imshow(uint8(color_space_img(:,:,1)))
end
% title
title([color_space_channels_names(1) ], 'FontSize', 7);
%--------------------------------------------------------------------------
% 2.2.2) display the input image: Green channel
%--------------------------------------------------------------------------
subaxis(2, 3, 5,  'sh', 0.01, 'sv', 0.02);
% display the image
if ( strcmp(color_space, 'HSV' ) == 1 )
    imshow((color_space_img(:,:,2)));
elseif ( strcmp(color_space, 'LAB' ) == 1 )
    imshow(uint8(color_space_img(:,:,2)))
end
% title
title([color_space_channels_names(2)], 'FontSize', 7);
%--------------------------------------------------------------------------
% 2.2.3) display the input image: Blue channel
%--------------------------------------------------------------------------
subaxis(2, 3, 6,  'sh', 0.01, 'sv', 0.02);
% display the image
if ( strcmp(color_space, 'HSV' ) == 1 )
    imshow((color_space_img(:,:,3)));
elseif ( strcmp(color_space, 'LAB' ) == 1 )
    imshow(uint8(color_space_img(:,:,3)))
end
% title
title([color_space_channels_names(3)], 'FontSize', 7);
% orient portrait;
% save the results
saveas(gcf, [output_folder 'separate-channels-visualization.jpg']);

%--------------------------------------------------------------------------
% number of clustered colors
%--------------------------------------------------------------------------
% apply the k-means algorithm with k = k_means
%--------------------------------------------------------------------------
nColors = k_means;

%--------------------------------------------------------------------------
% For every object in your input,
% imsegkmeans returns an index, or a label, corresponding to a cluster.
% Label every pixel in the image with its pixel label.
%--------------------------------------------------------------------------
% - Repeat the clustering 10 times to avoid local minima 
%--------------------------------------------------------------------------
pixel_labels = imsegkmeans(color_channels, nColors, 'NumAttempts',10); 

%--------------------------------------------------------------------------
% Step 4: Create Images that Segment the input image by Color Using
% pixel_labels, you can separate objects in hestain.png by color, which
% will result in three images.
%--------------------------------------------------------------------------
% setup the sub-plot
if ( k_means == 2 )
    % the subplot number of rows
    subplot_nrows = 1;
    % the subplot number of cols
    subplot_ncols = 3;
    % font-size
    font_size = 5;
elseif ( k_means == 3 )
    % the subplot number of rows
    subplot_nrows = 1;
    % the subplot number of cols
    subplot_ncols = 4;
    % font-size
    font_size = 5;
elseif ( k_means == 5 )
    % the subplot number of rows
    subplot_nrows = 1;
    % the subplot number of cols
    subplot_ncols = 6;
    % font-size
    font_size = 3;
elseif ( k_means == 7 )
    % the subplot number of rows
    subplot_nrows = 2;
    % the subplot number of cols
    subplot_ncols = 4;
    % font-size
    font_size = 5;
end
% plot the input image
subaxis(subplot_nrows, subplot_ncols, 1,  'sh', 0.01, 'sv', 0.05);
% display the input image
imshow(input_img)
% title
title('Input Image', 'FontSize', font_size);
% iterate over the k_means classes
for k = 1: k_means
    % create a subplot
    subaxis(subplot_nrows, subplot_ncols, k+1, 'sh', 0.01, 'sv', 0.05);
    % set the mask
    mask_k = pixel_labels == k;
    cluster_k = input_img .* uint8(mask_k);
    % h30 = figure('visible','off');
    imshow(cluster_k)
    title([color_space ': Color # ' num2str(k) ], 'FontSize', font_size);
    %----------------------------------------------------------------------
    % update the k_masks
    %----------------------------------------------------------------------
    % uint8 mask: 0-225
    %---------------------------------------------------------------------
    k_masks(:,:, k) = uint8(mask_k);
end
% save the results
saveas(gcf, [output_folder 'different-colors-segmentations.jpg']);

%--------------------------------------------------------------------------
% - Create a final segmentation labelled image.
%--------------------------------------------------------------------------
% - Use MATLAB functionality: label2rgb()
%--------------------------------------------------------------------------
% >> help label2rgb
%  label2rgb Convert label matrix to RGB image.
%     RGB = label2rgb(L) converts a label matrix L, such as returned by
%     LABELMATRIX, BWLABEL, BWLABELN, or WATERSHED, into a color RGB image
%     for the purpose of visualizing the labeled regions.
%--------------------------------------------------------------------------       
segmented_img = label2rgb(pixel_labels,classification_colors);
% Create a new figure
h50 = figure('visible','off');
% display the segmented image
imshow(segmented_img)
% save the final segmentation results
saveas(h50, [output_folder 'final-color-based-segmentation-figure.jpg']);
% write the segmentation image to disk
imwrite(segmented_img, [output_folder 'final-color-based-segmentation-image.jpg']);

% close all the figures
close('all');

% set status to success
status = 1;

% return
return;

end

