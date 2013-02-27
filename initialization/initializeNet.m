%Copyright (c) 2006, Franco Scarselli
%All rights reserved.
%
%Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
%
%Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
%Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
%
%THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.



function [parameters,net]=initializeNet(net)

switch net.nLayers
    case {1} 
        parameters.weights1=2*(rand(net.nOuts,net.nInputs)-0.5)*net.weightRange;
        parameters.bias1=2*(rand(net.nOuts,1)-0.5)*net.weightRange;
        if strcmp(net.outActivationType,'linear')
            net.forwardFunction=@forwardOneLayerLinearOutNet;
            net.backwardFunction=@backwardOneLayerLinearOutNet;
            net.getDeltaJacobianFunction=@getDeltaJacobianOneLayerLinearOutNet;
        elseif strcmp(net.outActivationType,'tanh')
            net.forwardFunction=@forwardOneLayerNet;
            net.backwardFunction=@backwardOneLayerNet;
            net.getDeltaJacobianFunction=@getDeltaJacobianOneLayerNet;
        end
    case {2}
        parameters.weights1=2*(rand(net.nHiddens,net.nInputs)-0.5)*net.weightRange;
        parameters.bias1=2*(rand(net.nHiddens,1)-0.5)*net.weightRange;
        parameters.weights2=2*(rand(net.nOuts,net.nHiddens)-0.5)*net.weightRange;
        parameters.bias2=2*(rand(net.nOuts,1)-0.5)*net.weightRange;
        if strcmp(net.outActivationType,'linear')
            net.forwardFunction=@forwardTwoLayerLinearOutNet;
            net.backwardFunction=@backwardTwoLayerLinearOutNet;
            net.getDeltaJacobianFunction=@getDeltaJacobianTwoLayerLinearOutNet;
        elseif strcmp(net.outActivationType,'tanh')
            net.forwardFunction=@forwardTwoLayerNet;
            net.backwardFunction=@backwardTwoLayerNet;
            net.getDeltaJacobianFunction=@getDeltaJacobianTwoLayerNet;
        end
end