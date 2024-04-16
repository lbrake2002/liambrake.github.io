/*
Liam Brake
*/

// Enumerations

/*
The enumerator Suit will store the suits of the cards and be used to set the suit a card given to the player or dealer. It also contains the unicode values for each suit.
*/
public enum Suit : String
{
  case Spade, Heart, Club, Diamond

  // This function will set the Unicode value of the Suit
  func printSuit() -> String
  {
    switch(self)
    {
      case.Spade : return "\u{2664}"
      case.Heart : return "\u{2665}"
      case.Club : return "\u{2666}"
      case.Diamond : return "\u{2667}"
    }
  }
}

/*
The Rank enumerator will contain the ranks of the cards and set the cards to their proper rank. It will also store the amount of points that each card is worth.
*/
public enum Rank : String
{
  case Two, Three, Four, Five, Six, Seven, Eight, Nine, Ten , Jack, Queen, King, Ace

  // This function will return the rank of the card
  func printRank() -> String
  {
    switch(self)
    {
      case.Two : return "2"
      case.Three : return "3"
      case.Four : return "4"
      case.Five : return "5"
      case.Six : return "6"
      case.Seven : return "7"
      case.Eight : return "8"
      case.Nine : return "9"
      case.Ten : return "10"
      case.Jack : return "Jack"
      case.Queen : return "Queen"
      case.King : return "King"
      case.Ace : return "Ace"
    }
  }

  // This function will return the amount of points each Rank is worth
  func setPoints() -> Int
  {
    switch(self)
    {
      case.Ace : return 1 // This will not be used as it can be a 1 or 11
      case.Two : return 2
      case.Three : return 3
      case.Four : return 4
      case.Five : return 5
      case.Six : return 6
      case.Seven : return 7
      case.Eight : return 8
      case.Nine : return 9
      case.Ten : return 10
      case.Jack : return 10
      case.Queen : return 10
      case.King : return 10
    }
  }
}

// Classes

/*
The Card class will set the rank and suit of the card and also be able to print out what the card is
*/
public class Card
{
  private var cardRank : Rank
  private var cardSuit : Suit

  public init(rank: Rank, suit: Suit)
  {
    self.cardSuit = suit
    self.cardRank = rank
  }

  public func getRank() -> Rank
  {
    return self.cardRank
  }

  public func printCard() -> String
  {
    return "\(cardRank.printRank()) of \(cardSuit.printSuit())"
  }
}

/*
The Deck class will be used to create a Deck made up of an array of cards
*/
public class Deck
{
  public func createDeck() -> [Card]
  {
    var deck = [Card]()
    let ranks = [Rank.Ace, Rank.Two, Rank.Three, Rank.Four, Rank.Five, Rank.Six, Rank.Seven, Rank.Eight, Rank.Nine, Rank.Ten, Rank.Jack, Rank.Queen, Rank.King]

    let suits = [Suit.Spade, Suit.Heart, Suit.Club, Suit.Diamond]

    for suit in suits
    {
      for rank in ranks
      {
        deck.append(Card(rank: rank, suit: suit))
      }
    }
    return deck
  }
}

/*
This class will be the dealer that the player is playing against
*/
public class Dealer
{

  /*
  This function will deal with the dealers action, if their points are 17, 18, 19, 20, or 21 they will stand, and if they are over 21 points they lose the round
  */
  public func dealerAction(points: inout Int, continueActions: inout Bool) -> ()
  {
    if points == 17 || points == 18 || points == 19 || points == 20 || points == 21
    {
      print("The dealer has standed")
      continueActions = false
    }
    else
    {
      print(dealerDraw(points: &points))
    }

    if points > 21
    {
      print("The dealer is over 21 points, they lose")
      continueActions = false
    }
  }

  /*
  This function will deal out the dealers starting cards
  */
  public func dealerStartingCards(points: inout Int)
  {
    var cardNumber = 1
    while cardNumber < 2
    {
      let deck : Deck = Deck()
      let shuffledDeck = deck.createDeck()
      let randomCard = Int.random(in: 0 ... 51)
      let card : Card = shuffledDeck[randomCard]
      let cardRank = card.getRank()
      
      if cardRank == Rank.Ace
      {
        points += 11
      }
      else
      {
        points += cardRank.setPoints()
      }

      if cardNumber == 1
      {
        print("The dealer's first card is: ")
        print(card.printCard())
      }

      if points == 21
      {
        print("The dealer wins the round as they got a blackjack!")
        print(card.printCard())
      }
      else
      {
        print("The dealers second card is:")
        print("_ of _")
      }
      
      cardNumber += 1
    } 
  }

  public func dealerDraw(points: inout Int) -> ()
  {
    let deck : Deck = Deck()
    let shuffledDeck = deck.createDeck()
    
    let newRandomCard = Int.random(in: 1...52)
    let newCard : Card = shuffledDeck[newRandomCard]

    print("The dealers new card is: ")
    print(newCard.printCard())
    points += newCard.getRank().setPoints()
  }
}

// Functions

/*
This function will be the first function called when the program starts. It will ask the user if they want to begin the game or view the rules.
*/
func beginGame()
{
  print("Welcome to Blackjack!\n")
  print("What would you like to do?\nStart Game (start)\nView Rules (rules)\n")
  
  let option = readLine()!

  if option == "start"
  {
    var balance: Double = 100
    print(game(balance: &balance)) 
  }

  if option == "rules"
  {
    print(readRules())
    print(beginGame())
  }
}
/*
This function will take in the balance of the player, if the player makes a bet it will subtract that amount of money from their balance and return the new balance, if the player doesn't make a bet the balance will remain the same.
*/
func placeBet(balance: inout Double) -> ()
{
  print("\nWould you like to place a bet\nyes\nno\n")
  let betChoice = readLine()!

  if betChoice == "yes"
  {
    print("How much would you like to bet?\nCurrent balance is $\(balance)")
    let bet = Double(readLine()!) ?? 0
    if bet > balance || bet < 0
    {
      print("That bet is not allowed")
      print("No bet was made your balance reamains $\(balance)") 
    }
    else
    {
      balance = balance - bet 
      print("Your new balance is $\(balance)\n")
    } 
  }
  else
  {
    print("No bet was made your balance remains $\(balance)\n")
  }
}

/*
This function will set the initial values and will continue to run as long as the player wants to continue the game
*/
func game(balance: inout Double) -> ()
{
  var round : Int = 0
  var continueGame : Bool = true

  while continueGame
  {
    round += 1
    print(placeBet(balance: &balance))
    var bet = 100 - balance
    print(roundTurn(roundNumber: &round, balance: &balance, bet: &bet))

    if balance == 0
    {
      print(gameOver())
      continueGame = false
    }
    else
    {
      print("Would you like to continue?\nyes\nno\n")
      let continueChoice = readLine()!

      if continueChoice == "no"
      {
        print("Thank you for playing!")
        continueGame = false
      }
      else
      {
        print(game(balance: &balance))
      }
    }
  }
}

/*
This function will do a round of the game. It will deal the first two cards to the player and tell them how many points they have.
*/
func roundTurn(roundNumber: inout Int, balance: inout Double, bet: inout Double) -> ()
{
  let dealer : Dealer = Dealer()

  print("\nRound \(roundNumber)\n")
  roundNumber += 1

  var roundPoints = 0
  var dealerPoints = 0
  var dealerContinue : Bool = true

  dealStartingCards(points: &roundPoints)
  if roundPoints == 21
  {
    print(blackjack(balance: &balance, bet: &bet))
    print("You currently have \(roundPoints) points\n") 
  }
  else
  {
    print("You currently have \(roundPoints) points\n") 
    dealer.dealerStartingCards(points: &dealerPoints)
    print(userAction(points: &roundPoints))

    while dealerContinue
    {
      dealer.dealerAction(points: &dealerPoints, continueActions: &dealerContinue)
    }

    if roundPoints > 21
    {
      print("You have \(roundPoints) points\n")
      print(overTwentyOne())
    }
    else
    {
      print(determineWinner(dealerPoints: dealerPoints, playerPoints: roundPoints, balance: &balance, bet: &bet))
    } 
  } 
}

/*
This function will choose a random card in the deck and add the rank values to the players points. It will also print out the cards that the player has
*/
func dealStartingCards(points: inout Int) -> ()
{
  let deck : Deck = Deck()
  let shuffledDeck = deck.createDeck()
  
  print("Your cards for this round are: ")
  for _ in 0..<2
  {
    let randomCard = Int.random(in: 0 ... 51)
    let card : Card = shuffledDeck[randomCard]
    let cardRank : Rank = card.getRank()
    if cardRank == Rank.Ace
    {
      print(card.printCard())
      print(setAce(aceCard: card, points: &points))
    }
    else
    {
      points += cardRank.setPoints()
    }
    print(card.printCard())
  }
}

/*
This function will be called if the player gets a blackjack and add their bet and an extra 50% of their bet to their balance
*/
func blackjack(balance: inout Double, bet: inout Double) -> ()
{
  print("You have a blackjack!\nYou win the round")
  balance += bet + (bet * 0.5)
  print("Your new balance is \(balance)")
}

/*
This function will be the users action if they hit it will deal them a new card and update their points. If they choose to stand, the round will be over for them. They can also view the rules again if they need to.
*/
func userAction(points: inout Int) -> ()
{
  var continueRound = true
  let deck : Deck = Deck()
  let shuffledDeck = deck.createDeck()

  while continueRound
  {
     print("\nWhat action would you like to do\nHit (hit)\nStand (stand)\nView Rules (rules)\n")
    let roundChoice = readLine()!
    print("\n\n")

    if roundChoice == "hit"
    {
      let newRandomCard = Int.random(in: 1...52)
      let newCard : Card = shuffledDeck[newRandomCard]

      print("Your new card is: ")
      print(newCard.printCard())
      if newCard.getRank() == Rank.Ace
      {
        print(setAce(aceCard: newCard, points: &points))
      }
      else
      {
        points += newCard.getRank().setPoints()
      }

      if points > 21
      {
        continueRound = false
      }
      else
      {
        print("You now have \(points) points\n")
      }
      
    }
    else if roundChoice == "rules"
    {
      print(readRules())
      print(userAction(points: &points))
    }
    else
    {
      continueRound = false
      print("You have standed, no more cards will be dealt to you this round")
    }
    print("The amount of points you have for this round is \(points)\n")
  }
}

/*
This function will be called if the player has an Ace card and allow them to set their points to 1 or 11
*/
func setAce(aceCard: Card, points: inout Int) -> ()
{
  print("Would you like to set your ace card to be 1 or 11?")
  let aceChoice = Int(readLine()!) ?? 1
  if aceChoice == 1
  {
    points += 1
  }
  else
  {
    points += 11
  }

}

/*
This function will be displayed when the player goes over 21 points telling them they have lost the round
*/
func overTwentyOne()
{
  print("You have gone over 21 points!\nYou lose the round!")
}

/*
This function will determine who has the most points and update the balance of the player
*/
func determineWinner(dealerPoints: Int, playerPoints: Int, balance: inout Double, bet: inout Double)
{
  if dealerPoints > playerPoints && dealerPoints < 21
  {
    print("The dealer had a total of \(dealerPoints) points\n")
    print("The dealer wins the round!\nYour bet will not be returned")
  }
  else if dealerPoints == playerPoints
  {
    print("No winner as both players have an equal amount of points\n")
  }
  else
  {
    print("The dealer had a total of \(dealerPoints)\n")
    print("You win the round!\nYour bet will now be returned\n")
    balance += bet
    print("You total balance is now $\(balance)\n")
  }
}

/*
This function will tell the player that they are out of money and can no longer play the game
*/
func gameOver() -> ()
{
  print("You have run out of money!\nGame Over!\nThanks for playing!")
  print(beginGame())
}

/*
This function will print out the rules when the player wants to read the rules of Blackjack
*/
func readRules() -> ()
{
  print("Rules of Blackjack:\nIn this game before each round you have the option to place a bet. Once your bet is placed the round will start.\n")
  print("During a round you will have two options:\nHit will deal the player an extra card\nStand will not deal the player any extra cards.\n")
  print("The goal of the game is to get the most amount of points that will\nadd up to 21\nAt the start of each round you will be dealt two cards and each\ncard is worth a certain amount of points:\n2 is worth 2 points\n3 is worth 3\n4 is worth 4\n5 is worth 5\n6 is worth 6\n7 is worth 7\n8 is worth 8\n9 is worth 9\n10 is worth 10\nJack is worth 10\nQueen is worth 10\nKing is worth 10\nAce can be either worth 1 or 11\n")
  print("If a player exceeds 21 during a round they lose the round and the bet\n")
  print("During the round the player will be able to see the dealers first card but there second card will be face down\nIf the dealer gets a blackjack they win the game and the second card will be revealed.")
}

// This line of code will begin the game
print(beginGame())