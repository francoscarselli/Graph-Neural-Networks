%Copyright (c) 2006, Franco Scarselli
%All rights reserved.
%
%Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
%
%Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
%Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
%
%THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.



function [lr,rollBack,state]=computeLearningRate(step,lr,error,state)

%% This fucntion compute the next learning rate by using an adaptive procedure
%% It returns
%% lr - the learning rate
%% rollBack - a variable which is set to 1 when the parameters should be
%%            restored to the previous values. It is used for signaling that error was increased to much
%% state - a structure containing some variables which will be useful at
%% the next activations

action=9;
rollBack=0;
sle=size(state.lastErrors);
nLastErrors=sle(2);


%% If error was encreased then learning factor is too large: we decrease it
%% and we set roolback to 1. Moreover, the set of last error was flushed
%% action contains a code that describe the action carried out on the
%% learning factor. The variable is used for debugging/logging puroposes
if (nLastErrors>1 && error >state.lastErrors(1));
    lr=lr*0.60;
    state.action(step)=-100;
    rollBack=1;
    state.increasedLR=0;
    state.lastErrors=[];
    return
end

%% if the vector lastErrors does not still contain two error then we
%% cannot use the adptive learning. First we check that condition.
%% Then, if error was not increased then we look at the error at times i-2 and i-1 and the previous action
%% in order to decide what to do.

if(nLastErrors==2)

    %% learning factor was increased and learning became faster  ->
    %% we increase learning factor
    if ((state.lastErrors(1)-error) >= (state.lastErrors(2)-state.lastErrors(1))) && state.increasedLR==1
        lr=lr*1.1;
        state.action(step)=2;
        state.increasedLR=1;
        %% learning factor was increased and learning became slower  ->
        %% we decrease learning factor
    elseif ((state.lastErrors(1)-error) < (state.lastErrors(2)-state.lastErrors(1))) && state.increasedLR==1
        lr=lr/1.1;
        state.action(step)=-1;
        state.increasedLR=-1;
        %% learning factor was decreased and learning became faster  ->
        %% we decrease learning factor
    elseif ((state.lastErrors(1)-error) > (state.lastErrors(2)-state.lastErrors(1)))&& state.increasedLR==-1
        lr=lr/1.1;
        state.action(step)=-2;
        state.increasedLR=-1;
        %% learning factor was decreased and learning became slower  ->
        %% we increase learning factor
    elseif ((state.lastErrors(1)-error) <= (state.lastErrors(2)-state.lastErrors(1))) && state.increasedLR==-1
        lr=lr*1.1;
        state.action(step)=1;
        state.increasedLR=1;
    elseif state.increasedLR==0
        state.increasedLR=1;
        state.action(step)=10;

    end
end

%% Finally, we update the last errors vector
if(nLastErrors<2)
    state.lastErrors(nLastErrors+1)=0;
    state.action(step)=0;
end
state.lastErrors=circshift(state.lastErrors',1)';
state.lastErrors(1)=error;