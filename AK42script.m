function AK42analysis


Protocol=[0 80 0 114 -2 111 0 116 0 111 0 99 0 111 0 108 0 32 0 58];
SeriesResistance=[0 83 0 101 0 114 0 105 0 101 0 115 0 32 0 82 0 101 0 115 0 105 0 115 0 116 0 97 0 110 0 99 0 101];
MembraneCapacitance=[0 77 0 101 0 109 0 98 0 114 0 97 0 110 0 101 0 32 0 67 0 97 0 112 0 97 0 99 0 105 0 116 0 97 0 110 0 99 0 101 0 32 0 32 0 61 0 32 0 32];
MembraneResistance=[0 77 0 101 0 109 0 98 0 114 0 97 0 110 0 101 0 32 0 82 0 101 0 115 0 105 0 115 0 116 0 97 0 110 0 99 0 101 0 32 0 32 0 32 0 32 0 32 0 32 0 32 0 32 0 61 0 32 0 32]; 

globalpath='C:\Users\aurel\Documents\GhasemlouLab\Data\Circadian_experiment\PatchClamp\ExVivo\C57BL6\MaleVCAK42';
globalpath='C:\Users\aurel\Documents\GhasemlouLab\Data\Circadian_experiment\PatchClamp\ExVivo\Nav1.8_Bmal1\MaleVCAK42';
cd(globalpath)

AllfilenameAK42=[];
AllfilenameBaseline=[];
newline = char(10); %char(10) is the character for line-break, or "enter"

[~,AllfilenameAK42] = system('dir /s /b *40_Step_VC_Koster2020_hold4mV_AK42.axgd'); %you can also simply write: !dir /s /b *.mat
AllfilenameAK42 = strsplit(AllfilenameAK42,newline)';
AllfilenameAK42(cellfun(@isempty,AllfilenameAK42))=[];

Global=[];
GlobalData=[];
GlobalData.Cells=[];
GlobalData.sizedata=[];

counter=1;

for f=1:size(AllfilenameAK42,1)
    filepathAK42=AllfilenameAK42{f};     
    [dataAK42,~] = importaxographx(filepathAK42);
    data=dataAK42*10^12;%in pA     
    
    filepathAK42=strrep(filepathAK42,'(','');
    filepathAK42=strrep(filepathAK42,')','');
    ii=strfind(filepathAK42,'\');
    
    date=filepathAK42(ii(end-3)+1:ii(end-2)-1);
    ZT=filepathAK42(ii(end-2)+1:ii(end-1)-1);
    cell=filepathAK42(ii(end-1)+1:ii(end)-1);
    nrun=filepathAK42(ii(end)+7:ii(end)+9);
    run=['AK42_run', nrun];
    
    
    Global.(date).(ZT).(cell).(run).Date=date;
    Global.(date).(ZT).(cell).(run).ZT=ZT;
    Global.(date).(ZT).(cell).(run).Cell=cell;
    Global.(date).(ZT).(cell).(run).Run=run;
    
    
    if size(data, 2)>=13 % in case recording interrupted, do not analyzed it 
        Global.(date).(ZT).(cell).(run).rawdata=data;

        Global.(date).(ZT).(cell).(run).IVcurve_m100_before=nanmean(data(8000:10000,2)); %pA 
        Global.(date).(ZT).(cell).(run).IVcurve_m90_before=nanmean(data(8000:10000,3)); %pA 
        Global.(date).(ZT).(cell).(run).IVcurve_m80_before=nanmean(data(8000:10000,4)); %pA 
        Global.(date).(ZT).(cell).(run).IVcurve_m70_before=nanmean(data(8000:10000,5)); %pA 
        Global.(date).(ZT).(cell).(run).IVcurve_m60_before=nanmean(data(8000:10000,6)); %pA 
        Global.(date).(ZT).(cell).(run).IVcurve_m50_before=nanmean(data(8000:10000,7)); %pA 
        Global.(date).(ZT).(cell).(run).IVcurve_m40_before=nanmean(data(8000:10000,8)); %pA 
        Global.(date).(ZT).(cell).(run).IVcurve_m30_before=nanmean(data(8000:10000,9)); %pA 
        Global.(date).(ZT).(cell).(run).IVcurve_m20_before=nanmean(data(8000:10000,10)); %pA 
        Global.(date).(ZT).(cell).(run).IVcurve_m10_before=nanmean(data(8000:10000,11)); %pA 
        Global.(date).(ZT).(cell).(run).IVcurve_0_before=nanmean(data(8000:10000,12)); %pA 
        Global.(date).(ZT).(cell).(run).IVcurve_10_before=nanmean(data(8000:10000,13)); %pA 
        Global.(date).(ZT).(cell).(run).IVcurve_20_before=nanmean(data(8000:10000,14)); %pA 

        Global.(date).(ZT).(cell).(run).IVcurve_m100_all=nanmean(data(10100:25000,2)); %pA 
        Global.(date).(ZT).(cell).(run).IVcurve_m90_all=nanmean(data(10100:25000,3)); %pA 
        Global.(date).(ZT).(cell).(run).IVcurve_m80_all=nanmean(data(10100:25000,4)); %pA 
        Global.(date).(ZT).(cell).(run).IVcurve_m70_all=nanmean(data(10100:25000,5)); %pA 
        Global.(date).(ZT).(cell).(run).IVcurve_m60_all=nanmean(data(10100:25000,6)); %pA 
        Global.(date).(ZT).(cell).(run).IVcurve_m50_all=nanmean(data(10100:25000,7)); %pA 
        Global.(date).(ZT).(cell).(run).IVcurve_m40_all=nanmean(data(10100:25000,8)); %pA 
        Global.(date).(ZT).(cell).(run).IVcurve_m30_all=nanmean(data(10100:25000,9)); %pA 
        Global.(date).(ZT).(cell).(run).IVcurve_m20_all=nanmean(data(10100:25000,10)); %pA 
        Global.(date).(ZT).(cell).(run).IVcurve_m10_all=nanmean(data(10100:25000,11)); %pA 
        Global.(date).(ZT).(cell).(run).IVcurve_0_all=nanmean(data(10100:25000,12)); %pA 
        Global.(date).(ZT).(cell).(run).IVcurve_10_all=nanmean(data(10100:25000,13)); %pA 
        Global.(date).(ZT).(cell).(run).IVcurve_20_all=nanmean(data(10100:25000,14)); %pA 

        Global.(date).(ZT).(cell).(run).IVcurve_m100_early=nanmean(data(10100:14100,2)); %pA 
        Global.(date).(ZT).(cell).(run).IVcurve_m90_early=nanmean(data(10100:14100,3)); %pA 
        Global.(date).(ZT).(cell).(run).IVcurve_m80_early=nanmean(data(10100:14100,4)); %pA 
        Global.(date).(ZT).(cell).(run).IVcurve_m70_early=nanmean(data(10100:14100,5)); %pA 
        Global.(date).(ZT).(cell).(run).IVcurve_m60_early=nanmean(data(10100:14100,6)); %pA 
        Global.(date).(ZT).(cell).(run).IVcurve_m50_early=nanmean(data(10100:14100,7)); %pA 
        Global.(date).(ZT).(cell).(run).IVcurve_m40_early=nanmean(data(10100:14100,8)); %pA 
        Global.(date).(ZT).(cell).(run).IVcurve_m30_early=nanmean(data(10100:14100,9)); %pA 
        Global.(date).(ZT).(cell).(run).IVcurve_m20_early=nanmean(data(10100:14100,10)); %pA 
        Global.(date).(ZT).(cell).(run).IVcurve_m10_early=nanmean(data(10100:14100,11)); %pA 
        Global.(date).(ZT).(cell).(run).IVcurve_0_early=nanmean(data(10100:14100,12)); %pA 
        Global.(date).(ZT).(cell).(run).IVcurve_10_early=nanmean(data(10100:14100,13)); %pA 
        Global.(date).(ZT).(cell).(run).IVcurve_20_early=nanmean(data(10100:14100,14)); %pA 

        Global.(date).(ZT).(cell).(run).IVcurve_m100_late=nanmean(data(23000:25000,2)); %pA 
        Global.(date).(ZT).(cell).(run).IVcurve_m90_late=nanmean(data(23000:25000,3)); %pA 
        Global.(date).(ZT).(cell).(run).IVcurve_m80_late=nanmean(data(23000:25000,4)); %pA 
        Global.(date).(ZT).(cell).(run).IVcurve_m70_late=nanmean(data(23000:25000,5)); %pA 
        Global.(date).(ZT).(cell).(run).IVcurve_m60_late=nanmean(data(23000:25000,6)); %pA 
        Global.(date).(ZT).(cell).(run).IVcurve_m50_late=nanmean(data(23000:25000,7)); %pA 
        Global.(date).(ZT).(cell).(run).IVcurve_m40_late=nanmean(data(23000:25000,8)); %pA 
        Global.(date).(ZT).(cell).(run).IVcurve_m30_late=nanmean(data(23000:25000,9)); %pA 
        Global.(date).(ZT).(cell).(run).IVcurve_m20_late=nanmean(data(23000:25000,10)); %pA 
        Global.(date).(ZT).(cell).(run).IVcurve_m10_late=nanmean(data(23000:25000,11)); %pA 
        Global.(date).(ZT).(cell).(run).IVcurve_0_late=nanmean(data(23000:25000,12)); %pA 
        Global.(date).(ZT).(cell).(run).IVcurve_10_late=nanmean(data(23000:25000,13)); %pA 
        Global.(date).(ZT).(cell).(run).IVcurve_20_late=nanmean(data(23000:25000,14)); %pA 

        Global.(date).(ZT).(cell).(run).IVcurve_m100_after=nanmean(data(25010:27010,2)); %pA 
        Global.(date).(ZT).(cell).(run).IVcurve_m90_after=nanmean(data(25010:27010,3)); %pA 
        Global.(date).(ZT).(cell).(run).IVcurve_m80_after=nanmean(data(25010:27010,4)); %pA 
        Global.(date).(ZT).(cell).(run).IVcurve_m70_after=nanmean(data(25010:27010,5)); %pA 
        Global.(date).(ZT).(cell).(run).IVcurve_m60_after=nanmean(data(25010:27010,6)); %pA 
        Global.(date).(ZT).(cell).(run).IVcurve_m50_after=nanmean(data(25010:27010,7)); %pA 
        Global.(date).(ZT).(cell).(run).IVcurve_m40_after=nanmean(data(25010:27010,8)); %pA 
        Global.(date).(ZT).(cell).(run).IVcurve_m30_after=nanmean(data(25010:27010,9)); %pA 
        Global.(date).(ZT).(cell).(run).IVcurve_m20_after=nanmean(data(25010:27010,10)); %pA 
        Global.(date).(ZT).(cell).(run).IVcurve_m10_after=nanmean(data(25010:27010,11)); %pA 
        Global.(date).(ZT).(cell).(run).IVcurve_0_after=nanmean(data(25010:27010,12)); %pA 
        Global.(date).(ZT).(cell).(run).IVcurve_10_after=nanmean(data(25010:27010,13)); %pA 
        Global.(date).(ZT).(cell).(run).IVcurve_20_after=nanmean(data(25010:27010,14)); %pA 

        Global.(date).(ZT).(cell).(run).IVcurve_m100_peakafter=max(data(25010:27010,2)); %pA 
        Global.(date).(ZT).(cell).(run).IVcurve_m90_peakafter=max(data(25010:27010,3)); %pA 
        Global.(date).(ZT).(cell).(run).IVcurve_m80_peakafter=max(data(25010:27010,4)); %pA 
        Global.(date).(ZT).(cell).(run).IVcurve_m70_peakafter=max(data(25010:27010,5)); %pA 
        Global.(date).(ZT).(cell).(run).IVcurve_m60_peakafter=max(data(25010:27010,6)); %pA 
        Global.(date).(ZT).(cell).(run).IVcurve_m50_peakafter=max(data(25010:27010,7)); %pA 
        Global.(date).(ZT).(cell).(run).IVcurve_m40_peakafter=max(data(25010:27010,8)); %pA 
        Global.(date).(ZT).(cell).(run).IVcurve_m30_peakafter=max(data(25010:27010,9)); %pA 
        Global.(date).(ZT).(cell).(run).IVcurve_m20_peakafter=max(data(25010:27010,10)); %pA 
        Global.(date).(ZT).(cell).(run).IVcurve_m10_peakafter=max(data(25010:27010,11)); %pA 
        Global.(date).(ZT).(cell).(run).IVcurve_0_peakafter=max(data(25010:27010,12)); %pA 
        Global.(date).(ZT).(cell).(run).IVcurve_10_peakafter=max(data(25010:27010,13)); %pA 
        Global.(date).(ZT).(cell).(run).IVcurve_20_peakafter=max(data(25010:27010,14)); %pA 

        %first 10ms after capacitance transient
        Global.(date).(ZT).(cell).(run).IVcurve_m100_initial=nanmean(data(10050:10100,2)); %pA 
        Global.(date).(ZT).(cell).(run).IVcurve_m90_initial=nanmean(data(10050:10100,3)); %pA 
        Global.(date).(ZT).(cell).(run).IVcurve_m80_initial=nanmean(data(10050:10100,4)); %pA 
        Global.(date).(ZT).(cell).(run).IVcurve_m70_initial=nanmean(data(10050:10100,5)); %pA 
        Global.(date).(ZT).(cell).(run).IVcurve_m60_initial=nanmean(data(10050:10100,6)); %pA 
        Global.(date).(ZT).(cell).(run).IVcurve_m50_initial=nanmean(data(10050:10100,7)); %pA 
        Global.(date).(ZT).(cell).(run).IVcurve_m40_initial=nanmean(data(10050:10100,8)); %pA 
        Global.(date).(ZT).(cell).(run).IVcurve_m30_initial=nanmean(data(10050:10100,9)); %pA 
        Global.(date).(ZT).(cell).(run).IVcurve_m20_initial=nanmean(data(10050:10100,10)); %pA 
        Global.(date).(ZT).(cell).(run).IVcurve_m10_initial=nanmean(data(10050:10100,11)); %pA 
        Global.(date).(ZT).(cell).(run).IVcurve_0_initial=nanmean(data(10050:10100,12)); %pA 
        Global.(date).(ZT).(cell).(run).IVcurve_10_initial=nanmean(data(10050:10100,13)); %pA 
        Global.(date).(ZT).(cell).(run).IVcurve_20_initial=nanmean(data(10050:10100,14)); %pA 

        %last 50ms 
        Global.(date).(ZT).(cell).(run).IVcurve_m100_last=nanmean(data(24750:25000,2)); %pA 
        Global.(date).(ZT).(cell).(run).IVcurve_m90_last=nanmean(data(24750:25000,3)); %pA 
        Global.(date).(ZT).(cell).(run).IVcurve_m80_last=nanmean(data(24750:25000,4)); %pA 
        Global.(date).(ZT).(cell).(run).IVcurve_m70_last=nanmean(data(24750:25000,5)); %pA 
        Global.(date).(ZT).(cell).(run).IVcurve_m60_last=nanmean(data(24750:25000,6)); %pA 
        Global.(date).(ZT).(cell).(run).IVcurve_m50_last=nanmean(data(24750:25000,7)); %pA 
        Global.(date).(ZT).(cell).(run).IVcurve_m40_last=nanmean(data(24750:25000,8)); %pA 
        Global.(date).(ZT).(cell).(run).IVcurve_m30_last=nanmean(data(24750:25000,9)); %pA 
        Global.(date).(ZT).(cell).(run).IVcurve_m20_last=nanmean(data(24750:25000,10)); %pA 
        Global.(date).(ZT).(cell).(run).IVcurve_m10_last=nanmean(data(24750:25000,11)); %pA 
        Global.(date).(ZT).(cell).(run).IVcurve_0_last=nanmean(data(24750:25000,12)); %pA 
        Global.(date).(ZT).(cell).(run).IVcurve_10_last=nanmean(data(24750:25000,13)); %pA 
        Global.(date).(ZT).(cell).(run).IVcurve_20_last=nanmean(data(24750:25000,14)); %pA 
    end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [~,AllfilenameBaseline] = system('dir /s /b *40_Step_VC_Koster2020_hold4mV.axgd'); 
    AllfilenameBaseline = strsplit(AllfilenameBaseline,newline)';
    AllfilenameBaseline(cellfun(@isempty,AllfilenameBaseline))=[];        

    if ~strcmp( AllfilenameBaseline, 'Fichier introuvable')
        for b=1:size(AllfilenameBaseline,1)
            filepathBaseline=AllfilenameBaseline{b};   
            [dataBaseline,~] = importaxographx(filepathBaseline);
            dataBaseline=dataBaseline*10^12;%in pA

            filepathBaseline=strrep(filepathBaseline,'(','');
            filepathBaseline=strrep(filepathBaseline,')','');
            ib=strfind(filepathBaseline,'\');

            date=filepathBaseline(ib(end-3)+1:ib(end-2)-1);
            ZT=filepathBaseline(ib(end-2)+1:ib(end-1)-1);
            cell=filepathBaseline(ib(end-1)+1:ib(end)-1);

            id=filepathBaseline(ib(end)+7:ib(end)+9);
            run=['Baseline_run', id];

            Global.(date).(ZT).(cell).(run).Date=date;
            Global.(date).(ZT).(cell).(run).ZT=ZT;
            Global.(date).(ZT).(cell).(run).Cell=cell;
            Global.(date).(ZT).(cell).(run).Run=run;

            if size(dataBaseline, 2)>=13 % in case recording interrupted, do not analyzed it 

                Global.(date).(ZT).(cell).(run).rawdata=dataBaseline;

                Global.(date).(ZT).(cell).(run).IVcurve_m100_before=nanmean(dataBaseline(8000:10000,2)); %pA 
                Global.(date).(ZT).(cell).(run).IVcurve_m90_before=nanmean(dataBaseline(8000:10000,3)); %pA 
                Global.(date).(ZT).(cell).(run).IVcurve_m80_before=nanmean(dataBaseline(8000:10000,4)); %pA 
                Global.(date).(ZT).(cell).(run).IVcurve_m70_before=nanmean(dataBaseline(8000:10000,5)); %pA 
                Global.(date).(ZT).(cell).(run).IVcurve_m60_before=nanmean(dataBaseline(8000:10000,6)); %pA 
                Global.(date).(ZT).(cell).(run).IVcurve_m50_before=nanmean(dataBaseline(8000:10000,7)); %pA 
                Global.(date).(ZT).(cell).(run).IVcurve_m40_before=nanmean(dataBaseline(8000:10000,8)); %pA 
                Global.(date).(ZT).(cell).(run).IVcurve_m30_before=nanmean(dataBaseline(8000:10000,9)); %pA 
                Global.(date).(ZT).(cell).(run).IVcurve_m20_before=nanmean(dataBaseline(8000:10000,10)); %pA 
                Global.(date).(ZT).(cell).(run).IVcurve_m10_before=nanmean(dataBaseline(8000:10000,11)); %pA 
                Global.(date).(ZT).(cell).(run).IVcurve_0_before=nanmean(dataBaseline(8000:10000,12)); %pA 
                Global.(date).(ZT).(cell).(run).IVcurve_10_before=nanmean(dataBaseline(8000:10000,13)); %pA 
                Global.(date).(ZT).(cell).(run).IVcurve_20_before=nanmean(dataBaseline(8000:10000,14)); %pA 

                Global.(date).(ZT).(cell).(run).IVcurve_m100_all=nanmean(dataBaseline(10100:25000,2)); %pA 
                Global.(date).(ZT).(cell).(run).IVcurve_m90_all=nanmean(dataBaseline(10100:25000,3)); %pA 
                Global.(date).(ZT).(cell).(run).IVcurve_m80_all=nanmean(dataBaseline(10100:25000,4)); %pA 
                Global.(date).(ZT).(cell).(run).IVcurve_m70_all=nanmean(dataBaseline(10100:25000,5)); %pA 
                Global.(date).(ZT).(cell).(run).IVcurve_m60_all=nanmean(dataBaseline(10100:25000,6)); %pA 
                Global.(date).(ZT).(cell).(run).IVcurve_m50_all=nanmean(dataBaseline(10100:25000,7)); %pA 
                Global.(date).(ZT).(cell).(run).IVcurve_m40_all=nanmean(dataBaseline(10100:25000,8)); %pA 
                Global.(date).(ZT).(cell).(run).IVcurve_m30_all=nanmean(dataBaseline(10100:25000,9)); %pA 
                Global.(date).(ZT).(cell).(run).IVcurve_m20_all=nanmean(dataBaseline(10100:25000,10)); %pA 
                Global.(date).(ZT).(cell).(run).IVcurve_m10_all=nanmean(dataBaseline(10100:25000,11)); %pA 
                Global.(date).(ZT).(cell).(run).IVcurve_0_all=nanmean(dataBaseline(10100:25000,12)); %pA 
                Global.(date).(ZT).(cell).(run).IVcurve_10_all=nanmean(dataBaseline(10100:25000,13)); %pA 
                Global.(date).(ZT).(cell).(run).IVcurve_20_all=nanmean(dataBaseline(10100:25000,14)); %pA 

                Global.(date).(ZT).(cell).(run).IVcurve_m100_early=nanmean(dataBaseline(10100:14100,2)); %pA 
                Global.(date).(ZT).(cell).(run).IVcurve_m90_early=nanmean(dataBaseline(10100:14100,3)); %pA 
                Global.(date).(ZT).(cell).(run).IVcurve_m80_early=nanmean(dataBaseline(10100:14100,4)); %pA 
                Global.(date).(ZT).(cell).(run).IVcurve_m70_early=nanmean(dataBaseline(10100:14100,5)); %pA 
                Global.(date).(ZT).(cell).(run).IVcurve_m60_early=nanmean(dataBaseline(10100:14100,6)); %pA 
                Global.(date).(ZT).(cell).(run).IVcurve_m50_early=nanmean(dataBaseline(10100:14100,7)); %pA 
                Global.(date).(ZT).(cell).(run).IVcurve_m40_early=nanmean(dataBaseline(10100:14100,8)); %pA 
                Global.(date).(ZT).(cell).(run).IVcurve_m30_early=nanmean(dataBaseline(10100:14100,9)); %pA 
                Global.(date).(ZT).(cell).(run).IVcurve_m20_early=nanmean(dataBaseline(10100:14100,10)); %pA 
                Global.(date).(ZT).(cell).(run).IVcurve_m10_early=nanmean(dataBaseline(10100:14100,11)); %pA 
                Global.(date).(ZT).(cell).(run).IVcurve_0_early=nanmean(dataBaseline(10100:14100,12)); %pA 
                Global.(date).(ZT).(cell).(run).IVcurve_10_early=nanmean(dataBaseline(10100:14100,13)); %pA 
                Global.(date).(ZT).(cell).(run).IVcurve_20_early=nanmean(dataBaseline(10100:14100,14)); %pA 

                Global.(date).(ZT).(cell).(run).IVcurve_m100_late=nanmean(dataBaseline(23000:25000,2)); %pA 
                Global.(date).(ZT).(cell).(run).IVcurve_m90_late=nanmean(dataBaseline(23000:25000,3)); %pA 
                Global.(date).(ZT).(cell).(run).IVcurve_m80_late=nanmean(dataBaseline(23000:25000,4)); %pA 
                Global.(date).(ZT).(cell).(run).IVcurve_m70_late=nanmean(dataBaseline(23000:25000,5)); %pA 
                Global.(date).(ZT).(cell).(run).IVcurve_m60_late=nanmean(dataBaseline(23000:25000,6)); %pA 
                Global.(date).(ZT).(cell).(run).IVcurve_m50_late=nanmean(dataBaseline(23000:25000,7)); %pA 
                Global.(date).(ZT).(cell).(run).IVcurve_m40_late=nanmean(dataBaseline(23000:25000,8)); %pA 
                Global.(date).(ZT).(cell).(run).IVcurve_m30_late=nanmean(dataBaseline(23000:25000,9)); %pA 
                Global.(date).(ZT).(cell).(run).IVcurve_m20_late=nanmean(dataBaseline(23000:25000,10)); %pA 
                Global.(date).(ZT).(cell).(run).IVcurve_m10_late=nanmean(dataBaseline(23000:25000,11)); %pA 
                Global.(date).(ZT).(cell).(run).IVcurve_0_late=nanmean(dataBaseline(23000:25000,12)); %pA 
                Global.(date).(ZT).(cell).(run).IVcurve_10_late=nanmean(dataBaseline(23000:25000,13)); %pA 
                Global.(date).(ZT).(cell).(run).IVcurve_20_late=nanmean(dataBaseline(23000:25000,14)); %pA 

                Global.(date).(ZT).(cell).(run).IVcurve_m100_after=nanmean(dataBaseline(25010:27010,2)); %pA 
                Global.(date).(ZT).(cell).(run).IVcurve_m90_after=nanmean(dataBaseline(25010:27010,3)); %pA 
                Global.(date).(ZT).(cell).(run).IVcurve_m80_after=nanmean(dataBaseline(25010:27010,4)); %pA 
                Global.(date).(ZT).(cell).(run).IVcurve_m70_after=nanmean(dataBaseline(25010:27010,5)); %pA 
                Global.(date).(ZT).(cell).(run).IVcurve_m60_after=nanmean(dataBaseline(25010:27010,6)); %pA 
                Global.(date).(ZT).(cell).(run).IVcurve_m50_after=nanmean(dataBaseline(25010:27010,7)); %pA 
                Global.(date).(ZT).(cell).(run).IVcurve_m40_after=nanmean(dataBaseline(25010:27010,8)); %pA 
                Global.(date).(ZT).(cell).(run).IVcurve_m30_after=nanmean(dataBaseline(25010:27010,9)); %pA 
                Global.(date).(ZT).(cell).(run).IVcurve_m20_after=nanmean(dataBaseline(25010:27010,10)); %pA 
                Global.(date).(ZT).(cell).(run).IVcurve_m10_after=nanmean(dataBaseline(25010:27010,11)); %pA 
                Global.(date).(ZT).(cell).(run).IVcurve_0_after=nanmean(dataBaseline(25010:27010,12)); %pA 
                Global.(date).(ZT).(cell).(run).IVcurve_10_after=nanmean(dataBaseline(25010:27010,13)); %pA 
                Global.(date).(ZT).(cell).(run).IVcurve_20_after=nanmean(dataBaseline(25010:27010,14)); %pA 

                Global.(date).(ZT).(cell).(run).IVcurve_m100_peakafter=max(dataBaseline(25010:27010,2)); %pA 
                Global.(date).(ZT).(cell).(run).IVcurve_m90_peakafter=max(dataBaseline(25010:27010,3)); %pA 
                Global.(date).(ZT).(cell).(run).IVcurve_m80_peakafter=max(dataBaseline(25010:27010,4)); %pA 
                Global.(date).(ZT).(cell).(run).IVcurve_m70_peakafter=max(dataBaseline(25010:27010,5)); %pA 
                Global.(date).(ZT).(cell).(run).IVcurve_m60_peakafter=max(dataBaseline(25010:27010,6)); %pA 
                Global.(date).(ZT).(cell).(run).IVcurve_m50_peakafter=max(dataBaseline(25010:27010,7)); %pA 
                Global.(date).(ZT).(cell).(run).IVcurve_m40_peakafter=max(dataBaseline(25010:27010,8)); %pA 
                Global.(date).(ZT).(cell).(run).IVcurve_m30_peakafter=max(dataBaseline(25010:27010,9)); %pA 
                Global.(date).(ZT).(cell).(run).IVcurve_m20_peakafter=max(dataBaseline(25010:27010,10)); %pA 
                Global.(date).(ZT).(cell).(run).IVcurve_m10_peakafter=max(dataBaseline(25010:27010,11)); %pA 
                Global.(date).(ZT).(cell).(run).IVcurve_0_peakafter=max(dataBaseline(25010:27010,12)); %pA 
                Global.(date).(ZT).(cell).(run).IVcurve_10_peakafter=max(dataBaseline(25010:27010,13)); %pA 
                Global.(date).(ZT).(cell).(run).IVcurve_20_peakafter=max(dataBaseline(25010:27010,14)); %pA 

                %first 10ms after capacitance transient
                Global.(date).(ZT).(cell).(run).IVcurve_m100_initial=nanmean(dataBaseline(10050:10100,2)); %pA 
                Global.(date).(ZT).(cell).(run).IVcurve_m90_initial=nanmean(dataBaseline(10050:10100,3)); %pA 
                Global.(date).(ZT).(cell).(run).IVcurve_m80_initial=nanmean(dataBaseline(10050:10100,4)); %pA 
                Global.(date).(ZT).(cell).(run).IVcurve_m70_initial=nanmean(dataBaseline(10050:10100,5)); %pA 
                Global.(date).(ZT).(cell).(run).IVcurve_m60_initial=nanmean(dataBaseline(10050:10100,6)); %pA 
                Global.(date).(ZT).(cell).(run).IVcurve_m50_initial=nanmean(dataBaseline(10050:10100,7)); %pA 
                Global.(date).(ZT).(cell).(run).IVcurve_m40_initial=nanmean(dataBaseline(10050:10100,8)); %pA 
                Global.(date).(ZT).(cell).(run).IVcurve_m30_initial=nanmean(dataBaseline(10050:10100,9)); %pA 
                Global.(date).(ZT).(cell).(run).IVcurve_m20_initial=nanmean(dataBaseline(10050:10100,10)); %pA 
                Global.(date).(ZT).(cell).(run).IVcurve_m10_initial=nanmean(dataBaseline(10050:10100,11)); %pA 
                Global.(date).(ZT).(cell).(run).IVcurve_0_initial=nanmean(dataBaseline(10050:10100,12)); %pA 
                Global.(date).(ZT).(cell).(run).IVcurve_10_initial=nanmean(dataBaseline(10050:10100,13)); %pA 
                Global.(date).(ZT).(cell).(run).IVcurve_20_initial=nanmean(dataBaseline(10050:10100,14)); %pA 

                %last 50ms 
                Global.(date).(ZT).(cell).(run).IVcurve_m100_last=nanmean(dataBaseline(24750:25000,2)); %pA 
                Global.(date).(ZT).(cell).(run).IVcurve_m90_last=nanmean(dataBaseline(24750:25000,3)); %pA 
                Global.(date).(ZT).(cell).(run).IVcurve_m80_last=nanmean(dataBaseline(24750:25000,4)); %pA 
                Global.(date).(ZT).(cell).(run).IVcurve_m70_last=nanmean(dataBaseline(24750:25000,5)); %pA 
                Global.(date).(ZT).(cell).(run).IVcurve_m60_last=nanmean(dataBaseline(24750:25000,6)); %pA 
                Global.(date).(ZT).(cell).(run).IVcurve_m50_last=nanmean(dataBaseline(24750:25000,7)); %pA 
                Global.(date).(ZT).(cell).(run).IVcurve_m40_last=nanmean(dataBaseline(24750:25000,8)); %pA 
                Global.(date).(ZT).(cell).(run).IVcurve_m30_last=nanmean(dataBaseline(24750:25000,9)); %pA 
                Global.(date).(ZT).(cell).(run).IVcurve_m20_last=nanmean(dataBaseline(24750:25000,10)); %pA 
                Global.(date).(ZT).(cell).(run).IVcurve_m10_last=nanmean(dataBaseline(24750:25000,11)); %pA 
                Global.(date).(ZT).(cell).(run).IVcurve_0_last=nanmean(dataBaseline(24750:25000,12)); %pA 
                Global.(date).(ZT).(cell).(run).IVcurve_10_last=nanmean(dataBaseline(24750:25000,13)); %pA 
                Global.(date).(ZT).(cell).(run).IVcurve_20_last=nanmean(dataBaseline(24750:25000,14)); %pA 
            end     
        end
    end       
    
    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
           
    id=strfind(filepathAK42, '\');
    folderpath=filepathAK42(1:id(end));
    cd(folderpath)

    [~,AllfilenameTestPulse] = system('dir /s /b *.axgx'); % special extension for test pusle data
    AllfilenameTestPulse = strsplit(AllfilenameTestPulse,newline)';
    AllfilenameTestPulse(cellfun(@isempty,AllfilenameTestPulse))=[];

    for f=1:size(AllfilenameTestPulse,1)
        filepathTEST=AllfilenameTestPulse{f};    
        SR=[];
        MC=[];
        MR=[];

%         try %avoid issues with corrupted files
            [textData] = ReadAxographfiles(filepathTEST);

            filepathTEST=strrep(filepathTEST,'(','');
            filepathTEST=strrep(filepathTEST,')','');
            it=strfind(filepathTEST,'\');
            date=filepathTEST(it(end-3)+1:it(end-2)-1);
            ZT=filepathTEST(it(end-2)+1:it(end-1)-1);
            cell=filepathTEST(it(end-1)+1:it(end)-1);
            id=regexprep(filepathTEST(it(end)+1:end-5), ' ', '');

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
            
            if strfind(id,'ak42')
                pr='AK42';
            else
                pr='Baseline';
            end

            run=[pr '_run00' num2str(runid)];                           
            i=strfind(textData,char(SeriesResistance));
            cellidx=find(~cellfun(@isempty,i'));

            if ~isempty(cellidx) && isfield( Global.(date).(ZT).(cell), run)
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

                i=strfind(textData,' 2 0 2 4 '); 
                cellidx=find(~cellfun(@isempty,i'));
                i=i{~cellfun('isempty',i)};
                hour=double(textData{cellidx,1}(i-41:i-27)); 
                hour(hour==0) = [];
                hour(hour==32) = [];
                hour=char(hour);

                Global.(date).(ZT).(cell).(run).(PulseTime)=hour;  

                if strcmp(ZT, 'ZT2')            
                    Global.(date).(ZT).(cell).(run).(TimeFromExtraction)=datetime(datenum(hour, 'HH:MM:SS') -datenum({'09:00:00'}, 'HH:MM:SS'), 'ConvertFrom', 'datenum', 'Format', 'HH:mm:ss');
                     Global.(date).(ZT).(cell).(run).(TimeFromExtraction)=rem(datenum((datetime(datenum(hour, 'HH:MM:SS') -datenum({'09:00:00'}, 'HH:MM:SS'), 'ConvertFrom', 'datenum', 'Format', 'HH:mm:ss'))),1);
                else
                    Global.(date).(ZT).(cell).(run).(TimeFromExtraction)=datetime(datenum(hour, 'HH:MM:SS') -datenum({'21:00:00'}, 'HH:MM:SS'), 'ConvertFrom', 'datenum', 'Format', 'HH:mm:ss');
                    Global.(date).(ZT).(cell).(run).(TimeFromExtraction)=rem(datenum((datetime(datenum(hour, 'HH:MM:SS') -datenum({'21:00:00'}, 'HH:MM:SS'), 'ConvertFrom', 'datenum', 'Format', 'HH:mm:ss'))),1);
                    if Global.(date).(ZT).(cell).(run).(TimeFromExtraction)<0
                       Global.(date).(ZT).(cell).(run).(TimeFromExtraction)=rem(datenum((datetime(datenum(hour, 'HH:MM:SS') -datenum({'21:00:00'}, 'HH:MM:SS'), 'ConvertFrom', 'datenum', 'Format', 'HH:mm:ss'))),1)+1;
                    end
                end
           end    
    end
    cd(filepathAK42(1:ii(end)))   
end
    
assignin('base', 'Global', Global)

%% Create the summary table
close all
Global= evalin('base','Global');
Test.SeriesResistance=[];
Test.MembraneCapacitance=[];
Test.MembraneResistance=[];
Test.RMP=[];
Test.Rheobase=[];
% figure; 
p=1;
Global_APmorpho=[];
GlobalTable=[];
GlobalTable_Extended=[];
day=fieldnames(Global);
mouseID=1;
for d=1:size(day, 1)
    date=day{d};
    time=fieldnames(Global.(date));
    for z=1:size(time, 1)
        ZT=time{z};
        cells=fieldnames(Global.(date).(ZT));
        for c=1:size(cells, 1)
            cell=cells{c};
            runs=fieldnames(Global.(date).(ZT).(cell));
            EC=[];
            for r=1:size(runs, 1)
                run=runs{r};
                Global.(date).(ZT).(cell).(run).MouseID=mouseID;
                if isfield(Global.(date).(ZT).(cell).(run), 'SeriesResistance_1') && isfield( Global.(date).(ZT).(cell).(run), 'SeriesResistance_2') 
                    SR1=Global.(date).(ZT).(cell).(run).SeriesResistance_1;
                    MR1=Global.(date).(ZT).(cell).(run).MembraneResistance_1;   
                    MC1=Global.(date).(ZT).(cell).(run).MembraneCapacitance_1;

                    SR2=Global.(date).(ZT).(cell).(run).SeriesResistance_2;
                    MR2=Global.(date).(ZT).(cell).(run).MembraneResistance_2;
                    MC2=Global.(date).(ZT).(cell).(run).MembraneCapacitance_2;                    
                    
                    varSR=abs((SR2-SR1)/SR1*100); %compared to the first value
                    varMC=abs((MC2-MC1)/MC1*100);
                    varMR=abs((MR2-MR1)/MR1*100);
                    
                    varSR=floor(abs((SR2-SR1)/SR2*100)); %compared to the second value
                    varMC=floor(abs((MC2-MC1)/MC2*100));
                    varMR=floor(abs((MR2-MR1)/MR2*100));
                    
                    if isfield(Global.(date).(ZT).(cell), 'run0')
                        MR0=Global.(date).(ZT).(cell).run0.MembraneResistance_1;% Requires no variation of MR since the break in
                        varMR0=abs((MR2-MR0)/MR0*100);
                        MC0=Global.(date).(ZT).(cell).run0.MembraneCapacitance_1;

                        if MC1<8 %failure detection pF by Axograph
                            MC1=Global.(date).(ZT).(cell).run0.MembraneCapacitance_1; %when break in
                        end
                    else
                        varMR0=NaN;
                        MC0=NaN;
                    end
                    
                    Global.(date).(ZT).(cell).(run).MembraneCapacitance_0=MC0;
                    Global.(date).(ZT).(cell).(run).varSR=varSR;
                    Global.(date).(ZT).(cell).(run).varMC=varMC;
                    Global.(date).(ZT).(cell).(run).varMR=varMR;
                    Global.(date).(ZT).(cell).(run).varMR0=varMR0;

                    Global.(date).(ZT).(cell).(run).ExclusionCriteria=0;
                                        
                    if SR1>40 %|| SR2>40 %inf to 35mOhms or 40
                        Global.(date).(ZT).(cell).(run).ExclusionCriteria=1;
                    end
                    
                    %MR1 <= 200 || MR2 <= 200 || MC1 >= 45 || MC2 >= 45
                    if MR1+SR1 <= 200 %|| MR2+SR2 <= 200 % MC1 <= 8 || MC1 >= 40 || MC2 <= 8 || MC2 >= 40 %inf to 40pF sup at 10pF
                        Global.(date).(ZT).(cell).(run).ExclusionCriteria=1;
                    end
                    
%                     % added 19th October 2023
%                     if MR1 >= 1500 %|| MR2+SR2 <= 200 % MC1 <= 8 || MC1 >= 40 || MC2 <= 8 || MC2 >= 40 %inf to 40pF sup at 10pF
%                         Global.(date).(ZT).(cell).(run).ExclusionCriteria=1;
%                     end
                    
                    if MC1 >= 40 %|| MC2 >= 40 % MC1 <= 8 || MC1 >= 40 || MC2 <= 8 || MC2 >= 40 %inf to 40pF sup at 10pF
                        Global.(date).(ZT).(cell).(run).ExclusionCriteria=1;
                    end
                    
%                     if SR1>10 %no computation of varSR if SR<10  
                        if varSR>40 %more than 30% variation
                            Global.(date).(ZT).(cell).(run).ExclusionCriteria=1;
                        end
%                     end 

                    if isfield(Global.(date).(ZT).(cell).(run), 'IVcurve_m90_before')
                        varBaseline=abs(Global.(date).(ZT).(cell).(run).IVcurve_m90_before-Global.(date).(ZT).(cell).(run).IVcurve_m100_before);
                        Global.(date).(ZT).(cell).(run).varBaseline=varBaseline;
                        if  varBaseline>100 %100pA variation before stim--> big weird tail current
                            Global.(date).(ZT).(cell).(run).ExclusionCriteria=1;
                        end                    
                        if varMR0>100
                            Global.(date).(ZT).(cell).(run).ExclusionCriteria=1;
                        end
                        
                        if Global.(date).(ZT).(cell).(run).IVcurve_0_all<-50 % too much current at 0mV holding
                            Global.(date).(ZT).(cell).(run).ExclusionCriteria=1;
                        end
                    end
                    
                    EC(end+1,1)=[Global.(date).(ZT).(cell).(run).ExclusionCriteria + varSR/100 + varMR/100];
                    Global.(date).(ZT).(cell).(run).ExclusionCriteriaAll=[Global.(date).(ZT).(cell).(run).ExclusionCriteria + varSR/100 + varMR/100];
                
                else
                    EC(end+1,1)=1; 
                    Global.(date).(ZT).(cell).(run).ExclusionCriteriaAll=1; %no seal detected
                    continue
                end
                
                %%% Select best run 
            
                [~,i]=min(EC);
                if Global.(date).(ZT).(cell).(runs{i}).ExclusionCriteriaAll<1
                    if isempty(GlobalTable) && isfield(Global.(date).(ZT).(cell).(run),'rawdata')
                        A=Global.(date).(ZT).(cell).(run);
                        A = rmfield(A,'rawdata');
                        tnew=struct2table(A,'AsArray',true);
                        GlobalTable=tnew;                    
                    elseif isfield(Global.(date).(ZT).(cell).(run),'rawdata')
                        A=Global.(date).(ZT).(cell).(run);
                        A = rmfield(A,'rawdata');
                        tnew=struct2table(A,'AsArray',true);
                        GlobalTable=outerjoin(GlobalTable,tnew,'MergeKeys',true);
                    else
                        A=Global.(date).(ZT).(cell).(run);
                        tnew=struct2table(A,'AsArray',true);
                        GlobalTable=outerjoin(GlobalTable,tnew,'MergeKeys',true);
                    end    
                end
            end             
        end
        mouseID=mouseID+1;
    end
end
assignin('base', 'Global', Global)
assignin('base', 'GlobalTable', GlobalTable)
GlobalTable = sortrows(GlobalTable,'Run','descend');
GlobalTable = sortrows(GlobalTable,'Cell','descend');
GlobalTable = sortrows(GlobalTable,'ZT','descend');
GlobalTable = sortrows(GlobalTable,'Date','descend');

save([globalpath '\GlobalTable_' regexprep(datestr(datetime), '[^a-zA-Z0-9]','')], 'GlobalTable',  '-v7.3')
save([globalpath '\Global_' regexprep(datestr(datetime), '[^a-zA-Z0-9]','')], 'Global',  '-v7.3')
