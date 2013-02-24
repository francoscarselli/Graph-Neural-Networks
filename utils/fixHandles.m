%Copyright (c) 2006, Franco Scarselli
%All rights reserved.
%
%Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
%
%Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
%Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
%
%THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.



function fixHandles
global dynamicSystem

dynamicSystem.config.computeErrorFunction=str2func(func2str(dynamicSystem.config.computeErrorFunction));
dynamicSystem.config.computeDeltaErrorFunction=str2func(func2str(dynamicSystem.config.computeDeltaErrorFunction));
dynamicSystem.config.forwardFunction=str2func(func2str(dynamicSystem.config.forwardFunction));
dynamicSystem.config.backwardFunction=str2func(func2str(dynamicSystem.config.backwardFunction));
dynamicSystem.config.forwardJacobianFunction=str2func(func2str(dynamicSystem.config.forwardJacobianFunction));
dynamicSystem.config.backwardJacobianFunction=str2func(func2str(dynamicSystem.config.backwardJacobianFunction));

dynamicSystem.config.transitionNet.forwardFunction=str2func(func2str(dynamicSystem.config.transitionNet.forwardFunction));
dynamicSystem.config.transitionNet.backwardFunction=str2func(func2str(dynamicSystem.config.transitionNet.backwardFunction));
dynamicSystem.config.transitionNet.getDeltaJacobianFunction=str2func(func2str(dynamicSystem.config.transitionNet.getDeltaJacobianFunction));

dynamicSystem.config.outNet.forwardFunction=str2func(func2str(dynamicSystem.config.outNet.forwardFunction));
dynamicSystem.config.outNet.backwardFunction=str2func(func2str(dynamicSystem.config.outNet.backwardFunction));
dynamicSystem.config.outNet.getDeltaJacobianFunction=str2func(func2str(dynamicSystem.config.outNet.getDeltaJacobianFunction));
