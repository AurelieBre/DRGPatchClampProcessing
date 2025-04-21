function Axograph_to_Matlab

Protocol=[0 80 0 114 -2 111 0 116 0 111 0 99 0 111 0 108 0 32 0 58];
SeriesResistance=[0 83 0 101 0 114 0 105 0 101 0 115 0 32 0 82 0 101 0 115 0 105 0 115 0 116 0 97 0 110 0 99 0 101];
MembraneCapacitance=[0 77 0 101 0 109 0 98 0 114 0 97 0 110 0 101 0 32 0 67 0 97 0 112 0 97 0 99 0 105 0 116 0 97 0 110 0 99 0 101 0 32 0 32 0 61 0 32 0 32];
MembraneResistance=[0 77 0 101 0 109 0 98 0 114 0 97 0 110 0 101 0 32 0 82 0 101 0 115 0 105 0 115 0 116 0 97 0 110 0 99 0 101 0 32 0 32 0 32 0 32 0 32 0 32 0 32 0 32 0 61 0 32 0 32]; 


Global=[];
Allfilename=[];
AllfilenameTestPulse=[];
Allpath=[];
    
previouscd=cd;

list = {'ExVivo_Male','ExVivo_Female','ExVivo_ImmuneDepleted_Male','ExVivo_Male_SCNBmal1KO','Dexamethasone', 'ExVivo_Female_SCNBmal1KO', 'EAE_ScnBmal1_Experiment', 'ExVivo_MaleIC_100nMAK42', 'ExVivo_MaleVC', 'ExVivo_FemaleVC', 'ExVivo_MaleVC_SCNBmal1KO', 'ExVivo_FemaleVC_SCNBmal1KO'};
[indx,tf] = listdlg('ListString',list, 'SelectionMode','single');

if tf==1
    if indx==1
        globalpath='C:\Users\aurel\Documents\GhasemlouLab\Data\Circadian_experiment\PatchClamp\ExVivo\C57BL6\Male';
    elseif indx==2
        globalpath='C:\Users\aurel\Documents\GhasemlouLab\Data\Circadian_experiment\PatchClamp\ExVivo\C57BL6\Female';
    elseif indx==3
        globalpath='C:\Users\aurel\Documents\GhasemlouLab\Data\Circadian_experiment\PatchClamp\ExVivo\C57BL6\ImmuneDepleted_Male_Mice\GoodIP';
    elseif indx==4
        globalpath='C:\Users\aurel\Documents\GhasemlouLab\Data\Circadian_experiment\PatchClamp\ExVivo\Nav1.8_Bmal1\Male';
    elseif indx==5
        globalpath='C:\Users\aurel\Documents\GhasemlouLab\Data\Circadian_experiment\PatchClamp\Dexamethasone';
    elseif indx==6
        globalpath='C:\Users\aurel\Documents\GhasemlouLab\Data\Circadian_experiment\PatchClamp\ExVivo\Nav1.8_Bmal1\Female';
    elseif indx==7
        globalpath='C:\Users\aurel\Documents\GhasemlouLab\Data\EAE_ScnBmal1_Experiment\PatchClamp';
    elseif indx==8
        globalpath='C:\Users\aurel\Documents\GhasemlouLab\Data\Circadian_experiment\PatchClamp\ExVivo\C57BL6\Male100nMAK42';               
    elseif indx==9
        globalpath='C:\Users\aurel\Documents\GhasemlouLab\Data\Circadian_experiment\PatchClamp\ExVivo\C57BL6\MaleVC';
    elseif indx==10
        globalpath='C:\Users\aurel\Documents\GhasemlouLab\Data\Circadian_experiment\PatchClamp\ExVivo\C57BL6\FemaleVC';
    elseif indx==11
        globalpath='C:\Users\aurel\Documents\GhasemlouLab\Data\Circadian_experiment\PatchClamp\ExVivo\Nav1.8_Bmal1\MaleVC';
    elseif indx==12
        globalpath='C:\Users\aurel\Documents\GhasemlouLab\Data\Circadian_experiment\PatchClamp\ExVivo\Nav1.8_Bmal1\FemaleVC';
    end    
else %default == Ex vivo Male
%     globalpath='C:\Users\aurel\Documents\GhasemlouLab\Data\Circadian_experiment\PatchClamp\ExVivo\C57BL6\Male';
    return
end
assignin('base', 'globalpath', globalpath)
assignin('base', 'indx', indx)
cd(globalpath)


answer1 = questdlg('Do you want to save the analysis?', ...
	'Save Analysis', ...
	'Yes, save everything','Yes, only the Tables','No', '');
switch answer1
    case 'Yes, save everything'
        saveA = 2;
    case 'Yes, only the Tables'
        saveA = 1;
    case 'No'
        saveA = 0;
end

newline = char(10); %char(10) is the character for line-break, or "enter"
[~,Allfilename] = system('dir /s /b *.axgd'); %you can also simply write: !dir /s /b *.mat
Allfilename = strsplit(Allfilename,newline)';
Allfilename(cellfun(@isempty,Allfilename))=[];

[~,AllfilenameTestPulse] = system('dir /s /b *.axgx'); %you can also simply write: !dir /s /b *.mat
AllfilenameTestPulse = strsplit(AllfilenameTestPulse,newline)';
AllfilenameTestPulse(cellfun(@isempty,AllfilenameTestPulse))=[];

Allpath=Allfilename;

% cd(previouscd)

%%{


%% Import recordings
dataLastP6bis=[];
a=0;
for f=1:size(Allfilename,1)
    filepath=Allfilename{f}; 
    
    [textData] = ReadAxographfiles(filepath);
        
    [data,~] = importaxographx(filepath);


    filepath=strrep(filepath,'(','');
    filepath=strrep(filepath,')','');
    ii=strfind(filepath,'\');
    
    date=filepath(ii(end-3)+1:ii(end-2)-1);
    ZT=filepath(ii(end-2)+1:ii(end-1)-1);
    cell=filepath(ii(end-1)+1:ii(end)-1);
    id=filepath(ii(end)+7:ii(end)+9);
    
    
    protocolname=double(textData{~cellfun('isempty',strfind(textData,char(Protocol)))}(:,23:end));
    protocolname(protocolname==0) = [];
    protocolname=['P' char(protocolname) '_' id];
    protocolname=strrep(protocolname,' ','');
    
    if indx<9
        if isempty(strfind(protocolname, 'P6bis')) * isempty(strfind(protocolname, 'P6_')) * isempty(strfind(protocolname, 'P5bis')) % if P6bis then it's the same run as the previous recording 
            try
                r=size(fieldnames(Global.(date).(ZT).(cell)),1)+a;   
            catch
                r=1;
            end
        end
    else
       try
            r=size(fieldnames(Global.(date).(ZT).(cell)),1)+a;   
        catch
            r=1;
        end
    end
    run=['run' num2str(r)];
    
    if ~isempty(strfind(protocolname, 'P5bis')) || ~isempty(strfind(protocolname, 'P6bis')) || ~isempty(strfind(protocolname, 'P5_')) || ~isempty(strfind(protocolname, 'P6_')) %|| ~isempty(strfind(protocolname, 'Koster')) 
        a=1; % next recording will be into a different run
    else
        a=0; % next recording will belong to the same run   
    end
    
    %% Analysis
    Global.(date).(ZT).(cell).(run).Date=date;
    Global.(date).(ZT).(cell).(run).ZT=ZT;
    Global.(date).(ZT).(cell).(run).Cell=cell;
    Global.(date).(ZT).(cell).(run).Run=run;

    %% 2_RestingMembranePotential_60s_IC
    if strfind(protocolname, 'P2_') 
        
        Global.(date).(ZT).(cell).(run).rawdata.(protocolname)=data;    
        Global.(date).(ZT).(cell).(run).RMP=mean(data(:,2))*1000; 
        [pks,locs]=findpeaks(data(:, 2), 'MinPeakHeight',0, 'MinPeakProminence', 0.01, 'MinPeakDistance',.01e4);  
        Global.(date).(ZT).(cell).(run).SpontaneousAPs=size(pks,1)/60; 
    
    %% 3_Rheobase_IC    
    elseif strfind(protocolname, 'P3_')     
        for i=1:size(data, 2) %2:size(data,2)
            
            Global.(date).(ZT).(cell).(run).rawdata.(protocolname)=data;
            [pospks]=findpeaks(data(5000:5600, i), 'npeaks', 1, 'sortstr', 'descend', 'MinPeakHeight',0, 'MinPeakProminence', 0.01);  
            
            if ~isempty(pospks)
                %{
                rmp=mean(data(1:4000, i));
                Global.(date).(ZT).(cell).(run).PositivePeak=pospks*1000;                
                Global.(date).(ZT).(cell).(run).PositiveAmplitude=posprominence*1000;
                Global.(date).(ZT).(cell).(run).PositiveSpikeWidth=poswidth/20000;

                [negpks,neglocs,negwidth,negprominence]=findpeaks(-data(poslocs:end, i), 'npeaks', 1, 'sortstr', 'descend');
                Global.(date).(ZT).(cell).(run).NegativePeak=-negpks*1000;                
                Global.(date).(ZT).(cell).(run).NegativeAmplitude=negprominence*1000;   
                Global.(date).(ZT).(cell).(run).NegativeSpikeWidth=negwidth/20000; 
                
                Global.(date).(ZT).(cell).(run).Peak2troughAmplitude=(pospks+negpks)*1000;
                Global.(date).(ZT).(cell).(run).Peak2troughDuration=(neglocs+poslocs-poslocs)/20000;
                Global.(date).(ZT).(cell).(run).RelativePositivePeak=(pospks-rmp)*1000;
                Global.(date).(ZT).(cell).(run).RelativeNegativePeak=(-negpks-rmp)*1000;                
%                 figure; findpeaks(data(:, i), 'npeaks', 1, 'sortstr', 'descend', 'MinPeakHeight',0, 'MinPeakProminence', 0.01, 'Annotate', 'Extent'); title(ZT)  
%                 figure; findpeaks(-data(poslocs:end, i), 'npeaks', 1, 'sortstr', 'descend', 'Annotate', 'Extent'); title(ZT)  
                %}
                
                [pospk,posloc,poswidth,posprominence]=findpeaks(data(5000:5600, i), 'npeak', 1, 'MinPeakHeight',0, 'MinPeakProminence', 0.01);
                rmp=mean(data(1:4000, i));
                Global.(date).(ZT).(cell).(run).PositivePeak=pospk*1000;                
                Global.(date).(ZT).(cell).(run).PositiveAmplitude=posprominence*1000;
                Global.(date).(ZT).(cell).(run).PositiveSpikeWidth=poswidth/20000;

                [negpk,negloc,negwidth,negprominence]=findpeaks(-data(posloc+5000:end, i), 'npeak', 1, 'MinPeakHeight',0, 'MinPeakProminence', 0.01);
                if isempty (negpk) 
                    [negpk,negloc]=max(-data(posloc+5000:end, i));
                    negwidth=NaN;
                    negprominence=NaN;
                end
                
                Global.(date).(ZT).(cell).(run).NegativePeak=-negpk*1000;                
                Global.(date).(ZT).(cell).(run).NegativeAmplitude=negprominence*1000;   
                Global.(date).(ZT).(cell).(run).NegativeSpikeWidth=negwidth/20000; 

                Global.(date).(ZT).(cell).(run).Peak2troughAmplitude=(pospk+negpk)*1000;
                Global.(date).(ZT).(cell).(run).Peak2troughDuration=negloc/20000;
                Global.(date).(ZT).(cell).(run).RelativePositivePeak=(pospk-rmp)*1000;
                Global.(date).(ZT).(cell).(run).RelativeNegativePeak=(-negpk-rmp)*1000;                
    %           figure; findpeaks(data(:, 2),'npeak', 1, 'MinPeakHeight',0, 'MinPeakProminence', 0.01);  
    %           figure; findpeaks(-data(poslocs:end, 2), 'npeak', 1,'MinPeakHeight',0, 'MinPeakProminence', 0.01);
               
                Global.(date).(ZT).(cell).(run).rawdata.APmorpho=data(posloc+5000-300:posloc+5000+600, i); %-5ms to +10ms from posloc
       
                break
            end  
          
        end
        Global.(date).(ZT).(cell).(run).Rheobase=(i)*25;
    
    %% 3bis_Long_Rheobase_IC    
    elseif strfind(protocolname, 'P3bis') 
        
        Global.(date).(ZT).(cell).(run).rawdata.(protocolname)=data;

        [pks,locs]=findpeaks(data(:, 2),  'MinPeakHeight',0, 'MinPeakProminence', 0.01, 'MinPeakDistance',.01e4);  
        Global.(date).(ZT).(cell).(run).AP_500ms_5steps_25pA=size(pks,1);
        [pks,locs]=findpeaks(data(:, 3),  'MinPeakHeight',0, 'MinPeakProminence', 0.01, 'MinPeakDistance',.01e4);  
        Global.(date).(ZT).(cell).(run).AP_500ms_5steps_50pA=size(pks,1);
        [pks,locs]=findpeaks(data(:, 4),  'MinPeakHeight',0, 'MinPeakProminence', 0.01, 'MinPeakDistance',.01e4);  
        Global.(date).(ZT).(cell).(run).AP_500ms_5steps_75pA=size(pks,1);
        [pks,locs]=findpeaks(data(:, 5),  'MinPeakHeight',0, 'MinPeakProminence', 0.01, 'MinPeakDistance',.01e4);  
        Global.(date).(ZT).(cell).(run).AP_500ms_5steps_100pA=size(pks,1);
        [pks,locs]=findpeaks(data(:, 6),  'MinPeakHeight',0, 'MinPeakProminence', 0.01, 'MinPeakDistance',.01e4);  
        Global.(date).(ZT).(cell).(run).AP_500ms_5steps_125pA=size(pks,1);
    
    %% 3cinq_Long_Rheobase_IC    
    elseif strfind(protocolname, 'P3cinq') & size(data, 2)==18
        
        Global.(date).(ZT).(cell).(run).rawdata.(protocolname)=data;

        [pks,locs]=findpeaks(data(:, 2),  'MinPeakHeight',0, 'MinPeakProminence', 0.01, 'MinPeakDistance',.01e4);  
        Global.(date).(ZT).(cell).(run).AP_500ms_17steps_m400pA=size(pks,1);
        [pks,locs]=findpeaks(data(:, 3), 'MinPeakHeight',0, 'MinPeakProminence', 0.01, 'MinPeakDistance',.01e4);  
        Global.(date).(ZT).(cell).(run).AP_500ms_17steps_m350pA=size(pks,1);
        [pks,locs]=findpeaks(data(:, 4),  'MinPeakHeight',0, 'MinPeakProminence', 0.01, 'MinPeakDistance',.01e4);  
        Global.(date).(ZT).(cell).(run).AP_500ms_17steps_m300pA=size(pks,1);
        [pks,locs]=findpeaks(data(:, 5),  'MinPeakHeight',0, 'MinPeakProminence', 0.01, 'MinPeakDistance',.01e4);  
        Global.(date).(ZT).(cell).(run).AP_500ms_17steps_m250pA=size(pks,1);
        [pks,locs]=findpeaks(data(:, 6),  'MinPeakHeight',0, 'MinPeakProminence', 0.01, 'MinPeakDistance',.01e4);  
        Global.(date).(ZT).(cell).(run).AP_500ms_17steps_m200pA=size(pks,1);
        [pks,locs]=findpeaks(data(:, 7),  'MinPeakHeight',0, 'MinPeakProminence', 0.01, 'MinPeakDistance',.01e4);  
        Global.(date).(ZT).(cell).(run).AP_500ms_17steps_m150pA=size(pks,1);
        [pks,locs]=findpeaks(data(:, 8),  'MinPeakHeight',0, 'MinPeakProminence', 0.01, 'MinPeakDistance',.01e4);  
        Global.(date).(ZT).(cell).(run).AP_500ms_17steps_m100pA=size(pks,1);
        [pks,locs]=findpeaks(data(:, 9),  'MinPeakHeight',0, 'MinPeakProminence', 0.01, 'MinPeakDistance',.01e4);  
        Global.(date).(ZT).(cell).(run).AP_500ms_17steps_m50pA=size(pks,1);
        [pks,locs]=findpeaks(data(:, 10),  'MinPeakHeight',0, 'MinPeakProminence', 0.01, 'MinPeakDistance',.01e4);  
        Global.(date).(ZT).(cell).(run).AP_500ms_17steps_0pA=size(pks,1);
        [pks,locs]=findpeaks(data(:, 11),  'MinPeakHeight',0, 'MinPeakProminence', 0.01, 'MinPeakDistance',.01e4);  
        Global.(date).(ZT).(cell).(run).AP_500ms_17steps_50pA=size(pks,1);
        [pks,locs]=findpeaks(data(:, 12),  'MinPeakHeight',0, 'MinPeakProminence', 0.01, 'MinPeakDistance',.01e4);  
        Global.(date).(ZT).(cell).(run).AP_500ms_17steps_100pA=size(pks,1);        
        [pks,locs]=findpeaks(data(:, 13),  'MinPeakHeight',0, 'MinPeakProminence', 0.01, 'MinPeakDistance',.01e4);  
        Global.(date).(ZT).(cell).(run).AP_500ms_17steps_150pA=size(pks,1);
        [pks,locs]=findpeaks(data(:, 14),  'MinPeakHeight',0, 'MinPeakProminence', 0.01, 'MinPeakDistance',.01e4);  
        Global.(date).(ZT).(cell).(run).AP_500ms_17steps_200pA=size(pks,1);
        [pks,locs]=findpeaks(data(:, 15),  'MinPeakHeight',0, 'MinPeakProminence', 0.01, 'MinPeakDistance',.01e4);  
        Global.(date).(ZT).(cell).(run).AP_500ms_17steps_250pA=size(pks,1);
        if size(pks,1)>1
            Global.(date).(ZT).(cell).(run).ISI_AP_500ms_17steps_250pA=mean(diff(locs)/20000);
        else            
            Global.(date).(ZT).(cell).(run).ISI_AP_500ms_17steps_250pA=NaN;
        end
        [pks,locs]=findpeaks(data(:, 16),  'MinPeakHeight',0, 'MinPeakProminence', 0.01, 'MinPeakDistance',.01e4);  
        Global.(date).(ZT).(cell).(run).AP_500ms_17steps_300pA=size(pks,1);
        if size(pks,1)>1
            Global.(date).(ZT).(cell).(run).ISI_AP_500ms_17steps_300pA=mean(diff(locs)/20000);
        else            
            Global.(date).(ZT).(cell).(run).ISI_AP_500ms_17steps_300pA=NaN;
        end
        [pks,locs]=findpeaks(data(:, 17),  'MinPeakHeight',0, 'MinPeakProminence', 0.01, 'MinPeakDistance',.01e4);
        Global.(date).(ZT).(cell).(run).AP_500ms_17steps_350pA=size(pks,1);        
        if size(pks,1)>1
            Global.(date).(ZT).(cell).(run).ISI_AP_500ms_17steps_350pA=mean(diff(locs)/20000);
        else            
            Global.(date).(ZT).(cell).(run).ISI_AP_500ms_17steps_350pA=NaN;
        end        
        [pks,locs]=findpeaks(data(:, 18),  'MinPeakHeight',0, 'MinPeakProminence', 0.01, 'MinPeakDistance',.01e4);
        Global.(date).(ZT).(cell).(run).AP_500ms_17steps_400pA=size(pks,1);
        if size(pks,1)>1
            Global.(date).(ZT).(cell).(run).ISI_AP_500ms_17steps_400pA=mean(diff(locs)/20000);
        else            
            Global.(date).(ZT).(cell).(run).ISI_AP_500ms_17steps_400pA=NaN;
        end
        
        if size(data, 1)==5*20000 %cause firsts P3cinq only lasted 1 second
            Global.(date).(ZT).(cell).(run).VmBefore_500ms_17steps_m400pA=mean(data(1:2*20000,2));
            Global.(date).(ZT).(cell).(run).VmBefore_500ms_17steps_m350pA=mean(data(1:2*20000,3));
            Global.(date).(ZT).(cell).(run).VmBefore_500ms_17steps_m300pA=mean(data(1:2*20000,4));
            Global.(date).(ZT).(cell).(run).VmBefore_500ms_17steps_m250pA=mean(data(1:2*20000,5));
            Global.(date).(ZT).(cell).(run).VmBefore_500ms_17steps_m200pA=mean(data(1:2*20000,6));
            Global.(date).(ZT).(cell).(run).VmBefore_500ms_17steps_m150pA=mean(data(1:2*20000,7));
            Global.(date).(ZT).(cell).(run).VmBefore_500ms_17steps_m100pA=mean(data(1:2*20000,8));
            Global.(date).(ZT).(cell).(run).VmBefore_500ms_17steps_m50pA=mean(data(1:2*20000,9));
            Global.(date).(ZT).(cell).(run).VmBefore_500ms_17steps_0pA=mean(data(1:2*20000,10));
            Global.(date).(ZT).(cell).(run).VmBefore_500ms_17steps_50pA=mean(data(1:2*20000,11));
            Global.(date).(ZT).(cell).(run).VmBefore_500ms_17steps_100pA=mean(data(1:2*20000,12));
            Global.(date).(ZT).(cell).(run).VmBefore_500ms_17steps_150pA=mean(data(1:2*20000,13));
            Global.(date).(ZT).(cell).(run).VmBefore_500ms_17steps_200pA=mean(data(1:2*20000,14));
            Global.(date).(ZT).(cell).(run).VmBefore_500ms_17steps_250pA=mean(data(1:2*20000,15));
            Global.(date).(ZT).(cell).(run).VmBefore_500ms_17steps_300pA=mean(data(1:2*20000,16));
            Global.(date).(ZT).(cell).(run).VmBefore_500ms_17steps_350pA=mean(data(1:2*20000,17));
            Global.(date).(ZT).(cell).(run).VmBefore_500ms_17steps_400pA=mean(data(1:2*20000,18));

            Global.(date).(ZT).(cell).(run).VmEarly_500ms_17steps_m400pA=mean(data(2*20000:2.25*20000,2));
            Global.(date).(ZT).(cell).(run).VmEarly_500ms_17steps_m350pA=mean(data(2*20000:2.25*20000,3));
            Global.(date).(ZT).(cell).(run).VmEarly_500ms_17steps_m300pA=mean(data(2*20000:2.25*20000,4));
            Global.(date).(ZT).(cell).(run).VmEarly_500ms_17steps_m250pA=mean(data(2*20000:2.25*20000,5));
            Global.(date).(ZT).(cell).(run).VmEarly_500ms_17steps_m200pA=mean(data(2*20000:2.25*20000,6));
            Global.(date).(ZT).(cell).(run).VmEarly_500ms_17steps_m150pA=mean(data(2*20000:2.25*20000,7));
            Global.(date).(ZT).(cell).(run).VmEarly_500ms_17steps_m100pA=mean(data(2*20000:2.25*20000,8));
            Global.(date).(ZT).(cell).(run).VmEarly_500ms_17steps_m50pA=mean(data(2*20000:2.25*20000,9));
            Global.(date).(ZT).(cell).(run).VmEarly_500ms_17steps_0pA=mean(data(2*20000:2.25*20000,10));
            Global.(date).(ZT).(cell).(run).VmEarly_500ms_17steps_50pA=mean(data(2*20000:2.25*20000,11));
            Global.(date).(ZT).(cell).(run).VmEarly_500ms_17steps_100pA=mean(data(2*20000:2.25*20000,12));
            Global.(date).(ZT).(cell).(run).VmEarly_500ms_17steps_150pA=mean(data(2*20000:2.25*20000,13));
            Global.(date).(ZT).(cell).(run).VmEarly_500ms_17steps_200pA=mean(data(2*20000:2.25*20000,14));
            Global.(date).(ZT).(cell).(run).VmEarly_500ms_17steps_250pA=mean(data(2*20000:2.25*20000,15));
            Global.(date).(ZT).(cell).(run).VmEarly_500ms_17steps_300pA=mean(data(2*20000:2.25*20000,16));
            Global.(date).(ZT).(cell).(run).VmEarly_500ms_17steps_350pA=mean(data(2*20000:2.25*20000,17));
            Global.(date).(ZT).(cell).(run).VmEarly_500ms_17steps_400pA=mean(data(2*20000:2.25*20000,18));

            Global.(date).(ZT).(cell).(run).VmLate_500ms_17steps_m400pA=mean(data(2.25*20000:2.5*20000,2));
            Global.(date).(ZT).(cell).(run).VmLate_500ms_17steps_m350pA=mean(data(2.25*20000:2.5*20000,3));
            Global.(date).(ZT).(cell).(run).VmLate_500ms_17steps_m300pA=mean(data(2.25*20000:2.5*20000,4));
            Global.(date).(ZT).(cell).(run).VmLate_500ms_17steps_m250pA=mean(data(2.25*20000:2.5*20000,5));
            Global.(date).(ZT).(cell).(run).VmLate_500ms_17steps_m200pA=mean(data(2.25*20000:2.5*20000,6));
            Global.(date).(ZT).(cell).(run).VmLate_500ms_17steps_m150pA=mean(data(2.25*20000:2.5*20000,7));
            Global.(date).(ZT).(cell).(run).VmLate_500ms_17steps_m100pA=mean(data(2.25*20000:2.5*20000,8));
            Global.(date).(ZT).(cell).(run).VmLate_500ms_17steps_m50pA=mean(data(2.25*20000:2.5*20000,9));
            Global.(date).(ZT).(cell).(run).VmLate_500ms_17steps_0pA=mean(data(2.25*20000:2.5*20000,10));
            Global.(date).(ZT).(cell).(run).VmLate_500ms_17steps_50pA=mean(data(2.25*20000:2.5*20000,11));
            Global.(date).(ZT).(cell).(run).VmLate_500ms_17steps_100pA=mean(data(2.25*20000:2.5*20000,12));
            Global.(date).(ZT).(cell).(run).VmLate_500ms_17steps_150pA=mean(data(2.25*20000:2.5*20000,13));
            Global.(date).(ZT).(cell).(run).VmLate_500ms_17steps_200pA=mean(data(2.25*20000:2.5*20000,14));
            Global.(date).(ZT).(cell).(run).VmLate_500ms_17steps_250pA=mean(data(2.25*20000:2.5*20000,15));
            Global.(date).(ZT).(cell).(run).VmLate_500ms_17steps_300pA=mean(data(2.25*20000:2.5*20000,16));
            Global.(date).(ZT).(cell).(run).VmLate_500ms_17steps_350pA=mean(data(2.25*20000:2.5*20000,17));
            Global.(date).(ZT).(cell).(run).VmLate_500ms_17steps_400pA=mean(data(2.25*20000:2.5*20000,18));

            Global.(date).(ZT).(cell).(run).VmAll_500ms_17steps_m400pA=mean(data(2*20000:2.5*20000,2));
            Global.(date).(ZT).(cell).(run).VmAll_500ms_17steps_m350pA=mean(data(2*20000:2.5*20000,3));
            Global.(date).(ZT).(cell).(run).VmAll_500ms_17steps_m300pA=mean(data(2*20000:2.5*20000,4));
            Global.(date).(ZT).(cell).(run).VmAll_500ms_17steps_m250pA=mean(data(2*20000:2.5*20000,5));
            Global.(date).(ZT).(cell).(run).VmAll_500ms_17steps_m200pA=mean(data(2*20000:2.5*20000,6));
            Global.(date).(ZT).(cell).(run).VmAll_500ms_17steps_m150pA=mean(data(2*20000:2.5*20000,7));
            Global.(date).(ZT).(cell).(run).VmAll_500ms_17steps_m100pA=mean(data(2*20000:2.5*20000,8));
            Global.(date).(ZT).(cell).(run).VmAll_500ms_17steps_m50pA=mean(data(2*20000:2.5*20000,9));
            Global.(date).(ZT).(cell).(run).VmAll_500ms_17steps_0pA=mean(data(2*20000:2.5*20000,10));
            Global.(date).(ZT).(cell).(run).VmAll_500ms_17steps_50pA=mean(data(2*20000:2.5*20000,11));
            Global.(date).(ZT).(cell).(run).VmAll_500ms_17steps_100pA=mean(data(2*20000:2.5*20000,12));
            Global.(date).(ZT).(cell).(run).VmAll_500ms_17steps_150pA=mean(data(2*20000:2.5*20000,13));
            Global.(date).(ZT).(cell).(run).VmAll_500ms_17steps_200pA=mean(data(2*20000:2.5*20000,14));
            Global.(date).(ZT).(cell).(run).VmAll_500ms_17steps_250pA=mean(data(2*20000:2.5*20000,15));
            Global.(date).(ZT).(cell).(run).VmAll_500ms_17steps_300pA=mean(data(2*20000:2.5*20000,16));
            Global.(date).(ZT).(cell).(run).VmAll_500ms_17steps_350pA=mean(data(2*20000:2.5*20000,17));
            Global.(date).(ZT).(cell).(run).VmAll_500ms_17steps_400pA=mean(data(2*20000:2.5*20000,18));

            Global.(date).(ZT).(cell).(run).VmAfterEarly_500ms_17steps_m400pA=min(data(2.5*20000:3*20000,2));
            Global.(date).(ZT).(cell).(run).VmAfterEarly_500ms_17steps_m350pA=min(data(2.5*20000:3*20000,3));
            Global.(date).(ZT).(cell).(run).VmAfterEarly_500ms_17steps_m300pA=min(data(2.5*20000:3*20000,4));
            Global.(date).(ZT).(cell).(run).VmAfterEarly_500ms_17steps_m250pA=min(data(2.5*20000:3*20000,5));
            Global.(date).(ZT).(cell).(run).VmAfterEarly_500ms_17steps_m200pA=min(data(2.5*20000:3*20000,6));
            Global.(date).(ZT).(cell).(run).VmAfterEarly_500ms_17steps_m150pA=min(data(2.5*20000:3*20000,7));
            Global.(date).(ZT).(cell).(run).VmAfterEarly_500ms_17steps_m100pA=min(data(2.5*20000:3*20000,8));
            Global.(date).(ZT).(cell).(run).VmAfterEarly_500ms_17steps_m50pA=min(data(2.5*20000:3*20000,9));
            Global.(date).(ZT).(cell).(run).VmAfterEarly_500ms_17steps_0pA=min(data(2.5*20000:3*20000,10));
            Global.(date).(ZT).(cell).(run).VmAfterEarly_500ms_17steps_50pA=min(data(2.5*20000:3*20000,11));
            Global.(date).(ZT).(cell).(run).VmAfterEarly_500ms_17steps_100pA=min(data(2.5*20000:3*20000,12));
            Global.(date).(ZT).(cell).(run).VmAfterEarly_500ms_17steps_150pA=min(data(2.5*20000:3*20000,13));
            Global.(date).(ZT).(cell).(run).VmAfterEarly_500ms_17steps_200pA=min(data(2.5*20000:3*20000,14));
            Global.(date).(ZT).(cell).(run).VmAfterEarly_500ms_17steps_250pA=min(data(2.5*20000:3*20000,15));
            Global.(date).(ZT).(cell).(run).VmAfterEarly_500ms_17steps_300pA=min(data(2.5*20000:3*20000,16));
            Global.(date).(ZT).(cell).(run).VmAfterEarly_500ms_17steps_350pA=min(data(2.5*20000:3*20000,17));
            Global.(date).(ZT).(cell).(run).VmAfterEarly_500ms_17steps_400pA=min(data(2.5*20000:3*20000,18));

            Global.(date).(ZT).(cell).(run).VmAfterLate_500ms_17steps_m400pA=mean(data(3*20000:end,2));
            Global.(date).(ZT).(cell).(run).VmAfterLate_500ms_17steps_m350pA=mean(data(3*20000:end,3));
            Global.(date).(ZT).(cell).(run).VmAfterLate_500ms_17steps_m300pA=mean(data(3*20000:end,4));
            Global.(date).(ZT).(cell).(run).VmAfterLate_500ms_17steps_m250pA=mean(data(3*20000:end,5));
            Global.(date).(ZT).(cell).(run).VmAfterLate_500ms_17steps_m200pA=mean(data(3*20000:end,6));
            Global.(date).(ZT).(cell).(run).VmAfterLate_500ms_17steps_m150pA=mean(data(3*20000:end,7));
            Global.(date).(ZT).(cell).(run).VmAfterLate_500ms_17steps_m100pA=mean(data(3*20000:end,8));
            Global.(date).(ZT).(cell).(run).VmAfterLate_500ms_17steps_m50pA=mean(data(3*20000:end,9));
            Global.(date).(ZT).(cell).(run).VmAfterLate_500ms_17steps_0pA=mean(data(3*20000:end,10));
            Global.(date).(ZT).(cell).(run).VmAfterLate_500ms_17steps_50pA=mean(data(3*20000:end,11));
            Global.(date).(ZT).(cell).(run).VmAfterLate_500ms_17steps_100pA=mean(data(3*20000:end,12));
            Global.(date).(ZT).(cell).(run).VmAfterLate_500ms_17steps_150pA=mean(data(3*20000:end,13));
            Global.(date).(ZT).(cell).(run).VmAfterLate_500ms_17steps_200pA=mean(data(3*20000:end,14));
            Global.(date).(ZT).(cell).(run).VmAfterLate_500ms_17steps_250pA=mean(data(3*20000:end,15));
            Global.(date).(ZT).(cell).(run).VmAfterLate_500ms_17steps_300pA=mean(data(3*20000:end,16));
            Global.(date).(ZT).(cell).(run).VmAfterLate_500ms_17steps_350pA=mean(data(3*20000:end,17));
            Global.(date).(ZT).(cell).(run).VmAfterLate_500ms_17steps_400pA=mean(data(3*20000:end,18));
            
        elseif  size(data, 1)==1*20000 % few recordings lasting only 1 second
            Global.(date).(ZT).(cell).(run).VmBefore_500ms_17steps_m400pA=mean(data(1:.5*10000,2));
            Global.(date).(ZT).(cell).(run).VmBefore_500ms_17steps_m350pA=mean(data(1:.5*10000,3));
            Global.(date).(ZT).(cell).(run).VmBefore_500ms_17steps_m300pA=mean(data(1:.5*10000,4));
            Global.(date).(ZT).(cell).(run).VmBefore_500ms_17steps_m250pA=mean(data(1:.5*10000,5));
            Global.(date).(ZT).(cell).(run).VmBefore_500ms_17steps_m200pA=mean(data(1:.5*10000,6));
            Global.(date).(ZT).(cell).(run).VmBefore_500ms_17steps_m150pA=mean(data(1:.5*10000,7));
            Global.(date).(ZT).(cell).(run).VmBefore_500ms_17steps_m100pA=mean(data(1:.5*10000,8));
            Global.(date).(ZT).(cell).(run).VmBefore_500ms_17steps_m50pA=mean(data(1:.5*10000,9));
            Global.(date).(ZT).(cell).(run).VmBefore_500ms_17steps_0pA=mean(data(1:.5*10000,10));
            Global.(date).(ZT).(cell).(run).VmBefore_500ms_17steps_50pA=mean(data(1:.5*10000,11));
            Global.(date).(ZT).(cell).(run).VmBefore_500ms_17steps_100pA=mean(data(1:.5*10000,12));
            Global.(date).(ZT).(cell).(run).VmBefore_500ms_17steps_150pA=mean(data(1:.5*10000,13));
            Global.(date).(ZT).(cell).(run).VmBefore_500ms_17steps_200pA=mean(data(1:.5*10000,14));
            Global.(date).(ZT).(cell).(run).VmBefore_500ms_17steps_250pA=mean(data(1:.5*10000,15));
            Global.(date).(ZT).(cell).(run).VmBefore_500ms_17steps_300pA=mean(data(1:.5*10000,16));
            Global.(date).(ZT).(cell).(run).VmBefore_500ms_17steps_350pA=mean(data(1:.5*10000,17));
            Global.(date).(ZT).(cell).(run).VmBefore_500ms_17steps_400pA=mean(data(1:.5*10000,18));

            Global.(date).(ZT).(cell).(run).VmEarly_500ms_17steps_m400pA=mean(data(.5*10000:.75*10000,2));
            Global.(date).(ZT).(cell).(run).VmEarly_500ms_17steps_m350pA=mean(data(.5*10000:.75*10000,3));
            Global.(date).(ZT).(cell).(run).VmEarly_500ms_17steps_m300pA=mean(data(.5*10000:.75*10000,4));
            Global.(date).(ZT).(cell).(run).VmEarly_500ms_17steps_m250pA=mean(data(.5*10000:.75*10000,5));
            Global.(date).(ZT).(cell).(run).VmEarly_500ms_17steps_m200pA=mean(data(.5*10000:.75*10000,6));
            Global.(date).(ZT).(cell).(run).VmEarly_500ms_17steps_m150pA=mean(data(.5*10000:.75*10000,7));
            Global.(date).(ZT).(cell).(run).VmEarly_500ms_17steps_m100pA=mean(data(.5*10000:.75*10000,8));
            Global.(date).(ZT).(cell).(run).VmEarly_500ms_17steps_m50pA=mean(data(.5*10000:.75*10000,9));
            Global.(date).(ZT).(cell).(run).VmEarly_500ms_17steps_0pA=mean(data(.5*10000:.75*10000,10));
            Global.(date).(ZT).(cell).(run).VmEarly_500ms_17steps_50pA=mean(data(.5*10000:.75*10000,11));
            Global.(date).(ZT).(cell).(run).VmEarly_500ms_17steps_100pA=mean(data(.5*10000:.75*10000,12));
            Global.(date).(ZT).(cell).(run).VmEarly_500ms_17steps_150pA=mean(data(.5*10000:.75*10000,13));
            Global.(date).(ZT).(cell).(run).VmEarly_500ms_17steps_200pA=mean(data(.5*10000:.75*10000,14));
            Global.(date).(ZT).(cell).(run).VmEarly_500ms_17steps_250pA=mean(data(.5*10000:.75*10000,15));
            Global.(date).(ZT).(cell).(run).VmEarly_500ms_17steps_300pA=mean(data(.5*10000:.75*10000,16));
            Global.(date).(ZT).(cell).(run).VmEarly_500ms_17steps_350pA=mean(data(.5*10000:.75*10000,17));
            Global.(date).(ZT).(cell).(run).VmEarly_500ms_17steps_400pA=mean(data(.5*10000:.75*10000,18));

            Global.(date).(ZT).(cell).(run).VmLate_500ms_17steps_m400pA=mean(data(.75*10000:1.5*10000,2));
            Global.(date).(ZT).(cell).(run).VmLate_500ms_17steps_m350pA=mean(data(.75*10000:1.5*10000,3));
            Global.(date).(ZT).(cell).(run).VmLate_500ms_17steps_m300pA=mean(data(.75*10000:1.5*10000,4));
            Global.(date).(ZT).(cell).(run).VmLate_500ms_17steps_m250pA=mean(data(.75*10000:1.5*10000,5));
            Global.(date).(ZT).(cell).(run).VmLate_500ms_17steps_m200pA=mean(data(.75*10000:1.5*10000,6));
            Global.(date).(ZT).(cell).(run).VmLate_500ms_17steps_m150pA=mean(data(.75*10000:1.5*10000,7));
            Global.(date).(ZT).(cell).(run).VmLate_500ms_17steps_m100pA=mean(data(.75*10000:1.5*10000,8));
            Global.(date).(ZT).(cell).(run).VmLate_500ms_17steps_m50pA=mean(data(.75*10000:1.5*10000,9));
            Global.(date).(ZT).(cell).(run).VmLate_500ms_17steps_0pA=mean(data(.75*10000:1.5*10000,10));
            Global.(date).(ZT).(cell).(run).VmLate_500ms_17steps_50pA=mean(data(.75*10000:1.5*10000,11));
            Global.(date).(ZT).(cell).(run).VmLate_500ms_17steps_100pA=mean(data(.75*10000:1.5*10000,12));
            Global.(date).(ZT).(cell).(run).VmLate_500ms_17steps_150pA=mean(data(.75*10000:1.5*10000,13));
            Global.(date).(ZT).(cell).(run).VmLate_500ms_17steps_200pA=mean(data(.75*10000:1.5*10000,14));
            Global.(date).(ZT).(cell).(run).VmLate_500ms_17steps_250pA=mean(data(.75*10000:1.5*10000,15));
            Global.(date).(ZT).(cell).(run).VmLate_500ms_17steps_300pA=mean(data(.75*10000:1.5*10000,16));
            Global.(date).(ZT).(cell).(run).VmLate_500ms_17steps_350pA=mean(data(.75*10000:1.5*10000,17));
            Global.(date).(ZT).(cell).(run).VmLate_500ms_17steps_400pA=mean(data(.75*10000:1.5*10000,18));

            Global.(date).(ZT).(cell).(run).VmAll_500ms_17steps_m400pA=mean(data(.5*10000:1.5*10000,2));
            Global.(date).(ZT).(cell).(run).VmAll_500ms_17steps_m350pA=mean(data(.5*10000:1.5*10000,3));
            Global.(date).(ZT).(cell).(run).VmAll_500ms_17steps_m300pA=mean(data(.5*10000:1.5*10000,4));
            Global.(date).(ZT).(cell).(run).VmAll_500ms_17steps_m250pA=mean(data(.5*10000:1.5*10000,5));
            Global.(date).(ZT).(cell).(run).VmAll_500ms_17steps_m200pA=mean(data(.5*10000:1.5*10000,6));
            Global.(date).(ZT).(cell).(run).VmAll_500ms_17steps_m150pA=mean(data(.5*10000:1.5*10000,7));
            Global.(date).(ZT).(cell).(run).VmAll_500ms_17steps_m100pA=mean(data(.5*10000:1.5*10000,8));
            Global.(date).(ZT).(cell).(run).VmAll_500ms_17steps_m50pA=mean(data(.5*10000:1.5*10000,9));
            Global.(date).(ZT).(cell).(run).VmAll_500ms_17steps_0pA=mean(data(.5*10000:1.5*10000,10));
            Global.(date).(ZT).(cell).(run).VmAll_500ms_17steps_50pA=mean(data(.5*10000:1.5*10000,11));
            Global.(date).(ZT).(cell).(run).VmAll_500ms_17steps_100pA=mean(data(.5*10000:1.5*10000,12));
            Global.(date).(ZT).(cell).(run).VmAll_500ms_17steps_150pA=mean(data(.5*10000:1.5*10000,13));
            Global.(date).(ZT).(cell).(run).VmAll_500ms_17steps_200pA=mean(data(.5*10000:1.5*10000,14));
            Global.(date).(ZT).(cell).(run).VmAll_500ms_17steps_250pA=mean(data(.5*10000:1.5*10000,15));
            Global.(date).(ZT).(cell).(run).VmAll_500ms_17steps_300pA=mean(data(.5*10000:1.5*10000,16));
            Global.(date).(ZT).(cell).(run).VmAll_500ms_17steps_350pA=mean(data(.5*10000:1.5*10000,17));
            Global.(date).(ZT).(cell).(run).VmAll_500ms_17steps_400pA=mean(data(.5*10000:1.5*10000,18));

            Global.(date).(ZT).(cell).(run).VmAfterEarly_500ms_17steps_m400pA=min(data(1.5*10000:2*10000,2));
            Global.(date).(ZT).(cell).(run).VmAfterEarly_500ms_17steps_m350pA=min(data(1.5*10000:2*10000,3));
            Global.(date).(ZT).(cell).(run).VmAfterEarly_500ms_17steps_m300pA=min(data(1.5*10000:2*10000,4));
            Global.(date).(ZT).(cell).(run).VmAfterEarly_500ms_17steps_m250pA=min(data(1.5*10000:2*10000,5));
            Global.(date).(ZT).(cell).(run).VmAfterEarly_500ms_17steps_m200pA=min(data(1.5*10000:2*10000,6));
            Global.(date).(ZT).(cell).(run).VmAfterEarly_500ms_17steps_m150pA=min(data(1.5*10000:2*10000,7));
            Global.(date).(ZT).(cell).(run).VmAfterEarly_500ms_17steps_m100pA=min(data(1.5*10000:2*10000,8));
            Global.(date).(ZT).(cell).(run).VmAfterEarly_500ms_17steps_m50pA=min(data(1.5*10000:2*10000,9));
            Global.(date).(ZT).(cell).(run).VmAfterEarly_500ms_17steps_0pA=min(data(1.5*10000:2*10000,10));
            Global.(date).(ZT).(cell).(run).VmAfterEarly_500ms_17steps_50pA=min(data(1.5*10000:2*10000,11));
            Global.(date).(ZT).(cell).(run).VmAfterEarly_500ms_17steps_100pA=min(data(1.5*10000:2*10000,12));
            Global.(date).(ZT).(cell).(run).VmAfterEarly_500ms_17steps_150pA=min(data(1.5*10000:2*10000,13));
            Global.(date).(ZT).(cell).(run).VmAfterEarly_500ms_17steps_200pA=min(data(1.5*10000:2*10000,14));
            Global.(date).(ZT).(cell).(run).VmAfterEarly_500ms_17steps_250pA=min(data(1.5*10000:2*10000,15));
            Global.(date).(ZT).(cell).(run).VmAfterEarly_500ms_17steps_300pA=min(data(1.5*10000:2*10000,16));
            Global.(date).(ZT).(cell).(run).VmAfterEarly_500ms_17steps_350pA=min(data(1.5*10000:2*10000,17));
            Global.(date).(ZT).(cell).(run).VmAfterEarly_500ms_17steps_400pA=min(data(1.5*10000:2*10000,18));
        end
        %{
        if ~isempty(pks)
            pospks=pks(1);
            rmp=mean(data(1:4000, 18));
            Global.(date).(ZT).(cell).(run).PositivePeak=pospks*1000;                
            Global.(date).(ZT).(cell).(run).PositiveAmplitude=posprominence*1000;
            Global.(date).(ZT).(cell).(run).PositiveSpikeWidth=poswidth/20000;

            [negpks,neglocs,negwidth,negprominence]=findpeaks(-data(poslocs:end, 18), 'npeaks', 1, 'sortstr', 'descend');
            Global.(date).(ZT).(cell).(run).NegativePeak=-negpks*1000;                
            Global.(date).(ZT).(cell).(run).NegativeAmplitude=negprominence*1000;   
            Global.(date).(ZT).(cell).(run).NegativeSpikeWidth=negwidth/20000; 

            Global.(date).(ZT).(cell).(run).Peak2troughAmplitude=(pospks+negpks)*1000;
            Global.(date).(ZT).(cell).(run).Peak2troughDuration=(neglocs+poslocs-poslocs)/20000;
            Global.(date).(ZT).(cell).(run).RelativePositivePeak=(pospks-rmp)*1000;
            Global.(date).(ZT).(cell).(run).RelativeNegativePeak=(-negpks-rmp)*1000;                
%                 figure; findpeaks(data(:, i), 'npeaks', 1, 'sortstr', 'descend', 'MinPeakHeight',0, 'MinPeakProminence', 0.01, 'Annotate', 'Extent'); title(ZT)  
%                 figure; findpeaks(-data(poslocs:end, i), 'npeaks', 1, 'sortstr', 'descend', 'Annotate', 'Extent'); title(ZT)  
                
        end
              %}      
%         Global.(date).(ZT).(cell).(run).NegPeak_AP_500ms_17steps_400pA=min(data(:, 18));
%         Global.(date).(ZT).(cell).(run).SteadyState_AP_500ms_17steps_400pA=mean(data(:, 18));
        
    %% 3ter_Long_Rheobase_IC    
    elseif strfind(protocolname, 'P3ter') 
        
        Global.(date).(ZT).(cell).(run).rawdata.(protocolname)=data;

        if size(data,2)>=5
        [pks,locs]=findpeaks(data(:, 2),  'MinPeakHeight',0, 'MinPeakProminence', 0.01, 'MinPeakDistance',.01e4);  
        Global.(date).(ZT).(cell).(run).AP_1000ms_4steps_0pA=size(pks,1);
        [pks,locs]=findpeaks(data(:, 3), 'MinPeakHeight',0, 'MinPeakProminence', 0.01, 'MinPeakDistance',.01e4);  
        Global.(date).(ZT).(cell).(run).AP_1000ms_4steps_100pA=size(pks,1);
        [pks,locs]=findpeaks(data(:, 4),  'MinPeakHeight',0, 'MinPeakProminence', 0.01, 'MinPeakDistance',.01e4);  
        Global.(date).(ZT).(cell).(run).AP_1000ms_4steps_200pA=size(pks,1);
        [pks,locs]=findpeaks(data(:, 5),  'MinPeakHeight',0, 'MinPeakProminence', 0.01, 'MinPeakDistance',.01e4);  
        Global.(date).(ZT).(cell).(run).AP_1000ms_4steps_300pA=size(pks,1);
        if size(pks,1)>1
            Global.(date).(ZT).(cell).(run).ISI_AP_1000ms_4steps_300pA=mean(diff(locs)/20000);
        else            
            Global.(date).(ZT).(cell).(run).ISI_AP_1000ms_4steps_300pA=NaN;
        end
        end
        
    %% 4_Ramp600pA_IC    
    elseif strfind(protocolname, 'P4_')
        
        Global.(date).(ZT).(cell).(run).rawdata.(protocolname)=data;

        [pks,locs]=findpeaks(data(:, 2),  'MinPeakHeight',0, 'MinPeakProminence', 0.01, 'MinPeakDistance',.01e4);  
        Global.(date).(ZT).(cell).(run).AP_Ramp600pA=size(pks,1);
        if size(pks,1)>1
            Global.(date).(ZT).(cell).(run).ISI_AP_Ramp600pA=mean(diff(locs)/20000);
        else            
            Global.(date).(ZT).(cell).(run).ISI_AP_Ramp600pA=NaN;
        end
        [pks,locs]=findpeaks(data(1200:end, 2),  'MinPeakHeight',0, 'MinPeakProminence', 0.01, 'MinPeakDistance',.01e4);  
        %from 250ms ou 60ms before the first AP to avoid Ca2+ spike
        if ~isempty(pks)
            dataX=data(locs(1,1):end,1); 
            dataY=data(locs(1,1):end,2);
            ddataY=diff(dataY);
            ddataX=diff(dataX);
            D=ddataY./ddataX;
            for i=1:size(D, 1)
                if D(i,1)>5 %when slope exceed mV/ms=5

                    Global.(date).(ZT).(cell).(run).Threshold_AP_Ramp600pA=data(i+locs(1,1)-1200,2)*1000;
                    Global.(date).(ZT).(cell).(run).Latency_AP_Ramp600pA=data(i+locs(1,1)-1200,1);
                    break
                else
                    Global.(date).(ZT).(cell).(run).Threshold_AP_Ramp600pA=NaN;
                    Global.(date).(ZT).(cell).(run).Latency_AP_Ramp600pA=NaN;
                end
            end
        else
            Global.(date).(ZT).(cell).(run).Threshold_AP_Ramp600pA=NaN;
            Global.(date).(ZT).(cell).(run).Latency_AP_Ramp600pA=NaN;
        end

    %% 4bis_Ramp100pA_IC    
    elseif strfind(protocolname, 'P4bis') 
        
        Global.(date).(ZT).(cell).(run).rawdata.(protocolname)=data;

        [pks,locs]=findpeaks(data(:, 2),  'MinPeakHeight',0, 'MinPeakProminence', 0.01, 'MinPeakDistance',.01e4);  
        Global.(date).(ZT).(cell).(run).AP_Ramp100pA=size(pks,1);
        if ~isempty(pks)
            dataX=data(locs(1,1)-1200:end,1);
            dataY=data(locs(1,1)-1200:end,2);
            ddataY=diff(dataY);
            ddataX=diff(dataX);
            D=ddataY./ddataX;
            for i=1:size(D, 1)
                if D(i,1)>5 %when slope exceed mV/ms=5

                    Global.(date).(ZT).(cell).(run).Threshold_AP_Ramp100pA=data(i+locs(1,1)-1200,2)*1000;
                    Global.(date).(ZT).(cell).(run).Latency_AP_Ramp100pA=data(i+locs(1,1)-1200,1);
                    break
                else
                    Global.(date).(ZT).(cell).(run).Threshold_AP_Ramp100pA=NaN;
                    Global.(date).(ZT).(cell).(run).Latency_AP_Ramp100pA=NaN;
                end
            end
        else
            Global.(date).(ZT).(cell).(run).Threshold_AP_Ramp100pA=NaN;
            Global.(date).(ZT).(cell).(run).Latency_AP_Ramp100pA=NaN;
        end
        
    %% 4qar_Ramp300pA_IC    
    elseif strfind(protocolname, 'P4qar') 
        
        Global.(date).(ZT).(cell).(run).rawdata.(protocolname)=data;

        [pks,locs]=findpeaks(data(:, 2),  'MinPeakHeight',0, 'MinPeakProminence', 0.01, 'MinPeakDistance',.01e4);  
        Global.(date).(ZT).(cell).(run).AP_Ramp300pA=size(pks,1);
        if ~isempty(pks)
            dataX=data(locs(1,1)-1200:end,1);
            dataY=data(locs(1,1)-1200:end,2);
            ddataY=diff(dataY);
            ddataX=diff(dataX);
            D=ddataY./ddataX;
            for i=1:size(D, 1)
                if D(i,1)>5 %when slope exceed mV/ms=5

                    Global.(date).(ZT).(cell).(run).Threshold_AP_Ramp300pA=data(i+locs(1,1)-1200,2)*1000;
                    Global.(date).(ZT).(cell).(run).Latency_AP_Ramp300pA=data(i+locs(1,1)-1200,1);
                    break
                else
                    Global.(date).(ZT).(cell).(run).Threshold_AP_Ramp300pA=NaN;
                    Global.(date).(ZT).(cell).(run).Latency_AP_Ramp300pA=NaN;
                end
            end
        else
            Global.(date).(ZT).(cell).(run).Threshold_AP_Ramp300pA=NaN;
            Global.(date).(ZT).(cell).(run).Latency_AP_Ramp300pA=NaN;
        end
        
    %% 4ter_Ramp200pA_IC    
    elseif strfind(protocolname, 'P4ter') 
        
        Global.(date).(ZT).(cell).(run).rawdata.(protocolname)=data;

        [pks,locs]=findpeaks(data(:, 2), 'MinPeakHeight',0, 'MinPeakProminence', 0.01, 'MinPeakDistance',.01e4);  
        Global.(date).(ZT).(cell).(run).AP_Ramp200pA=size(pks,1);
        if ~isempty(pks)
            dataX=data(locs(1,1)-1200:end,1);
            dataY=data(locs(1,1)-1200:end,2);
            ddataY=diff(dataY);
            ddataX=diff(dataX);
            D=ddataY./ddataX;
            for i=1:size(D, 1)
                if D(i,1)>5 %when slope exceed mV/ms=5

                    Global.(date).(ZT).(cell).(run).Threshold_AP_Ramp200pA=data(i+locs(1,1)-1200,2)*1000;
                    Global.(date).(ZT).(cell).(run).Latency_AP_Ramp200pA=data(i+locs(1,1)-1200,1);
                    break
                else
                    Global.(date).(ZT).(cell).(run).Threshold_AP_Ramp200pA=NaN;
                    Global.(date).(ZT).(cell).(run).Latency_AP_Ramp200pA=NaN;
                end
            end
        else
            Global.(date).(ZT).(cell).(run).Threshold_AP_Ramp200pA=NaN;
            Global.(date).(ZT).(cell).(run).Latency_AP_Ramp200pA=NaN;
        end
        
    %% 5_Ramp1200pA_IC    
    elseif strfind(protocolname, 'P5_') 
        
        Global.(date).(ZT).(cell).(run).rawdata.(protocolname)=data;

        [pks,locs]=findpeaks(data(:, 2),  'MinPeakHeight',0, 'MinPeakProminence', 0.01, 'MinPeakDistance',.01e4);  
        Global.(date).(ZT).(cell).(run).AP_Ramp1200pA=size(pks,1);
        if size(pks,1)>1
            Global.(date).(ZT).(cell).(run).ISI_AP_Ramp1200pA=mean(diff(locs)/20000);
        else            
            Global.(date).(ZT).(cell).(run).ISI_AP_Ramp1200pA=NaN;
        end
        if ~isempty(pks)
            dataX=data(locs(1,1)-1200:end,1);
            dataY=data(locs(1,1)-1200:end,2);
            ddataY=diff(dataY);
            ddataX=diff(dataX);
            D=ddataY./ddataX;
            for i=1:size(D, 1)
                if D(i,1)>5 %when slope exceed mV/ms=5

                    Global.(date).(ZT).(cell).(run).Threshold_AP_Ramp1200pA=data(i+locs(1,1)-1200,2)*1000;
                    Global.(date).(ZT).(cell).(run).Latency_AP_Ramp1200pA=data(i+locs(1,1)-1200,1);
                    break
                else
                    Global.(date).(ZT).(cell).(run).Threshold_AP_Ramp1200pA=NaN;
                    Global.(date).(ZT).(cell).(run).Latency_AP_Ramp1200pA=NaN;
                end
            end
            %{
            [pospk,posloc,poswidth,posprominence]=findpeaks(data(:, 2), 'npeak', 1, 'MinPeakHeight',0, 'MinPeakProminence', 0.01);
            rmp=mean(data(1:4000, 2));
            Global.(date).(ZT).(cell).(run).PositivePeak=pospk*1000;                
            Global.(date).(ZT).(cell).(run).PositiveAmplitude=posprominence*1000;
            Global.(date).(ZT).(cell).(run).PositiveSpikeWidth=poswidth/20000;

            [negpk,negloc,negwidth,negprominence]=findpeaks(-data(posloc:end, 2), 'npeak', 1, 'MinPeakHeight',0, 'MinPeakProminence', 0.01);
            Global.(date).(ZT).(cell).(run).NegativePeak=-negpk*1000;                
            Global.(date).(ZT).(cell).(run).NegativeAmplitude=negprominence*1000;   
            Global.(date).(ZT).(cell).(run).NegativeSpikeWidth=negwidth/20000; 

            Global.(date).(ZT).(cell).(run).Peak2troughAmplitude=(pospk+negpk)*1000;
            Global.(date).(ZT).(cell).(run).Peak2troughDuration=(negloc+posloc-posloc)/20000;
            Global.(date).(ZT).(cell).(run).RelativePositivePeak=(pospk-rmp)*1000;
            Global.(date).(ZT).(cell).(run).RelativeNegativePeak=(-negpk-rmp)*1000;                
%           figure; findpeaks(data(:, 2),'npeak', 1, 'MinPeakHeight',0, 'MinPeakProminence', 0.01);  
%           figure; findpeaks(-data(poslocs:end, 2), 'npeak', 1,'MinPeakHeight',0, 'MinPeakProminence', 0.01);
%           disp ok

            Global.(date).(ZT).(cell).(run).rawdata.APmorpho=data(posloc-300:posloc+600, 2); %-5ms to +10ms from posloc
       %}
        else
            Global.(date).(ZT).(cell).(run).Threshold_AP_Ramp1200pA=NaN;
            Global.(date).(ZT).(cell).(run).Latency_AP_Ramp1200pA=NaN;
        end
        
    %% 5bis_Ramp2000pA_IC    
    elseif strfind(protocolname, 'P5bis') 
        
        Global.(date).(ZT).(cell).(run).rawdata.(protocolname)=data;
        
        [pospk,poslocs]=findpeaks(data(:, 2), 'MinPeakHeight',0, 'MinPeakProminence', 0.01, 'MinPeakDistance',.01e4);  
        Global.(date).(ZT).(cell).(run).AP_Ramp2000pA=size(pospk,1);
        if size(pospk,1)>1
            Global.(date).(ZT).(cell).(run).ISI_AP_Ramp2000pA=mean(diff(poslocs)/20000);
        else            
            Global.(date).(ZT).(cell).(run).ISI_AP_Ramp2000pA=NaN;
        end
        if ~isempty(pospk)
            dataX=data(poslocs(1,1)-1200:end,1);
            dataY=data(poslocs(1,1)-1200:end,2);
            ddataY=diff(dataY);
            ddataX=diff(dataX);
            D=ddataY./ddataX;
            for i=1:size(D, 1)
                if D(i,1)>5 %when slope exceed mV/ms=5

                    Global.(date).(ZT).(cell).(run).Threshold_AP_Ramp2000pA=data(i+poslocs(1,1)-1200,2)*1000;
                    Global.(date).(ZT).(cell).(run).Latency_AP_Ramp2000pA=data(i+poslocs(1,1)-1200,1);
                    break
                else
                    Global.(date).(ZT).(cell).(run).Threshold_AP_Ramp2000pA=NaN;
                    Global.(date).(ZT).(cell).(run).Latency_AP_Ramp2000pA=NaN;
                end
            end
        else
                Global.(date).(ZT).(cell).(run).Threshold_AP_Ramp2000pA=NaN;
                Global.(date).(ZT).(cell).(run).Latency_AP_Ramp2000pA=NaN;
        end
    %% 6bis_CurveIV_VC
    elseif strfind(protocolname, 'P6bis') 
        dataLastP6bis=data;
        if size(data, 2)==16 % in case recording interrupted, do not analyzed it     
            Global.(date).(ZT).(cell).(run).rawdata.(protocolname)=data;
            for rr= 1:size(fieldnames(Global.(date).(ZT).(cell)),1) % for all the run 
                runn=['run' num2str(rr)];                
                %fieldn=fieldnames(Global.(date).(ZT).(cell));
                %runn=fieldn{rr};
                if ~isfield(Global.(date).(ZT).(cell).(runn), 'IVcurve_m110_all') % cause not all runs have IVCurve
                    
                    Fs = 10000;                       % Sampling frequency
                    N = 8;
                    fc = 1000;
                    [z,p,k] = besself(N,fc);          % Bessel analog filter design
                    [num,den]=zp2tf(z,p,k);             % Convert to transfer function form
                    [numd,dend]=bilinear(num,den,Fs);   % Analog to Digital conversion
                    data(:,2) = filtfilt(numd,dend,data(:,2));


                    Global.(date).(ZT).(cell).(runn).rawdata.(protocolname)=data;
                    Global.(date).(ZT).(cell).(runn).IVcurve_m110_all=nanmean(data(5020:15000,2))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_m105_all=nanmean(data(5020:15000,3))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_m100_all=nanmean(data(5020:15000,4))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_m95_all=nanmean(data(5020:15000,5))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_m90_all=nanmean(data(5020:15000,6))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_m85_all=nanmean(data(5020:15000,7))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_m80_all=nanmean(data(5020:15000,8))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_m75_all=nanmean(data(5020:15000,9))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_m70_all=nanmean(data(5020:15000,10))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_m65_all=nanmean(data(5020:15000,11))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_m60_all=nanmean(data(5020:15000,12))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_m55_all=nanmean(data(5020:15000,13))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_m50_all=nanmean(data(5020:15000,14))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_m45_all=nanmean(data(5020:15000,15))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_m40_all=nanmean(data(5020:15000,16))*10^12; %pA 

                    Global.(date).(ZT).(cell).(runn).IVcurve_m110_early=nanmean(data(5400:5600,2))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_m105_early=nanmean(data(5400:5600,3))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_m100_early=nanmean(data(5400:5600,4))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_m95_early=nanmean(data(5400:5600,5))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_m90_early=nanmean(data(5400:5600,6))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_m85_early=nanmean(data(5400:5600,7))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_m80_early=nanmean(data(5400:5600,8))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_m75_early=nanmean(data(5400:5600,9))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_m70_early=nanmean(data(5400:5600,10))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_m65_early=nanmean(data(5400:5600,11))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_m60_early=nanmean(data(5400:5600,12))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_m55_early=nanmean(data(5400:5600,13))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_m50_early=nanmean(data(5400:5600,14))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_m45_early=nanmean(data(5400:5600,15))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_m40_early=nanmean(data(5400:5600,16))*10^12; %pA 

                    Global.(date).(ZT).(cell).(runn).IVcurve_m110_late=nanmean(data(14700:14900,2))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_m105_late=nanmean(data(14700:14900,3))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_m100_late=nanmean(data(14700:14900,4))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_m95_late=nanmean(data(14700:14900,5))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_m90_late=nanmean(data(14700:14900,6))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_m85_late=nanmean(data(14700:14900,7))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_m80_late=nanmean(data(14700:14900,8))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_m75_late=nanmean(data(14700:14900,9))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_m70_late=nanmean(data(14700:14900,10))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_m65_late=nanmean(data(14700:14900,11))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_m60_late=nanmean(data(14700:14900,12))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_m55_late=nanmean(data(14700:14900,13))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_m50_late=nanmean(data(14700:14900,14))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_m45_late=nanmean(data(14700:14900,15))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_m40_late=nanmean(data(14700:14900,16))*10^12; %pA
                    
                    
                    Global.(date).(ZT).(cell).(runn).IVcurve_m110_after=max(data(15020:end,2))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_m105_after=max(data(15020:end,3))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_m100_after=max(data(15020:end,4))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_m95_after=max(data(15020:end,5))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_m90_after=max(data(15020:end,6))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_m85_after=max(data(15020:end,7))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_m80_after=max(data(15020:end,8))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_m75_after=max(data(15020:end,9))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_m70_after=max(data(15020:end,10))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_m65_after=max(data(15020:end,11))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_m60_after=max(data(15020:end,12))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_m55_after=max(data(15020:end,13))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_m50_after=max(data(15020:end,14))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_m45_after=max(data(15020:end,15))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_m40_after=max(data(15020:end,16))*10^12; %pA
                end
            end
        end
        
    elseif strfind(protocolname, 'P6_') 
        if size(data, 2)>=16 % in case recording interrupted, do not analyzed it    %CHANGE AB NOVEMBER 23th <= for >= 
            Global.(date).(ZT).(cell).(run).rawdata.(protocolname)=data;
            for rr= 1:size(fieldnames(Global.(date).(ZT).(cell)),1) % for all the run 
                runn=['run' num2str(rr)];
                if ~isfield(Global.(date).(ZT).(cell).(runn), 'IVcurve_m120_all') % cause not all runs have IVCurve
                    Global.(date).(ZT).(cell).(runn).rawdata.(protocolname)=data;
                    Global.(date).(ZT).(cell).(runn).IVcurve_m120_all=nanmean(data(5020:10000,2))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_m110_all=nanmean(data(5020:10000,3))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_m100_all=nanmean(data(5020:10000,4))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_m90_all=nanmean(data(5020:10000,5))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_m80_all=nanmean(data(5020:10000,6))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_m70_all=nanmean(data(5020:10000,7))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_m60_all=nanmean(data(5020:10000,8))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_m50_all=nanmean(data(5020:10000,9))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_m40_all=nanmean(data(5020:10000,10))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_m30_all=nanmean(data(5020:10000,11))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_m20_all=nanmean(data(5020:10000,12))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_m10_all=nanmean(data(5020:10000,13))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_0_all=nanmean(data(5020:10000,14))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_10_all=nanmean(data(5020:10000,15))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_20_all=nanmean(data(5020:10000,16))*10^12; %pA 

                    Global.(date).(ZT).(cell).(runn).IVcurve_m120_early=nanmean(data(5400:5600,2))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_m110_early=nanmean(data(5400:5600,3))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_m100_early=nanmean(data(5400:5600,4))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_m90_early=nanmean(data(5400:5600,5))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_m80_early=nanmean(data(5400:5600,6))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_m70_early=nanmean(data(5400:5600,7))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_m60_early=nanmean(data(5400:5600,8))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_m50_early=nanmean(data(5400:5600,9))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_m40_early=nanmean(data(5400:5600,10))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_m30_early=nanmean(data(5400:5600,11))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_m20_early=nanmean(data(5400:5600,12))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_m10_early=nanmean(data(5400:5600,13))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_0_early=nanmean(data(5400:5600,14))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_10_early=nanmean(data(5400:5600,15))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_20_early=nanmean(data(5400:5600,16))*10^12; %pA 

                    Global.(date).(ZT).(cell).(runn).IVcurve_m120_late=nanmean(data(9700:9900,2))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_m110_late=nanmean(data(9700:9900,3))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_m100_late=nanmean(data(9700:9900,4))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_m90_late=nanmean(data(9700:9900,5))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_m80_late=nanmean(data(9700:9900,6))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_m70_late=nanmean(data(9700:9900,7))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_m60_late=nanmean(data(9700:9900,8))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_m50_late=nanmean(data(9700:9900,9))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_m40_late=nanmean(data(9700:9900,10))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_m30_late=nanmean(data(9700:9900,11))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_m20_late=nanmean(data(9700:9900,12))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_m10_late=nanmean(data(9700:9900,13))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_0_late=nanmean(data(9700:9900,14))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_10_late=nanmean(data(9700:9900,15))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_20_late=nanmean(data(9700:9900,16))*10^12; %pA
                    
                    
                    Global.(date).(ZT).(cell).(runn).IVcurve_m120_after=max(data(10020:15000,2))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_m110_after=max(data(10020:15000,3))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_m100_after=max(data(10020:15000,4))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_m90_after=max(data(10020:15000,5))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_m80_after=max(data(10020:15000,6))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_m70_after=max(data(10020:15000,7))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_m60_after=max(data(10020:15000,8))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_m50_after=max(data(10020:15000,9))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_m40_after=max(data(10020:15000,10))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_m30_after=max(data(10020:15000,11))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_m20_after=max(data(10020:15000,12))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_m10_after=max(data(10020:15000,13))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_0_after=max(data(10020:15000,14))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_10_after=max(data(10020:15000,15))*10^12; %pA 
                    Global.(date).(ZT).(cell).(runn).IVcurve_20_after=max(data(10020:15000,16))*10^12; %pA
                end
            end
        end
       elseif strfind(protocolname, 'P40_Step_VC_Koster2020') 
           if isempty(strfind(protocolname, 'AK42')) && isempty(strfind(protocolname, 'Wash'))
               if size(data, 2)>=14 % in case recording interrupted, do not analyzed it 

                    Global.(date).(ZT).(cell).(run).rawdata.(protocolname)=data;

                    Global.(date).(ZT).(cell).(run).IVcurve_m100_before=nanmean(data(8000:10000,2))*10^12; %pA 
                    Global.(date).(ZT).(cell).(run).IVcurve_m90_before=nanmean(data(8000:10000,3))*10^12; %pA 
                    Global.(date).(ZT).(cell).(run).IVcurve_m80_before=nanmean(data(8000:10000,4))*10^12; %pA 
                    Global.(date).(ZT).(cell).(run).IVcurve_m70_before=nanmean(data(8000:10000,5))*10^12; %pA 
                    Global.(date).(ZT).(cell).(run).IVcurve_m60_before=nanmean(data(8000:10000,6))*10^12; %pA 
                    Global.(date).(ZT).(cell).(run).IVcurve_m50_before=nanmean(data(8000:10000,7))*10^12; %pA 
                    Global.(date).(ZT).(cell).(run).IVcurve_m40_before=nanmean(data(8000:10000,8))*10^12; %pA 
                    Global.(date).(ZT).(cell).(run).IVcurve_m30_before=nanmean(data(8000:10000,9))*10^12; %pA 
                    Global.(date).(ZT).(cell).(run).IVcurve_m20_before=nanmean(data(8000:10000,10))*10^12; %pA 
                    Global.(date).(ZT).(cell).(run).IVcurve_m10_before=nanmean(data(8000:10000,11))*10^12; %pA 
                    Global.(date).(ZT).(cell).(run).IVcurve_0_before=nanmean(data(8000:10000,12))*10^12; %pA 
                    Global.(date).(ZT).(cell).(run).IVcurve_10_before=nanmean(data(8000:10000,13))*10^12; %pA 
                    Global.(date).(ZT).(cell).(run).IVcurve_20_before=nanmean(data(8000:10000,14))*10^12; %pA 


                    Global.(date).(ZT).(cell).(run).IVcurve_m100_all=nanmean(data(10100:25000,2))*10^12; %pA 
                    Global.(date).(ZT).(cell).(run).IVcurve_m90_all=nanmean(data(10100:25000,3))*10^12; %pA 
                    Global.(date).(ZT).(cell).(run).IVcurve_m80_all=nanmean(data(10100:25000,4))*10^12; %pA 
                    Global.(date).(ZT).(cell).(run).IVcurve_m70_all=nanmean(data(10100:25000,5))*10^12; %pA 
                    Global.(date).(ZT).(cell).(run).IVcurve_m60_all=nanmean(data(10100:25000,6))*10^12; %pA 
                    Global.(date).(ZT).(cell).(run).IVcurve_m50_all=nanmean(data(10100:25000,7))*10^12; %pA 
                    Global.(date).(ZT).(cell).(run).IVcurve_m40_all=nanmean(data(10100:25000,8))*10^12; %pA 
                    Global.(date).(ZT).(cell).(run).IVcurve_m30_all=nanmean(data(10100:25000,9))*10^12; %pA 
                    Global.(date).(ZT).(cell).(run).IVcurve_m20_all=nanmean(data(10100:25000,10))*10^12; %pA 
                    Global.(date).(ZT).(cell).(run).IVcurve_m10_all=nanmean(data(10100:25000,11))*10^12; %pA 
                    Global.(date).(ZT).(cell).(run).IVcurve_0_all=nanmean(data(10100:25000,12))*10^12; %pA 
                    Global.(date).(ZT).(cell).(run).IVcurve_10_all=nanmean(data(10100:25000,13))*10^12; %pA 
                    Global.(date).(ZT).(cell).(run).IVcurve_20_all=nanmean(data(10100:25000,14))*10^12; %pA 

                    Global.(date).(ZT).(cell).(run).IVcurve_m100_early=nanmean(data(10100:14100,2))*10^12; %pA 
                    Global.(date).(ZT).(cell).(run).IVcurve_m90_early=nanmean(data(10100:14100,3))*10^12; %pA 
                    Global.(date).(ZT).(cell).(run).IVcurve_m80_early=nanmean(data(10100:14100,4))*10^12; %pA 
                    Global.(date).(ZT).(cell).(run).IVcurve_m70_early=nanmean(data(10100:14100,5))*10^12; %pA 
                    Global.(date).(ZT).(cell).(run).IVcurve_m60_early=nanmean(data(10100:14100,6))*10^12; %pA 
                    Global.(date).(ZT).(cell).(run).IVcurve_m50_early=nanmean(data(10100:14100,7))*10^12; %pA 
                    Global.(date).(ZT).(cell).(run).IVcurve_m40_early=nanmean(data(10100:14100,8))*10^12; %pA 
                    Global.(date).(ZT).(cell).(run).IVcurve_m30_early=nanmean(data(10100:14100,9))*10^12; %pA 
                    Global.(date).(ZT).(cell).(run).IVcurve_m20_early=nanmean(data(10100:14100,10))*10^12; %pA 
                    Global.(date).(ZT).(cell).(run).IVcurve_m10_early=nanmean(data(10100:14100,11))*10^12; %pA 
                    Global.(date).(ZT).(cell).(run).IVcurve_0_early=nanmean(data(10100:14100,12))*10^12; %pA 
                    Global.(date).(ZT).(cell).(run).IVcurve_10_early=nanmean(data(10100:14100,13))*10^12; %pA 
                    Global.(date).(ZT).(cell).(run).IVcurve_20_early=nanmean(data(10100:14100,14))*10^12; %pA 

                    Global.(date).(ZT).(cell).(run).IVcurve_m100_late=nanmean(data(23000:25000,2))*10^12; %pA 
                    Global.(date).(ZT).(cell).(run).IVcurve_m90_late=nanmean(data(23000:25000,3))*10^12; %pA 
                    Global.(date).(ZT).(cell).(run).IVcurve_m80_late=nanmean(data(23000:25000,4))*10^12; %pA 
                    Global.(date).(ZT).(cell).(run).IVcurve_m70_late=nanmean(data(23000:25000,5))*10^12; %pA 
                    Global.(date).(ZT).(cell).(run).IVcurve_m60_late=nanmean(data(23000:25000,6))*10^12; %pA 
                    Global.(date).(ZT).(cell).(run).IVcurve_m50_late=nanmean(data(23000:25000,7))*10^12; %pA 
                    Global.(date).(ZT).(cell).(run).IVcurve_m40_late=nanmean(data(23000:25000,8))*10^12; %pA 
                    Global.(date).(ZT).(cell).(run).IVcurve_m30_late=nanmean(data(23000:25000,9))*10^12; %pA 
                    Global.(date).(ZT).(cell).(run).IVcurve_m20_late=nanmean(data(23000:25000,10))*10^12; %pA 
                    Global.(date).(ZT).(cell).(run).IVcurve_m10_late=nanmean(data(23000:25000,11))*10^12; %pA 
                    Global.(date).(ZT).(cell).(run).IVcurve_0_late=nanmean(data(23000:25000,12))*10^12; %pA 
                    Global.(date).(ZT).(cell).(run).IVcurve_10_late=nanmean(data(23000:25000,13))*10^12; %pA 
                    Global.(date).(ZT).(cell).(run).IVcurve_20_late=nanmean(data(23000:25000,14))*10^12; %pA 



                    Global.(date).(ZT).(cell).(run).IVcurve_m100_after=nanmean(data(25010:27010,2))*10^12; %pA 
                    Global.(date).(ZT).(cell).(run).IVcurve_m90_after=nanmean(data(25010:27010,3))*10^12; %pA 
                    Global.(date).(ZT).(cell).(run).IVcurve_m80_after=nanmean(data(25010:27010,4))*10^12; %pA 
                    Global.(date).(ZT).(cell).(run).IVcurve_m70_after=nanmean(data(25010:27010,5))*10^12; %pA 
                    Global.(date).(ZT).(cell).(run).IVcurve_m60_after=nanmean(data(25010:27010,6))*10^12; %pA 
                    Global.(date).(ZT).(cell).(run).IVcurve_m50_after=nanmean(data(25010:27010,7))*10^12; %pA 
                    Global.(date).(ZT).(cell).(run).IVcurve_m40_after=nanmean(data(25010:27010,8))*10^12; %pA 
                    Global.(date).(ZT).(cell).(run).IVcurve_m30_after=nanmean(data(25010:27010,9))*10^12; %pA 
                    Global.(date).(ZT).(cell).(run).IVcurve_m20_after=nanmean(data(25010:27010,10))*10^12; %pA 
                    Global.(date).(ZT).(cell).(run).IVcurve_m10_after=nanmean(data(25010:27010,11))*10^12; %pA 
                    Global.(date).(ZT).(cell).(run).IVcurve_0_after=nanmean(data(25010:27010,12))*10^12; %pA 
                    Global.(date).(ZT).(cell).(run).IVcurve_10_after=nanmean(data(25010:27010,13))*10^12; %pA 
                    Global.(date).(ZT).(cell).(run).IVcurve_20_after=nanmean(data(25010:27010,14))*10^12; %pA 


                    Global.(date).(ZT).(cell).(run).IVcurve_m100_peakafter=max(data(25010:27010,2))*10^12; %pA 
                    Global.(date).(ZT).(cell).(run).IVcurve_m90_peakafter=max(data(25010:27010,3))*10^12; %pA 
                    Global.(date).(ZT).(cell).(run).IVcurve_m80_peakafter=max(data(25010:27010,4))*10^12; %pA 
                    Global.(date).(ZT).(cell).(run).IVcurve_m70_peakafter=max(data(25010:27010,5))*10^12; %pA 
                    Global.(date).(ZT).(cell).(run).IVcurve_m60_peakafter=max(data(25010:27010,6))*10^12; %pA 
                    Global.(date).(ZT).(cell).(run).IVcurve_m50_peakafter=max(data(25010:27010,7))*10^12; %pA 
                    Global.(date).(ZT).(cell).(run).IVcurve_m40_peakafter=max(data(25010:27010,8))*10^12; %pA 
                    Global.(date).(ZT).(cell).(run).IVcurve_m30_peakafter=max(data(25010:27010,9))*10^12; %pA 
                    Global.(date).(ZT).(cell).(run).IVcurve_m20_peakafter=max(data(25010:27010,10))*10^12; %pA 
                    Global.(date).(ZT).(cell).(run).IVcurve_m10_peakafter=max(data(25010:27010,11))*10^12; %pA 
                    Global.(date).(ZT).(cell).(run).IVcurve_0_peakafter=max(data(25010:27010,12))*10^12; %pA 
                    Global.(date).(ZT).(cell).(run).IVcurve_10_peakafter=max(data(25010:27010,13))*10^12; %pA 
                    Global.(date).(ZT).(cell).(run).IVcurve_20_peakafter=max(data(25010:27010,14))*10^12; %pA 


                    %first 10ms after capacitance transient
                    Global.(date).(ZT).(cell).(run).IVcurve_m100_initial=nanmean(data(10050:10100,2))*10^12; %pA 
                    Global.(date).(ZT).(cell).(run).IVcurve_m90_initial=nanmean(data(10050:10100,3))*10^12; %pA 
                    Global.(date).(ZT).(cell).(run).IVcurve_m80_initial=nanmean(data(10050:10100,4))*10^12; %pA 
                    Global.(date).(ZT).(cell).(run).IVcurve_m70_initial=nanmean(data(10050:10100,5))*10^12; %pA 
                    Global.(date).(ZT).(cell).(run).IVcurve_m60_initial=nanmean(data(10050:10100,6))*10^12; %pA 
                    Global.(date).(ZT).(cell).(run).IVcurve_m50_initial=nanmean(data(10050:10100,7))*10^12; %pA 
                    Global.(date).(ZT).(cell).(run).IVcurve_m40_initial=nanmean(data(10050:10100,8))*10^12; %pA 
                    Global.(date).(ZT).(cell).(run).IVcurve_m30_initial=nanmean(data(10050:10100,9))*10^12; %pA 
                    Global.(date).(ZT).(cell).(run).IVcurve_m20_initial=nanmean(data(10050:10100,10))*10^12; %pA 
                    Global.(date).(ZT).(cell).(run).IVcurve_m10_initial=nanmean(data(10050:10100,11))*10^12; %pA 
                    Global.(date).(ZT).(cell).(run).IVcurve_0_initial=nanmean(data(10050:10100,12))*10^12; %pA 
                    Global.(date).(ZT).(cell).(run).IVcurve_10_initial=nanmean(data(10050:10100,13))*10^12; %pA 
                    Global.(date).(ZT).(cell).(run).IVcurve_20_initial=nanmean(data(10050:10100,14))*10^12; %pA 

                    %last 50ms 
                    Global.(date).(ZT).(cell).(run).IVcurve_m100_last=nanmean(data(24750:25000,2))*10^12; %pA 
                    Global.(date).(ZT).(cell).(run).IVcurve_m90_last=nanmean(data(24750:25000,3))*10^12; %pA 
                    Global.(date).(ZT).(cell).(run).IVcurve_m80_last=nanmean(data(24750:25000,4))*10^12; %pA 
                    Global.(date).(ZT).(cell).(run).IVcurve_m70_last=nanmean(data(24750:25000,5))*10^12; %pA 
                    Global.(date).(ZT).(cell).(run).IVcurve_m60_last=nanmean(data(24750:25000,6))*10^12; %pA 
                    Global.(date).(ZT).(cell).(run).IVcurve_m50_last=nanmean(data(24750:25000,7))*10^12; %pA 
                    Global.(date).(ZT).(cell).(run).IVcurve_m40_last=nanmean(data(24750:25000,8))*10^12; %pA 
                    Global.(date).(ZT).(cell).(run).IVcurve_m30_last=nanmean(data(24750:25000,9))*10^12; %pA 
                    Global.(date).(ZT).(cell).(run).IVcurve_m20_last=nanmean(data(24750:25000,10))*10^12; %pA 
                    Global.(date).(ZT).(cell).(run).IVcurve_m10_last=nanmean(data(24750:25000,11))*10^12; %pA 
                    Global.(date).(ZT).(cell).(run).IVcurve_0_last=nanmean(data(24750:25000,12))*10^12; %pA 
                    Global.(date).(ZT).(cell).(run).IVcurve_10_last=nanmean(data(24750:25000,13))*10^12; %pA 
                    Global.(date).(ZT).(cell).(run).IVcurve_20_last=nanmean(data(24750:25000,14))*10^12; %pA 
                end
            end
    end 
end
%}

%% Import Seal test 

%%{
for f=1:size(AllfilenameTestPulse,1)
    filepath=AllfilenameTestPulse{f};    
    
    
    SR=[];
    MC=[];
    MR=[];
    
    try %avoid issues with corrupted files
        [textData] = ReadAxographfiles(filepath);
        
        filepath=strrep(filepath,'(','');
        filepath=strrep(filepath,')','');
        ii=strfind(filepath,'\');
        date=filepath(ii(end-3)+1:ii(end-2)-1);
        ZT=filepath(ii(end-2)+1:ii(end-1)-1);
        cell=filepath(ii(end-1)+1:ii(end)-1);
        id=regexprep(filepath(ii(end)+1:end-5), ' ', '');

        id=lower(id);
        runid=NaN;
        
        if strfind(id, 'after')
            pos=2; 
        else
            pos=1;
        end

        if strfind(id,'run')
            ir=strfind(id,'run');
            runid=str2double(id(ir+3));                
        elseif size(regexprep(id, 'bis', ''), 2)==16 
            runid=1;
        elseif size(regexprep(id, 'ak42', ''), 2)==16 
            runid=1;
        elseif strcmp(id, 'testpulsewindow')
            runid=0;
        else
            disp(id)  
            filepath
            continue
        end           
        
        run=['run' num2str(runid)];                             
        i=strfind(textData,char(SeriesResistance));
        cellidx=find(~cellfun(@isempty,i'));
        
        if ~isempty(cellidx) && (isfield( Global.(date).(ZT).(cell), run) || runid==0)
            i=i{~cellfun('isempty',i)};
            SR=double(textData{cellidx,1}(i+59:i+66)); 
            SR(SR==0) = [];
            SR(SR==32) = [];
            SR=char(SR);
            SR=str2double(regexp(SR,['\d+\.?\d*'],'match'));

            i=strfind(textData,char(MembraneCapacitance));
            cellidx=find(~cellfun(@isempty,i'));
            i=i{~cellfun('isempty',i)};
            MC=double(textData{cellidx,1}(i+51:i+59)); 
            MC(MC==0) = [];
            MC(MC==32) = [];
            MC=char(MC);
            MC=str2double(regexp(MC,['\d+\.?\d*'],'match'));

            i=strfind(textData,char(MembraneResistance));
            cellidx=find(~cellfun(@isempty,i'));
            i=i{~cellfun('isempty',i)};
            MR=double(textData{cellidx,1}(i+57:i+67)); 
            MR(MR==0) = [];
            MR(MR==32) = [];
            MR=char(MR);
            MR=str2double(regexp(MR,['\d+\.?\d*'],'match'));            
            if MR(1)<10 %ig GOhms instead of MOhms
                MR=MR(1)*1000;
            end
            
            SerieR=['SeriesResistance_' num2str(pos)];
            MembR=['MembraneResistance_' num2str(pos)];
            MembCap=['MembraneCapacitance_' num2str(pos)];
            PulseTime=['TestPulseTime_' num2str(pos)];
            TimeFromExtraction=['TimeFromExtraction_' num2str(pos)];
            
            Global.(date).(ZT).(cell).(run).(SerieR)=SR;
            Global.(date).(ZT).(cell).(run).(MembCap)=MC;
            Global.(date).(ZT).(cell).(run).(MembR)=MR;
            
            i=strfind(textData,'
