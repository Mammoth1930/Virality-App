class Word {
  final String word;
  final String clue;
  final int xpos;
  final int ypos;
  final bool horizontal;
  final int number;

  Word({
    required this.word,
    required this.clue,
    required this.xpos,
    required this.ypos,
    required this.horizontal,
    required this.number,
});
}

class Crossword {
  final String title;
  final List<Word> words;
  final int xaxis;
  final int yaxis;
  bool isComplete;

  Crossword({
    required this.title,
    required this.words,
    required this.xaxis,
    required this.yaxis,
    this.isComplete = false,
  });

  List<List<String>> getAnswerGrid() {
    List<List<String>> lines = List.generate(yaxis, (i) => List.generate(xaxis, (j) => '0', growable: false), growable: false);
    for (var word in words) {
      if (word.horizontal) {
        for (int i = 0; i < word.word.length; i++) {
          lines[word.ypos][word.xpos + i] = word.word[i];
        }
      } else {
        for (int i = 0; i < word.word.length; i++) {
          lines[word.ypos + i][word.xpos] = word.word[i];
        }
      }
    }
    return lines;
  }

  void setCompleted(bool bool) {
    isComplete = bool;
  }
}

final crosssword1 = Crossword(title: 'Puzzle 1', words: crossword1Words, xaxis: 10, yaxis: 10);
final crossword2 = Crossword(title: 'Puzzle 2', words: crossword2Words, xaxis: 10, yaxis: 10);
final crossword3 = Crossword(title: 'Puzzle 3', words: crossword3Words, xaxis: 10, yaxis: 10);
final crossword4 = Crossword(title: 'Puzzle 4', words: crossword4Words, xaxis: 10, yaxis: 10);
final crossword5 = Crossword(title: 'Puzzle 5', words: crossword5Words, xaxis: 10, yaxis: 10);

final CrosswordList = [crosssword1, crossword2, crossword3, crossword4, crossword5];

final crossword1Words = [
  Word(word: 'endemic',
    clue: "Ongoing, low-level presence of a disease in the community",
    xpos: 0,
    ypos: 1,
    horizontal: true,
    number: 1),
  Word(word: 'replicate',
      clue: "Viruses reproduce by this means, they ____",
      xpos: 3,
      ypos: 0,
      horizontal: false,
      number: 1),
  Word(word: 'chicken',
      clue: "A common childhood illness is the ____ pox",
      xpos: 1,
      ypos: 4,
      horizontal: true,
      number: 2),
  Word(word: 'bacteria',
      clue: "Most viruses infect not humans or animals, but this microscopic organism",
      xpos: 2,
      ypos: 6,
      horizontal: true,
      number: 3),
  Word(word: 'mask',
      clue: "The best way to stop spreading airborne germs is to wear a ____",
      xpos: 9,
      ypos: 5,
      horizontal: false,
      number: 2),
];

final crossword2Words = [
  Word(word: 'protein',
      clue: "The capsule a virus travels within is made of what macronutrient",
      xpos: 1,
      ypos: 0,
      horizontal: false,
      number: 2),
  Word(word: 'vaccinate',
      clue: "To give someone a shot made from dead viral material is to ____ them",
      xpos: 3,
      ypos: 0,
      horizontal: false,
      number: 1),
  Word(word: 'vaccine',
      clue: "A product made from extracts of viruses or bacteria that can stimulate an immune response to natural infection",
      xpos: 3,
      ypos: 0,
      horizontal: true,
      number: 1),
  Word(word: 'cell',
      clue: "A virus can only replicate inside a living ____",
      xpos: 3,
      ypos: 2,
      horizontal: true,
      number: 2),
  Word(word: 'infant',
      clue: "These young humans are often more susceptible to infection due to their lack of development in their immune system",
      xpos: 0,
      ypos: 6,
      horizontal: true,
      number: 3),
];

final crossword3Words = [
  Word(word: 'influenza',
      clue: "The common flu",
      xpos: 1,
      ypos: 0,
      horizontal: false,
      number: 1),
  Word(word: 'cold',
      clue: "The most common form of a rhinovirus is the common ____",
      xpos: 5,
      ypos: 0,
      horizontal: false,
      number: 2),
  Word(word: 'omicron',
      clue: "A more infectious variant of the COVID-19 virus",
      xpos: 8,
      ypos: 0,
      horizontal: false,
      number: 3),
  Word(word: 'infection',
      clue: "When bacteria or viruses invade the body",
      xpos: 1,
      ypos: 0,
      horizontal: true,
      number: 1),
  Word(word: 'antibody',
      clue: "Produced by the body to fight off infection",
      xpos: 1,
      ypos: 8,
      horizontal: true,
      number: 2),
  Word(word: 'herd',
      clue: "A situation in which a large portion of the community is immune to the disease is called ____ immunity",
      xpos: 0,
      ypos: 5,
      horizontal: true,
      number: 3),
];


final crossword4Words = [
  Word(word: 'epidemic',
      clue: "The spread of infection through a community at a faster than expected rate",
      xpos: 2,
      ypos: 0,
      horizontal: false,
      number: 1),
  Word(word: 'virus',
      clue: "An infectious agent that replicates only inside the living cells of an organism",
      xpos: 7,
      ypos: 3,
      horizontal: false,
      number: 2),
  Word(word: 'pandemic',
      clue: "Prevalence of a disease across the whole country or the world",
      xpos: 2,
      ypos: 1,
      horizontal: true,
      number: 1),
  Word(word: 'endemic',
      clue: "Ongoing, low-level presence of disease in a community",
      xpos: 2,
      ypos: 4,
      horizontal: true,
      number: 2),
  Word(word: 'rhino',
      clue: "A common cold is the most common type of a ____virus",
      xpos: 0,
      ypos: 6,
      horizontal: true,
      number: 3),
];

final crossword5Words = [
  Word(word: 'bubonic',
      clue: "The ____ plague that swept through Asia, Europe and Africa in the 14th century, killing an estimated 50 million people",
      xpos: 0,
      ypos: 2,
      horizontal: false,
      number: 1),
  Word(word: 'necrosis',
      clue: "A symptom of the bubonic plague that caused victims skin to turn black",
      xpos: 7,
      ypos: 0,
      horizontal: false,
      number: 2),
  Word(word: 'lymph',
      clue: "These nodes would swell up an possibly break open due to the bubonic plague",
      xpos: 9,
      ypos: 2,
      horizontal: false,
      number: 3),
  Word(word: 'biological',
      clue: "____ warfare is in some cases earliest evidenced in catapulting diseased corpses over the walls of towns",
      xpos: 0,
      ypos: 2,
      horizontal: true,
      number: 1),
  Word(word: 'black',
      clue: "Another name given to the bubonic plague is the ____ death, due to one of it's nastier effects",
      xpos: 0,
      ypos: 4,
      horizontal: true,
      number: 2),
];


