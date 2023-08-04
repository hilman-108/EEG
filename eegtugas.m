function varargout = eegtugas(varargin)
% EEGTUGAS MATLAB code for eegtugas.fig
%      EEGTUGAS, by itself, creates a new EEGTUGAS or raises the existing
%      singleton*.
%
%      H = EEGTUGAS returns the handle to a new EEGTUGAS or the handle to
%      the existing singleton*.
%
%      EEGTUGAS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EEGTUGAS.M with the given input arguments.
%
%      EEGTUGAS('Property','Value',...) creates a new EEGTUGAS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before eegtugas_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to eegtugas_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help eegtugas

% Last Modified by GUIDE v2.5 28-Nov-2020 07:53:56

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @eegtugas_OpeningFcn, ...
                   'gui_OutputFcn',  @eegtugas_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before eegtugas is made visible.
function eegtugas_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to eegtugas (see VARARGIN)

% Choose default command line output for eegtugas
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes eegtugas wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = eegtugas_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clear;
[EEG, command] = bdfread();
nama=EEG.data;
global nama;

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global nama

ss=nama(3:16,:);
cc=ss(:,1:15360);
data=rmbase(ss);

Fs=128;
channels={'AF3','F7','F3','FC5','T7','P7','O1','O2','P8','T8','FC6','F4','F8','AF4'};
ch=size(data,1);

for c=1:ch
    filtering(c,:)=eegfilt(data(c,:),128,1,45,0,64);
end

[weight, sphere] = runica(filtering, 'verbose', 'off');
W = weight*sphere;
icaEEG = W*filtering;
[icaEEG2, opt]= RemoveStrongArtifacts(icaEEG, (1:14), 1.25, Fs);
Data_wICA = inv(W)*icaEEG2;
Fs=128;
wlength=256;
NFFT = 2^nextpow2(wlength+1);
for c=1:14
    [power(c,:),frekuensi]=pwelch(Data_wICA(c,:),hamming(256),wlength/2,NFFT,Fs);
end
delta = power(:,1:16);
theta = power(:,17:32);
alpha = power(:,33:52);
beta = power(:,53:120);
gamma = power(:,121:257);

for c=1:14
    delta1(c,:) = mean(delta(c,:));
    theta1(c,:) = mean(theta(c,:));
    alpha1(c,:) = mean(alpha(c,:));
    beta1(c,:) = mean(beta(c,:));
    gamma1(c,:) = mean(gamma(c,:));
end
A = mean(delta1);
B = mean(theta1);
C = mean(alpha1);
D = mean(beta1);
E = mean(gamma1);
Hasil = [A B C D E];

handles.power=power;
handles.frekuensi=frekuensi;
handles.Hasil=Hasil;

guidata(hObject, handles)


% --- Executes when selected object is changed in uibuttongroup1.
function uibuttongroup1_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uibuttongroup1 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


switch get(eventdata.NewValue,'Tag');
    case 'radiobutton1'
        axes(handles.axes1);
        cla(handles.axes1,'reset');
        plotPSD(handles.power,handles.frekuensi);
        title('Power Spectral Density')
        xlabel('Frekuensi (Hz)')
        ylabel('Power Spectral (\muV^{2})')
        grid on
    case 'radiobutton2'
        axes(handles.axes1);
        cla(handles.axes1,'reset');
        bar(diag(handles.Hasil), 'stacked')
        set(gca,'XTickLabel',{'Delta (0-4Hz)','Theta (4-8Hz)','Alpha (9-13Hz)','Beta (13-30)','Gamma (>30)'});
        title('Frequency Spectrum')
        xlabel('Frekuensi')
        ylabel('Mean Power')

end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Hasil
Z = random_f(handles.Hasil);
set(handles.text3,'String',Z);
