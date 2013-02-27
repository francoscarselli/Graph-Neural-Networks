%Copyright (c) 2006, Franco Scarselli
%All rights reserved.
%
%Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
%
%Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
%Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
%
%THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.



function [e,outState]=neuralModelQuadraticComputeError(dataset,x,optimalParam)

global dataSet dynamicSystem learning

%% x will be empty except when called to test the results
if isempty(x) && strcmp(dataset,'trainSet')
    in=[dynamicSystem.state;dataSet.trainSet.nodeLabels];
elseif isempty(x) && strcmp(dataset,'validationSet')
    in=[learning.current.validationState;dataSet.validationSet.nodeLabels];
else
    in=[x;dataSet.(dataset).nodeLabels];
end


%[outState.out,outState.outNetState]=feval(dynamicSystem.config.outNet.forwardFunction,in,'outNet');
outState.outNetState=feval(dynamicSystem.config.outNet.forwardFunction,in,'outNet',optimalParam);

%% Compute the error. The error is the quadratic difference of the targets from current outputs
%% In general  supervision may be placed only on some outputs: matrix "maksMatrix" allows to select the supervised outputs
outState.delta=(dataSet.(dataset).maskMatrix*outState.outNetState.outs')';
e= outState.outNetState.outs*dataSet.(dataset).maskMatrix*outState.outNetState.outs'/2;
