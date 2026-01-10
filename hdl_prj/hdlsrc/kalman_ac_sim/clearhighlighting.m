SLStudio.Utils.RemoveHighlighting(get_param('kalman_ac_sim', 'handle'));
SLStudio.Utils.RemoveHighlighting(get_param('gm_kalman_ac_sim', 'handle'));
annotate_port('gm_kalman_ac_sim/Kalman DUT/Kalman Gain Calculation/Inverse_aprox', 0, 1, '');
annotate_port('kalman_ac_sim/Kalman DUT/Kalman Gain Calculation/Inverse_aprox', 0, 1, '');
