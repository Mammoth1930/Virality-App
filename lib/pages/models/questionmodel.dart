class Question {
  final String text;
  final List<Option> options;
  final Duration time;
  bool isLocked;
  Option? selectedOption;

  Question({
    required this.text,
    required this.options,
    required this.time,
    this.isLocked = false,
    this.selectedOption,
});
}

class Option {
  final String text;
  final bool isCorrect;

  const Option({
    required this.text,
    required this.isCorrect,
});
}

class Quiz {
  final String title;
  final List<Question> questions;
  bool  completed;
  Quiz({
    required this.title,
    required this.questions,
    this.completed = false
});

  void setCompleted(bool value) => completed = value;
}

final questions = [
  Question(
    text: 'Say my name?',
    time: const Duration(seconds: 15),
    options: [
      const Option(text: 'Ben', isCorrect: false),
      const Option(text: 'Waltuh', isCorrect: true),
      const Option(text: 'Ebola', isCorrect: false),
      const Option(text: 'Johhny', isCorrect: false),
    ],
  ),
  Question(
      text: 'What disease was responsible for what is widely considered'
          ' as the first pandemic in history?',
      time: const Duration(seconds: 15),
      options: [
        const Option(text: 'Bubonic Plague', isCorrect: true),
        const Option(text: 'Spanish Flu', isCorrect: false),
        const Option(text: 'Rabies', isCorrect: false),
        const Option(text: 'COVID-19', isCorrect: false)
      ]),
  Question(
      text: 'What is the difference between DNA and RNA based viruses?',
      time: const Duration(seconds: 15),
      options: [
        const Option(text: 'One uses DNA and one used RNA to store genetic information', isCorrect: true),
        const Option(text: 'There is no difference', isCorrect: false),
        const Option(text: 'DNA based viruses are deadlier than RNA based ones', isCorrect: false),
        const Option(text: 'All of the above', isCorrect: false),
        const Option(text: "Your big fat momma", isCorrect: false)
      ])
];

final virusBasicsQuestions = [
  Question(
    text: 'How do viruses spread?',
    time: const Duration(seconds: 15),
    options: [
      const Option(text: 'They walk among us', isCorrect: false),
      const Option(text: 'None of these options are correct', isCorrect: false),
      const Option(text: 'Vaccines', isCorrect: false),
      const Option(text: 'Through air and touch', isCorrect: true),
    ]),
  Question(
      text: 'How does a virus replicate?',
      time: const Duration(seconds: 15),
      options: [
        const Option(text: 'It makes a cell die', isCorrect: false),
        const Option(text: 'It makes a cell shrink', isCorrect: false),
        const Option(text: 'It turns the cell into a virus-making machine', isCorrect: true),
        const Option(text: 'It turns the cell into a virus', isCorrect: false),
      ]),
  Question(
      text: 'How big is a virus?',
      time: const Duration(seconds: 15),
      options: [
        const Option(text: 'It is the size of an ant', isCorrect: false),
        const Option(text: 'It is too small to be seen', isCorrect: true),
        const Option(text: 'It is the size of a grain of sand', isCorrect: false),
        const Option(text: 'It is the size of a piece of dust', isCorrect: false),
      ]),
];

final fluQuestions = [
  Question(
      text: 'Influenza or the flu is predominantly affects which part of the body?',
      time: const Duration(seconds: 15),
      options: [
        const Option(text: 'Intestines', isCorrect: false),
        const Option(text: 'Lungs', isCorrect: true),
        const Option(text: 'Skin', isCorrect: false),
        const Option(text: 'Bones', isCorrect: false),
      ]),
  Question(
      text: 'In what time period was the first flu case reported?',
      time: const Duration(seconds: 15),
      options: [
        const Option(text: '1900s', isCorrect: false),
        const Option(text: '1100s', isCorrect: false),
        const Option(text: '1800s', isCorrect: false),
        const Option(text: '400BCE', isCorrect: true),
      ]),
  Question(
      text: 'How long is the incubation period for the flu?',
      time: const Duration(seconds: 15),
      options: [
        const Option(text: '12 hours', isCorrect: false),
        const Option(text: '1-4 days', isCorrect: true),
        const Option(text: '7-14 days', isCorrect: false),
        const Option(text: '14+ days', isCorrect: false),
      ]),
];

final covidQuestions = [
  Question(
      text: 'COVID-19 predominately affects which bodily system?',
      time: const Duration(seconds: 15),
      options: [
        const Option(text: 'Respiratory system', isCorrect: true),
        const Option(text: 'Nervous system', isCorrect: false),
        const Option(text: 'Musculoskeletal system', isCorrect: false),
        const Option(text: 'Endocrine system', isCorrect: false),
      ]),
  Question(
      text: 'When was the first case of COVID-19 reported?',
      time: const Duration(seconds: 15),
      options: [
        const Option(text: 'December 2019', isCorrect: true),
        const Option(text: 'January 2020', isCorrect: false),
        const Option(text: 'February 2020', isCorrect: false),
        const Option(text: 'November 2019', isCorrect: false),
      ]),
  Question(
      text: 'Which of the following is not a variant of COVID-19',
      time: const Duration(seconds: 15),
      options: [
        const Option(text: 'Omicron', isCorrect: false),
        const Option(text: 'Megatron', isCorrect: true),
        const Option(text: 'Delta', isCorrect: false),
        const Option(text: 'Gamma', isCorrect: false),
      ]),
  Question(
      text: 'Which of the following companies was the only to produce COVID-19 vaccines?',
      time: const Duration(seconds: 15),
      options: [
        const Option(text: 'Moderna', isCorrect: true),
        const Option(text: 'Pfizer', isCorrect: false),
        const Option(text: 'Astrazeneca', isCorrect: false),
        const Option(text: 'All of the above', isCorrect: false),
      ]),
  Question(
      text: 'What general guideline is given when it comes to social distancing measures?',
      time: const Duration(seconds: 15),
      options: [
        const Option(text: 'Maintain 1.5m distance or greater', isCorrect: true),
        const Option(text: 'Maintain less than 1.5m distance', isCorrect: false),
        const Option(text: 'Gather in large groups', isCorrect: false),
        const Option(text: 'All of the above', isCorrect: false),
      ]),
  Question(
      text: 'Which country hold the highest vaccination rate for COVID-19?',
      time: const Duration(seconds: 15),
      options: [
        const Option(text: 'Germany', isCorrect: false),
        const Option(text: 'India', isCorrect: false),
        const Option(text: 'Australia', isCorrect: false),
        const Option(text: 'China', isCorrect: true),
      ]),
];

final hivQuestions = [
  Question(
    text: 'What does the acronym HIV stand for?',
    time: const Duration(seconds: 15),
    options: [
      const Option(text: 'Helicopter Immunodeficiency Virus', isCorrect: false),
      const Option(text: 'Human Impotency Virus', isCorrect: false),
      const Option(text: 'Human Intestinal Virus', isCorrect: false),
      const Option(text: 'Human Immunodeficiency Virus', isCorrect: true),
    ]
  ),
  Question(
      text: 'The first HIV virus was discovered where and when?',
      time: const Duration(seconds: 15),
      options: [
        const Option(text: 'India in 1999', isCorrect: false),
        const Option(text: 'South Africa in 1944', isCorrect: false),
        const Option(text: 'USA in 1981', isCorrect: true),
        const Option(text: 'Australia in 2001', isCorrect: false),
      ]),
  Question(
      text: 'Since HIVs discovery, how many people have lost their lives to date?',
      time: const Duration(seconds: 15),
      options: [
        const Option(text: '>25 million', isCorrect: true),
        const Option(text: '>40 million', isCorrect: false),
        const Option(text: '<30 million>', isCorrect: false),
        const Option(text: '<10 million', isCorrect: false),
      ]),
  Question(
      text: 'Which NBA player famously has survived and lived with HIV for more than 30 years?',
      time: const Duration(seconds: 15),
      options: [
        const Option(text: 'Magic Johnson', isCorrect: true),
        const Option(text: 'Michael Jordan', isCorrect: false),
        const Option(text: 'Lebron James', isCorrect: false),
        const Option(text: "Shaquille O'Neal", isCorrect: false),
      ]),
  Question(
      text: 'Which of the following is not a possible method of contracting the HIV virus?',
      time: const Duration(seconds: 15),
      options: [
        const Option(text: 'Sexual activity', isCorrect: false),
        const Option(text: 'Reusing of needles', isCorrect: false),
        const Option(text: 'Drinking dirty water', isCorrect: true),
        const Option(text: 'Childbirth', isCorrect: false),
      ]),
];

final chickenpoxQuestions = [
  Question(
      text: 'Chicken pox is a viral and highly contagious disease that predominantly affects which organ?',
      time: const Duration(seconds: 15),
      options: [
        const Option(text: 'Brain', isCorrect: false),
        const Option(text: 'Eyes', isCorrect: false),
        const Option(text: 'Lungs', isCorrect: false),
        const Option(text: 'Skin', isCorrect: true),
      ]
  ),
  Question(
      text: 'Which of the following is not a symptom of chicken pox?',
      time: const Duration(seconds: 15),
      options: [
        const Option(text: 'Itchy rashes over the body', isCorrect: false),
        const Option(text: 'Raised blisters', isCorrect: false),
        const Option(text: 'Excessive vomiting', isCorrect: true),
        const Option(text: 'Fever and tiredness', isCorrect: false),
      ]),
  Question(
      text: 'The disease shingles is a product of what?',
      time: const Duration(seconds: 15),
      options: [
        const Option(text: 'Improper hygiene', isCorrect: false),
        const Option(text: 'Polio', isCorrect: false),
        const Option(text: 'Reactivated chicken pox virus', isCorrect: true),
        const Option(text: 'A bad case of the flu', isCorrect: false),
      ]),
  Question(
      text: 'Chicken pox can affect which species of animal?',
      time: const Duration(seconds: 15),
      options: [
        const Option(text: 'Humans alone', isCorrect: false),
        const Option(text: 'Humans, birds and reptiles', isCorrect: false),
        const Option(text: 'Humans, gorillas and chimpanzees', isCorrect: true),
        const Option(text: "None of the above", isCorrect: false),
      ]),
];

final ebolaQuestions = [
  Question(
      text: 'When was Ebola first discovered?',
      time: const Duration(seconds: 15),
      options: [
        const Option(text: '1999', isCorrect: false),
        const Option(text: '1976', isCorrect: true),
        const Option(text: '1960', isCorrect: false),
        const Option(text: '2014', isCorrect: false),
      ]
  ),
  Question(
      text: 'Which country did Ebola originate in?',
      time: const Duration(seconds: 15),
      options: [
        const Option(text: 'Simultaneously in the Democratic Republic of Congo and Sudan', isCorrect: true),
        const Option(text: 'Egypt', isCorrect: false),
        const Option(text: 'South Africa', isCorrect: false),
        const Option(text: 'Simultaneously in Nigeria and Uganda', isCorrect: false),
      ]),
  Question(
      text: 'Which of the following cannot transmit the Ebola virus?',
      time: const Duration(seconds: 15),
      options: [
        const Option(text: 'Chimpanzees', isCorrect: false),
        const Option(text: 'Dogs', isCorrect: true),
        const Option(text: 'Gorillas', isCorrect: false),
        const Option(text: 'Monkeys', isCorrect: false),
      ]),
  Question(
      text: 'Which is not a symptom of the Ebola virus?',
      time: const Duration(seconds: 15),
      options: [
        const Option(text: 'Unexplained bleeding and bruising', isCorrect: false),
        const Option(text: 'Stomach pain and vomiting', isCorrect: false),
        const Option(text: 'Coughing and sneezing', isCorrect: true),
        const Option(text: "Diarrhea", isCorrect: false),
      ]),
  Question(
      text: 'When did the most widespread outbreak of Ebola occur?',
      time: const Duration(seconds: 15),
      options: [
        const Option(text: '2014-2016', isCorrect: true),
        const Option(text: '2015-2018', isCorrect: false),
        const Option(text: 'Ongoing', isCorrect: false),
        const Option(text: "2008-2011", isCorrect: false),
      ]),
];

final rabiesQuestions = [
  Question(
      text: 'What is not a symptom of rabies?',
      time: const Duration(seconds: 15),
      options: [
        const Option(text: 'Loss of consciousness', isCorrect: false),
        const Option(text: 'Sudden fear of heights', isCorrect: true),
        const Option(text: 'Excessive salivary secretions', isCorrect: false),
        const Option(text: 'Anxiety and vomiting', isCorrect: false),
      ]
  ),
  Question(
      text: 'Approximately how many deaths happen each year due to rabies?',
      time: const Duration(seconds: 15),
      options: [
        const Option(text: '120,000 - 150,000', isCorrect: false),
        const Option(text: '55,000 - 59,000', isCorrect: true),
        const Option(text: '65,000 - 80,000', isCorrect: false),
        const Option(text: '45,000 or less', isCorrect: false),
      ]),
  Question(
      text: 'Rabies can affect which of the following groups of animals?',
      time: const Duration(seconds: 15),
      options: [
        const Option(text: 'Mammals', isCorrect: true),
        const Option(text: 'Mammals and birds', isCorrect: false),
        const Option(text: 'Mammals and fish', isCorrect: false),
        const Option(text: 'Humans and dogs alone', isCorrect: false),
      ]),
  Question(
      text: 'Which country has the highest rate of human rabies cases in the world?',
      time: const Duration(seconds: 15),
      options: [
        const Option(text: 'USA', isCorrect: false),
        const Option(text: 'India', isCorrect: true),
        const Option(text: 'Australia', isCorrect: false),
        const Option(text: "China", isCorrect: false),
      ]),
];

final polioQuestions = [
  Question(
      text: 'How close is the polio virus to eradication?',
      time: const Duration(seconds: 15),
      options: [
        const Option(text: '33%', isCorrect: false),
        const Option(text: '50%', isCorrect: false),
        const Option(text: '98%', isCorrect: true),
        const Option(text: '100%', isCorrect: false),
      ]
  ),
  Question(
      text: 'The polio virus is most commonly transmitted by which of the following methods?',
      time: const Duration(seconds: 15),
      options: [
        const Option(text: 'Fecal-oral', isCorrect: true),
        const Option(text: 'By bodily fluids', isCorrect: false),
        const Option(text: 'Airborne transmission', isCorrect: false),
        const Option(text: 'Sexual transmission', isCorrect: false),
      ]),
  Question(
      text: 'What group of individuals is most susceptible to polio?',
      time: const Duration(seconds: 15),
      options: [
        const Option(text: 'Children under 5 years old', isCorrect: true),
        const Option(text: 'Teens from 13-18', isCorrect: false),
        const Option(text: 'Adults in their 50s', isCorrect: false),
        const Option(text: 'Polio tends to effect all of the above equally', isCorrect: false),
      ]),
  Question(
      text: 'Which President of the United States famously has polio, and kept it from the public during his tenure as president?',
      time: const Duration(seconds: 15),
      options: [
        const Option(text: 'Donald J Trump', isCorrect: false),
        const Option(text: 'Theodore Roosevelt', isCorrect: false),
        const Option(text: 'Abraham Lincoln', isCorrect: false),
        const Option(text: "Franklin Delano Roosevelt", isCorrect: true),
      ]),
];

final generalQuestions1 = [
  Question(
      text: 'The simplest version of a virus stores genetic information using which of the following?',
      time: const Duration(seconds: 15),
      options: [
        const Option(text: 'DNA or RNA', isCorrect: true),
        const Option(text: 'RNA or MRNA', isCorrect: false),
        const Option(text: 'MRNA', isCorrect: false),
        const Option(text: 'None of the above', isCorrect: false),
      ]
  ),
  Question(
      text: 'How do viruses reproduce?',
      time: const Duration(seconds: 15),
      options: [
        const Option(text: 'They divide by mitosis', isCorrect: false),
        const Option(text: 'Sexually, by external fertilization', isCorrect: false),
        const Option(text: 'They can replicate on their own with no resources', isCorrect: false),
        const Option(text: 'Inserting DNA into the host cell and turning it into a virus factory', isCorrect: true),
      ]),
  Question(
      text: 'Retroviruses are different from viruses in that they:',
      time: const Duration(seconds: 15),
      options: [
        const Option(text: 'Insert a DNA copy of their RNA genome into the host', isCorrect: true),
        const Option(text: 'Are the only viruses to use RNA to store genetic material', isCorrect: false),
        const Option(text: 'Are the only viruses that can be transmitted through fluids', isCorrect: false),
        const Option(text: 'All of the above', isCorrect: false),
      ]),
  Question(
      text: 'Which of the following is smallest?',
      time: const Duration(seconds: 15),
      options: [
        const Option(text: 'Eukaryotic cell', isCorrect: false),
        const Option(text: 'Bacteria', isCorrect: false),
        const Option(text: 'Bacteriophage', isCorrect: true),
        const Option(text: "\$1 coin", isCorrect: false),
      ]),
  Question(
      text: 'Vaccines can be used to prevent viral infection by which of the following methods?',
      time: const Duration(seconds: 15),
      options: [
        const Option(text: 'Stimulating an immune response in the host upon natural infection', isCorrect: true),
        const Option(text: 'Curing the host', isCorrect: false),
        const Option(text: 'Creating a blocking protein on the cells', isCorrect: false),
        const Option(text: "Preventing replication of the virus", isCorrect: false),
      ]),
];

final generalQuestions2 = [
  Question(
      text: 'Antiviral drugs that are used after infection often prevent which of the following?',
      time: const Duration(seconds: 15),
      options: [
        const Option(text: 'Cell division', isCorrect: false),
        const Option(text: 'Immune system degradation', isCorrect: false),
        const Option(text: 'Reinfection by other viruses', isCorrect: false),
        const Option(text: 'Uptake of the virus', isCorrect: true),
      ]
  ),
  Question(
      text: 'Why do some viruses tend to lead to a recovery and then becoming ill later, without becoming reinfected?',
      time: const Duration(seconds: 15),
      options: [
        const Option(text: 'The host has been infected with a different strain', isCorrect: false),
        const Option(text: 'The immune system forgot about the virus', isCorrect: false),
        const Option(text: 'The virus had entered a dormant state, which it has emerged from', isCorrect: true),
        const Option(text: 'The virus has mutated into a more potent form', isCorrect: false),
      ]),
  Question(
      text: 'WHy is it difficult to develop vaccines for retroviruses?',
      time: const Duration(seconds: 15),
      options: [
        const Option(text: 'Their small size allows them to evade the immune system', isCorrect: false),
        const Option(text: 'RNA mutates more frequently than DNA', isCorrect: true),
        const Option(text: 'The protein shell around retroviruses is more resistant to breaches', isCorrect: false),
        const Option(text: 'Vaccines can only target DNA based viruses', isCorrect: false),
      ]),
  Question(
      text: 'What happens after the virus has been taken up by the cell?',
      time: const Duration(seconds: 15),
      options: [
        const Option(text: 'It begins making proteins', isCorrect: false),
        const Option(text: 'It divides itself', isCorrect: false),
        const Option(text: 'It inserts itself into the host DNA', isCorrect: true),
        const Option(text: 'It switches to infectious mode', isCorrect: false),
      ]),
];

final Quiz fluQuiz = Quiz(title: 'FLU QUIZ', questions: fluQuestions);
final Quiz covidQuiz = Quiz(title: 'COVID QUIZ', questions: covidQuestions);
final Quiz hivQuiz = Quiz(title: 'HIV QUIZ', questions: hivQuestions);
final Quiz chickenpoxQuiz = Quiz(title: 'CHICKEN POX QUIZ', questions: chickenpoxQuestions);
final Quiz ebolaQuiz = Quiz(title: 'EBOLA QUIZ', questions: ebolaQuestions);
final Quiz rabiesQuiz = Quiz(title: 'RABIES QUIZ', questions: rabiesQuestions);
final Quiz polioQuiz = Quiz(title: 'POLIO QUIZ', questions: polioQuestions);
final Quiz generalQuiz1 = Quiz(title: 'GENERAL QUIZ 1', questions: generalQuestions1);
final Quiz generalQuiz2 = Quiz(title: 'GENERAL QUIZ 2', questions: generalQuestions2);

final List<Quiz> quizList = [fluQuiz, covidQuiz, hivQuiz, chickenpoxQuiz, ebolaQuiz, rabiesQuiz, polioQuiz, generalQuiz1, generalQuiz2];
