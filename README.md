# epsilon-PAL

```
@article{zuluaga2016ϵ,
  title={ϵ-PAL: An Active Learning Approach to the Multi-Objective Optimization Problem},
  author={Zuluaga, Marcela and Krause, Andreas and P{\"u}schel, Markus},
  journal={Journal of Machine Learning Research},
  volume={17},
  pages={1--32},
  year={2016}
}
```

This is the authors implementation of epsilon-PAL from the [project website](http://www.spiral.net/software/pal.html) along with modification for collecting data for the configuration datasets.

### Step to modify this code
1. Add the dataset in train_data/. The values are seperated using a semicolon
2. Add configuration specs in conf/
3. Add the configuration you wish to run in run_pal.m (line 30)
4. Execute
5. The results are collected in results_CONFNAME/ (also define in the configuration specs in step 2). The final pareto fronts are stored as predicted_pareto_REPEATNO_EPSILONVALUE.csv and the number of evaluations is stored in prediction_error.csv. The format of prediction_error.csv is rep_iter, epsilon,num_evaluations,avg_epsilon_perc_obj1,total_time,pop_sampled.num_entries
