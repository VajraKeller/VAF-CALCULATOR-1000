function datatable = force_analog2grams(datatable,fs)
%conversion de force de voltage (signal analogue) � gr.

% hold time: en s

% rappel: dans datatable, essais vont de -500 ms avant d�but jusqu'� +500
% post-r�compense (d�livrance r�compense) si r�ussis

%% point force correspondant � 0 gr 

warning off;

% pre_initiation_laps: de 100 � 400 ms avant d�but essai
for trial_index=1:size(datatable,2)
    analog_baseline(trial_index)=cellfun(@(x) median(x(.1*fs.FORCE:.4*fs.FORCE)),datatable{4,trial_index});
end
analog_baseline=median(analog_baseline);

% %% d�termination point seuil (threshold hold time)
% % seuil: ce qui survient au d�but maintien qui va mener � r�ussite
% successful_trials=find(cell2mat(datatable{2,:})==1);
% for trial_index=1:numel(successful_trials)
%     analog_threshold(trial_index)=cellfun(@(x) x(end-round((.5+hold_time)*fs.FORCE)+1),datatable{4,successful_trials(trial_index)});
% end
% analog_threshold=median(analog_threshold);

%% fonction affine et correction
% for trial_index=1:size(datatable,2)
%     datatable{4,trial_index}=cellfun(@(x) force_threshold/(analog_threshold-analog_baseline)*(x-analog_baseline),datatable{4,trial_index},'un',0);
% end

for trial_index=1:size(datatable,2)
    datatable{4,trial_index}=cellfun(@(x) (x-analog_baseline)*100,datatable{4,trial_index},'un',0);
end

end