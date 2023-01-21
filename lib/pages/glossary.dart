import 'package:flutter/material.dart';
import 'package:viral_gamification_app/theme/constants.dart';

import '../api/UserAPI.dart';

class GlossaryPage extends StatelessWidget {
  const GlossaryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Glossary"),
        backgroundColor: backgroundBlack,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: const [
            GlossaryDropDown(),
            SizedBox(height: 50)
          ],
        ),
      ),
    );
  }
}

// stores ExpansionPanel state information
class Article {
  final String title;
  final List<String> causes;
  final List<String> symptoms;
  final List<String> transmission;
  final List<String> prevention;
  final List<String> origin;
  final List<String> mortality;
  final List<String> ingame;
  bool isExpanded;

  Article({
    required this.title,
    required this.causes,
    required this.symptoms,
    required this.transmission,
    required this.prevention,
    required this.origin,
    required this.mortality,
    required this.ingame,
    this.isExpanded = false
  });
}

class GlossaryDropDown extends StatefulWidget {
  const GlossaryDropDown({super.key});

  @override
  State<GlossaryDropDown> createState() => _GlossaryDropDown();
}

class _GlossaryDropDown extends State<GlossaryDropDown> {
  final List<Article> _data = articles;

  @override
  Widget build(BuildContext context) {
    return _buildPanel();
  }

  Widget _buildPanel() {
    return ExpansionPanelList(
      dividerColor: accentPurple,
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _data.elementAt(index).isExpanded = !isExpanded;
        });
      },
      children: _data.map<ExpansionPanel>((Article article) {
        return ExpansionPanel(
          canTapOnHeader: true,
          backgroundColor: backgroundDarkGrey,
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text(
                article.title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            );
          },
          body: ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Causes:',
                    style: Theme.of(context).textTheme.bodyLarge
                  ),
                  BulletList(texts: article.causes),
                  const SizedBox(height: 15),
                  Text(
                    'Symptoms:',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  BulletList(texts: article.symptoms),
                  const SizedBox(height: 15),
                  Text(
                    'Transmission:',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  BulletList(texts: article.transmission),
                  const SizedBox(height: 15),
                  Text(
                    'Prevention:',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  BulletList(texts: article.prevention),
                  const SizedBox(height: 15),
                  Text(
                    'Origin:',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  BulletList(texts: article.origin),
                  const SizedBox(height: 15),
                  Text(
                    'Mortality:',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  BulletList(texts: article.mortality),
                  const SizedBox(height: 15),
                  Text(
                    'In-game:',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  BulletList(texts: article.ingame),
                ],
              )
              ),
          isExpanded: article.isExpanded,
        );
      }).toList(),
    );
  }
}

class BulletList extends StatelessWidget {
  const BulletList({Key? key, required this.texts}) : super(key: key);
  final Iterable<String> texts;

  @override
  Widget build(BuildContext context) {
    var widgetList = <Widget>[];
    for (String text in texts) {
      // Add list item
      widgetList.add(ListItem(text: text));
      // Add space between items
      widgetList.add(const SizedBox(height: 0.5));
    }
    return Column(children: widgetList);
  }
}


class ListItem extends StatelessWidget {
  const ListItem({Key? key, required this.text,}) : super(key: key);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "-  ",
          style: Theme.of(context).textTheme.bodyMedium
        ),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium
          ),
        )
      ],
    );
  }
}



// Enter information for different diseases here
// Can have different statistics as well as short description or some historical information
final List<Article> articles = [
  Article(
    title: 'Human Flu (Influenza)',
    causes: ['Influenza viruses, primarily Alphainfluenzavirus.'],
    symptoms: [
      'Symptoms typically develop 1-4 days from exposure, however many '
          'infections are asymptomatic.',
      'Fever',
      'Chills',
      'Headaches',
      'Muscle pain',
      'Discomfort',
      'Loss of appetite',
      'Lack of energy/fatigue',
      'Confusion',
      'Dry cough',
      'Sore/dry throat',
      'Hoarse voice',
      'Stuffy/runny nose',
      'Nausea',
      'Vomiting',
      'Diarrhea',
      'Gastroenteritis ("gastro")'
    ],
    transmission: [
      'People who are infected with influenza can spread it through breathing,'
          ' talking and sneezing, which spreads respiratory droplets and '
          'aerosols though the air.'
      'Transmission through contact with a person, bodily fluids or formites '
          '(inanimate objects) can also occur.'
    ],
    prevention: [
      'Annual vaccination ins the primary and most effective way to prevent '
          'influenza.',
      'Staying in open well-ventilated spaces.',
      'Regular hand washing with soap or alcohol-based rub.',
      'Covering your mouth and nose when coughing or sneezing.',
      'Self-isolation if unwell.',
      'Social distancing.'
    ],
    origin: ['It is not well known when the first influenza '
        'infection/pandemic occurred. A possible candidate is in 6,000 BC in '
        'China but there are also possible descriptions in Greek writings '
        'from the 5th century BC.'],
    mortality: ['0.096%'],
    ingame: ['In-game, this disease has an infection time of 7 hours']
  ),
  Article(
    title: 'COVID-19 (Coronavirus)',
    causes: ['Caused by the SARS-Cov-2 virus.'],
    symptoms: [
      'Symptoms typically develop 5-6 days from exposure. However, in some '
          'circumstances it can take up to 14 days.',
      'Fever',
      'Cough',
      'Tiredness',
      'Loss of taste or smell',
      'Sore throat',
      'Aches and pains',
      'Diarrhoea',
      'A rash',
      'Discoloration of fingers and toes',
      'Red or irritated eyes',
      'Difficulty breathing or shortness or breath',
      'Loss of speech or mobility or confusion',
      'Chest pain'
    ],
    transmission: ['Depending on the coronavirus species it can be spread by '
        'either an aerosol, fomite (living on an inanimate object) or via a '
        'fecal-oral route.'],
    prevention: [
      'Vaccination',
      'Social distancing of at least 1 meter, even from people who don\'t '
          'appear sick.',
      'Properly fitted mask.',
      'Staying in open well-ventilated spaces.',
      'Regular hand washing with soap with soap or alcohol-based rub.',
      'Covering your mouth and nose when coughing or sneezing.',
      'Self-isolation if unwell.'
    ],
    origin: [
      'The earliest report of a coronavirus infection in animals was in the '
          'late 1920s.',
      'Human coronaviruses were discovered in the 1960s.',
      'The COVID-19 coronavirus originated in Wuhan, China in 2019 and is '
          'thought to have originated from bats.'
    ],
    mortality: ['1.06%'],
    ingame: ['In-game, this disease has an infection time of 90 minutes']
  ),
  Article(
    title: 'Bubonic Plague (Black Death)',
    causes: ['One of the three types of plague caused by the bacterium '
        'Yersina pestis.'],
    symptoms: [
      'Symptoms begin to develop 1-7 days after exposure.',
      'Fever',
      'Headaches',
      'Vomiting',
      'Swollen and painful lymph nodes close to where the bacteria entered '
          'the skin.',
      'Dark discoloration of the skin.'
    ],
    transmission: [
      'Primarily transmitted by infected fleas form small animals.',
      'Can also spread from exposure to the body fluids from a dead '
          'plague-infected animal.'
    ],
    prevention: [
      'Avoid contact with rodents.',
      'Use flea control products for your pets.',
      'Don\'t let pets who roam freely in your bed.',
      'Use protective clothing if you handle dead animals.',
      'Use insect repellent if you go into wooded locations.',
      'Vaccination (this is only for people who are at very high risk).'
    ],
    origin: ['Yersinia pestis has been discovered in archaeological finds of '
      'human teeth from the late bronze age in Asian and Europe dating 2,800 '
      'to 5,000 years old.'],
    mortality: [
      '10% if treated.',
      '30-90% if untreated.'
    ],
    ingame: ['In-game, this disease has an infection time of 6 hours']
  ),
  Article(
    title: "Measles",
    causes: ["The measles virus."],
    symptoms: [
      "Symptoms typically begin 10-14 days after exposure.",
      "Four-day fever",
      "Cough",
      "Sneezing",
      "Head cold",
      "Conjunctivitis",
      "A maculopapular rash (flat red area on skin, covered with small "
          "confluent bumps).",
      "Koplik's spots (small white spots typically on the inside othe cheeks)."
    ],
    transmission: [
      "Measles is the most contagious disease known to humankind.",
      "Measles is an airborne disease spreading via aerosols or direct "
          "contact with mouth or nasal secretions."
    ],
    prevention: [
      "Mothers who are immune to measles pass antibodies to their children "
          "while they are still in the womb, however, these antibodies are "
          "gradually lost over the first nine months of life.",
      "Vaccine"
    ],
    origin: [
      "Measles originated from rinderpest, a disease which infects cows.",
      "It is estimated that the first case of Measles was as early as 4th "
          "century BC or 500 AD."
    ],
    mortality: ["0.1%"],
    ingame: ['In-game, this disease has an infection time of 2 hours']
  ),
  Article(
    title: 'Ebola (EVD)',
    causes: ['EVD is caused by four of six viruses fo the genus Ebolavirus.'],
    symptoms: [
      'Symptoms begin to develop between 2 and 21 days after exposure. '
          'However, typically it is between 4 and 10.',
      'Fatigue',
      'Fever',
      'Weakness',
      'Decreased appetite',
      'Muscular pain',
      'Joint pain',
      'Headache',
      'Sore throat',
      'Nausea',
      'Vomiting',
      'Diarrhea',
      'Hiccups',
      'Shortness of breath',
      'Chest pain',
      'Swelling',
      'Headaches',
      'Confusion',
      'Decreased blood clotting',
      'Maculopapular rash (flat red area on skin, covered with small '
          'confluent bumps), 5-7 days after symptoms begin.',
      'In some cases, external bleeding may occur this is typically 5-7 days '
          'after first symptoms.'
    ],
    transmission: [
      'It is believed that between people, EVD spreads only by direct contact '
          'with the blood or bodily fluids of a person who has developed '
          'symptoms of the disease.',
      'The WHO states that only people who are very sick are able to spread '
          'the disease in saliva and the virus has not been reported to be '
          'transferred through sweat.',
      'Although it is not entirely clear how EVD initially spreads from '
          'animals to humans, the spread is believed to involve direct '
          'contact with and infected wild animal, especially fruit bats.',
      'In Africa, wild animals including fruit bats are hunted for food which'
          ' is commonly referred to as "bushmeat". This bushmeat is believed '
          'to be one of the primary was EVD is spread from animal to humans.'
    ],
    prevention: [
      'Vaccines',
      'People who care for those who are infected with the virus should wear '
          'protective clothing including masks, gloves and goggles.',
      'Bushmeat should be handled and prepared with appropriate protective '
          'clothing and thoroughly cooked before consumption.',
      'Regular hand washing using soap and water or an alcohol-based rub.'
    ],
    origin: [
      'EVD is believed to originate in fruit bats who then spread it directly '
          'to humans or to other animals who then spread it to humans.',
      'The first known EVD outbreak was in 1976 in Nzara, South Sudan (then a'
          ' part of Sudan). 284 people where infected, 151 of whom died. WHO '
          'medical staff did not know at the time what the disease was and '
          'this was only officially discovered during a second outbreak that '
          'same year in Zaire.'
    ],
    mortality: ['25-90% mortality.'],
    ingame: ['In-game, this disease has an infection time of 2 hours']
  )
];