class TimelineDay {
  final String dayNumber;
  final bool completed;
  final String changes;

  TimelineDay({
    required this.dayNumber,
    required this.completed,
    required this.changes,
  });
}

List<TimelineDay> getDummyTimelineDays() {
  return [
    TimelineDay(dayNumber: 'Day 1', completed: true, changes: 'You will experience a significant drop in your nicotine levels. Your body will begin to experience withdrawal symptoms such as cravings, irritability, and anxiety.'),
    TimelineDay(dayNumber: 'Day 2', completed: true, changes: 'Your sense of smell and taste will begin to improve. Your oxygen levels in the blood will increase to normal.'),
    TimelineDay(dayNumber: 'Day 3', completed: true, changes: 'Your nicotine withdrawal symptoms will peak. Your breathing will become easier as your bronchial tubes relax.'),
    TimelineDay(dayNumber: 'Day 4', completed: true, changes: 'Your carbon monoxide levels in the blood will decrease. Your blood circulation will improve.'),
    TimelineDay(dayNumber: 'Day 5', completed: true, changes: 'Your lung function will begin to improve.'),
    TimelineDay(dayNumber: 'Day 10', completed: true, changes: 'Your breathing will become even easier as your lung function improves. Your physical endurance may increase.'),
    TimelineDay(dayNumber: 'Day 20', completed: true, changes: 'Your blood pressure and heart rate will begin to normalize. Your lung function will continue to improve.'),
    TimelineDay(dayNumber: 'Day 30', completed: true, changes: 'Your overall energy levels will increase. Your coughing and shortness of breath will decrease.'),
    TimelineDay(dayNumber: '2 months', completed: false, changes: 'Your circulation will improve further. Your lung function will continue to increase, reducing coughing and wheezing.'),
    TimelineDay(dayNumber: '3 months', completed: false, changes: 'Your physical activities will become easier. Your lung capacity will increase, making breathing easier.'),
    TimelineDay(dayNumber: '6 months', completed: false, changes: 'Your cilia in the lungs will start to repair, improving their ability to clear mucus. Your overall lung function will improve.'),
    TimelineDay(dayNumber: '1 year', completed: false, changes: 'The risk of heart disease will decrease by about 50%. Your coughing, sinus congestion, and fatigue will decrease.'),
    TimelineDay(dayNumber: '2 years', completed: false, changes: 'The risk of stroke will decrease to that of a non-smoker. Your circulation will continue to improve, reducing the risk of blood clots.'),
    TimelineDay(dayNumber: '3 years', completed: false, changes: 'The risk of heart disease will decrease to that of a non-smoker. Your lung function will continue to improve, reducing the risk of infections and respiratory issues.'),
    TimelineDay(dayNumber: '4 years', completed: false, changes: 'The risk of mouth, throat, esophagus, and bladder cancer will decrease significantly. Your overall risk of stroke will decrease further.'),
  ];
}