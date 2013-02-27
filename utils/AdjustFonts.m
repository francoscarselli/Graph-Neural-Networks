%Copyright (c) 2006, Franco Scarselli
%All rights reserved.
%
%Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
%
%Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
%Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
%
%THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.



function AdjustFonts(handles)
global fonts
for it=fieldnames(handles)'
    if ishandle(handles.(char(it)))
        if ~isempty(strfind(char(it),'Butt')) 
            set(handles.(char(it)),'FontName',fonts.Button.font);
            set(handles.(char(it)),'FontSize',fonts.Button.size);
        elseif  ~isempty(strfind(char(it),'Pop')) 
            set(handles.(char(it)),'FontName',fonts.Pop.font);
            set(handles.(char(it)),'FontSize',fonts.Pop.size);
        elseif  ~isempty(strfind(char(it),'Chk')) 
            set(handles.(char(it)),'FontName',fonts.Chk.font);
            set(handles.(char(it)),'FontSize',fonts.Chk.size);
        elseif ~isempty(strfind(char(it),'Radio')) 
            set(handles.(char(it)),'FontName',fonts.Radio.font);
            set(handles.(char(it)),'FontSize',fonts.Radio.size);
        elseif ~isempty(strfind(char(it),'Edit')) 
            set(handles.(char(it)),'FontName',fonts.Edit.font);
            set(handles.(char(it)),'FontSize',fonts.Edit.size);
        elseif ~isempty(strfind(char(it),'Bar'))
            set(handles.(char(it)),'FontName',fonts.Bar.font);
            set(handles.(char(it)),'FontSize',fonts.Bar.size);
        elseif ~isempty(strfind(char(it),'Text'))
            set(handles.(char(it)),'FontName',fonts.Text.font);
            set(handles.(char(it)),'FontSize',fonts.Text.size);
        elseif ~isempty(strfind(char(it),'Title'))
            set(handles.(char(it)),'FontName',fonts.Title.font);
            set(handles.(char(it)),'FontSize',fonts.Title.size);
        end
    end
end