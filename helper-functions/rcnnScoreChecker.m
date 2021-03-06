function [probability,FastRCNNTime] = rcnnScoreChecker(image,net,boxes,varargin)
%FAST_RCNN_DEMO  Demonstrates Fast-RCNN
%
% Copyright (C) 2016 Abhishek Dutta and Hakan Bilen.
% All rights reserved.
% https://github.com/vlfeat/matconvnet/blob/master/examples/fast_rcnn/fast_rcnn_demo.m
%
% This file is part of the VLFeat library and is made available under
% the terms of the BSD license (see the COPYING file).

% Modified by: Oscar Howse 21116226
% 
%net = handles.net;
% Load an image and convert to grayscale if image is RGB.
if size(image,3) > 1
    im = rgb2gray(image);
    im = single(im) ;
else 
    im = single(image) ;
end

% Resize images and boxes to a size compatible with the network.
imageSize = size(im) ;
fullImageSize = net.meta.normalization.imageSize(1) ...
    / net.meta.normalization.cropSize ;
scale = max(fullImageSize ./ imageSize(1:2)) ;
im = imresize(im, scale, ...
              net.meta.normalization.interpolation, ...
              'antialiasing', false) ;
boxes = bsxfun(@times, boxes - 1, scale) + 1 ;


% Remove the average color from the input image.
imNorm = im - net.meta.normalization.averageImage ;
% Convert boxes into ROIs by prepending the image index.
rois = [ones(1,size(boxes,2)) ; boxes] ;

net.conserveMemory = false ;
% Evaluate the R-CNN
net.eval({'data', imNorm, 'rois', rois});

% Extract class probabilities
probs = squeeze(gather(net.vars(net.getVarIndex('cls_prob')).value)) ;
c = 16; %Class ID for class 'person'
probability = max(probs(c,:));
FastRCNNTime = sum([net.layers(1:38).forwardTime]);
toc