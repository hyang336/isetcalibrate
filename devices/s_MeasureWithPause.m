%% s_MeasureWithPause
% Remotely control the PR670 photospectrometer to measure spectral
% reflection for OralEye project. Edit the code so that the result can be
% saved with the same format as ieSaveSpectralFiles do.

%% Initialize isetcam to use ieSaveSpectralFiles.m function
ieInit;

%%
tic
% Repeated measurements of a light
pathName = '20191207';
folderName = fullfile(icalRootPath, 'local', pathName);
if ~exist(folderName, 'dir'), mkdir(folderName); end
cd(folderName);
% SubjectName = 'WhiteTarget_Velscope';
%% Define the filename session

target = 'mcc24'; % tongue or white target
lightsource = 'OralEye_blue'; % LED400 / LED425 / LED450
filter = 'Y44'; % Y52 / NoY52
posNumber = 'position2'; % # of the positions
SubjectName = strcat(target,'_' ,lightsource,'_' ,filter,'_' ,posNumber);

%% Define the comment
subjectNumber = 'none';
shortPassFilter = 'None';
spectroRadioMeterModel = 'PR670';
longPassFilter = 'Y44';
power = 'None';
apertureSize = '0.5';

comment = strcat(target, " measurements for subject ", subjectNumber,...
            " illuminated with a ", lightsource, " with ", shortPassFilter,...
            " shortpass filter and measured with a ", spectroRadioMeterModel,...
            "spectroradiometer with ", longPassFilter,...
            ". Power supply was: ", power, " watts.", ...
            " The aperture size was: ", apertureSize, " deg.");
%%
photometerCOM = 'COM5';           % Select the correct COM port number for the photometer
%spectr = figure;

if ~isempty(instrfind) 
fclose(instrfind);
delete(instrfind);
end
instrfind;

% ph = PR670init(photometerCOM);
msg = PR670init(photometerCOM);
% ph = pr670init(photometerCOM);
% Change the pr aperture size to 0.5c
% The PR will integrate the spectrum over a smaller region, but the
% measurement will take longer
% fprintf(ph,'S,,,1\n');
% pause(1);
%%
nMeasruement = 1;
data = [];
%%
wav = [350:5:780];

for ii = 1:nMeasruement
    fprintf('Measuring spectrum.... ');
    spd =[];

    setwav = [350 3 87];
    while isempty(spd)
        spd = PR670measspd();
        %     [spd, wav] = pr670spectrum(ph);
    end
%     figure();
    hold on
    plot(wav,spd);hold on

    %save(sprintf('spectr%d.mat',80),'spd');
    %cd('C:\Users\SCIENlab\Documents\MATLAB-scien\MATLAB\workdir\velscope')
%     filename= sprintf([SubjectName,'_%dV.mat'],29-ii);
    data = [data,spd];
%     save(filename,'result');
    fprintf('Done!\n');
%     if ii~=3
%         uiwait(msgbox('Please decrease the light level by 1 V.','Pause','modal'));
%     end
end

fullPathName = fullfile(pwd, SubjectName);
saveas(gcf,[SubjectName,'_mcc.fig'],'fig');
ieSaveSpectralFile(wav', data, comment, fullPathName);
toc
% fclose(ph);
%{
s_400 = load('stanford_670_400.mat');
s_400 = s_400.result;filename= sprintf('oraleye_2_20190711_oraleye_reflect_blue_10.mat');

plot(s_400(1,:), s_400(2,:));hold on
p_400 = load('715_400.mat');
p_400 = p_400.result;
plot(p_400(1,:), p_400(2,:));
%}
%% quit remote mode
PR670write('Q', 0);
